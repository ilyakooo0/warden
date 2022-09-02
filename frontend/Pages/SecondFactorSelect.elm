module Pages.SecondFactorSelect exposing (..)

import Bridge
import Html exposing (..)
import Html.Attributes as Attr
import Page exposing (..)
import Utils exposing (..)


type alias Model =
    { availableFactors : List Bridge.TwoFactorProviderType
    }


type Msg
    = Noop


type alias Callbacks =
    {}


page : Callbacks -> Page (List Bridge.TwoFactorProviderType) Model Msg emsg
page callbacks liftMsg =
    { init = \providers -> Tuple.mapSecond (Cmd.map liftMsg) (init providers)
    , view = \model -> view model |> List.map (Html.map liftMsg)
    , update = \msg model -> update callbacks liftMsg msg model
    , subscriptions = \model -> subscriptions model |> Sub.map liftMsg
    , title = always [ text "Captcha" ]
    , event = \model _ -> model
    }


init : List Bridge.TwoFactorProviderType -> ( Model, Cmd Msg )
init providers =
    ( { availableFactors = providers }, Cmd.none )


update : Callbacks -> (Msg -> emsg) -> Msg -> Model -> ( Result String Model, Cmd emsg )
update _ _ msg model =
    case msg of
        Noop ->
            ( Ok model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


view : Model -> List (Html Msg)
view { availableFactors } =
    [ h1 [] [ text "factors" ]
    ]
