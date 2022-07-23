module Main where

import Prelude

import BW as WB
import Bridge (Sub(..))
import Bridge as Bridge
import Control.Promise (toAff)
import Data.Argonaut as A
import Data.Either (Either(..))
import Data.Maybe (Maybe(..))
import Data.Nullable (null, toNullable)
import Effect (Effect)
import Effect.Aff (joinFiber, runAff, runAff_)
import Effect.Console (log)
import Elm as Elm
import FFI as FFI
import Foreign as F


main :: Effect Unit
main = do
  app <- FFI.startElm "elm"
  Elm.subscribe app \(Bridge.Login (Bridge.Cmd_Login {email, server})) -> do
    log $ "Got cmd"
    bwAPI <- WB.getAPI
      { base : toNullable $ Just server,
        webVault : null,
        api : null,
        identity : null,
        icons : null,
        notifications : null,
        events : null,
        keyConnector : null
      }
    runAff_ (\res -> case res of
        Left _ -> log "Error"
        Right x -> log $ show x
      ) $ toAff $ bwAPI.postPrelogin {email}
    pure unit

  Elm.send app Hello

  log "🍝"
