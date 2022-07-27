module Main
  ( main
  ) where

import Bridge
import Prelude
import BW (CryptoService)
import BW as WB
import BW.Logic (decrypt, liftPromise)
import BW.Logic as Logic
import BW.Types (Email(..), EncryptedString(..), Password(..), Urls, CipherResponse)
import Bridge as Bridge
import Control.El (class HasL, Al, L(..), l)
import Control.Monad.Reader (runReaderT)
import Control.Promise (Promise)
import Control.Promise as Promise
import Data.Argonaut (class EncodeJson, encodeJson)
import Data.Argonaut as Json
import Data.Array as A
import Data.Either (Either(..))
import Data.Maybe (Maybe(..))
import Data.Nullable (Nullable, null, toNullable)
import Data.Nullable as Nullable
import Data.SymmetricCryptoKey (SymmetricCryptoKey)
import Data.Timestamp as Timestamp
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
        { masterKey, token, key } <-
          flip runReaderT { api: unauthedApi, crypto: services.crypto } do
            token <-
              try (Logic.getLogInRequestToken (Email email) (Password password))
                >>= \et -> case et of
                    Left _ -> liftEffect $ Exc.throw "Could not log in. Please check your data and try again."
                    Right t -> pure t
            masterKey <- Logic.makePreloginKey (Email email) (Password password)
            key <- Logic.makeDecryptionKey masterKey token.key
            pure { token, masterKey, key }
        api <- liftPromise $ services.getApi urls (nullify token)
        _ <-
          flip runReaderT { api: api, crypto: services.crypto, key: key } do
            sync <- liftPromise $ api.getSync unit
            processedCiphers <- traverse processCipher sync.ciphers
            liftEffect $ Elm.send app $ LoadCiphers $ Bridge.Sub_LoadCiphers_List (A.take 3 processedCiphers)
            pure unit
        pure unit
    Bridge.Init -> Elm.send app (Bridge.NeedsLogin)

processCipher ::
  forall r.
  HasL "crypto" CryptoService r =>
  HasL "key" SymmetricCryptoKey r =>
  CipherResponse -> Al r Bridge.Sub_LoadCiphers
processCipher cipher = do
  name <- decrypt cipher.name
  pure
    $ Bridge.Sub_LoadCiphers
        { name: name, date: Timestamp.toLocalDateTimeString cipher.revisionDate }

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
