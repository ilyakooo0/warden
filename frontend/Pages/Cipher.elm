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
            maybeList username
                (\x ->
                    row
                        { name = "Username", value = x, nameIcon = "user", icons = [ ( "copy", Noop ) ] }
                )
                ++ maybeList password
                    (\x ->
                        row
                            { name = "Password"
                            , value =
                                if passwordHidden then
                                    hiddenPassword

                                else
                                    x
                            , nameIcon = "security"
                            , icons = [ ( hiddenButtonIcon passwordHidden, TogglePasswordVisiblity ), ( "copy", Noop ) ]
                            }
                    )
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
            maybeList number (\x -> row { name = "Card number", value = x, nameIcon = "containers", icons = [ ( "copy", Noop ) ] })
                ++ optional (expMonth /= Nothing || expYear /= Nothing)
                    (row
                        { name = "Expiration date"
                        , value = [ expMonth, expYear ] |> List.concatMap (flip maybeList identity) |> String.join "/"
                        , nameIcon = "timed-out"
                        , icons = [ ( "copy", Noop ) ]
                        }
                    )
                ++ maybeList code
                    (\x ->
                        row
                            { name = "CVV"
                            , value =
                                if cvvHidden then
                                    hiddenCvv

                                else
                                    x
                            , nameIcon = "security"
                            , icons = [ ( hiddenButtonIcon cvvHidden, ToggleCVVVisiblity ), ( "copy", Noop ) ]
                            }
                    )
                ++ maybeList cardholderName
                    (\x -> row { name = "Cardholder name", value = x, nameIcon = "user", icons = [ ( "copy", Noop ) ] })

        Bridge.IdentityCipher { address1, address2, address3, city, company, country, email, firstName, lastName, licenseNumber, middleName, passportNumber, phone, postalCode, ssn, state, title, username } ->
            optional (firstName /= Nothing || middleName /= Nothing || lastName /= Nothing)
                (row
                    { name = "Name"
                    , value = [ firstName, middleName, lastName ] |> List.concatMap (flip maybeList identity) |> unwords
                    , nameIcon = ""
                    , icons = [ ( "copy", Noop ) ]
                    }
                )
                ++ maybeList username
                    (\x ->
                        row
                            { name = "Username"
                            , value = x
                            , nameIcon = ""
                            , icons = [ ( "copy", Noop ) ]
                            }
                    )
                ++ maybeList company
                    (\x ->
                        row
                            { name = "Company"
                            , value = x
                            , nameIcon = ""
                            , icons = [ ( "copy", Noop ) ]
                            }
                    )
                ++ maybeList ssn
                    (\x ->
                        row
                            { name = "Socia security number"
                            , value = x
                            , nameIcon = ""
                            , icons = [ ( "copy", Noop ) ]
                            }
                    )
                ++ maybeList passportNumber
                    (\x ->
                        row
                            { name = "Passport number"
                            , value = x
                            , nameIcon = ""
                            , icons = [ ( "copy", Noop ) ]
                            }
                    )
                ++ maybeList licenseNumber
                    (\x ->
                        row
                            { name = "License Number"
                            , value = x
                            , nameIcon = ""
                            , icons = [ ( "copy", Noop ) ]
                            }
                    )
                ++ maybeList email
                    (\x ->
                        row
                            { name = "Email"
                            , value = x
                            , nameIcon = ""
                            , icons = [ ( "copy", Noop ) ]
                            }
                    )
                ++ maybeList phone
                    (\x ->
                        row
                            { name = "Phone number"
                            , value = x
                            , nameIcon = ""
                            , icons = [ ( "copy", Noop ) ]
                            }
                    )
                ++ optional (address1 /= Nothing || address2 /= Nothing || address3 /= Nothing)
                    (row
                        { name = "Address"
                        , value = [ address1, address2, address3 ] |> List.concatMap (flip maybeList identity) |> unwords
                        , nameIcon = ""
                        , icons = [ ( "copy", Noop ) ]
                        }
                    )
    )
        |> List.intersperse (hr [] [])


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
