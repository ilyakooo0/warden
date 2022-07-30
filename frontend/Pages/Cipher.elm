module Pages.Cipher exposing (..)

import Bridge
import Html exposing (..)
import Html.Attributes as Attr
import Html.Events as Ev
import Page exposing (..)
import Utils exposing (..)


type alias Model =
    { cipher : Bridge.Sub_LoadCipher
    , passwordHidden : Bool
    , cvvHidden : Bool
    }


type Msg
    = Noop
    | TogglePasswordVisiblity
    | ToggleCVVVisiblity


type alias Callbacks =
    {}


page : Callbacks -> Page Bridge.Sub_LoadCipher Model Msg emsg
page callbacks liftMsg =
    { init = \cipher -> Tuple.mapSecond (Cmd.map liftMsg) (init cipher)
    , view = \model -> view model |> List.map (Html.map liftMsg)
    , update = \msg model -> update callbacks liftMsg msg model
    , subscriptions = \model -> subscriptions model |> Sub.map liftMsg
    , title = \{ cipher } -> cipher.name
    }


init : Bridge.Sub_LoadCipher -> ( Model, Cmd Msg )
init cipher =
    ( { cipher = cipher
      , passwordHidden = True
      , cvvHidden = True
      }
    , Cmd.none
    )


update : Callbacks -> (Msg -> emsg) -> Msg -> Model -> ( Result String Model, Cmd emsg )
update {} _ msg model =
    case msg of
        Noop ->
            ( Ok model, Cmd.none )

        TogglePasswordVisiblity ->
            ( Ok { model | passwordHidden = not model.passwordHidden }, Cmd.none )

        ToggleCVVVisiblity ->
            ( Ok { model | cvvHidden = not model.cvvHidden }, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


row : { name : String, value : String, nameIcon : String, icons : List ( String, msg ) } -> Html msg
row { name, value, nameIcon, icons } =
    p []
        [ span [ Attr.class "u-text--muted" ] [ i [ Attr.class ("p-icon--" ++ nameIcon) ] [], text (" " ++ name) ]
        , br [] []
        , text value
        , span [ Attr.class "u-float-right" ] (icons |> List.map (uncurry iconButton))
        ]


view : Model -> List (Html Msg)
view { passwordHidden, cipher, cvvHidden } =
    (case cipher.cipherType of
        Bridge.LoginCipher { username, password, uris } ->
            [ row { name = "Username", value = username, nameIcon = "user", icons = [ ( "copy", Noop ) ] }
            , row
                { name = "Password"
                , value =
                    if passwordHidden then
                        hiddenPassword

                    else
                        password
                , nameIcon = "security"
                , icons = [ ( hiddenButtonIcon passwordHidden, TogglePasswordVisiblity ), ( "copy", Noop ) ]
                }
            ]
                ++ (uris
                        |> List.map
                            (\uri ->
                                row
                                    { name = "URL", value = uri, nameIcon = "get-link", icons = [ ( "external-link", Noop ), ( "copy", Noop ) ] }
                            )
                   )

        Bridge.NoteCipher contents ->
            [ row { name = "Note", value = contents, nameIcon = "edit", icons = [] }
            ]

        Bridge.CardCipher { number, code, cardholderName, expMonth, expYear } ->
            [ row { name = "Card number", value = number, nameIcon = "containers", icons = [ ( "copy", Noop ) ] }
            , row { name = "Expiration date", value = expMonth ++ "/" ++ expYear, nameIcon = "timed-out", icons = [ ( "copy", Noop ) ] }
            , row
                { name = "CVV"
                , value =
                    if cvvHidden then
                        cvvPassword

                    else
                        code
                , nameIcon = "security"
                , icons = [ ( hiddenButtonIcon cvvHidden, ToggleCVVVisiblity ), ( "copy", Noop ) ]
                }
            , row { name = "Cardholder name", value = cardholderName, nameIcon = "user", icons = [ ( "copy", Noop ) ] }
            ]

        Bridge.IdentityCipher { address1, address2, address3, city, company, country, email, firstName, lastName, licenseNumber, middleName, passportNumber, phone, postalCode, ssn, state, title, username } ->
            [ row
                { name = "Name"
                , value = firstName ++ " " ++ middleName ++ " " ++ lastName
                , nameIcon = ""
                , icons = [ ( "copy", Noop ) ]
                }
            , row
                { name = "Username"
                , value = username
                , nameIcon = ""
                , icons = [ ( "copy", Noop ) ]
                }
            , row
                { name = "Company"
                , value = company
                , nameIcon = ""
                , icons = [ ( "copy", Noop ) ]
                }
            , row
                { name = "Socia security number"
                , value = ssn
                , nameIcon = ""
                , icons = [ ( "copy", Noop ) ]
                }
            , row
                { name = "Passport number"
                , value = passportNumber
                , nameIcon = ""
                , icons = [ ( "copy", Noop ) ]
                }
            , row
                { name = "License Number"
                , value = licenseNumber
                , nameIcon = ""
                , icons = [ ( "copy", Noop ) ]
                }
            , row
                { name = "Email"
                , value = email
                , nameIcon = ""
                , icons = [ ( "copy", Noop ) ]
                }
            , row
                { name = "Phone number"
                , value = phone
                , nameIcon = ""
                , icons = [ ( "copy", Noop ) ]
                }
            , row
                { name = "Address"
                , value = address1 ++ "\n" ++ address2 ++ "\n" ++ address3
                , nameIcon = ""
                , icons = [ ( "copy", Noop ) ]
                }
            ]
    )
        |> List.intersperse (hr [] [])


hiddenPassword : String
hiddenPassword =
    String.repeat 12 "●"


cvvPassword : String
cvvPassword =
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
