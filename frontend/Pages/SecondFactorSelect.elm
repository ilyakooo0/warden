module Pages.SecondFactorSelect exposing (Callbacks, Model, Msg, page)

import Bridge
import Element
import Element.Input as Input
import Html exposing (..)
import Html.Attributes as Attr
import Logic.SecondFactor exposing (secondFactorName)
import Page exposing (..)
import Utils exposing (..)


type alias Model =
    { availableFactors : List Bridge.TwoFactorProviderType
    }


type Msg
    = SelectFactor Bridge.TwoFactorProviderType


type alias Callbacks emsg =
    { selectFactor : Bridge.TwoFactorProviderType -> emsg
    }


page : Callbacks emsg -> Page (List Bridge.TwoFactorProviderType) Model Msg emsg
page callbacks liftMsg =
    { init = \providers -> Tuple.mapSecond (Cmd.map liftMsg) (init providers)
    , view = \model -> view model |> List.map (Html.map liftMsg)
    , update = \msg model -> update callbacks liftMsg msg model
    , subscriptions = \model -> subscriptions model |> Sub.map liftMsg
    , title = always [ text "Second factor" ]
    , event = \model _ -> model
    }


init : List Bridge.TwoFactorProviderType -> ( Model, Cmd Msg )
init providers =
    ( { availableFactors = providers }, Cmd.none )


update : Callbacks emsg -> (Msg -> emsg) -> Msg -> Model -> ( Result String Model, Cmd emsg )
update { selectFactor } _ msg model =
    case msg of
        SelectFactor factor ->
            ( Ok model, selectFactor factor |> pureCmd )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


view : Model -> List (Html Msg)
view { availableFactors } =
    [ Element.layout []
        (Element.column [ Element.centerX ]
            (availableFactors
                |> List.map
                    (\factor ->
                        Input.button []
                            { label =
                                button [ Attr.class "p-button" ] [ secondFactorName factor |> text ]
                                    |> Element.html
                            , onPress = SelectFactor factor |> Just
                            }
                    )
            )
        )
    ]
