module Pages.SecondFactorSelect exposing
    ( Callbacks
    , Model
    , Msg
    , init
    , main
    , title
    , update
    , view
    )

import Bridge
import Element
import Element.Input as Input
import Html exposing (..)
import Html.Attributes as Attr
import Logic.SecondFactor exposing (secondFactorName)
import Page exposing (..)
import Utils exposing (..)


main : Program () (Model (Maybe Msg)) (Maybe Msg)
main =
    Page.page
        { init =
            init { selectFactor = always Nothing }
                [ Bridge.Authenticator
                , Bridge.Duo
                , Bridge.Email
                ]
        , view = view
        , update = update
        }


type alias Model emsg =
    { availableFactors : List Bridge.TwoFactorProviderType
    , callbacks : Callbacks emsg
    }


type Msg
    = SelectFactor Bridge.TwoFactorProviderType


type alias Callbacks emsg =
    { selectFactor : Bridge.TwoFactorProviderType -> emsg
    }


title : String
title =
    "Second factor"


init : Callbacks emsg -> List Bridge.TwoFactorProviderType -> Model emsg
init callbacks providers =
    { availableFactors = providers
    , callbacks = callbacks
    }


update : Msg -> Model emsg -> ( Model emsg, Cmd emsg )
update msg model =
    case msg of
        SelectFactor factor ->
            ( model, model.callbacks.selectFactor factor |> pureCmd )


view : Model emsg -> List (Html Msg)
view { availableFactors } =
    [ Element.layout []
        (Element.column [ Element.centerX ]
            (availableFactors
                |> List.map
                    (\factor ->
                        Input.button [ Element.centerX ]
                            { label =
                                button [ Attr.class "p-button" ] [ secondFactorName factor |> text ]
                                    |> Element.html
                            , onPress = SelectFactor factor |> Just
                            }
                    )
            )
        )
    ]
