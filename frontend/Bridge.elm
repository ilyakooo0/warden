module Bridge exposing(..)

import Json.Decode
import Json.Encode exposing (Value)
-- The following module comes from bartavelle/json-helpers
import Json.Helpers exposing (..)
import Dict exposing (Dict)
import Set exposing (Set)


type Sub  =
    Hello 

jsonDecSub : Json.Decode.Decoder ( Sub )
jsonDecSub =
    Json.Decode.lazy (\_ -> Json.Decode.succeed Hello)


jsonEncSub : Sub -> Value
jsonEncSub (Hello ) =
    Json.Encode.list identity []

