module Elm
  ( send
  , subscribe
  ) where

import Data.Either
import Prelude
import Bridge as Bridge
import Data.Argonaut (decodeJson, encodeJson, stringify)
import Effect (Effect)
import Effect.Class.Console (log)
import FFI as FFI
import Effect.Exception (try)

send ∷ FFI.Elm → Bridge.Sub → Effect Unit
send elm a = FFI.sendElmEvent elm "bridgeSub" (encodeJson a)

subscribe :: FFI.Elm → (Bridge.Cmd → Effect Unit) -> Effect Unit
subscribe elm f =
  FFI.createElmSubscription elm "bridgeCmd"
    $ \a → do
        log $ stringify a
        result <- case decodeJson a of
          Right (cmd :: Bridge.Cmd) -> do
            result <- try $ f cmd
            case result of
              Left err -> pure $ Left $ show err
              Right _ -> pure $ Right unit
          Left err -> pure $ Left $ show err
        case result of
          Left err -> do
            log err
            send elm $ Bridge.Error err
          Right _ -> pure unit
