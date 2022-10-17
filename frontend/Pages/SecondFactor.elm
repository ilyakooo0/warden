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
    { submit : { token : String, remember : Bool } -> msg
    }


type Msg
    = Submit
    | UpdateValue String
    | UpdateRemember Bool


type alias Model msg =
    { token : String
    , remember : Bool
    , factorType : Bridge.TwoFactorProviderType
    , callbacks : Callbacks msg
    }


init :
    { provider : Bridge.TwoFactorProviderType
    , callbacks : Callbacks msg
    }
    -> Model msg
init { provider, callbacks } =
    { token = ""
    , remember = True
    , factorType = provider
    , callbacks = callbacks
    }


title : Model msg -> String
title { factorType } =
    secondFactorName factorType


update : Model emsg -> Msg -> ( Model emsg, Maybe emsg )
update model msg =
    case msg of
        Submit ->
            ( model, model.callbacks.submit { token = model.token, remember = model.remember } |> Just )

        UpdateValue token ->
            ( { model | token = token }, Nothing )

        UpdateRemember remember ->
            ( { model | remember = remember }, Nothing )


view : Model emsg -> Html Msg
view { factorType, token, remember } =
    form [ Ev.onSubmit Submit ]
        [ label [] [ secondFactorName factorType ++ " code" |> text ]
        , input
            [ Attr.type_ "number"
            , Attr.value token
            , Attr.required True
            , Ev.onInput UpdateValue
            , Attr.attribute "autocomplete" "one-time-code"
            ]
            []
        , label []
            [ input
                [ Attr.type_ "checkbox"
                , Attr.checked remember
                , Ev.onCheck UpdateRemember
                ]
                []
            , text "Remember this device"
            ]
        , alignRight [ button [ Attr.type_ "submit" ] [ text "Submit" ] ]
        ]
