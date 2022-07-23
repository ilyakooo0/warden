module Main where

import Prelude

import Bridge (Sub(..))
import Effect (Effect)
import Effect.Console (log)
import Elm as Elm
import FFI as FFI


main :: Effect Unit
main = do
  app <- FFI.startElm "elm"
  Elm.subscribe app \c -> log $ "Got cmd"
  Elm.send app Hello


  log "🍝"
