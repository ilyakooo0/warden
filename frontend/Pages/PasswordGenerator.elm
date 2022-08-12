module Pages.PasswordGenerator exposing (Model, Msg, init, update, view)

import Bridge
import Html exposing (..)
import Html.Attributes as Attr
import Html.Events as Ev
import Switch exposing (switch)


type Msg
    = Noop
    | UpdateNumberCount Int
    | ToggleNumber Bool
    | ToggleAmbiguousCharacters Bool
    | ToggleCapitals Bool
    | UpdateNumberOfCapitals Int
    | UpdateLength Int
    | ToggleSpecialCharacters Bool
    | UpdateSpecialCharactersCount Int


type alias Model =
    { passwordConfig : Bridge.PasswordGeneratorConfig
    }


update : Msg -> Model -> Model
update msg { passwordConfig } =
    case msg of
        Noop ->
            { passwordConfig = passwordConfig }

        UpdateNumberCount count ->
            { passwordConfig = { passwordConfig | minNumber = count } }

        ToggleNumber enabled ->
            { passwordConfig = { passwordConfig | includeNumber = enabled } }

        ToggleAmbiguousCharacters enabled ->
            { passwordConfig = { passwordConfig | ambiguous = enabled } }

        ToggleCapitals enabled ->
            { passwordConfig = { passwordConfig | capitalize = enabled } }

        UpdateNumberOfCapitals count ->
            { passwordConfig = { passwordConfig | minUppercase = count } }

        UpdateLength count ->
            { passwordConfig = { passwordConfig | length = count } }

        ToggleSpecialCharacters enabled ->
            { passwordConfig = { passwordConfig | special = enabled } }

        UpdateSpecialCharactersCount count ->
            { passwordConfig = { passwordConfig | minSpecial = count } }


init : Model
init =
    { passwordConfig =
        { ambiguous = True
        , capitalize = True
        , includeNumber = True
        , length = 16
        , lowercase = True
        , minLowercase = 1
        , minNumber = 1
        , minSpecial = 1
        , minUppercase = 1
        , numWords = 1
        , number = True
        , special = True
        , type_ = "password"
        , uppercase = True
        , wordSeparator = "-"
        }
    }


view : Model -> List (Html Msg)
view { passwordConfig } =
    [ passwordGeneratorGroup
        [ switch
            { trigger = always Noop
            , label = "Length"
            , value = True
            , hidden = True
            }
        , input
            [ Attr.type_ "number"
            , Attr.class "is-dense"
            , Attr.value (String.fromInt passwordConfig.length)
            , Ev.onInput (String.toInt >> Maybe.withDefault 1 >> UpdateLength)
            , Attr.min "6"
            ]
            []
        ]
    , switchRow
        { label = "Numbers"
        , enabled = passwordConfig.includeNumber
        , toggle = ToggleNumber
        , trigger = UpdateNumberCount
        , value = passwordConfig.minNumber
        }
    , switchRow
        { label = "Uppercase Characters"
        , enabled = passwordConfig.capitalize
        , toggle = ToggleCapitals
        , trigger = UpdateNumberOfCapitals
        , value = passwordConfig.minUppercase
        }
    , switchRow
        { label = "Special Characters"
        , enabled = passwordConfig.special
        , toggle = ToggleSpecialCharacters
        , trigger = UpdateSpecialCharactersCount
        , value = passwordConfig.minSpecial
        }
    , switch
        { trigger = ToggleAmbiguousCharacters
        , label = "Ambiguous Characters"
        , value = passwordConfig.ambiguous
        , hidden = False
        }
    ]


switchRow :
    { toggle : Bool -> Msg
    , label : String
    , enabled : Bool
    , value : Int
    , trigger : Int -> Msg
    }
    -> Html Msg
switchRow { toggle, label, enabled, value, trigger } =
    passwordGeneratorGroup
        [ switch
            { trigger = toggle
            , label = label
            , value = enabled
            , hidden = False
            }
        , input
            [ Attr.type_ "number"
            , Attr.class "is-dense"
            , Attr.value (String.fromInt value)
            , Ev.onInput (String.toInt >> Maybe.withDefault 1 >> trigger)
            , Attr.min "1"
            , Attr.disabled (not enabled)
            ]
            []
        ]


passwordGeneratorGroup : List (Html msg) -> Html msg
passwordGeneratorGroup =
    div [ Attr.class "password-generator-group" ]
