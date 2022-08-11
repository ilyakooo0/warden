module Pages.EditCipher exposing (..)

import Bridge
import Html exposing (..)
import Html.Attributes as Attr
import Html.Events as Ev
import Page exposing (..)
import Utils exposing (..)


type alias Model =
    { fullCipher : Bridge.FullCipher
    }


type Msg
    = EditCipher Bridge.FullCipher


type alias Callbacks msg =
    { save : Bridge.FullCipher -> msg }


page : Callbacks emsg -> Page Bridge.FullCipher Model Msg emsg
page callbacks liftMsg =
    { init = \cipher -> Tuple.mapSecond (Cmd.map liftMsg) (init cipher)
    , view = \model -> view model |> List.map (Html.map liftMsg)
    , update = \msg model -> update callbacks liftMsg msg model
    , subscriptions = \model -> subscriptions model |> Sub.map liftMsg
    , title =
        \{ fullCipher } ->
            [ text fullCipher.name
            , span [ Attr.class "u-float-right" ] [ iconButton "task-outstanding" (callbacks.save fullCipher) ]
            ]
    }


init : Bridge.FullCipher -> ( Model, Cmd Msg )
init cipher =
    ( { fullCipher = cipher
      }
    , Cmd.none
    )


update : Callbacks emsg -> (Msg -> emsg) -> Msg -> Model -> ( Result String Model, Cmd emsg )
update _ _ msg model =
    case msg of
        EditCipher fullCipher ->
            ( Ok { model | fullCipher = fullCipher }, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


heading : String -> String -> Html msg
heading icons name =
    span [ Attr.class "u-text--muted" ] [ i [ Attr.class ("p-icon--" ++ icons) ] [], text (" " ++ name) ]


row : { name : String, nameIcon : String, attrs : List (Html.Attribute msg) } -> Html msg
row { name, nameIcon, attrs } =
    p []
        [ heading nameIcon name
        , br [] []
        , input attrs []
        ]


view : Model -> List (Html Msg)
view { fullCipher } =
    case fullCipher.cipher of
        Bridge.LoginCipher cipher ->
            let
                { username, password, uris } =
                    cipher

                edit c =
                    { fullCipher | cipher = Bridge.LoginCipher c } |> EditCipher
            in
            [ row
                { name = "Username"
                , nameIcon = "user"
                , attrs =
                    [ Attr.type_ "text"
                    , Attr.value (Maybe.withDefault "" username)
                    , Ev.onInput (\x -> edit { cipher | username = Just x })
                    , Attr.attribute "autocomplete" "username"
                    ]
                }
            , row
                { name = "Password"
                , nameIcon = "security"
                , attrs =
                    [ Attr.type_ "text"
                    , Attr.value (Maybe.withDefault "" password)
                    , Ev.onInput (\x -> edit { cipher | password = Just x })
                    , Attr.attribute "autocomplete" "new-password"
                    ]
                }
            ]
                ++ (uris
                        |> List.indexedMap
                            (\i uri ->
                                row
                                    { name = "URL"
                                    , nameIcon = "get-link"
                                    , attrs =
                                        [ Attr.type_ "url"
                                        , Attr.value uri
                                        , Ev.onInput (\x -> edit { cipher | uris = replace i x uris })
                                        ]
                                    }
                            )
                   )
                ++ [ row
                        { name = "URL"
                        , nameIcon = "get-link"
                        , attrs =
                            [ Attr.type_ "url"
                            , Ev.onInput (\x -> edit { cipher | uris = uris ++ [ x ] })
                            ]
                        }
                   ]

        Bridge.NoteCipher contents ->
            [ p []
                [ heading "switcher-environments" "Note"
                , br [] []
                , textarea
                    [ Attr.spellcheck True
                    , Attr.style "height" "70vh"
                    , Attr.value contents
                    , Ev.onInput (\x -> EditCipher { fullCipher | cipher = Bridge.NoteCipher x })
                    ]
                    []
                ]
            ]

        Bridge.CardCipher cipher ->
            let
                { number, code, cardholderName, expMonth, expYear } =
                    cipher

                edit c =
                    { fullCipher | cipher = Bridge.CardCipher c } |> EditCipher
            in
            [ row
                { name = "Card number"
                , nameIcon = "containers"
                , attrs =
                    [ Attr.attribute "autocomplete" "cc-number"
                    , Attr.type_ "text"
                    , Attr.value (Maybe.withDefault "" number)
                    , Ev.onInput (\x -> edit { cipher | number = Just x })
                    ]
                }
            , p []
                [ heading "timed-out" "Expiration date"
                , br [] []
                , input
                    [ Attr.attribute "autocomplete" "cc-exp-month"
                    , Attr.type_ "text"
                    , Attr.value (Maybe.withDefault "" expMonth)
                    , Ev.onInput (\x -> edit { cipher | expMonth = Just x })
                    , Attr.style "width" "20%"
                    , Attr.class "u-align--right"
                    ]
                    []
                , text " / "
                , input
                    [ Attr.attribute "autocomplete" "cc-exp-year"
                    , Attr.type_ "text"
                    , Attr.value (Maybe.withDefault "" expYear)
                    , Ev.onInput (\x -> edit { cipher | expYear = Just x })
                    , Attr.style "width" "20%"
                    ]
                    []
                ]
            , row
                { name = "CVV"
                , nameIcon = "security"
                , attrs =
                    [ Attr.attribute "autocomplete" "cc-csc"
                    , Attr.type_ "text"
                    , Attr.value (Maybe.withDefault "" code)
                    , Ev.onInput (\x -> edit { cipher | code = Just x })
                    ]
                }
            , row
                { name = "Cardholder name"
                , nameIcon = "user"
                , attrs =
                    [ Attr.attribute "autocomplete" "cc-name"
                    , Attr.type_ "text"
                    , Attr.value (Maybe.withDefault "" cardholderName)
                    , Ev.onInput (\x -> edit { cipher | cardholderName = Just x })
                    ]
                }
            ]

        Bridge.IdentityCipher cipher ->
            let
                { address1, address2, address3, company, email, firstName, lastName, licenseNumber, middleName, passportNumber, phone, ssn, username } =
                    cipher

                edit c =
                    { fullCipher | cipher = Bridge.IdentityCipher c } |> EditCipher
            in
            [ row
                { name = "First name"
                , nameIcon = ""
                , attrs =
                    [ Attr.attribute "autocomplete" "given-name"
                    , Attr.type_ "text"
                    , Attr.value (Maybe.withDefault "" firstName)
                    , Ev.onInput (\x -> edit { cipher | firstName = Just x })
                    ]
                }
            , row
                { name = "Middle name"
                , nameIcon = ""
                , attrs =
                    [ Attr.attribute "autocomplete" "additional-name"
                    , Attr.type_ "text"
                    , Attr.value (Maybe.withDefault "" middleName)
                    , Ev.onInput (\x -> edit { cipher | middleName = Just x })
                    ]
                }
            , row
                { name = "Last name"
                , nameIcon = ""
                , attrs =
                    [ Attr.attribute "autocomplete" "family-name"
                    , Attr.type_ "text"
                    , Attr.value (Maybe.withDefault "" lastName)
                    , Ev.onInput (\x -> edit { cipher | lastName = Just x })
                    ]
                }
            , row
                { name = "Username"
                , nameIcon = ""
                , attrs =
                    [ Attr.attribute "autocomplete" "username"
                    , Attr.type_ "text"
                    , Attr.value (Maybe.withDefault "" username)
                    , Ev.onInput (\x -> edit { cipher | username = Just x })
                    ]
                }
            , row
                { name = "Company"
                , nameIcon = ""
                , attrs =
                    [ Attr.attribute "autocomplete" "organization"
                    , Attr.type_ "text"
                    , Attr.value (Maybe.withDefault "" company)
                    , Ev.onInput (\x -> edit { cipher | company = Just x })
                    ]
                }
            , row
                { name = "Social security number"
                , nameIcon = ""
                , attrs =
                    [ Attr.attribute "autocomplete" "off"
                    , Attr.type_ "number"
                    , Attr.value (Maybe.withDefault "" ssn)
                    , Ev.onInput (\x -> edit { cipher | ssn = Just x })
                    ]
                }
            , row
                { name = "Passport number"
                , nameIcon = ""
                , attrs =
                    [ Attr.attribute "autocomplete" "off"
                    , Attr.type_ "number"
                    , Attr.value (Maybe.withDefault "" passportNumber)
                    , Ev.onInput (\x -> edit { cipher | passportNumber = Just x })
                    ]
                }
            , row
                { name = "License Number"
                , nameIcon = ""
                , attrs =
                    [ Attr.attribute "autocomplete" "off"
                    , Attr.type_ "number"
                    , Attr.value (Maybe.withDefault "" licenseNumber)
                    , Ev.onInput (\x -> edit { cipher | licenseNumber = Just x })
                    ]
                }
            , row
                { name = "Email"
                , nameIcon = ""
                , attrs =
                    [ Attr.attribute "autocomplete" "email"
                    , Attr.type_ "email"
                    , Attr.value (Maybe.withDefault "" email)
                    , Ev.onInput (\x -> edit { cipher | email = Just x })
                    ]
                }
            , row
                { name = "Phone number"
                , nameIcon = ""
                , attrs =
                    [ Attr.attribute "autocomplete" "tel"
                    , Attr.type_ "tel"
                    , Attr.value (Maybe.withDefault "" phone)
                    , Ev.onInput (\x -> edit { cipher | phone = Just x })
                    ]
                }
            , row
                { name = "Address line 1"
                , nameIcon = ""
                , attrs =
                    [ Attr.attribute "autocomplete" "address-line1"
                    , Attr.type_ "text"
                    , Attr.value (Maybe.withDefault "" address1)
                    , Ev.onInput (\x -> edit { cipher | address1 = Just x })
                    ]
                }
            , row
                { name = "Address line 2"
                , nameIcon = ""
                , attrs =
                    [ Attr.attribute "autocomplete" "address-line2"
                    , Attr.type_ "text"
                    , Attr.value (Maybe.withDefault "" address2)
                    , Ev.onInput (\x -> edit { cipher | address2 = Just x })
                    ]
                }
            , row
                { name = "Address line 3"
                , nameIcon = ""
                , attrs =
                    [ Attr.attribute "autocomplete" "address-line3"
                    , Attr.type_ "text"
                    , Attr.value (Maybe.withDefault "" address3)
                    , Ev.onInput (\x -> edit { cipher | address3 = Just x })
                    ]
                }
            ]


hiddenPassword : String
hiddenPassword =
    String.repeat 12 "●"


hiddenCvv : String
hiddenCvv =
    String.repeat 3 "●"


iconButton : String -> msg -> Html msg
iconButton name msg =
    button [ Attr.class "p-button is-inline is-dense has-icon", Ev.onClick msg ]
        [ i [ Attr.class ("p-icon--" ++ name) ] [] ]


hiddenButtonIcon : Bool -> String
hiddenButtonIcon hidden =
    if hidden then
        "show"

    else
        "hide"
