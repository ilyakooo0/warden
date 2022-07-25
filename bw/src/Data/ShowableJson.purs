module Data.ShowableJson
  ( ShowableJson(..)
  )
  where

import Prelude

import Data.Argonaut (Json)
import Data.Argonaut as Json

newtype ShowableJson = ShowableJson Json

instance Show ShowableJson where
  show (ShowableJson x) = Json.stringify x
