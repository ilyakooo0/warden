module Pages.Loader exposing (loader)

import Html exposing (..)
import Html.Attributes as Attr
import Utils exposing (..)


loader : Html msg
loader =
    flexCenter [ i [ Attr.class "p-icon--spinner u-animation--spin spinner" ] [] ]
