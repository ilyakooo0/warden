module BW.Logic where

import BW
import BW.Types
import Control.El
import Prelude

import Control.Promise as Promise
import Data.Function.Uncurried (runFn3, runFn4)
import Data.Maybe (Maybe(..))
import Data.Nullable (null, toNullable)
import Data.String as String
import Effect.Aff.Class (liftAff)

makePreloginKey ::
  forall r.
  HasL "api" ApiService r =>
  HasL "crypto" CryptoService r =>
  Email -> Password -> Al r SymmetricCryptoKey
makePreloginKey (Email email') (Password password) = do
  api :: ApiService <- l (L :: L "api")
  crypto <- l (L :: L "crypto")

  let email = (String.trim >>> String.toLower) email'

  {kdf, kdfIterations} <- liftAff $ Promise.toAff $ api.postPrelogin {email}
  liftAff $ Promise.toAff $ runFn4 crypto.makeKey (Password password) email kdf kdfIterations

getLogInRequestToken ::
  forall r.
  HasL "api" ApiService r =>
  HasL "crypto" CryptoService r =>
  Email -> Password -> Al r IdentityTokenResponse
getLogInRequestToken email password = do
  key <- makePreloginKey email password
  crypto <- l (L :: L "crypto")
  api :: ApiService <- l (L :: L "api")

  _localHashedPassword <- liftAff $ Promise.toAff $
    runFn3 crypto.hashPassword password key (toNullable $ Just hashPurposeLocalAuthorization)

  Hash hashedPassword <- liftAff $ Promise.toAff $ runFn3 crypto.hashPassword password key null

  liftAff $ Promise.toAff $ api.postIdentityToken  {
      email: email,
      masterPasswordHash: hashedPassword,
      captchaResponse: "",
      twoFactor: {
        provider: twoFactorProviderTypeEmail,
        token: "",
        remember: false
      },
      device: {
        type: deviceTypeUnknownBrowser,
        name: "Temporary device name",
        identifier: "42",
        pushToken: null
      }
    }
