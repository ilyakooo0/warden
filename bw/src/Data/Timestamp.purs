module Data.Timestamp where

import Prelude
import Data.Bifunctor (lmap)
import Data.DateTime (DateTime)
import Data.DateTime.Parsing as DateTime
import Data.Either (Either(..), either)
import Data.Maybe (maybe)
import Effect (Effect)
import Effect.Exception (throw)

newtype Timestamp
  = Timestamp String

toDateTime :: Timestamp -> Effect DateTime
toDateTime (Timestamp ts) =
  either throw pure
    $ lmap (const $ "Couldn't parse date: " <> ts) (DateTime.fromString ts)
    >>= (DateTime.toUTC >>> maybe (Left $ "Couldn't process date " <> ts) Right)

foreign import toLocalDateTimeString :: Timestamp -> String
