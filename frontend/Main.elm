module Main exposing (..)

import Bridge
import Browser
import FFI exposing (getBridge)
import Html exposing (..)
import Html.Attributes as Attr
import Html.Events as Ev
import Utils exposing (..)


type Msg
    = RecieveMessage String
    | Error String
    | UpdateEmail String
    | UpdateServer String
    | UpdatePassword String
    | Submit


type alias Model =
    { messages : List String
    , error : Maybe String
    , server : String
    , email : String
    , password : String
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
    , server = "bitwarden.iko.soy"
    , email = "mail@iko.soy"
    , password = ""
    }


view : Model -> Html Msg
view model =
    div []
        (maybeList model.error (text >> List.singleton >> h2 [])
            ++ [ h1 [] [ text "HELLO" ]
               , ul [] (model.messages |> List.map (text >> List.singleton >> li []))
               , h4 [] [ text "Email" ]
               , input [ Attr.type_ "text", Attr.value model.email, Ev.onInput UpdateEmail ] []
               , h4 [] [ text "Password" ]
               , input [ Attr.type_ "text", Attr.value model.password, Ev.onInput UpdatePassword ] []
               , h4 [] [ text "Server" ]
               , input [ Attr.type_ "text", Attr.value model.server, Ev.onInput UpdateServer ] []
               , button [ Ev.onClick Submit ] [ text "Submit" ]
               , table []
                    [ tbody []
                        (List.repeat 10 (tr [] [ td [] [ text "test" ] ]))
                    ]
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

        UpdateEmail email ->
            ( { model | email = email }, Cmd.none )

        UpdateServer server ->
            ( { model | server = server }, Cmd.none )

        UpdatePassword password ->
            ( { model | password = password }, Cmd.none )

        Submit ->
            ( model
            , FFI.sendBridge
                (Bridge.Login
                    { email = model.email
                    , server = model.server
                    , password = model.password
                    }
                )
            )
