module BW.Logic where

import BW.Types
import Prelude

import Control.Ell (class EllHas, Ell, l)
import Data.Nullable (null)

newtype Email = Email String

newtype Password = Password String

generateLogin :: forall r. EllHas (hashPassword :: String -> Ell r String) r => Email -> Password -> Ell r PasswordTokenRequest
generateLogin (Email email) (Password password) = do
  _ <- l _.hashPassword ""
  -- let token = user ++ password
  pure $
    { email
      , masterPasswordHash: ""
      , captchaResponse: ""
      , twoFactor: {
        provider: twoFactorProviderTypeEmail,
        token: "",
        remember: true
      }
      , device: null
    }
