module Pages.Ciphers exposing (Callbacks, Model, Msg, page)

import Bridge
import Html exposing (..)
import Html.Attributes as Attr
import Html.Events as Ev
import Page exposing (..)
import Utils exposing (..)


type alias Model =
    { ciphers : Bridge.Sub_LoadCiphers_List
    }


type Msg
    = Noop


type alias Callbacks msg =
    { selected : String -> msg
    }


page : Callbacks emsg -> Page Bridge.Sub_LoadCiphers_List Model Msg emsg
page callbacks liftMsg =
    { init = \ciphers -> Tuple.mapSecond (Cmd.map liftMsg) (init ciphers)
    , view = view callbacks
    , update = \msg model -> update callbacks liftMsg msg model
    , subscriptions = \model -> subscriptions model |> Sub.map liftMsg
    , title = always "Passwords"
    }


init : Bridge.Sub_LoadCiphers_List -> ( Model, Cmd Msg )
init ciphers =
    ( { ciphers = ciphers }
    , Cmd.none
    )


update : Callbacks emsg -> (Msg -> emsg) -> Msg -> Model -> ( Result String Model, Cmd emsg )
update {} liftMsg msg model =
    case msg of
        Noop ->
            ( Ok model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


view : Callbacks emsg -> Model -> List (Html emsg)
view { selected } { ciphers } =
    [ ul [ Attr.class "p-list--divided" ]
        (List.map
            (\{ name, date, id } ->
                li [ Attr.class "p-list__item cipher-row", Ev.onClick (selected id) ]
                    [ div [ Attr.class "cipher-row-container" ]
                        [ p [] [ text name ]
                        , p [ Attr.class "p-text--small u-align-text--right u-text--muted" ] [ text date ]
                        ]
                    ]
            )
            ciphers
        )
    ]
