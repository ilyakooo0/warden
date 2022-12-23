module BW.Logic where

import BW
import BW.Types
import Prelude

import Bridge as Bridge
import Control.Monad.Error.Class (throwError)
import Control.Promise (Promise)
import Control.Promise as Promise
import Data.EncString as EncString
import Data.Function.Uncurried (runFn2, runFn3, runFn4)
import Data.JNullable (JNullable, fromJNullable, jnull, nullify)
import Data.JNullable as JNullable
import Data.JOpt (JOpt(..), fromJOpt)
import Data.Maybe (Maybe(..), fromMaybe, maybe)
import Data.Newtype (class Newtype, unwrap, wrap)
import Data.String as String
import Data.SymmetricCryptoKey (SymmetricCryptoKey)
import Data.SymmetricCryptoKey as SymmetricCryptoKey
import Data.Traversable (traverse)
import Data.Undefined.NoProblem (opt, undefined)
import Effect (Effect)
import Effect.Aff (Aff)
import Effect.Aff.Class (class MonadAff, liftAff)
import Effect.Class (liftEffect)
import Effect.Exception (error)
import Effect.Exception as Exc
import Run (Run)
import Run.Reader (Reader, askAt)
import Type.Prelude (Proxy(..))
import Untagged.Union (type (|+|))

-- | Creates the master key
makePreloginKey
  :: forall r
   . PreloginResponse
  -> Email
  -> Password
  -> Run
       ( crypto ::
           Reader CryptoService
       , effect :: Effect
       , aff :: Aff
       | r
       )
       SymmetricCryptoKey
