module Main
  ( main
  ) where

import Bridge
import Prelude

import BW (ApiService, CryptoService, Hash(..), Services)
import BW as WB
import BW.Logic (decrypt, hashPassword, liftPromise)
import BW.Logic as Logic
import BW.Types (CipherResponse, Email(..), EncryptedString(..), IdentityTokenResponse, Password(..), PreloginResponse, SyncResponse, Urls, PreloginRequest)
import Bridge as Bridge
import Control.El (class HasL, Al, L(..), l)
import Control.Monad.Reader (runReaderT)
import Control.Promise (Promise)
import Control.Promise as Promise
import Data.Argonaut (class DecodeJson, class EncodeJson, encodeJson)
import Data.Argonaut as Json
import Data.Array as A
import Data.Either (Either(..))
import Data.JNullable (JNullable(..), jnull, nullify)
import Data.Maybe (Maybe(..))
import Data.Nullable (Nullable, null, toNullable)
import Data.Nullable as Nullable
import Data.SymmetricCryptoKey (SymmetricCryptoKey)
import Data.Timestamp as Timestamp
import Data.Traversable (traverse)
import Effect (Effect)
import Effect.Aff (Aff, runAff_, try)
import Effect.Aff as Aff
import Effect.Aff.Class (class MonadAff, liftAff)
import Effect.Aff.Class as Aff
import Effect.Class (liftEffect)
import Effect.Class.Console (log)
import Effect.Exception as Exc
import Effect.Ref as Ref
import Elm as Elm
import FFI (Elm)
import FFI as FFI
import Localstorage (class StorageKey, storageKey)
import Localstorage as Storage
import Localstorage as Storage
import Prelude as Array
import Unsafe.Coerce (unsafeCoerce)
import Web.HTML (Window)
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
  let run act = do
          maybeKey <- Ref.read masterKeyRef
          runElmAff app $ flip runReaderT {app: app, crypto : services.crypto, storage: storage} $
            case maybeKey of
              Just masterKey -> do
                token <- getOrReset storage TokenKey
                key <- Logic.makeDecryptionKey masterKey token.key
                liftEffect $ runElmAff app $ runReaderT act
                  {app : app , storage : storage, services : services, crypto : services.crypto
                  , key : key}
              Nothing -> requestMasterPassword
  Elm.subscribe app \cmd -> case cmd of
    Bridge.Login (Bridge.Cmd_Login { email, server, password }) -> do
      let
        urls = baseUrl server
      runElmAff app do
        unauthedApi <- liftPromise $ services.getApi urls jnull
        flip runReaderT { api: unauthedApi, crypto: services.crypto, storage:
              storage, cryptoFunctions: services.cryptoFunctions } do
            {token, prelogin: (prelogin :: PreloginResponse)} <-
              try (do
                prelogin <- liftPromise $ unauthedApi.postPrelogin {email}
                token <- (Logic.getLogInRequestToken prelogin (Email email) (Password password))
                pure {token, prelogin}
                )
                  >>= \et -> case et of
                      Left _ -> liftEffect $ Exc.throw "Could not log in. Please check your data and try again."
                      Right t -> pure t
            masterKey <- Logic.makePreloginKey prelogin (Email email) (Password password)
            api <- liftPromise $ services.getApi urls (nullify token)
            sync <- liftPromise $ api.getSync unit
            hash <- hashPassword (Password password)
            log $ show sync
            liftEffect $ Ref.write (Just masterKey) masterKeyRef
            liftEffect $ Storage.store storage UrlsKey server
            liftEffect $ Storage.store storage MasterPasswordHashKey hash
            liftEffect $ Storage.store storage PreloginResponseKey prelogin
            liftEffect $ Storage.store storage SyncKey sync
            liftEffect $ Storage.store storage TokenKey token
            liftEffect $ Elm.send app Bridge.LoginSuccessful
            pure unit
        pure unit
    Bridge.NeedCiphersList -> run do
      sync <- getOrReset storage SyncKey
      ciphers <- traverse processCipher sync.ciphers
      liftEffect $ Elm.send app $ Bridge.LoadCiphers $ Bridge.Sub_LoadCiphers_List ciphers
      pure unit
    Bridge.NeedsReset -> pure unit
    Bridge.SendMasterPassword masterPassword -> runElmAff app $ do
      flip runReaderT {app: app, storage: storage, crypto: services.crypto, cryptoFunctions: services.cryptoFunctions} $ do
        hash <- getOrReset storage MasterPasswordHashKey
        newHash <- hashPassword (Password masterPassword)
        if hash == newHash
          then do
            sync <- getOrReset storage SyncKey
            prelogin <- getOrReset storage PreloginResponseKey
            masterKey <- Logic.makePreloginKey prelogin (Email sync.profile.email) (Password masterPassword)
            liftEffect $ Ref.write (Just masterKey) masterKeyRef
            liftEffect $ Elm.send app Bridge.LoginSuccessful
          else do
            liftEffect $ Elm.send app $ Bridge.Error "The password is wrong. Please try again."
            requestMasterPassword
        pure unit
    Bridge.Init -> do
      liftEffect $ Storage.get storage TokenKey >>= \x -> case x of
        Just _ -> liftEffect $ Elm.send app Bridge.LoginSuccessful
        Nothing -> Elm.send app Bridge.NeedsLogin

