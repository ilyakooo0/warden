module Notification exposing
    ( Config
    , Severity(..)
    , notification
    )

import Html exposing (..)
import Html.Attributes as Attr
import Html.Events as Ev


type alias Config =
    { message : String
    , title : String
    , severity : Severity
    }


type Severity
    = Info
    | Warning
    | Error
    | Success


notification : msg -> Config -> Html msg
notification close { message, title, severity } =
    div
        [ Attr.class "floating-notifications"
        , Attr.class
            (case severity of
                Info ->
                    "p-notification--information"

                Error ->
                    "p-notification--negative"

                Warning ->
                    "p-notification--caution"

                Success ->
                    "p-notification--positive"
            )
        ]
        [ div [ Attr.class "p-notification__content" ]
            [ h5 [ Attr.class "p-notification__title" ] [ text title ]
            , p [ Attr.class "notification__message" ] [ text message ]
            , button [ Attr.class "p-notification__close", Ev.onClick close ] []
            ]
        ]
