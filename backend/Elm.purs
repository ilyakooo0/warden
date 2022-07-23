module Elm
  ( sendEvent
  )
  where

import Prelude

import Bridge as Bridge
import Data.Argonaut.Encode.Generic (genericEncodeJson)
import Effect (Effect)
import FFI as FFI

sendEvent ∷ FFI.Elm → Bridge.Sub → Effect Unit
sendEvent elm a = FFI.sendElmEvent elm "bridge" (genericEncodeJson a)
