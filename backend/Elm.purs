module Elm
  ( send
  , subscribe
  )
  where

import Data.Either
import Prelude

import Bridge as Bridge
import Data.Argonaut (decodeJson, encodeJson, stringify)
import Effect (Effect)
import Effect.Class.Console (log)
import FFI as FFI

send ∷ FFI.Elm → Bridge.Sub → Effect Unit
send elm a = FFI.sendElmEvent elm "bridgeSub" (encodeJson a)

subscribe :: FFI.Elm → (Bridge.Cmd → Effect Unit) -> Effect Unit
subscribe elm f = FFI.createElmSubscription elm "bridgeCmd" $ \a → do
  log $ stringify a
  case decodeJson a of
    Right (cmd :: Bridge.Cmd) ->  f cmd
    Left err -> log $ show err
