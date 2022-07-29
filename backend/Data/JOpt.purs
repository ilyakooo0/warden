module Data.JOpt where

import Prelude

import Data.Argonaut (class DecodeJson, class EncodeJson, decodeJson, encodeJson)
import Data.Foldable (class Foldable)
import Data.Maybe (Maybe(..))
import Data.Traversable (class Traversable)
import Data.Undefined.NoProblem (Opt)
import Data.Undefined.NoProblem as Opt

newtype JOpt a
  = JOpt (Opt a)

derive newtype instance Eq a => Eq (JOpt a)
derive newtype instance Ord a => Ord (JOpt a)
derive newtype instance Show a => Show (JOpt a)

instance Functor JOpt where
  map f (JOpt a) = case Opt.toMaybe a of
    Nothing -> JOpt (Opt.fromMaybe Nothing)
    Just x -> JOpt (Opt.fromMaybe (Just $ f x))

instance Apply JOpt where
  apply (JOpt f) (JOpt a) = case Opt.toMaybe f of
    Nothing -> JOpt (Opt.fromMaybe Nothing)
    Just f' -> case Opt.toMaybe a of
      Nothing -> JOpt (Opt.fromMaybe Nothing)
      Just a' -> JOpt (Opt.fromMaybe (Just $ f' a'))

instance Applicative JOpt where
  pure = JOpt <<< Opt.fromMaybe <<< Just

instance Foldable JOpt where
  foldMap f (JOpt a) = case Opt.toMaybe a of
    Nothing -> mempty
    Just x -> f x
  foldl f z (JOpt a) = case Opt.toMaybe a of
    Nothing -> z
    Just x -> f z x
  foldr f z (JOpt a) = case Opt.toMaybe a of
    Nothing -> z
    Just x -> f x z

instance Traversable JOpt where
  traverse f (JOpt a) = case Opt.toMaybe a of
    Nothing -> pure (JOpt (Opt.fromMaybe Nothing))
    Just x -> map pure (f x)
  sequence (JOpt a) = case Opt.toMaybe a of
    Nothing -> pure (JOpt (Opt.fromMaybe Nothing))
    Just x -> map pure x

fromJOpt :: forall a. a -> JOpt a -> a
fromJOpt def (JOpt a) = case Opt.toMaybe a of
  Nothing -> def
  Just x -> x

instance EncodeJson a => EncodeJson (JOpt a) where
  encodeJson (JOpt a) = encodeJson $ Opt.toMaybe a

instance DecodeJson a => DecodeJson (JOpt a) where
  decodeJson json = JOpt <<< Opt.fromMaybe <$> decodeJson json
