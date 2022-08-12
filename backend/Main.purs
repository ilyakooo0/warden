module Main
  ( main
  ) where

import Prelude
import BW (ApiService, CryptoFunctions, Services, CryptoService)
import BW as WB
import BW.Logic (decodeCipher, decrypt, encodeCipher, hashPassword, liftPromise)
import BW.Logic as Logic
import BW.Types (CipherResponse, Email(..), Password(..), Urls, SyncResponse, cipherTypeCard, cipherTypeIdentity, cipherTypeLogin, cipherTypeSecureNote)
import Bridge as Bridge
import Control.Monad.Error.Class (catchError, throwError)
import Data.Argonaut (class DecodeJson)
import Data.Array as Array
import Data.Clipboard as Clipboard
import Data.DateTime (DateTime)
import Data.Either (Either(..))
import Data.HCaptcha (bindHCaptchToken)
import Data.JNullable (jnull, nullify)
import Data.JNullable as JNullable
import Data.Maybe (Maybe(..), maybe)
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
import Run (AFF, EFFECT, Run, liftAff, runBaseAff')
import Run.Reader (Reader, askAt, runReaderAt)
import Storage (MasterPasswordHashKey(..), PreloginResponseKey(..), SyncKey(..), TokenKey(..), UrlsKey(..))
import Type.Prelude (Proxy(..))
import Type.Row (type (+))
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
    runAff act = runElmAff app $ run $ act

    run ::
      forall a.
      Run
        ( app :: Reader Elm
        , aff :: Aff
        , effect :: Effect
        , crypto :: Reader CryptoService
        , storage :: Reader Storage
        , services :: Reader Services
        , cryptoFunctions :: Reader CryptoFunctions
        )
        a ->
      Run (EFFECT + AFF + ()) a
    run act =
      runReaderAt (Proxy :: _ "app") app
        $ runReaderAt (Proxy :: _ "crypto") services.crypto
        $ runReaderAt (Proxy :: _ "storage") storage
        $ runReaderAt (Proxy :: _ "services") services
        $ runReaderAt (Proxy :: _ "cryptoFunctions") services.cryptoFunctions
        $ act

    runWithDecryptionKey ::
      Run
        ( app :: Reader Elm
        , aff :: Aff
        , effect :: Effect
        , key :: Reader SymmetricCryptoKey
        , crypto :: Reader CryptoService
        , storage :: Reader Storage
        , services :: Reader Services
        , cryptoFunctions :: Reader CryptoFunctions
        )
        Unit ->
      Effect Unit
    runWithDecryptionKey act = do
      maybeKey <- Ref.read masterKeyRef
      runAff
        $ case maybeKey of
            Just masterKey -> do
              token <- getOrReset TokenKey
              key <- Logic.makeDecryptionKey masterKey token.key
              runReaderAt (Proxy :: _ "key") key $ act
            Nothing -> requestMasterPassword
  Elm.subscribe app \cmd -> case cmd of
    Bridge.Login (Bridge.Cmd_Login { email, server, password }) -> do
      captchaToken <- Ref.read hCaptchaTokenRef
      Ref.write Nothing hCaptchaTokenRef
      let
        urls = baseUrl server
      runAff do
        unauthedApi <- liftPromise $ services.getApi urls jnull
        prelogin <- liftPromise $ unauthedApi.postPrelogin { email }
        runReaderAt (Proxy :: _ "api") unauthedApi do
          loginResponse <-
            liftAff
              $ catchError
                  ( runBaseAff' $ run $ runReaderAt (Proxy :: _ "api") unauthedApi
                      $ Logic.getLogInRequestToken prelogin (Email email) (Password password) captchaToken
                  )
                  ( const
                      $ liftEffect do
                          Elm.send app Bridge.NeedsLogin
                          Exc.throw "Could not log in. Please check your data and try again."
                  )
          case toEither1 loginResponse of
            Left { siteKey } -> send $ Bridge.NeedsCaptcha siteKey
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
              send Bridge.LoginSuccessful
    Bridge.NeedCiphersList ->
      runWithDecryptionKey do
        sendCiphers
        performSync
    Bridge.NeedsReset -> do
      WebStorage.clear storage
      Elm.send app Bridge.Reset
    Bridge.SendMasterPassword masterPassword ->
      runAff do
        hash <- getOrReset MasterPasswordHashKey
        newHash <- hashPassword (Password masterPassword)
        if hash == newHash then do
          sync <- getOrReset SyncKey
          prelogin <- getOrReset PreloginResponseKey
          masterKey <- Logic.makePreloginKey prelogin (Email sync.profile.email) (Password masterPassword)
          liftEffect $ Ref.write (Just masterKey) masterKeyRef
          send Bridge.LoginSuccessful
        else do
          send $ Bridge.Error "The password is wrong. Please try again."
          requestMasterPassword
    Bridge.Init -> do
      Storage.get storage TokenKey
        >>= \x ->
            Elm.send app case x of
              Just _ -> Bridge.LoginSuccessful
              Nothing -> Bridge.NeedsLogin
    Bridge.RequestCipher id ->
      runWithDecryptionKey do
        sync <- getOrReset SyncKey
        case Array.find (\c -> c.id == id) sync.ciphers of
          Nothing -> pure unit
          Just cipherResponse -> do
            cipher <- decodeCipher cipherResponse
            send $ Bridge.LoadCipher cipher
            pure unit
        pure unit
    Bridge.NeedEmail ->
      runWithDecryptionKey do
        sync <- getOrReset SyncKey
        send $ Bridge.RecieveEmail sync.profile.email
        pure unit
    Bridge.Copy text ->
      runWithDecryptionKey do
        liftPromise $ Clipboard.clipboard text
    Bridge.Open uri -> openURL uri
    Bridge.UpdateCipher fullCipher ->
      runWithDecryptionKey do
        api <- getAuthedApi
        cipher <- encodeCipher fullCipher
        newCipher <- liftPromise (api.putCipher cipher) >>= decodeCipher
        send $ Bridge.CipherChanged newCipher
        performSync
        pure unit
    Bridge.GeneratePassword cfg ->
      runWithDecryptionKey do
        password <- liftPromise $ services.passwordGeneration.generatePassword cfg
        send $ Bridge.GeneratedPassword password
        pure unit

processCipher ::
  forall r.
  CipherResponse ->
  Run
    ( crypto :: Reader CryptoService
    , key :: Reader SymmetricCryptoKey
    , aff :: Aff
    , effect :: Effect
    | r
    )
    { cipher :: Bridge.Sub_LoadCiphers, date :: DateTime }
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
    n -> liftEffect $ throwError $ error $ "Unsupported cipher type: " <> show n
  date <- liftEffect $ maybe (pure bottom) (Timestamp.toDateTime) $ JNullable.toMaybe cipher.revisionDate
  pure
    $ { cipher:
          Bridge.Sub_LoadCiphers
            { name: name
            , date: maybe "" Timestamp.toLocalDateTimeString $ JNullable.toMaybe cipher.revisionDate
            , id: cipher.id
            , cipherType
            }
      , date
      }

runElmAff :: FFI.Elm -> Run (AFF + EFFECT + ()) Unit -> Effect Unit
runElmAff app =
  runAff_
    ( \res -> do
        case res of
          Left e -> do
            log $ show e
            Elm.send app (Bridge.Error $ Exc.message e)
          Right unit -> pure unit
    )
    <<< runBaseAff'

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
  StorageKey k t =>
  DecodeJson t =>
  k ->
  Run
    ( storage :: Reader Storage
    , app :: Reader Elm
    , effect :: Effect
    | r
    )
    t
getOrReset key = do
  storage <- askAt (Proxy :: _ "storage")
  app <- askAt (Proxy :: _ "app")
  let
    handleError = do
      WebStorage.clear storage
      Elm.send app Bridge.Reset
      Exc.throw "Encountered an internal error. Resetting the app."
  liftEffect $ try (Storage.get storage key)
    >>= \x -> case x of
        Left err -> do
          log $ show err
          handleError
        Right Nothing -> handleError
        Right (Just y) -> pure y

getAuthedApi ::
  forall r.
  Run
    ( storage :: Reader Storage
    , app :: Reader Elm
    , aff :: Aff
    , effect :: Effect
    , services :: Reader Services
    | r
    )
    ApiService
getAuthedApi = do
  services <- askAt (Proxy :: _ "services")
  token <- getOrReset TokenKey
  url <- getOrReset UrlsKey
  liftPromise $ services.getApi (baseUrl url) (nullify token)

requestMasterPassword ::
  forall r.
  Run
    ( storage :: Reader Storage
    , app :: Reader Elm
    , effect :: Effect
    | r
    )
    Unit
requestMasterPassword = do
  url <- getOrReset UrlsKey
  sync <- getOrReset SyncKey
  send $ Bridge.NeedsMasterPassword $ Bridge.Sub_NeedsMasterPassword { server: url, login: sync.profile.email }

send ::
  forall r.
  Bridge.Sub ->
  Run
    ( app :: Reader Elm
    , effect :: Effect
    | r
    )
    Unit
send sub = do
  app <- askAt (Proxy :: _ "app")
  liftEffect $ Elm.send app sub

performSync ::
  forall r.
  Run
    ( storage :: Reader Storage
    , app :: Reader Elm
    , aff :: Aff
    , effect :: Effect
    , services :: Reader Services
    , crypto :: Reader CryptoService
    , key :: Reader SymmetricCryptoKey
    | r
    )
    Unit
performSync = do
  api <- getAuthedApi
  storage <- askAt (Proxy :: _ "storage")
  newSync <- liftPromise $ api.getSync unit
  liftEffect $ Storage.store storage SyncKey newSync
  sendCiphers

sendCiphers ::
  forall r.
  Run
    ( storage :: Reader Storage
    , app :: Reader Elm
    , aff :: Aff
    , effect :: Effect
    , services :: Reader Services
    , crypto :: Reader CryptoService
    , key :: Reader SymmetricCryptoKey
    | r
    )
    Unit
sendCiphers = do
  sync <- getOrReset SyncKey
  ciphers <- traverse processCipher sync.ciphers
  let
    sortedCiphers = Array.sortWith (_.date >>> Down) ciphers
  send $ Bridge.LoadCiphers $ Bridge.Sub_LoadCiphers_List $ map _.cipher sortedCiphers
  pure unit
