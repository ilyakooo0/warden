module Pages.Cipher exposing
    ( Callbacks
    , Model
    , Msg
    , event
    , init
    , subscriptions
    , title
    , update
    , view
    )

import Bridge
import GlobalEvents
import Html exposing (..)
import Html.Attributes as Attr
import Html.Events as Ev
import Page exposing (..)
import Time
import Utils exposing (..)


type alias Model emsg =
    { cipher : Bridge.FullCipher
    , passwordHidden : Bool
    , cvvHidden : Bool
    , decodedTotp : Maybe { code : String, interval : Int }
    , callbacks : Callbacks emsg
    }


type Msg
    = TogglePasswordVisiblity
    | ToggleCVVVisiblity
    | Copy String
    | Open String


type alias Callbacks msg =
    { copy : String -> msg
    , open : String -> msg
    , edit : Bridge.FullCipher -> msg
    , needTotp : String -> msg
    }


event : Model emsg -> GlobalEvents.Event -> Model emsg
event model ev =
    case ev of
        GlobalEvents.UpdateCipher c ->
            { model
                | cipher =
                    if c.id == model.cipher.id then
                        c

                    else
                        model.cipher
            }

        GlobalEvents.DecodedTotp { source, code, interval } ->
            case model.cipher.cipher of
                Bridge.LoginCipher { totp } ->
                    if totp == Just source then
                        { model | decodedTotp = Just { code = code, interval = interval } }

                    else
                        model

                _ ->
                    model

        _ ->
            model


title : Model emsg -> List (Html emsg)
title { cipher, callbacks } =
    [ text cipher.name
    , span [ Attr.class "u-float-right" ] [ iconButton "edit" (callbacks.edit cipher) ]
    ]


init : Callbacks emsg -> Bridge.FullCipher -> ( Model emsg, Cmd emsg )
init callbacks cipher =
    ( { cipher = cipher
      , passwordHidden = True
      , cvvHidden = True
      , decodedTotp = Nothing
      , callbacks = callbacks
      }
    , case cipher.cipher of
        Bridge.LoginCipher { totp } ->
            case totp of
                Just x ->
                    callbacks.needTotp x |> pureCmd

                Nothing ->
                    Cmd.none

        _ ->
            Cmd.none
    )


update : Msg -> Model emsg -> ( Model emsg, Cmd emsg )
update msg model =
    case msg of
        TogglePasswordVisiblity ->
            ( { model | passwordHidden = not model.passwordHidden }, Cmd.none )

        ToggleCVVVisiblity ->
            ( { model | cvvHidden = not model.cvvHidden }, Cmd.none )

        Copy text ->
            ( model, model.callbacks.copy text |> pureCmd )

        Open uri ->
            ( model, model.callbacks.open uri |> pureCmd )


subscriptions : Model msg -> Sub msg
subscriptions { cipher, callbacks } =
    case cipher.cipher of
        Bridge.LoginCipher { totp } ->
            case totp of
                Just x ->
                    Time.every 1000 (always (callbacks.needTotp x))

                Nothing ->
                    Sub.none

        _ ->
            Sub.none


row : { name : String, value : String, nameIcon : String, icons : List ( String, msg ) } -> Html msg
row { name, value, nameIcon, icons } =
    p []
        [ span [ Attr.class "u-text--muted" ] [ i [ Attr.class ("p-icon--" ++ nameIcon) ] [], text (" " ++ name) ]
        , br [] []
        , text value
        , span [ Attr.class "u-float-right" ] (icons |> List.map (uncurry iconButton))
        ]


view : Model emsg -> List (Html Msg)
view { passwordHidden, cipher, cvvHidden, decodedTotp } =
    (case cipher.cipher of
        Bridge.LoginCipher { username, password, uris, totp } ->
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
                ++ maybeList totp
                    (\_ ->
                        row
                            { name = "One-time password"
                            , value =
                                case decodedTotp of
                                    Nothing ->
                                        "Loading..."

                                    Just { code } ->
                                        code
                            , nameIcon = "revisions"
                            , icons =
                                case decodedTotp of
                                    Nothing ->
                                        []

                                    Just { code } ->
                                        [ ( "copy", Copy code ) ]
                            }
                    )
                ++ (uris
                        |> List.map
                            (\uri ->
                                row
                                    { name = "URL"
                                    , value = uri
                                    , nameIcon = "get-link"
                                    , icons = [ ( "external-link", Open uri ), ( "copy", Copy uri ) ]
                                    }
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
