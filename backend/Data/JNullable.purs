module Data.JNullable where

import Prelude

import Data.Argonaut (class DecodeJson, class EncodeJson, decodeJson, encodeJson)
import Data.Maybe (Maybe(..))
import Data.Nullable (Nullable, null, toNullable)
import Data.Nullable as Nullable

newtype JNullable a
  = JNullable (Nullable a)

derive newtype instance Eq a => Eq (JNullable a)
derive newtype instance Ord a => Ord (JNullable a)
derive newtype instance Show a => Show (JNullable a)

instance EncodeJson a => EncodeJson (JNullable a) where
  encodeJson (JNullable a) = encodeJson $ Nullable.toMaybe a

instance DecodeJson a => DecodeJson (JNullable a) where
  decodeJson json = JNullable <<< Nullable.toNullable <$> decodeJson json

jnull :: forall a. JNullable a
jnull = JNullable null

nullify :: forall a. a -> JNullable a
nullify = Just >>> toNullable >>> JNullable
