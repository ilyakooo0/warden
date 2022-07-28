module BW.Logic where

import BW
import BW.Types
import Control.El
import Prelude
import Control.Monad.Error.Class (throwError)
import Control.Promise (Promise)
import Control.Promise as Promise
import Data.EncString as EncString
import Data.Function.Uncurried (runFn2, runFn3, runFn4)
import Data.JNullable (jnull, nullify)
import Data.Maybe (Maybe(..))
import Data.String as String
import Data.SymmetricCryptoKey (SymmetricCryptoKey)
import Data.SymmetricCryptoKey as SymmetricCryptoKey
import Effect.Aff.Class (class MonadAff, liftAff)
import Effect.Class (liftEffect)
import Effect.Class.Console (log)
import Effect.Exception (error)
import Effect.Exception as Exc
import Localstorage (class StorageKey)
import Web.Storage.Storage (Storage)

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
