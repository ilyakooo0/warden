module Main
  ( main
  ) where

import Prelude

import BW (ApiService, CryptoService, Hash, Services)
import BW as WB
import BW.Logic (decrypt, hashPassword, liftPromise)
import BW.Logic as Logic
import BW.Types (CipherResponse, Email(..), IdentityTokenResponse, Password(..), PreloginResponse, SyncResponse, Urls, cipherTypeCard, cipherTypeIdentity, cipherTypeLogin, cipherTypeSecureNote)
import Bridge as Bridge
import Control.El (class HasL, Al, L(..), l)
import Control.Monad.Error.Class (throwError)
import Control.Monad.Reader (runReaderT)
import Data.Argonaut (class DecodeJson)
import Data.Array as Array
import Data.Clipboard as Clipboard
import Data.DateTime (DateTime)
import Data.Either (Either(..))
import Data.HCaptcha (bindHCaptchToken)
import Data.JNullable (fromJNullable, jnull, nullify)
import Data.JNullable as JNullable
import Data.JOpt (fromJOpt)
import Data.Maybe (Maybe(..))
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
  bindHCaptchToken log
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
      let sortedCiphers = Array.sortWith (_.date >>> Down) ciphers
      liftEffect $ Elm.send app $ Bridge.LoadCiphers $ Bridge.Sub_LoadCiphers_List $ map _.cipher sortedCiphers
      liftEffect $ Storage.store storage SyncKey sync
      pure unit
    Bridge.NeedsReset -> do
      WebStorage.clear storage
      Elm.send app Bridge.Reset
      pure unit
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
        Just _ -> do liftEffect $ Elm.send app Bridge.LoginSuccessful
        Nothing -> Elm.send app Bridge.NeedsLogin
    Bridge.RequestCipher id -> run do
      sync <- getOrReset storage SyncKey
      case Array.find (\c -> c.id == id) sync.ciphers of
        Nothing -> pure unit
        Just cipher -> do
          name <- decrypt cipher.name
          cipherType <- do
            case cipher.type of
              n | cipherTypeSecureNote == n -> do
                note <- fromJNullable "" <$> (traverse decrypt cipher.notes)
                pure $ Bridge.NoteCipher note
              n | cipherTypeLogin == n -> do
                case JNullable.toMaybe cipher.login of
                  Nothing -> throwError $ error "Login data is missing"
                  Just login -> do
                    username <- Bridge.Sub_LoadCipher_cipherType_LoginCipher_username_Maybe <<< fromJNullable Nothing <<< map Just <$> (traverse decrypt login.username)
                    password <- Bridge.Sub_LoadCipher_cipherType_LoginCipher_password_Maybe <<< fromJNullable Nothing <<< map Just <$> (traverse decrypt login.password)
                    uris <- fromJOpt [] <$> ((traverse >>> traverse) (_.uri >>> decrypt) login.uris)
                    pure $ Bridge.LoginCipher $ Bridge.Sub_LoadCipher_cipherType_LoginCipher
                      { username
                      , password
                      , uris: Bridge.Sub_LoadCipher_cipherType_LoginCipher_uris_List uris
                      }
              n | cipherTypeCard == n -> do
                case JNullable.toMaybe cipher.card of
                  Nothing -> throwError $ error "Card data is missing"
                  Just card -> do
                    cardholderName <- Bridge.Sub_LoadCipher_cipherType_CardCipher_cardholderName_Maybe <<< fromJNullable Nothing <<< map Just <$> (traverse decrypt card.cardholderName)
                    number <- Bridge.Sub_LoadCipher_cipherType_CardCipher_number_Maybe <<< fromJNullable Nothing <<< map Just <$> (traverse decrypt card.number)
                    code <- Bridge.Sub_LoadCipher_cipherType_CardCipher_code_Maybe <<< fromJNullable Nothing <<< map Just <$> (traverse decrypt card.code)
                    brand <- Bridge.Sub_LoadCipher_cipherType_CardCipher_brand_Maybe <<< fromJNullable Nothing <<< map Just <$> (traverse decrypt card.brand)
                    expMonth <- Bridge.Sub_LoadCipher_cipherType_CardCipher_expMonth_Maybe <<< fromJNullable Nothing <<< map Just <$> (traverse decrypt card.expMonth)
                    expYear <- Bridge.Sub_LoadCipher_cipherType_CardCipher_expYear_Maybe <<< fromJNullable Nothing <<< map Just <$> (traverse decrypt card.expYear)
                    pure $ Bridge.CardCipher $ Bridge.Sub_LoadCipher_cipherType_CardCipher
                      { brand, cardholderName, code, expMonth, expYear, number }
              n | cipherTypeIdentity == n -> do
                case JNullable.toMaybe cipher.identity of
                  Nothing -> throwError $ error "Identity data is missing"
                  Just identity -> do
                    firstName <- Bridge.Sub_LoadCipher_cipherType_IdentityCipher_firstName_Maybe <<< fromJNullable Nothing <<< map Just <$> (traverse decrypt identity.firstName)
                    middleName <- Bridge.Sub_LoadCipher_cipherType_IdentityCipher_middleName_Maybe <<< fromJNullable Nothing <<< map Just <$> (traverse decrypt identity.middleName)
                    lastName <- Bridge.Sub_LoadCipher_cipherType_IdentityCipher_lastName_Maybe <<< fromJNullable Nothing <<< map Just <$> (traverse decrypt identity.lastName)
                    address1 <- Bridge.Sub_LoadCipher_cipherType_IdentityCipher_address1_Maybe <<< fromJNullable Nothing <<< map Just <$> (traverse decrypt identity.address1)
                    address2 <- Bridge.Sub_LoadCipher_cipherType_IdentityCipher_address2_Maybe <<< fromJNullable Nothing <<< map Just <$> (traverse decrypt identity.address2)
                    address3 <- Bridge.Sub_LoadCipher_cipherType_IdentityCipher_address3_Maybe <<< fromJNullable Nothing <<< map Just <$> (traverse decrypt identity.address3)
                    city <- Bridge.Sub_LoadCipher_cipherType_IdentityCipher_city_Maybe <<< fromJNullable Nothing <<< map Just <$> (traverse decrypt identity.city)
                    company <- Bridge.Sub_LoadCipher_cipherType_IdentityCipher_company_Maybe <<< fromJNullable Nothing <<< map Just <$> (traverse decrypt identity.company)
                    country <- Bridge.Sub_LoadCipher_cipherType_IdentityCipher_country_Maybe <<< fromJNullable Nothing <<< map Just <$> (traverse decrypt identity.country)
                    email <- Bridge.Sub_LoadCipher_cipherType_IdentityCipher_email_Maybe <<< fromJNullable Nothing <<< map Just <$> (traverse decrypt identity.email)
                    licenseNumber <- Bridge.Sub_LoadCipher_cipherType_IdentityCipher_licenseNumber_Maybe <<< fromJNullable Nothing <<< map Just <$> (traverse decrypt identity.licenseNumber)
                    passportNumber <- Bridge.Sub_LoadCipher_cipherType_IdentityCipher_passportNumber_Maybe <<< fromJNullable Nothing <<< map Just <$> (traverse decrypt identity.passportNumber)
                    phone <- Bridge.Sub_LoadCipher_cipherType_IdentityCipher_phone_Maybe <<< fromJNullable Nothing <<< map Just <$> (traverse decrypt identity.phone)
                    postalCode <- Bridge.Sub_LoadCipher_cipherType_IdentityCipher_postalCode_Maybe <<< fromJNullable Nothing <<< map Just <$> (traverse decrypt identity.postalCode)
                    ssn <- Bridge.Sub_LoadCipher_cipherType_IdentityCipher_ssn_Maybe <<< fromJNullable Nothing <<< map Just <$> (traverse decrypt identity.ssn)
                    state <- Bridge.Sub_LoadCipher_cipherType_IdentityCipher_state_Maybe <<< fromJNullable Nothing <<< map Just <$> (traverse decrypt identity.state)
                    title <- Bridge.Sub_LoadCipher_cipherType_IdentityCipher_title_Maybe <<< fromJNullable Nothing <<< map Just <$> (traverse decrypt identity.title)
                    username <- Bridge.Sub_LoadCipher_cipherType_IdentityCipher_username_Maybe <<< fromJNullable Nothing <<< map Just <$> (traverse decrypt identity.username)
                    pure $ Bridge.IdentityCipher $ Bridge.Sub_LoadCipher_cipherType_IdentityCipher
                      { firstName,
                        middleName,
                        lastName,
                        address1,
                        address2,
                        address3,
                        city,
                        company,
                        country,
                        email,
                        licenseNumber,
                        passportNumber,
                        phone,
                        postalCode,
                        ssn,
                        state,
                        title,
                        username
                       }
              n -> throwError $ error $ "Unsupported cipher type: " <> show n
          send $ Bridge.LoadCipher $ Bridge.Sub_LoadCipher {cipherType, name, id}
          pure unit
      pure unit
    Bridge.NeedEmail -> run do
      sync <- getOrReset storage SyncKey
      send $ Bridge.RecieveEmail sync.profile.email
      pure unit
    Bridge.Copy text -> run do
      liftPromise $ Clipboard.clipboard text
    Bridge.Open uri -> openURL uri

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
  CipherResponse -> Al r {cipher :: Bridge.Sub_LoadCiphers, date :: DateTime}
processCipher cipher = do
  name <- decrypt cipher.name
  cipherType <- case cipher.type of
        n | n == cipherTypeLogin -> pure Bridge.LoginType
        n | n == cipherTypeSecureNote -> pure Bridge.NoteType
        n | n == cipherTypeCard -> pure Bridge.CardType
        n | n == cipherTypeIdentity -> pure Bridge.IdentityType
        n -> throwError $ error $ "Unsupported cipher type: " <> show n
  date <- liftEffect $ Timestamp.toDateTime cipher.revisionDate
  pure
    $ {cipher: Bridge.Sub_LoadCiphers
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

send :: forall r. HasL "app" Elm r => Bridge.Sub -> Al r Unit
send sub = do
  app <- l (L :: L "app")
  liftEffect $ Elm.send app sub
