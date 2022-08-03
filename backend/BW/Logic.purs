module BW.Logic where

import BW
import BW.Types
import Control.El
import Prelude
import Bridge as Bridge
import Control.Monad.Error.Class (throwError)
import Control.Promise (Promise)
import Control.Promise as Promise
import Data.EncString as EncString
import Data.Function.Uncurried (runFn2, runFn3, runFn4)
import Data.JNullable (JNullable, fromJNullable, jnull, nullify)
import Data.JNullable as JNullable
import Data.JOpt (fromJOpt)
import Data.Maybe (Maybe(..))
import Data.Newtype (class Newtype, wrap)
import Data.String as String
import Data.SymmetricCryptoKey (SymmetricCryptoKey)
import Data.SymmetricCryptoKey as SymmetricCryptoKey
import Data.Traversable (traverse)
import Effect.Aff.Class (class MonadAff, liftAff)
import Effect.Class (liftEffect)
import Effect.Exception (error)
import Effect.Exception as Exc

-- | Creates the master key
makePreloginKey ::
  forall r.
  HasL "crypto" CryptoService r =>
  PreloginResponse -> Email -> Password -> Al r SymmetricCryptoKey
makePreloginKey { kdf, kdfIterations } (Email email') password = do
  crypto <- l (L :: L "crypto")
  let
    email = (String.trim >>> String.toLower) email'
  liftPromise $ runFn4 crypto.makeKey password email kdf kdfIterations

makeDecryptionKey ::
  forall r.
  HasL "crypto" CryptoService r =>
  -- | Matser key (prelogin key)
  SymmetricCryptoKey -> EncryptedString -> Al r SymmetricCryptoKey
makeDecryptionKey masterKey str = do
  crypto <- l (L :: L "crypto")
  let
    encryptedKeyString = EncString.fromString str

    encType = EncString.encryptionType encryptedKeyString
  key <-
    if encType == EncString.encryptionTypeAesCbc256_B64 then
      liftPromise $ runFn2 crypto.decryptToBytes (EncString.fromString str) masterKey
    else if encType == EncString.encryptionTypeAesCbc256_HmacSha256_B64 then do
      stretchedMasterKey <- liftPromise $ crypto.stretchKey masterKey
      liftPromise $ runFn2 crypto.decryptToBytes (EncString.fromString str) stretchedMasterKey
    else
      liftEffect $ Exc.throw $ "Unsupported key encryption type: " <> show encType
  pure $ SymmetricCryptoKey.fromArrayBuffer key

getLogInRequestToken ::
  forall r.
  HasL "api" ApiService r =>
  HasL "crypto" CryptoService r =>
  PreloginResponse -> Email -> Password -> Al r IdentityTokenResponse
getLogInRequestToken prelogin email password = do
  key <- makePreloginKey prelogin email password
  crypto <- l (L :: L "crypto")
  api :: ApiService <- l (L :: L "api")
  _localHashedPassword <-
    liftPromise
      $ runFn3 crypto.hashPassword password key (nullify hashPurposeLocalAuthorization)
  StringHash hashedPassword <- liftPromise $ runFn3 crypto.hashPassword password key jnull
  liftPromise
    $ api.postIdentityToken
        { email: email
        , masterPasswordHash: hashedPassword
        , captchaResponse: ""
        , twoFactor:
            { provider: twoFactorProviderTypeEmail
            , token: ""
            , remember: false
            }
        , device:
            { type: deviceTypeUnknownBrowser
            , name: "Temporary device name"
            , identifier: "42"
            , pushToken: jnull
            }
        }

hashPassword :: forall r. HasL "cryptoFunctions" CryptoFunctions r => Password -> Al r Hash
hashPassword (Password password) = do
  cryptoFunctions <- l (L :: L "cryptoFunctions")
  liftPromise $ runFn2 cryptoFunctions.hash password cryptoFunctionsTypeSha512

decrypt ::
  forall r.
  HasL "crypto" CryptoService r =>
  HasL "key" SymmetricCryptoKey r =>
  EncryptedString ->
  Al r String
decrypt input = do
  crypto <- l (L :: L "crypto")
  key <- l (L :: L "key")
  liftPromise $ runFn2 crypto.decryptToUtf8 (EncString.fromString input) key

liftPromise ∷ forall m a. MonadAff m ⇒ Promise a → m a
liftPromise = liftAff <<< Promise.toAff

decodeCipher ::
  forall r.
  HasL "crypto" CryptoService r =>
  HasL "key" SymmetricCryptoKey r =>
  CipherResponse -> Al r Bridge.Sub_LoadCipher
decodeCipher cipher = do
  name <- decrypt cipher.name
  cipherType <- case cipher.type of
    n
      | cipherTypeSecureNote == n -> do
        note <- fromJNullable "" <$> (traverse decrypt cipher.notes)
        pure $ Bridge.NoteCipher note
    n
      | cipherTypeLogin == n -> do
        case JNullable.toMaybe cipher.login of
          Nothing -> throwError $ error "Login data is missing"
          Just login -> do
            username <- decryptNullable login.username
            password <- decryptNullable login.password
            uris <- fromJOpt [] <$> ((traverse >>> traverse) (_.uri >>> decrypt) login.uris)
            pure $ Bridge.LoginCipher
              $ Bridge.Cipher_LoginCipher
                  { username
                  , password
                  , uris: wrap uris
                  }
    n
      | cipherTypeCard == n -> do
        case JNullable.toMaybe cipher.card of
          Nothing -> throwError $ error "Card data is missing"
          Just card -> do
            cardholderName <- decryptNullable card.cardholderName
            number <- decryptNullable card.number
            code <- decryptNullable card.code
            brand <- decryptNullable card.brand
            expMonth <- decryptNullable card.expMonth
            expYear <- decryptNullable card.expYear
            pure $ Bridge.CardCipher
              $ Bridge.Cipher_CardCipher
                  { brand, cardholderName, code, expMonth, expYear, number }
    n
      | cipherTypeIdentity == n -> do
        case JNullable.toMaybe cipher.identity of
          Nothing -> throwError $ error "Identity data is missing"
          Just identity -> do
            firstName <- decryptNullable identity.firstName
            middleName <- decryptNullable identity.middleName
            lastName <- decryptNullable identity.lastName
            address1 <- decryptNullable identity.address1
            address2 <- decryptNullable identity.address2
            address3 <- decryptNullable identity.address3
            city <- decryptNullable identity.city
            company <- decryptNullable identity.company
            country <- decryptNullable identity.country
            email <- decryptNullable identity.email
            licenseNumber <- decryptNullable identity.licenseNumber
            passportNumber <- decryptNullable identity.passportNumber
            phone <- decryptNullable identity.phone
            postalCode <- decryptNullable identity.postalCode
            ssn <- decryptNullable identity.ssn
            state <- decryptNullable identity.state
            title <- decryptNullable identity.title
            username <- decryptNullable identity.username
            pure $ Bridge.IdentityCipher
              $ wrap
                  { firstName
                  , middleName
                  , lastName
                  , address1
                  , address2
                  , address3
                  , city
                  , company
                  , country
                  , email
                  , licenseNumber
                  , passportNumber
                  , phone
                  , postalCode
                  , ssn
                  , state
                  , title
                  , username
                  }
    n -> throwError $ error $ "Unsupported cipher type: " <> show n
  pure $ Bridge.Sub_LoadCipher { cipherType, name, id: cipher.id }

decryptNullable ::
  forall x r.
  Newtype x (Maybe String) =>
  HasL "crypto" CryptoService r =>
  HasL "key" SymmetricCryptoKey r =>
  JNullable EncryptedString ->
  Al r x
decryptNullable x = wrap <<< fromJNullable Nothing <<< map Just <$> (traverse decrypt x)
