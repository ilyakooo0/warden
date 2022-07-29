module Data.JNullable where

import Prelude

import Data.Argonaut (class DecodeJson, class EncodeJson, decodeJson, encodeJson)
import Data.Foldable (class Foldable, foldlDefault, foldrDefault)
import Data.Maybe (Maybe(..))
import Data.Nullable (Nullable, null, toNullable)
import Data.Nullable as Nullable
import Data.Traversable (class Traversable)
import Data.Tuple.Nested ((/\))

newtype JNullable a
  = JNullable (Nullable a)

derive newtype instance Eq a => Eq (JNullable a)
derive newtype instance Ord a => Ord (JNullable a)
derive newtype instance Show a => Show (JNullable a)

instance Functor JNullable where
  map f (JNullable n) = case Nullable.toMaybe n of
    Nothing -> jnull
    Just a -> nullify (f a)

instance Foldable JNullable where
  foldMap f (JNullable n) = case Nullable.toMaybe n of
    Nothing -> mempty
    Just a -> f a
  foldr f def (JNullable n) = case Nullable.toMaybe n of
    Nothing -> def
    Just a -> f a def
  foldl f def (JNullable n) = case Nullable.toMaybe n of
    Nothing -> def
    Just a -> f def a

instance Apply JNullable where
  apply (JNullable n) (JNullable m) = case (Nullable.toMaybe n /\ Nullable.toMaybe m) of
    (Nothing /\ _) -> jnull
    (_ /\ Nothing) -> jnull
    (Just f /\ Just a) -> nullify (f a)


instance Applicative JNullable where
  pure = nullify

instance Traversable JNullable where
  traverse f (JNullable n) = case Nullable.toMaybe n of
    Nothing -> pure jnull
    Just a -> nullify <$> f a

  sequence (JNullable n) = case Nullable.toMaybe n of
    Nothing -> pure jnull
    Just a -> nullify <$> a

instance EncodeJson a => EncodeJson (JNullable a) where
  encodeJson (JNullable a) = encodeJson $ Nullable.toMaybe a

instance DecodeJson a => DecodeJson (JNullable a) where
  decodeJson json = JNullable <<< Nullable.toNullable <$> decodeJson json

jnull :: forall a. JNullable a
jnull = JNullable null

nullify :: forall a. a -> JNullable a
nullify = Just >>> toNullable >>> JNullable

fromJNullable :: forall a. a -> JNullable a -> a
fromJNullable def (JNullable a) = case Nullable.toMaybe a of
  Nothing -> def
  Just a' -> a'

toMaybe :: forall a. JNullable a -> Maybe a
toMaybe (JNullable a) = Nullable.toMaybe a
