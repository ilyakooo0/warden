module Main where

import Prelude

import BW as WB
import Bridge (Sub(..))
import Data.Nullable (null)
import Effect (Effect)
import Effect.Console (log)
import Elm as Elm
import FFI as FFI


main :: Effect Unit
main = do
  bwAPI <- WB.getAPI
    { base : null,
      webVault : null,
      api : null,
      identity : null,
      icons : null,
      notifications : null,
      events : null,
      keyConnector : null
    }

  app <- FFI.startElm "elm"
  Elm.subscribe app \c -> log $ "Got cmd"
  Elm.send app Hello


  log "🍝"
