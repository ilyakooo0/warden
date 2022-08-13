module Pages.SelectCipherType exposing (..)

import Bridge
import Html exposing (..)
import Html.Attributes as Attr
import Html.Events as Ev
import Page exposing (..)
import Utils exposing (..)


type alias Model =
    {}


type Msg
    = Choose Bridge.CipherType


type alias Callbacks msg =
    { choose : Bridge.CipherType -> msg
    }


page : Callbacks emsg -> Page () Model Msg emsg
page callbacks liftMsg =
    { init = \() -> Tuple.mapSecond (Cmd.map liftMsg) init
    , view = \model -> view model |> List.map (Html.map liftMsg)
    , update = \msg model -> update callbacks liftMsg msg model
    , subscriptions = \model -> subscriptions model |> Sub.map liftMsg
    , title = always [ text "Select entry type" ]
    , event = \model _ -> model
    }


init : ( Model, Cmd Msg )
init =
    ( {}, Cmd.none )


update : Callbacks emsg -> (Msg -> emsg) -> Msg -> Model -> ( Result String Model, Cmd emsg )
update { choose } _ msg model =
    case msg of
        Choose t ->
            ( Ok model, pureCmd (choose t) )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


view : Model -> List (Html Msg)
view {} =
    [ div [ Attr.class "select-cipher-type-container" ]
        [ button
            [ Attr.class "p-button"
            , Ev.onClick (Choose Bridge.LoginType)
            ]
            [ text "Login" ]
        , button
            [ Attr.class "p-button"
            , Ev.onClick (Choose Bridge.CardType)
            ]
            [ text "Card" ]
        , button
            [ Attr.class "p-button"
            , Ev.onClick (Choose Bridge.NoteType)
            ]
            [ text "Note" ]
        , button
            [ Attr.class "p-button"
            , Ev.onClick (Choose Bridge.IdentityType)
            ]
            [ text "Contact" ]
        ]
    ]
