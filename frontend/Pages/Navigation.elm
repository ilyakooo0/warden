module Pages.Navigation exposing (Config, navigation)

import Html exposing (..)
import Html.Attributes as Attr
import Utils exposing (..)


type alias Config =
    { back : Bool
    , title : String
    }


navigation : Config -> Html msg
navigation { back, title } =
    nav [ Attr.class "p-tabs p-tabs__list" ]
        [ h3 []
            [ button
                (Attr.class "p-button--base is-inline u-no-margin" :: optional (not back) (Attr.style "visibility" "hidden"))
                [ i [ Attr.class "p-icon--chevron-up ninety-counter" ] []
                ]
            , text title
            ]
        ]
