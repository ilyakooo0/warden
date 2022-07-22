module FFI
  ( startElm
  )
  where

import Prelude

import Effect (Effect)

foreign import startElm :: String -> Effect Unit
