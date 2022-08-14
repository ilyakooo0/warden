module Pages.Login exposing (Callbacks, Model, Msg, page)

import Html exposing (..)
import Html.Attributes as Attr
import Html.Events as Ev
import Page exposing (..)
import Utils exposing (..)


type alias Model =
    { server : String
    , email : String
    , password : String
    }


type Msg
    = UpdateEmail String
    | UpdateServer String
    | UpdatePassword String
    | Submit


type alias Callbacks emsg =
    { submit : { email : String, server : String, password : String } -> emsg
    }


page : Callbacks emsg -> Page () Model Msg emsg
page callbacks liftMsg =
    { init = \() -> Tuple.mapSecond (Cmd.map liftMsg) init
    , view = \model -> view model |> List.map (Html.map liftMsg)
    , update = \msg model -> update callbacks liftMsg msg model
    , subscriptions = \model -> subscriptions model |> Sub.map liftMsg
    , title = always [ text "Log into bitwarden" ]
    , event = \model _ -> model
    }


init : ( Model, Cmd Msg )
init =
    ( { server = "https://vault.bitwarden.com"
      , email = ""
      , password = ""
      }
    , Cmd.none
    )


update : Callbacks emsg -> (Msg -> emsg) -> Msg -> Model -> ( Result String Model, Cmd emsg )
update { submit } liftMsg msg model =
    case msg of
        UpdateEmail email ->
            ( Ok { model | email = email }, Cmd.none )

        UpdateServer server ->
            ( Ok { model | server = server }, Cmd.none )

        UpdatePassword password ->
            ( Ok { model | password = password }, Cmd.none )

        Submit ->
            ( Ok model, pureCmd (submit model) )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


view : Model -> List (Html Msg)
view model =
    [ form [ Ev.onSubmit Submit ]
        ([ label [] [ text "Server" ]
         , input
            [ Attr.type_ "url"
            , Attr.value model.server
            , Ev.onInput UpdateServer
            , Attr.attribute "autocomplete" "url"
            , Attr.required True
            ]
            []
         , label [] [ text "Email" ]
         , input
            [ Attr.type_ "email"
            , Attr.value model.email
            , Ev.onInput UpdateEmail
            , Attr.attribute "autocomplete" "email"
            , Attr.required True
            ]
            []
         , label [] [ text "Password" ]
         , input
            [ Attr.type_ "password"
            , Attr.value model.password
            , Ev.onInput UpdatePassword
            , Attr.attribute "autocomplete" "current-password"
            , Attr.required True
            ]
            []
         ]
            ++ [ alignRight [ button [ Attr.type_ "submit" ] [ text "Log in" ] ] ]
        )
    ]
