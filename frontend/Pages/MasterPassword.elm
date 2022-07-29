module Pages.MasterPassword exposing (..)

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
    = UpdatePassword String
    | Submit
    | Reset


type alias Callbacks emsg =
    { submit : { password : String } -> emsg
    , reset : emsg
    }


page : Callbacks emsg -> Page { server : String, login : String } Model Msg emsg
page callbacks liftMsg =
    { init = \cfg -> Tuple.mapSecond (Cmd.map liftMsg) (init cfg)
    , view = \model -> view model |> List.map (Html.map liftMsg)
    , update = \msg model -> update callbacks liftMsg msg model
    , subscriptions = \model -> subscriptions model |> Sub.map liftMsg
    , title = always "Enter master password"
    }


init : { server : String, login : String } -> ( Model, Cmd Msg )
init { server, login } =
    ( { server = server
      , email = login
      , password = ""
      }
    , Cmd.none
    )


update : Callbacks emsg -> (Msg -> emsg) -> Msg -> Model -> ( Result String Model, Cmd emsg )
update { submit, reset } _ msg model =
    case msg of
        UpdatePassword password ->
            ( Ok { model | password = password }, Cmd.none )

        Submit ->
            ( Ok model, pureCmd (submit { password = model.password }) )

        Reset ->
            ( Ok model, pureCmd reset )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


view : Model -> List (Html Msg)
view model =
    [ alignRight [ button [ Attr.class "p-button--negative", Ev.onClick Reset ] [ text "Log out" ] ]
    , table [ Attr.class "p-table--mobile-card" ]
        [ thead [] [ tr [] [ th [] [ text "Server" ], th [] [ text "Email" ] ] ]
        , tbody
            []
            [ tr []
                [ td [ Attr.attribute "data-heading" "Server" ] [ text model.server ]
                , td [ Attr.attribute "data-heading" "Email" ] [ text model.email ]
                ]
            ]
        ]
    , form []
        [ label [] [ text "Password" ]
        , input
            [ Attr.type_ "password"
            , Attr.value model.password
            , Ev.onInput UpdatePassword
            , Attr.attribute "autocomplete" "current-password"
            ]
            []
        ]
    , alignRight [ button [ Ev.onClick Submit ] [ text "Log in" ] ]
    ]
