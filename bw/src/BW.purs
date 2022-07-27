module BW where

import BW.Types
import Prelude
import Control.Promise (Promise)
import Data.ArrayBuffer.Types (ArrayBuffer)
import Data.EncString (EncString)
import Data.Function.Uncurried (Fn2, Fn3, Fn4)
import Data.Nullable (Nullable)
import Data.SymmetricCryptoKey (SymmetricCryptoKey)
import Effect (Effect)

type CryptoService
  = { makeKey :: Fn4 Password String KDF Int (Promise SymmetricCryptoKey)
    , hashPassword :: Fn3 Password SymmetricCryptoKey (Nullable HashPurpose) (Promise Hash)
    , decryptToUtf8 :: Fn2 EncString SymmetricCryptoKey (Promise String)
    , decryptToBytes :: Fn2 EncString SymmetricCryptoKey (Promise ArrayBuffer)
    , stretchKey :: SymmetricCryptoKey -> Promise SymmetricCryptoKey
    }

type ApiService
  = { postPrelogin :: PreloginRequest -> Promise PreloginResponse
    , getProfile :: Unit -> Promise ProfileResponse
    -- TODO: There can really be more request and response types. Maybe handle this later.
    , postIdentityToken :: PasswordTokenRequest -> Promise IdentityTokenResponse
    , getSync :: Unit -> Promise SyncResponse
    }

type Services
  = { crypto :: CryptoService
    , getApi :: Urls -> Nullable IdentityTokenResponse -> Promise ApiService
    }

foreign import getServices :: Effect Services