data SyncKey  = SyncKey

instance StorageKey SyncKey SyncResponse where
  storageKey SyncKey = "sync"

data TokenKey
  = TokenKey

instance StorageKey TokenKey IdentityTokenResponse where
  storageKey TokenKey = "token"

data UrlsKey
  = UrlsKey

instance StorageKey UrlsKey String where
  storageKey UrlsKey = "urls"

data PreloginResponseKey
  = PreloginResponseKey

instance StorageKey PreloginResponseKey PreloginResponse where
  storageKey PreloginResponseKey = "prelogin-reponse"

data MasterPasswordHashKey
  = MasterPasswordHashKey

instance StorageKey MasterPasswordHashKey Hash where
  storageKey MasterPasswordHashKey = "master-password-hash"


processCipher ::
  forall r.
  HasL "crypto" CryptoService r =>
  HasL "key" SymmetricCryptoKey r =>
  CipherResponse -> Al r Bridge.Sub_LoadCiphers
processCipher cipher = do
  name <- decrypt cipher.name
  pure
    $ Bridge.Sub_LoadCiphers
        { name: name, date: Timestamp.toLocalDateTimeString cipher.revisionDate }

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

getOrReset :: forall k t r. HasL "app" Elm r =>
  StorageKey k t => DecodeJson t => Storage -> k -> Al r t
getOrReset storage key = do
  let handleError = do
          app <- l (L :: L "app")
          liftEffect $ WebStorage.clear storage
          liftEffect $ Elm.send app Bridge.Reset
          liftEffect $ Exc.throw "Encountered an internal error. Resetting the app."
  try (liftEffect $ Storage.get storage key) >>= \x -> case x of
    Left err -> do
      liftEffect $ log $ show err
      handleError
    Right Nothing -> handleError
    Right (Just y) -> pure y

getAuthedApi :: forall r. HasL "services" Services r => HasL "storage" Storage r
  => HasL "app" Elm r =>
  Al r ApiService
getAuthedApi = do
  storage <- l (L :: L "storage")
  services <- l (L :: L "services")
  token <- getOrReset storage TokenKey
  url <- getOrReset storage UrlsKey
  liftPromise $ services.getApi (baseUrl url) (nullify token)

requestMasterPassword :: forall r. HasL "storage" Storage r => HasL "app" Elm r => Al r Unit
requestMasterPassword = do
  storage <- l (L :: L "storage")
  app <- l (L :: L "app")
  url <- getOrReset storage UrlsKey
  sync <- getOrReset storage SyncKey
  liftEffect $ Elm.send app $ Bridge.NeedsMasterPassword
    $ Bridge.Sub_NeedsMasterPassword {server: url, login: sync.profile.email}
