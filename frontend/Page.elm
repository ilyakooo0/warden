module Page exposing (..)

import Browser
import Html exposing (..)
import Html.Events exposing (..)


page :
    { init : model
    , view : model -> List (Html msg)
    , update : msg -> model -> ( model, Cmd (Maybe msg) )
    }
    -> Program () model (Maybe msg)
page { init, view, update } =
    Browser.element
        { subscriptions = always Sub.none
        , init = \_ -> ( init, Cmd.none )
        , view = view >> Html.div [] >> Html.map Just
        , update =
            \mmsg model ->
                case mmsg of
                    Nothing ->
                        ( model, Cmd.none )

                    Just msg ->
                        update msg model
        }
