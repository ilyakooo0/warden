module Pages.MasterPassword exposing (Callbacks, Model, Msg, init, title, update, view)

import Html exposing (..)
import Html.Attributes as Attr
import Html.Events as Ev
import Page exposing (..)
import Utils exposing (..)


type alias Model emsg =
    { server : String
    , email : String
    , password : String
    , callbacks : Callbacks emsg
    }


type Msg
    = UpdatePassword String
    | Submit
    | Reset


type alias Callbacks emsg =
    { submit : { password : String } -> emsg
    , reset : emsg
    }


title : String
title =
    "Enter master password"


init : Callbacks emsg -> { server : String, login : String } -> Model emsg
init callbacks { server, login } =
    { server = server
    , email = login
    , password = ""
    , callbacks = callbacks
    }


update : Msg -> Model emsg -> ( Model emsg, Cmd emsg )
update msg model =
    case msg of
        UpdatePassword password ->
            ( { model | password = password }, Cmd.none )

        Submit ->
            ( model, pureCmd (model.callbacks.submit { password = model.password }) )

        Reset ->
            ( model, pureCmd model.callbacks.reset )


view : Model emsg -> List (Html Msg)
view model =
    [ alignRight [ button [ Attr.class "p-button--negative", Ev.onClick Reset ] [ text "Log out" ] ]
    , table [ Attr.class "p-table--mobile-card u-no-margin" ]
        [ thead [] [ tr [] [ th [] [ text "Server" ], th [] [ text "Email" ] ] ]
        , tbody
            []
            [ tr []
                [ td [ Attr.attribute "data-heading" "Server" ] [ text model.server ]
                , td [ Attr.attribute "data-heading" "Email" ] [ text model.email ]
                ]
            ]
        ]
    , form [ Ev.onSubmit Submit ]
        [ label [] [ text "Password" ]
        , input
            [ Attr.type_ "password"
            , Attr.value model.password
            , Ev.onInput UpdatePassword
            , Attr.attribute "autocomplete" "new-password"
            , Attr.required True
            ]
            []
        , alignRight [ button [ Attr.type_ "submit" ] [ text "Log in" ] ]
        ]
    ]
