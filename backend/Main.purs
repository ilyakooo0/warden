module Main where

import Prelude

import BW as WB
import BW.Logic as Logic
import BW.Types (Email(..), Password(..))
import Bridge (Sub(..))
import Bridge as Bridge
import Control.Monad.Reader (runReaderT)
import Data.Either (Either(..))
import Data.Maybe (Maybe(..))
import Data.Nullable (null, toNullable)
import Effect (Effect)
import Effect.Aff (runAff_)
import Effect.Console (log)
import Elm as Elm
import FFI as FFI


main :: Effect Unit
main = do
  app <- FFI.startElm "elm"
  Elm.subscribe app \(Bridge.Login (Bridge.Cmd_Login {email, server, password})) -> do
    log $ "Got cmd"
    services <- WB.getServices
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
        Left e -> log $ show e
        Right x -> log $ show x
      ) $ runReaderT (Logic.getLogInRequestToken (Email email) (Password password)) {
          api: services.api,
          crypto : services.crypto
        }
    pure unit

  Elm.send app Hello

  log "🍝"
