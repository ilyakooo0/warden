module Data.JOpt where

import Prelude

import Data.Argonaut (class DecodeJson, class EncodeJson, decodeJson, encodeJson)
import Data.Undefined.NoProblem (Opt)
import Data.Undefined.NoProblem as Opt

newtype JOpt a
  = JOpt (Opt a)

derive newtype instance Eq a => Eq (JOpt a)
derive newtype instance Ord a => Ord (JOpt a)
derive newtype instance Show a => Show (JOpt a)

instance EncodeJson a => EncodeJson (JOpt a) where
  encodeJson (JOpt a) = encodeJson $ Opt.toMaybe a

instance DecodeJson a => DecodeJson (JOpt a) where
  decodeJson json = JOpt <<< Opt.fromMaybe <$> decodeJson json
