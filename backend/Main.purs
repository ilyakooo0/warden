module Main
  ( main
  ) where

import Prelude
import BW as WB
import BW.Logic (decrypt)
import BW.Logic as Logic
import BW.Types (Email(..), EncryptedString(..), Password(..), Urls)
import Bridge as Bridge
import Control.Monad.Reader (runReaderT)
import Control.Promise (Promise)
import Control.Promise as Promise
import Data.Argonaut (class EncodeJson, encodeJson)
import Data.Argonaut as Json
import Data.Either (Either(..))
import Data.Maybe (Maybe(..))
import Data.Nullable (Nullable, null, toNullable)
import Data.Nullable as Nullable
import Data.Traversable (traverse)
import Effect (Effect)
import Effect.Aff (Aff, runAff_, try)
import Effect.Aff as Aff
import Effect.Aff.Class (class MonadAff, liftAff)
import Effect.Aff.Class as Aff
import Effect.Class (liftEffect)
import Effect.Class.Console (log)
import Effect.Exception as Exc
import Elm as Elm
import FFI as FFI
import Prelude as Array
import Unsafe.Coerce (unsafeCoerce)

main :: Effect Unit
main = do
  app <- FFI.startElm "elm"
  services <- WB.getServices
  Elm.subscribe app \cmd -> case cmd of
    Bridge.Login (Bridge.Cmd_Login { email, server, password }) -> do
      let
        urls = baseUrl server
      runElmAff app do
        unauthedApi <- liftPromise $ services.getApi urls null
        { masterKey, token } <-
          flip runReaderT { api: unauthedApi, crypto: services.crypto } do
            token <-
              try (Logic.getLogInRequestToken (Email email) (Password password))
                >>= \et -> case et of
                    Left _ -> liftEffect $ Exc.throw "Could not log in. Please check your data and try again."
                    Right t -> pure t
            masterKey <- Logic.makePreloginKey (Email email) (Password password)
            pure { token, masterKey }
        api <- liftPromise $ services.getApi urls (nullify token)
        _ <-
          flip runReaderT { api: api, crypto: services.crypto } do
            sync <- liftPromise $ api.getSync unit
            key <- Logic.makeDecryptionKey masterKey sync.profile.key
            log $ show key.keyB64
            ciphersNames <- traverse (decrypt key) $ map _.name sync.ciphers
            liftEffect $ Elm.send app $ Bridge.Hello $ Bridge.Sub_Hello { first: "hello", second: show ciphersNames }
            pure unit
        pure unit
    Bridge.Init -> Elm.send app (Bridge.NeedsLogin)

liftPromise ∷ forall m a. MonadAff m ⇒ Promise a → m a
liftPromise = Aff.liftAff <<< Promise.toAff

runElmAff :: FFI.Elm -> Aff Unit -> Effect Unit
runElmAff app =
  runAff_
    $ \res -> do
        case res of
          Left e -> do
            log $ show e
            Elm.send app (Bridge.Error $ Exc.message e)
          Right unit -> pure unit

baseUrl :: String -> Urls
baseUrl server =
  { base: nullify server
  , webVault: null
  , api: null
  , identity: null
  , icons: null
  , notifications: null
  , events: null
  , keyConnector: null
  }

nullify :: forall a. a -> Nullable a
nullify = Just >>> toNullable
