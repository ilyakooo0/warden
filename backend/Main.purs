module Main
  ( main
  ) where

import Prelude
import BW (ApiService, CryptoService, Services)
import BW as WB
import BW.Logic (decodeCipher, decrypt, hashPassword, liftPromise)
import BW.Logic as Logic
import BW.Types (CipherResponse, Email(..), Password(..), Urls, cipherTypeCard, cipherTypeIdentity, cipherTypeLogin, cipherTypeSecureNote)
import Bridge as Bridge
import Control.El (class HasL, Al, L(..), l)
import Control.Monad.Error.Class (catchError, throwError)
import Control.Monad.Reader (runReaderT)
import Data.Argonaut (class DecodeJson)
import Data.Array as Array
import Data.Clipboard as Clipboard
import Data.DateTime (DateTime)
import Data.Either (Either(..))
import Data.HCaptcha (bindHCaptchToken)
import Data.JNullable (jnull, nullify)
import Data.Maybe (Maybe(..))
import Data.Newtype (wrap)
import Data.OpenURL (openURL)
import Data.Ord.Down (Down(..))
import Data.SymmetricCryptoKey (SymmetricCryptoKey)
import Data.Timestamp as Timestamp
import Data.Traversable (traverse)
import Effect (Effect)
import Effect.Aff (Aff, runAff_, try)
import Effect.Class (liftEffect)
import Effect.Class.Console (log)
import Effect.Exception (error)
import Effect.Exception as Exc
import Effect.Ref as Ref
import Elm as Elm
import FFI (Elm)
import FFI as FFI
import Localstorage (class StorageKey)
import Localstorage as Storage
import Storage (MasterPasswordHashKey(..), PreloginResponseKey(..), SyncKey(..), TokenKey(..), UrlsKey(..))
import Untagged.Union (toEither1)
import Web.HTML as Html
import Web.HTML.Window as Window
import Web.Storage.Storage (Storage)
import Web.Storage.Storage as WebStorage

main :: Effect Unit
main = do
  app <- FFI.startElm "elm"
  storage <- Html.window >>= Window.localStorage
  services <- WB.getServices
  masterKeyRef <- Ref.new Nothing
  hCaptchaTokenRef <- Ref.new Nothing
  bindHCaptchToken \captchaToken -> do
    Ref.write (Just captchaToken) hCaptchaTokenRef
    Elm.send app Bridge.CaptchaDone
  let
    run act = do
      maybeKey <- Ref.read masterKeyRef
      runElmAff app $ flip runReaderT { app: app, crypto: services.crypto, storage: storage }
        $ case maybeKey of
            Just masterKey -> do
              token <- getOrReset TokenKey
              key <- Logic.makeDecryptionKey masterKey token.key
              liftEffect $ runElmAff app
                $ runReaderT act
                    { app
                    , storage
                    , services
                    , crypto: services.crypto
                    , key
                    }
            Nothing -> requestMasterPassword
  Elm.subscribe app \cmd -> case cmd of
    Bridge.Login (Bridge.Cmd_Login { email, server, password }) -> do
      captchaToken <- Ref.read hCaptchaTokenRef
      Ref.write Nothing hCaptchaTokenRef
      let
        urls = baseUrl server
      runElmAff app do
        unauthedApi <- liftPromise $ services.getApi urls jnull
        let
          env =
            { api: unauthedApi
            , crypto: services.crypto
            , storage
            , cryptoFunctions: services.cryptoFunctions
            }
        flip runReaderT env do
          prelogin <- liftPromise $ unauthedApi.postPrelogin { email }
          loginResponse <-
            catchError
              (Logic.getLogInRequestToken prelogin (Email email) (Password password) captchaToken)
              (const $ liftEffect $ Exc.throw "Could not log in. Please check your data and try again.")
          case toEither1 loginResponse of
            Left { siteKey } ->
              liftEffect do
                Elm.send app $ Bridge.NeedsCaptcha siteKey
            Right token -> do
              masterKey <- Logic.makePreloginKey prelogin (Email email) (Password password)
              api <- liftPromise $ services.getApi urls (nullify token)
              sync <- liftPromise $ api.getSync unit
              hash <- hashPassword (Password password)
              log $ show sync
              liftEffect do
                Ref.write (Just masterKey) masterKeyRef
                Storage.store storage UrlsKey server
                Storage.store storage MasterPasswordHashKey hash
                Storage.store storage PreloginResponseKey prelogin
                Storage.store storage SyncKey sync
                Storage.store storage TokenKey token
                Elm.send app Bridge.LoginSuccessful
    Bridge.NeedCiphersList ->
      run do
        sync <- getOrReset SyncKey
        ciphers <- traverse processCipher sync.ciphers
        let
          sortedCiphers = Array.sortWith (_.date >>> Down) ciphers
        liftEffect do
          Elm.send app $ Bridge.LoadCiphers $ Bridge.Sub_LoadCiphers_List $ map _.cipher sortedCiphers
          Storage.store storage SyncKey sync
    Bridge.NeedsReset -> do
      WebStorage.clear storage
      Elm.send app Bridge.Reset
    Bridge.SendMasterPassword masterPassword ->
      runElmAff app
        $ do
            flip runReaderT { app: app, storage: storage, crypto: services.crypto, cryptoFunctions: services.cryptoFunctions }
              $ do
                  hash <- getOrReset MasterPasswordHashKey
                  newHash <- hashPassword (Password masterPassword)
                  if hash == newHash then do
                    sync <- getOrReset SyncKey
                    prelogin <- getOrReset PreloginResponseKey
                    masterKey <- Logic.makePreloginKey prelogin (Email sync.profile.email) (Password masterPassword)
                    liftEffect do
                      Ref.write (Just masterKey) masterKeyRef
                      Elm.send app Bridge.LoginSuccessful
                  else do
                    liftEffect $ Elm.send app $ Bridge.Error "The password is wrong. Please try again."
                    requestMasterPassword
    Bridge.Init -> do
      liftEffect $ Storage.get storage TokenKey
        >>= \x ->
            Elm.send app case x of
              Just _ -> Bridge.LoginSuccessful
              Nothing -> Bridge.NeedsLogin
    Bridge.RequestCipher id ->
      run do
        sync <- getOrReset SyncKey
        case Array.find (\c -> c.id == id) sync.ciphers of
          Nothing -> pure unit
          Just cipherResponse -> do
            cipher <- decodeCipher cipherResponse
            send $ Bridge.LoadCipher cipher
            pure unit
        pure unit
    Bridge.NeedEmail ->
      run do
        sync <- getOrReset SyncKey
        send $ Bridge.RecieveEmail sync.profile.email
        pure unit
    Bridge.Copy text ->
      run do
        liftPromise $ Clipboard.clipboard text
    Bridge.Open uri -> openURL uri

