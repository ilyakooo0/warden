module Main exposing (..)

import Bridge
import Browser
import FFI exposing (getBridge)
import Html exposing (..)
import Notification
import Pages.Loader exposing (loader)
import Pages.Login as Login
import Pages.Navigation as Navigation
import Utils exposing (..)


type Msg
    = RecieveMessage String
    | ShowLoginPage
    | ShowError String
    | CloseNotification
    | SubmitLogin { email : String, password : String, server : String }
    | LoginMsg Login.Msg


type alias Model =
    { notifications : List Notification.Config
    , page : PageModel
    }


appendNotification : Notification.Config -> Model -> Model
appendNotification cfg model =
    { model | notifications = cfg :: model.notifications }


type PageModel
    = LoginModel Login.Model
    | LoadingPage


showPage : PageModel -> ( String, List (Html Msg) )
showPage page =
    case page of
        LoginModel model ->
            let
                p =
                    Login.page loginCallbacks LoginMsg
            in
            ( p.title model, p.view model )

        LoadingPage ->
            ( "", [ loader ] )


main : Program () Model Msg
main =
    Browser.element
        { init = \_ -> init
        , view = view
        , update = update
        , subscriptions =
            \_ ->
                getBridge ShowError
                    (\msg ->
                        case msg of
                            Bridge.Hello { first, second } ->
                                RecieveMessage ("Got it! " ++ first ++ second)

                            Bridge.GotEverything everything ->
                                RecieveMessage everything

                            Bridge.Empty ->
                                RecieveMessage "Empty"

                            Bridge.NeedsLogin ->
                                ShowLoginPage

                            Bridge.Error err ->
                                ShowError err
                    )
        }


init : ( Model, Cmd Msg )
init =
    ( { notifications = []
      , page = LoadingPage
      }
    , FFI.sendBridge Bridge.Init
    )


view : Model -> Html Msg
view model =
    let
        ( title, body ) =
            showPage model.page
    in
    div []
        [ Navigation.navigation { back = False, title = title }
        , main_ []
            (maybeList (List.head model.notifications) (Notification.notification CloseNotification)
                ++ body
            )
        ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        processPage : (pageModel -> PageModel) -> ( Result String pageModel, Cmd Msg ) -> ( Model, Cmd Msg )
        processPage liftModel ( resultModel, cmd ) =
            case resultModel of
                Ok mdl ->
                    ( { model | page = liftModel mdl }, cmd )

                Err err ->
                    ( appendNotification
                        { title = "An error had occured"
                        , message = err
                        , severity = Notification.Error
                        }
                        model
                    , cmd
                    )
    in
    case msg of
        RecieveMessage x ->
            ( appendNotification
                { title = "Got a message!"
                , message = x
                , severity = Notification.Info
                }
                model
            , Cmd.none
            )

        ShowError err ->
            ( appendNotification
                { title = "Something went wrong"
                , message = err
                , severity = Notification.Error
                }
                model
            , Cmd.none
            )

        CloseNotification ->
            ( { model | notifications = tailEmpty model.notifications }
            , Cmd.none
            )

        SubmitLogin data ->
            ( model
            , FFI.sendBridge (Bridge.Login data)
            )

        LoginMsg imsg ->
            case model.page of
                LoginModel page ->
                    (Login.page loginCallbacks LoginMsg).update imsg page |> processPage LoginModel

                _ ->
                    ( model, Cmd.none )

        ShowLoginPage ->
            (Login.page loginCallbacks LoginMsg).init ()
                |> Tuple.mapFirst (\pageModel -> { model | page = LoginModel pageModel })


loginCallbacks : Login.Callbacks Msg
loginCallbacks =
    { submit = SubmitLogin }
