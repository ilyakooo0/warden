module Page exposing (..)

import Browser
import GlobalEvents exposing (Event)
import Html exposing (..)
import Html.Events exposing (..)


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
    , title : model -> List (Html emsg)
    , event : model -> Event -> model
    }


page :
    { init : ( model, Cmd msg )
    , view : model -> List (Html msg)
    , update : msg -> model -> ( model, Cmd (Maybe msg) )
    }
    -> Program () model (Maybe msg)
page { init, view, update } =
    Browser.element
        { subscriptions = always Sub.none
        , init = \_ -> init |> Tuple.mapSecond (Cmd.map Just)
        , view = view >> Html.div [] >> Html.map Just
        , update =
            \mmsg model ->
                case mmsg of
                    Nothing ->
                        ( model, Cmd.none )

                    Just msg ->
                        update msg model
        }
