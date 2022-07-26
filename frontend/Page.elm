module Page exposing (..)

import Html exposing (..)
import Html.Attributes as Attr exposing (..)
import Html.Events exposing (..)
import Time


type alias Env =
    {}


type alias Page init model imsg emsg =
    (imsg -> emsg)
    -> InitializedPage init model imsg emsg


type alias InitializedPage init model imsg emsg =
    { init : init -> ( model, Cmd emsg )
    , view : model -> List (Html emsg)
    , update : imsg -> model -> ( Result String model, Cmd emsg )
    , subscriptions : model -> Sub emsg
    , title : model -> String
    }
