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
import Element as El
import Element.Font as Font
import Element.Input as Input
import Html
import Html.Attributes as Attr
import Logic.SecondFactor exposing (secondFactorName)
import Page exposing (..)
import Utils exposing (..)


main : Program () (Model (Maybe Msg)) (Maybe Msg)
main =
    Page.page
        { init =
            init { selectFactor = always Nothing }
                [ Bridge.Duo
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


view : Model emsg -> List (Html.Html Msg)
view { availableFactors } =
    let
        ( supportedProviders, unsupportedProviders ) =
            List.partition providerIsSupported availableFactors
    in
    [ El.layout [ El.padding 8 ]
        (El.column
            [ El.width El.fill
            , El.spacing 8
            ]
            ([ if List.isEmpty supportedProviders then
                El.column []
                    [ El.paragraph []
                        [ El.text "Unfortunately, your account has no compatible 2FA providers."
                        ]
                    , El.el
                        [ El.height (El.px 16)
                        ]
                        El.none
                    ]

               else
                El.column [ El.centerX ]
                    (supportedProviders
                        |> List.map
                            (\factor ->
                                Input.button [ El.centerX ]
                                    { label =
                                        Html.button [ Attr.class "p-button" ] [ secondFactorName factor |> Html.text ]
                                            |> El.html
                                    , onPress = SelectFactor factor |> Just
                                    }
                            )
                    )
             ]
                ++ (if List.isEmpty unsupportedProviders |> not then
                        [ Html.div
                            [ Attr.class "p-notification--information"
                            ]
                            [ Html.div [ Attr.class "p-notification__content" ]
                                [ Html.h5 [ Attr.class "p-notification__title" ]
                                    [ Html.text "The following 2FA providers are not supported"
                                    ]
                                , Html.p [ Attr.class "notification__message" ]
                                    [ Html.ul []
                                        (List.map
                                            (secondFactorName >> Html.text >> List.singleton >> Html.li [])
                                            unsupportedProviders
                                        )
                                    ]
                                ]
                            ]
                            |> El.html
                            |> El.el
                                [ Font.size 16
                                , El.width El.fill
                                ]
                        ]

                    else
                        []
                   )
            )
        )
    ]


providerIsSupported : Bridge.TwoFactorProviderType -> Bool
providerIsSupported provider =
    case provider of
        Bridge.Authenticator ->
            True

        Bridge.Duo ->
            False

        Bridge.Email ->
            True

        Bridge.OrganizationDuo ->
            False

        Bridge.Remember ->
            False

        Bridge.U2f ->
            False

        Bridge.WebAuthn ->
            False

        Bridge.Yubikey ->
            False
