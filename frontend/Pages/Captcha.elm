module Pages.Captcha exposing (HCaptchSiteKey, Model, init, main, title, view)

import Html exposing (..)
import Html.Attributes as Attr
import Page exposing (..)
import Utils exposing (..)


main : Program () Model (Maybe (Maybe ()))
main =
    page
        { init = init "10000000-ffff-ffff-ffff-000000000001"
        , view = view
        , update = noUpdate
        }


type alias HCaptchSiteKey =
    String


type alias Model =
    { siteKey : HCaptchSiteKey
    }


title : String
title =
    "Captcha"


init : HCaptchSiteKey -> Model
init siteKey =
    { siteKey = siteKey }


view : Model -> List (Html msg)
view { siteKey } =
    [ iframe
        [ Attr.src ("https://iko.soy/warden/hcaptcha.html?" ++ siteKey)
        , Attr.style "width" "100%"
        , Attr.style "height" "80vh"
        ]
        []
    ]
