module Modal exposing (..)

import Html exposing (..)
import Html.Attributes as Attr
import Html.Events as Ev


type alias ModelConfig msg =
    { title : String
    , body : List (Html msg)
    , close : msg
    , footer : List (Html msg)
    }


modal : ModelConfig msg -> Html msg
modal cfg =
    div
        [ Attr.class "p-modal" ]
        [ section
            [ Attr.class "p-modal__dialog"
            ]
            (header
                [ Attr.class "p-modal__header"
                ]
                [ h2 [ Attr.class "p-modal__title" ] [ text cfg.title ]
                , button [ Attr.class "p-modal__close", Ev.onClick cfg.close ] [ text "Close" ]
                ]
                :: cfg.body
                ++ [ footer [ Attr.class "p-modal__footer" ] cfg.footer
                   ]
            )
        ]
