module Main exposing (..)

import Browser
import FFI
import Html exposing (..)


type Msg
    = RecieveMessage String


type alias Model =
    { messages : List String
    }


main : Program () Model Msg
main =
    Browser.element
        { init = \_ -> ( init, Cmd.none )
        , view = view
        , update = update
        , subscriptions = \_ -> FFI.getString RecieveMessage
        }


init : Model
init =
    { messages = []
    }


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text "HELLO" ]
        , ul [] (model.messages |> List.map (text >> List.singleton >> li []))
        ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        RecieveMessage x ->
            ( { messages = x :: model.messages
              }
            , Cmd.none
            )
