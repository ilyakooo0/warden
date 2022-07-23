module Main exposing (..)

import Browser
import FFI exposing (getBridge)
import Html exposing (..)
import Utils exposing (..)


type Msg
    = RecieveMessage String
    | Error String


type alias Model =
    { messages : List String
    , error : Maybe String
    }


main : Program () Model Msg
main =
    Browser.element
        { init = \_ -> ( init, Cmd.none )
        , view = view
        , update = update
        , subscriptions = \_ -> getBridge Error (always (RecieveMessage "Got it!"))
        }


init : Model
init =
    { messages = []
    , error = Nothing
    }


view : Model -> Html Msg
view model =
    div []
        (maybeList model.error (text >> List.singleton >> h2 [])
            ++ [ h1 [] [ text "HELLO" ]
               , ul [] (model.messages |> List.map (text >> List.singleton >> li []))
               ]
        )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        RecieveMessage x ->
            ( { model | messages = x :: model.messages }
            , Cmd.none
            )

        Error err ->
            ( { model | error = Just err }, Cmd.none )
