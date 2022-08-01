module Data.HCaptcha where

import Prelude
import Effect (Effect)

foreign import bindHCaptchToken :: (String -> Effect Unit) -> Effect Unit
