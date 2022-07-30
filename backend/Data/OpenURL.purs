module Data.OpenURL where

import Prelude
import Effect (Effect)

foreign import openURL :: String -> Effect Unit