makePreloginKey { kdf, kdfIterations } (Email email') password = do
  crypto <- askAt (Proxy :: _ "crypto")
  let
    email = (String.trim >>> String.toLower) email'
  liftPromise $ runFn4 crypto.makeKey password email kdf kdfIterations

makeDecryptionKey
  :: forall r
   .
  -- | Matser key (prelogin key)
  SymmetricCryptoKey
  -> EncryptedString
  -> Run
       ( crypto :: Reader CryptoService
       , effect :: Effect
       , aff :: Aff
       | r
       )
       SymmetricCryptoKey
makeDecryptionKey masterKey str = do
  crypto <- askAt (Proxy :: _ "crypto")
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

getLogInRequestToken
  :: forall r
   . { prelogin :: PreloginResponse
     , email :: Email
     , password :: Password
     , captchaResponse :: Maybe String
     , secondFactor :: Bridge.Cmd_Login_secondFactor_Maybe
     }
  -> Run
       ( api :: Reader ApiService
       , crypto :: Reader CryptoService
       , effect :: Effect
       , aff :: Aff
       | r
       )
       (IdentityCaptchaResponse |+| IdentityTwoFactorResponse |+| IdentityTokenResponse)
getLogInRequestToken
  { prelogin
  , email
  , password
  , captchaResponse
  , secondFactor: Bridge.Cmd_Login_secondFactor_Maybe secondFactor
  } = do
  let
    twoFactor =
      maybe
        { provider: twoFactorProviderTypeEmail
        , token: ""
        , remember: false
        }
        ( \(Bridge.Cmd_Login_secondFactor x@{ provider }) ->
            x { provider = bridgeToSecondFactorType provider }
        )
        secondFactor
  StringHash hashedPassword <- bwPasswordStringHash prelogin email password
  api :: ApiService <- askAt (Proxy :: _ "api")
  liftPromise
    $ api.postIdentityToken
        { email: email
        , masterPasswordHash: hashedPassword
        , captchaResponse: fromMaybe "" captchaResponse
        , twoFactor
        , device:
            { type: deviceTypeUnknownBrowser
            , name: "Ubuntu Touch"
            , identifier: "42"
            , pushToken: jnull
            }
        }

bwPasswordStringHash
  :: forall r
   . PreloginResponse
  -> Email
  -> Password
  -> Run
       ( crypto :: Reader CryptoService
       , effect :: Effect
       , aff :: Aff
       | r
       )
       StringHash
bwPasswordStringHash prelogin email password = do
  key <- makePreloginKey prelogin email password
  crypto <- askAt (Proxy :: _ "crypto")
  _localHashedPassword <-
    liftPromise
      $ runFn3 crypto.hashPassword password key (nullify hashPurposeLocalAuthorization)
  liftPromise $ runFn3 crypto.hashPassword password key jnull

hashPassword
  :: forall r
   . Password
  -> Run
       ( cryptoFunctions :: Reader CryptoFunctions
       , aff :: Aff
       , effect :: Effect
       | r
       )
       Hash
hashPassword (Password password) = do
  cryptoFunctions <- askAt (Proxy :: _ "cryptoFunctions")
  liftPromise $ runFn2 cryptoFunctions.hash password cryptoFunctionsTypeSha512

decrypt
  :: forall r
   . EncryptedString
  -> Run
       ( key :: Reader SymmetricCryptoKey
       , crypto :: Reader CryptoService
       , aff :: Aff
       , effect :: Effect
       | r
       )
       String
decrypt input = do
  crypto <- askAt (Proxy :: _ "crypto")
  key <- askAt (Proxy :: _ "key")
  liftPromise $ runFn2 crypto.decryptToUtf8 (EncString.fromString input) key

encrypt
  :: forall r
   . String
  -> Run
       ( key :: Reader SymmetricCryptoKey
       , crypto :: Reader CryptoService
       , aff :: Aff
       , effect :: Effect
       | r
       )
       EncryptedString
encrypt input = do
  crypto <- askAt (Proxy :: _ "crypto")
  key <- askAt (Proxy :: _ "key")
  map EncString.toString $ liftPromise $ runFn2 crypto.encrypt input key

liftPromise :: forall m a. MonadAff m => Promise a -> m a
liftPromise = liftAff <<< Promise.toAff

encodeCipher
  :: forall r
   . Bridge.FullCipher
  -> Run
       ( key :: Reader SymmetricCryptoKey
       , crypto :: Reader CryptoService
       , aff :: Aff
       , effect :: Effect
       | r
       )
       CipherResponse
encodeCipher
  (Bridge.FullCipher { name, cipher, id, favorite, reprompt, collectionIds }) = do
  let
    f :: CipherResponse -> Run _ CipherResponse
    f x = case cipher of
      Bridge.CardCipher (Bridge.Cipher_CardCipher c) -> do
        cardholderName <- encryptNullable c.cardholderName
        brand <- encryptNullable c.brand
        number <- encryptNullable c.number
        expMonth <- encryptNullable c.expMonth
        expYear <- encryptNullable c.expYear
        code <- encryptNullable c.code
        pure
          x
            { card =
                nullify
                  { cardholderName
                  , brand
                  , number
                  , expMonth
                  , expYear
                  , code
                  }
            , type = cipherTypeCard
            }
      Bridge.IdentityCipher (Bridge.Cipher_IdentityCipher identity) -> do
        address1 <- encryptNullable identity.address1
        address2 <- encryptNullable identity.address2
        address3 <- encryptNullable identity.address3
        city <- encryptNullable identity.city
        company <- encryptNullable identity.company
        country <- encryptNullable identity.country
        email <- encryptNullable identity.email
        firstName <- encryptNullable identity.firstName
        lastName <- encryptNullable identity.lastName
        licenseNumber <- encryptNullable identity.licenseNumber
        middleName <- encryptNullable identity.middleName
        passportNumber <- encryptNullable identity.passportNumber
        phone <- encryptNullable identity.phone
        postalCode <- encryptNullable identity.postalCode
        ssn <- encryptNullable identity.ssn
        state <- encryptNullable identity.state
        title <- encryptNullable identity.title
        username <- encryptNullable identity.username
        pure
          x
            { identity =
                nullify
                  { address1
                  , address2
                  , address3
                  , city
                  , company
                  , country
                  , email
                  , firstName
                  , lastName
                  , licenseNumber
                  , middleName
                  , passportNumber
                  , phone
                  , postalCode
                  , ssn
                  , state
                  , title
                  , username
                  }
            , type = cipherTypeIdentity
            }
      Bridge.LoginCipher (Bridge.Cipher_LoginCipher login) -> do
        password <- encryptNullable login.password
        uris <-
          traverse
            ( \uri -> do
                uriEnc <- nullify <$> encrypt uri
                pure { uri: uriEnc, match: jnull }
            )
            (unwrap login.uris)
        username <- encryptNullable login.username
        totp <- encryptNullable login.totp
        pure
          x
            { login =
                nullify
                  { password
                  , uris: JOpt $ opt uris
                  , username
                  , passwordRevisionDate: jnull
                  , totp: totp
                  , autofillOnPageLoad: JOpt undefined
                  }
            , type = cipherTypeLogin
            }
      Bridge.NoteCipher note -> do
        encNote <- encrypt note
        pure
          x
            { notes = nullify encNote
            , type = cipherTypeSecureNote
            }
  encName <- encrypt name
  f
    { id
    , organizationId: jnull
    , folderId: jnull
    , type: 0
    , name: encName
    , notes: jnull
    , fields: jnull
    , login: jnull
    , card: jnull
    , identity: jnull
    , secureNote: jnull
    , favorite: favorite
    , edit: jnull
    , viewPassword: jnull
    , organizationUseTotp: jnull
    , revisionDate: jnull
    , attachments: jnull
    , passwordHistory: jnull
    , collectionIds: nullify $ unwrap collectionIds
    , deletedDate: jnull
    , reprompt
    }

-- | Check if the cipher is supported by Warden.
supportedCipher :: CipherResponse -> Boolean
-- We do not support organizations since that requires managing a separate set of 
-- encryption keys
supportedCipher { organizationId } | Just _ <- JNullable.toMaybe organizationId = false
supportedCipher _ = true

decodeCipher
  :: forall r
   . CipherResponse
  -> Run
       ( key :: Reader SymmetricCryptoKey
       , crypto :: Reader CryptoService
       , aff :: Aff
       , effect :: Effect
       | r
       )
       (Maybe Bridge.FullCipher)
decodeCipher cipher | not (supportedCipher cipher) =
  pure $ Nothing
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
            Nothing -> liftEffect $ throwError $ error "Login data is missing"
            Just login -> do
              username <- decryptNullable login.username
              password <- decryptNullable login.password
              totp <- decryptNullable login.totp
              uris <- fromJOpt [] <$>
                ((traverse >>> traverse) (_.uri >>> JNullable.toMaybe >>> maybe (pure "") decrypt) login.uris)
              pure $ Bridge.LoginCipher
                $ Bridge.Cipher_LoginCipher
                    { username
                    , password
                    , uris: wrap uris
                    , totp
                    }
    n
      | cipherTypeCard == n -> do
          case JNullable.toMaybe cipher.card of
            Nothing -> liftEffect $ throwError $ error "Card data is missing"
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
            Nothing -> liftEffect $ throwError $ error "Identity data is missing"
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
    n -> liftEffect $ throwError $ error $ "Unsupported cipher type: " <> show n
  pure $ Just
    $ wrap
        { cipher: cipherType
        , name
        , id: cipher.id
        , favorite: cipher.favorite
        , reprompt: cipher.reprompt
        , collectionIds: wrap <<< fromJNullable [] $ cipher.collectionIds
        }

decryptNullable
  :: forall x r
   . Newtype x (Maybe String)
  => JNullable EncryptedString
  -> Run
       ( key :: Reader SymmetricCryptoKey
       , crypto :: Reader CryptoService
       , aff :: Aff
       , effect :: Effect
       | r
       )
       x
decryptNullable x = wrap <<< fromJNullable Nothing <<< map Just <$> (traverse decrypt x)

encryptNullable
  :: forall x r
   . Newtype x (Maybe String)
  => x
  -> Run
       ( key :: Reader SymmetricCryptoKey
       , crypto :: Reader CryptoService
       , aff :: Aff
       , effect :: Effect
       | r
       )
       (JNullable EncryptedString)
encryptNullable x = case unwrap x of
  Nothing -> pure jnull
  Just y -> nullify <$> encrypt y
