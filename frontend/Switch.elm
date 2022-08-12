module Switch exposing (..)

import Html exposing (..)
import Html.Attributes as Attr
import Html.Events as Ev
import Utils exposing (..)


type alias SwitchConfig msg =
    { trigger : Bool -> msg
    , label : String
    , value : Bool
    , hidden : Bool
    }


switch : SwitchConfig msg -> Html msg
switch cfg =
    label
        [ Attr.class "p-switch"
        ]
        [ input
            [ Attr.type_ "checkbox"
            , Attr.class "p-switch__input"
            , Ev.onCheck cfg.trigger
            , Attr.checked cfg.value
            ]
            []
        , span
            (Attr.class "p-switch__slider"
                :: optional cfg.hidden (Attr.style "visibility" "hidden")
            )
            []
        , span [ Attr.class "p-switch__label" ] [ text cfg.label ]
        ]
