module BW where

import BW.Types
import Prelude

import Control.Promise (Promise)
import Data.Function.Uncurried (Fn3, Fn4)
import Data.Nullable (Nullable)
import Effect (Effect)

type CryptoService = {
  makeKey :: Fn4 Password String KDF Int (Promise SymmetricCryptoKey),
  hashPassword :: Fn3 Password SymmetricCryptoKey (Nullable HashPurpose) (Promise Hash)
}

type ApiService = {
  postPrelogin :: PreloginRequest -> Promise PreloginResponse,
  getProfile :: Unit -> Promise ProfileResponse,

  -- TODO: There can really be more request and response types. Maybe handle this later.
  postIdentityToken :: PasswordTokenRequest -> Promise IdentityTokenResponse,
  getSync :: Unit -> Promise SyncResponse
}

type Services = {
  crypto :: CryptoService,
  getApi :: Urls -> Nullable IdentityTokenResponse -> Promise ApiService
}

foreign import getServices :: Effect Services
