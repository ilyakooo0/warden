module Pages.SecondFactor exposing
    ( Callbacks
    , Model
    , Msg
    , init
    , title
    , update
    , view
    )

import Bridge
import Html exposing (..)
import Html.Attributes as Attr
import Html.Events as Ev
import Logic.SecondFactor exposing (secondFactorName)
import Utils exposing (..)


type alias Callbacks msg =
    { submit : { factorType : Bridge.TwoFactorProviderType, value : String } -> msg
    }


type Msg
    = Submit String
    | UpdateValue String


type alias Model =
    { value : String
    , factorType : Bridge.TwoFactorProviderType
    }


init : Bridge.TwoFactorProviderType -> Model
init factorType =
    { value = ""
    , factorType = factorType
    }


title : Model -> String
title { factorType } =
    secondFactorName factorType


update : Callbacks emsg -> Model -> Msg -> ( Model, Maybe emsg )
update { submit } model msg =
    case msg of
        Submit value ->
            ( model, submit { value = value, factorType = model.factorType } |> Just )

        UpdateValue value ->
            ( { model | value = value }, Nothing )


view : Model -> Html Msg
view { factorType, value } =
    form []
        [ label [] [ secondFactorName factorType ++ " code" |> text ]
        , input
            [ Attr.type_ "number"
            , Attr.value value
            , Attr.required True
            , Ev.onInput UpdateValue
            , Attr.attribute "autocomplete" "one-time-code"
            ]
            []
        , alignRight [ button [ Attr.type_ "submit" ] [ text "Submit" ] ]
        ]
