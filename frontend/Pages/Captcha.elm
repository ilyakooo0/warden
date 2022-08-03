module Pages.Captcha exposing (Callbacks, HCaptchSiteKey, Model, Msg, page)

import Html exposing (..)
import Html.Attributes as Attr
import Page exposing (..)
import Utils exposing (..)


type alias HCaptchSiteKey =
    String


type alias Model =
    { siteKey : HCaptchSiteKey
    }


type Msg
    = Noop


type alias Callbacks =
    {}


page : Callbacks -> Page HCaptchSiteKey Model Msg emsg
page callbacks liftMsg =
    { init = \siteKey -> Tuple.mapSecond (Cmd.map liftMsg) (init siteKey)
    , view = \model -> view model |> List.map (Html.map liftMsg)
    , update = \msg model -> update callbacks liftMsg msg model
    , subscriptions = \model -> subscriptions model |> Sub.map liftMsg
    , title = always "Captcha"
    }


init : HCaptchSiteKey -> ( Model, Cmd Msg )
init siteKey =
    ( { siteKey = siteKey }, Cmd.none )


update : Callbacks -> (Msg -> emsg) -> Msg -> Model -> ( Result String Model, Cmd emsg )
update _ _ msg model =
    case msg of
        Noop ->
            ( Ok model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


view : Model -> List (Html Msg)
view { siteKey } =
    [ div [ Attr.class "u-embedded-media" ]
        [ iframe [ Attr.src ("https://iko.soy/warden/hcaptcha.html?" ++ siteKey) ] [] ]
    ]
