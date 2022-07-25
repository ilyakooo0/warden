module Data.EncString where

import Prelude

foreign import data EncString :: Type

foreign import fromString :: String -> EncString
