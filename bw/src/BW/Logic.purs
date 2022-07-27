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
import Data.Maybe (Maybe(..))
import Data.Nullable (null, toNullable)
import Data.String as String
import Data.SymmetricCryptoKey (SymmetricCryptoKey)
import Data.SymmetricCryptoKey as SymmetricCryptoKey
import Effect.Aff.Class (class MonadAff, liftAff)
import Effect.Class (liftEffect)
import Effect.Class.Console (log)
import Effect.Exception (error)
import Effect.Exception as Exc

makePreloginKey ::
  forall r.
  HasL "api" ApiService r =>
  HasL "crypto" CryptoService r =>
  Email -> Password -> Al r SymmetricCryptoKey
makePreloginKey (Email email') (Password password) = do
  api :: ApiService <- l (L :: L "api")
  crypto <- l (L :: L "crypto")
  let
    email = (String.trim >>> String.toLower) email'
  { kdf, kdfIterations } <- liftPromise $ api.postPrelogin { email }
  liftPromise $ runFn4 crypto.makeKey (Password password) email kdf kdfIterations

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
  Email -> Password -> Al r IdentityTokenResponse
getLogInRequestToken email password = do
  key <- makePreloginKey email password
  crypto <- l (L :: L "crypto")
  api :: ApiService <- l (L :: L "api")
  _localHashedPassword <-
    liftPromise
      $ runFn3 crypto.hashPassword password key (toNullable $ Just hashPurposeLocalAuthorization)
  Hash hashedPassword <- liftPromise $ runFn3 crypto.hashPassword password key null
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
            , pushToken: null
            }
        }

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
