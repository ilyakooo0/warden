module Main where

import Prelude

import Data.Argonaut (encodeJson)
import Effect (Effect)
import Effect.Console (log)
import FFI as FFI


main :: Effect Unit
main = do
  app <- FFI.startElm "elm"
  FFI.sendElmEvent app "getString" (encodeJson "hello from elm")
  FFI.sendElmEvent app "getString" (encodeJson "hello from elm")


  log "🍝"
