module BW where

import Prelude

import BW.Types
import Control.Promise (Promise)
import Effect (Effect)



type ApiService = {
  postPrelogin :: PreloginRequest -> Promise PreloginResponse,
  getProfile :: Unit -> Promise ProfileResponse
}

foreign import getAPI :: Urls -> Effect ApiService
