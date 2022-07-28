module Data.ShowableJson
  ( ShowableJson(..)
  )
  where

import Prelude

import Data.Argonaut (class DecodeJson, class EncodeJson, Json)
import Data.Argonaut as Json

newtype ShowableJson = ShowableJson Json

instance Show ShowableJson where
  show (ShowableJson x) = Json.stringify x

derive newtype instance Eq ShowableJson
derive newtype instance Ord ShowableJson
derive newtype instance EncodeJson ShowableJson
derive newtype instance DecodeJson ShowableJson
