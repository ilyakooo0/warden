module Main exposing (..)

import Browser
import Html exposing (..)


type alias Msg =
    ()


type alias Model =
    ()


main : Program () Model Msg
main =
    Browser.sandbox
        { init = init
        , view = view
        , update = update
        }


init : Model
init =
    ()


view : Model -> Html Msg
view _ =
    h1 [] [ text "HELLO" ]


update : Msg -> Model -> Model
update _ model =
    model
