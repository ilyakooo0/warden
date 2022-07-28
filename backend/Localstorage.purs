module Localstorage where

import Prelude
import Data.Argonaut (class DecodeJson, class EncodeJson)
import Data.Argonaut as Json
import Data.Either (Either(..))
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Exception as Exc
import Type.Prelude (Proxy)
import Web.Storage.Storage (Storage)
import Web.Storage.Storage as Storage

class TypeId a where
  typeId :: Proxy a -> String

class StorageKey k t | k -> t where
  storageKey :: k -> String

store :: forall k t. StorageKey k t => EncodeJson t => Storage -> k -> t -> Effect Unit
store storage key t = Storage.setItem (storageKey key) (Json.stringify $ Json.encodeJson $ t) storage

get :: forall k t. StorageKey k t => DecodeJson t => Storage -> k -> Effect (Maybe t)
get storage key =
  Storage.getItem (storageKey key) storage
    >>= \x -> case x of
        Nothing -> pure Nothing
        Just y -> case Json.parseJson y >>= Json.decodeJson of
          Left err -> Exc.throw $ Json.printJsonDecodeError err
          Right y -> pure $ Just y

delete :: forall k t. StorageKey k t => Storage -> k -> Effect Unit
delete storage key = Storage.removeItem (storageKey key) storage
