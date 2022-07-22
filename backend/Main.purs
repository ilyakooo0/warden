module Main where

import Prelude

import Effect (Effect)
import Effect.Console (log)
import FFI as FFI


main :: Effect Unit
main = do
  FFI.startElm "elm"
  log "🍝"
