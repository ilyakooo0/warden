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
    = TogglePasswordVisiblity
    | ToggleCVVVisiblity
    | Copy String
    | Open String


type alias Callbacks msg =
    { copy : String -> msg, open : String -> msg, edit : Bridge.FullCipher -> msg }


page : Callbacks emsg -> Page Bridge.Sub_LoadCipher Model Msg emsg
page callbacks liftMsg =
    { init = \cipher -> Tuple.mapSecond (Cmd.map liftMsg) (init cipher)
    , view = \model -> view model |> List.map (Html.map liftMsg)
    , update = \msg model -> update callbacks liftMsg msg model
    , subscriptions = \model -> subscriptions model |> Sub.map liftMsg
    , title =
        \{ cipher } ->
            [ text cipher.cipher.name
            , span [ Attr.class "u-float-right" ] [ iconButton "edit" (callbacks.edit cipher.cipher) ]
            ]
    }


init : Bridge.Sub_LoadCipher -> ( Model, Cmd Msg )
init cipher =
    ( { cipher = cipher
      , passwordHidden = True
      , cvvHidden = True
      }
    , Cmd.none
    )


update : Callbacks emsg -> (Msg -> emsg) -> Msg -> Model -> ( Result String Model, Cmd emsg )
update { copy, open } _ msg model =
    case msg of
        TogglePasswordVisiblity ->
            ( Ok { model | passwordHidden = not model.passwordHidden }, Cmd.none )

        ToggleCVVVisiblity ->
            ( Ok { model | cvvHidden = not model.cvvHidden }, Cmd.none )

        Copy text ->
            ( Ok model, copy text |> pureCmd )

        Open uri ->
            ( Ok model, open uri |> pureCmd )


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
    (case cipher.cipher.cipher of
        Bridge.LoginCipher { username, password, uris } ->
            maybeList username
                (\x ->
                    row
                        { name = "Username", value = x, nameIcon = "user", icons = [ ( "copy", Copy x ) ] }
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
                            , icons = [ ( hiddenButtonIcon passwordHidden, TogglePasswordVisiblity ), ( "copy", Copy x ) ]
                            }
                    )
                ++ (uris
                        |> List.map
                            (\uri ->
                                row
                                    { name = "URL", value = uri, nameIcon = "get-link", icons = [ ( "external-link", Open uri ), ( "copy", Copy uri ) ] }
                            )
                   )

        Bridge.NoteCipher contents ->
            [ row { name = "Note", value = contents, nameIcon = "switcher-environments", icons = [] }
            ]

        Bridge.CardCipher { number, code, cardholderName, expMonth, expYear } ->
            maybeList number (\x -> row { name = "Card number", value = x, nameIcon = "containers", icons = [ ( "copy", Copy x ) ] })
                ++ optional (expMonth /= Nothing || expYear /= Nothing)
                    (row
                        (let
                            x =
                                [ expMonth, expYear ] |> List.concatMap (flip maybeList identity) |> String.join "/"
                         in
                         { name = "Expiration date"
                         , value = x
                         , nameIcon = "timed-out"
                         , icons = [ ( "copy", Copy x ) ]
                         }
                        )
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
                            , icons = [ ( hiddenButtonIcon cvvHidden, ToggleCVVVisiblity ), ( "copy", Copy x ) ]
                            }
                    )
                ++ maybeList cardholderName
                    (\x -> row { name = "Cardholder name", value = x, nameIcon = "user", icons = [ ( "copy", Copy x ) ] })

        Bridge.IdentityCipher { address1, address2, address3, company, email, firstName, lastName, licenseNumber, middleName, passportNumber, phone, ssn, username } ->
            optional (firstName /= Nothing || middleName /= Nothing || lastName /= Nothing)
                (row
                    (let
                        x =
                            [ firstName, middleName, lastName ] |> List.concatMap (flip maybeList identity) |> unwords
                     in
                     { name = "Name"
                     , value = x
                     , nameIcon = ""
                     , icons = [ ( "copy", Copy x ) ]
                     }
                    )
                )
                ++ maybeList username
                    (\x ->
                        row
                            { name = "Username"
                            , value = x
                            , nameIcon = ""
                            , icons = [ ( "copy", Copy x ) ]
                            }
                    )
                ++ maybeList company
                    (\x ->
                        row
                            { name = "Company"
                            , value = x
                            , nameIcon = ""
                            , icons = [ ( "copy", Copy x ) ]
                            }
                    )
                ++ maybeList ssn
                    (\x ->
                        row
                            { name = "Social security number"
                            , value = x
                            , nameIcon = ""
                            , icons = [ ( "copy", Copy x ) ]
                            }
                    )
                ++ maybeList passportNumber
                    (\x ->
                        row
                            { name = "Passport number"
                            , value = x
                            , nameIcon = ""
                            , icons = [ ( "copy", Copy x ) ]
                            }
                    )
                ++ maybeList licenseNumber
                    (\x ->
                        row
                            { name = "License Number"
                            , value = x
                            , nameIcon = ""
                            , icons = [ ( "copy", Copy x ) ]
                            }
                    )
                ++ maybeList email
                    (\x ->
                        row
                            { name = "Email"
                            , value = x
                            , nameIcon = ""
                            , icons = [ ( "copy", Copy x ) ]
                            }
                    )
                ++ maybeList phone
                    (\x ->
                        row
                            { name = "Phone number"
                            , value = x
                            , nameIcon = ""
                            , icons = [ ( "copy", Copy x ) ]
                            }
                    )
                ++ optional (address1 /= Nothing || address2 /= Nothing || address3 /= Nothing)
                    (row
                        (let
                            x =
                                [ address1, address2, address3 ] |> List.concatMap (flip maybeList identity) |> unwords
                         in
                         { name = "Address"
                         , value = x
                         , nameIcon = ""
                         , icons = [ ( "copy", Copy x ) ]
                         }
                        )
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