processCipher ::
  forall r.
  HasL "crypto" CryptoService r =>
  HasL "key" SymmetricCryptoKey r =>
  CipherResponse -> Al r { cipher :: Bridge.Sub_LoadCiphers, date :: DateTime }
processCipher cipher = do
  name <- decrypt cipher.name
  cipherType <- case cipher.type of
    n
      | n == cipherTypeLogin -> pure Bridge.LoginType
    n
      | n == cipherTypeSecureNote -> pure Bridge.NoteType
    n
      | n == cipherTypeCard -> pure Bridge.CardType
    n
      | n == cipherTypeIdentity -> pure Bridge.IdentityType
    n -> throwError $ error $ "Unsupported cipher type: " <> show n
  date <- liftEffect $ Timestamp.toDateTime cipher.revisionDate
  pure
    $ { cipher:
          Bridge.Sub_LoadCiphers
            { name: name
            , date: Timestamp.toLocalDateTimeString cipher.revisionDate
            , id: cipher.id
            , cipherType
            }
      , date
      }

runElmAff :: FFI.Elm -> Aff Unit -> Effect Unit
runElmAff app =
  runAff_
    $ \res -> do
        case res of
          Left e -> do
            log $ show e
            Elm.send app (Bridge.Error $ Exc.message e)
          Right unit -> pure unit

baseUrl :: String -> Urls
baseUrl server =
  { base: nullify server
  , webVault: jnull
  , api: jnull
  , identity: jnull
  , icons: jnull
  , notifications: jnull
  , events: jnull
  , keyConnector: jnull
  }

getOrReset ::
  forall k t r.
  HasL "app" Elm r =>
  HasL "storage" Storage r =>
  StorageKey k t =>
  DecodeJson t =>
  k -> Al r t
getOrReset key = do
  storage <- l (L :: L "storage")
  let
    handleError = do
      app <- l (L :: L "app")
      liftEffect $ WebStorage.clear storage
      liftEffect $ Elm.send app Bridge.Reset
      liftEffect $ Exc.throw "Encountered an internal error. Resetting the app."
  try (liftEffect $ Storage.get storage key)
    >>= \x -> case x of
        Left err -> do
          liftEffect $ log $ show err
          handleError
        Right Nothing -> handleError
        Right (Just y) -> pure y

getAuthedApi ::
  forall r.
  HasL "services" Services r =>
  HasL "storage" Storage r =>
  HasL "app" Elm r =>
  Al r ApiService
getAuthedApi = do
  services <- l (L :: L "services")
  token <- getOrReset TokenKey
  url <- getOrReset UrlsKey
  liftPromise $ services.getApi (baseUrl url) (nullify token)

requestMasterPassword :: forall r. HasL "storage" Storage r => HasL "app" Elm r => Al r Unit
requestMasterPassword = do
  app <- l (L :: L "app")
  url <- getOrReset UrlsKey
  sync <- getOrReset SyncKey
  liftEffect $ Elm.send app $ Bridge.NeedsMasterPassword
    $ Bridge.Sub_NeedsMasterPassword { server: url, login: sync.profile.email }

send :: forall r. HasL "app" Elm r => Bridge.Sub -> Al r Unit
send sub = do
  app <- l (L :: L "app")
  liftEffect $ Elm.send app sub
