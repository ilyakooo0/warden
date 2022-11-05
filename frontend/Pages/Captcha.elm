module Pages.Captcha exposing (HCaptchSiteKey, Model, init, title, view)

import Html exposing (..)
import Html.Attributes as Attr
import Page exposing (..)
import Utils exposing (..)


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
    [ div [ Attr.class "u-embedded-media" ]
        [ iframe [ Attr.src ("https://iko.soy/warden/hcaptcha.html?" ++ siteKey) ] [] ]
    ]
