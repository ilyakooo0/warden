module Main where

import Prelude

import BW as WB
import BW.Logic as Logic
import BW.Types (Email(..), Password(..))
import Bridge (Sub(..))
import Bridge as Bridge
import Control.Monad.Reader (runReaderT)
import Control.Promise as Promise
import Data.Either (Either(..))
import Data.Maybe (Maybe(..))
import Data.Nullable (null, toNullable)
import Effect (Effect)
import Effect.Aff (runAff_)
import Effect.Aff.Class as Aff
import Effect.Class (liftEffect)
import Effect.Console (log)
import Elm as Elm
import FFI as FFI


main :: Effect Unit
main = do
  app <- FFI.startElm "elm"
  let
    processResult res = do
      log res
      Elm.send app (GotEverything res)
  Elm.subscribe app \(Bridge.Login (Bridge.Cmd_Login {email, server, password})) -> do
    log $ "Got cmd"
    services <- WB.getServices
    runAff_ (\res -> case res of
          Left e -> processResult $ show e
          Right x -> processResult $ show x
        ) do
      unauthedApi <- Aff.liftAff $ Promise.toAff $ services.getApi
        { base : toNullable $ Just server,
          webVault : null,
          api : null,
          identity : null,
          icons : null,
          notifications : null,
          events : null,
          keyConnector : null
        }
        null

      runReaderT (do
          tokens <- Logic.getLogInRequestToken (Email email) (Password password)

          api <- Aff.liftAff $ Promise.toAff $ services.getApi
            { base : toNullable $ Just server,
              webVault : null,
              api : null,
              identity : null,
              icons : null,
              notifications : null,
              events : null,
              keyConnector : null
            }
            (toNullable $ Just tokens)


          Aff.liftAff $ Promise.toAff $ api.getSync unit
          ) {
            api: unauthedApi,
            crypto : services.crypto
          }

  Elm.send app Hello

  log "🍝"
