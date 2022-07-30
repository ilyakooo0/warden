module Data.Clipboard where

import Prelude
import Control.Promise (Promise)

foreign import clipboard :: String -> Promise Unit
