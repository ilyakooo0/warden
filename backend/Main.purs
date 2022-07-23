module Main where

import Prelude

import Bridge (Sub(..))
import Effect (Effect)
import Effect.Console (log)
import Elm (sendEvent)
import FFI as FFI


main :: Effect Unit
main = do
  app <- FFI.startElm "elm"
  sendEvent app Hello


  log "🍝"
