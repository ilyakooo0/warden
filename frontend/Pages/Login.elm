module Pages.Login exposing (Callbacks, Model, Msg, init, title, update, view)

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
    = UpdateEmail String
    | UpdateServer String
    | UpdatePassword String
    | Submit


type alias Callbacks emsg =
    { submit : { email : String, server : String, password : String } -> emsg
    }


title : String
title =
    "Log into bitwarden"


init : Callbacks emsg -> Model emsg
init callbacks =
    { server = "https://vault.bitwarden.com"
    , email = ""
    , password = ""
    , callbacks = callbacks
    }


update : Msg -> Model emsg -> ( Model emsg, Cmd emsg )
update msg model =
    case msg of
        UpdateEmail email ->
            ( { model | email = email }, Cmd.none )

        UpdateServer server ->
            ( { model | server = server }, Cmd.none )

        UpdatePassword password ->
            ( { model | password = password }, Cmd.none )

        Submit ->
            ( model
            , pureCmd
                (model.callbacks.submit
                    { email = model.email
                    , password = model.password
                    , server = model.password
                    }
                )
            )


view : Model emsg -> List (Html Msg)
view model =
    [ form [ Ev.onSubmit Submit ]
        [ label [] [ text "Server" ]
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
        , alignRight [ button [ Attr.type_ "submit" ] [ text "Log in" ] ]
        ]
    ]
