module Main exposing (..)

import Bridge
import Browser
import FFI exposing (getBridge, sendBridge)
import Html exposing (..)
import Notification
import Pages.Cipher as Cipher
import Pages.Ciphers as Ciphers
import Pages.Loader exposing (loader)
import Pages.Login as Login
import Pages.MasterPassword as MasterPassword
import Pages.Navigation as Navigation
import Utils exposing (..)


type Msg
    = RecieveMessage String
    | ShowLoginPage
    | ShowError String
    | CloseNotification
    | SubmitLogin { email : String, password : String, server : String }
    | LoginMsg Login.Msg
    | CiphersMsg Ciphers.Msg
    | LoadCiphers Bridge.Sub_LoadCiphers_List
    | OpenCiphersScreen
    | Reset
    | NeedsReset
    | MasterPasswordMsg MasterPassword.Msg
    | SendMasterPassword { password : String }
    | ShowMasterPasswordPage { server : String, login : String }
    | CipherMsg Cipher.Msg
    | ShowCipherPage Bridge.Sub_LoadCipher
    | RequestCipher CipherId


type alias CipherId =
    String


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
    | CiphersModel Ciphers.Model
    | MasterPasswordModel MasterPassword.Model
    | CipherModel Cipher.Model


showPage : PageModel -> ( String, List (Html Msg) )
showPage page =
    case page of
        LoginModel model ->
            let
                p =
                    Login.page loginCallbacks LoginMsg
            in
            ( p.title model, p.view model )

        CiphersModel model ->
            let
                p =
                    Ciphers.page ciphersCallbacks CiphersMsg
            in
            ( p.title model, p.view model )

        LoadingPage ->
            ( "", [ loader ] )

        MasterPasswordModel model ->
            let
                p =
                    MasterPassword.page masterPasswordCallbacks MasterPasswordMsg
            in
            ( p.title model, p.view model )

        CipherModel model ->
            let
                p =
                    Cipher.page cipherCallbacks CipherMsg
            in
            ( p.title model, p.view model )


main : Program () Model Msg
main =
    Browser.element
        { init = \_ -> init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


subscriptions : Model -> Sub Msg
subscriptions _ =
    getBridge ShowError
        (\msg ->
            case msg of
                Bridge.NeedsLogin ->
                    ShowLoginPage

                Bridge.Error err ->
                    ShowError err

                Bridge.LoadCiphers ciphers ->
                    LoadCiphers ciphers

                Bridge.LoginSuccessful ->
                    OpenCiphersScreen

                Bridge.Reset ->
                    Reset

                Bridge.NeedsMasterPassword { server, login } ->
                    ShowMasterPasswordPage { server = server, login = login }

                Bridge.LoadCipher cipher ->
                    ShowCipherPage cipher
        )


init : ( Model, Cmd Msg )
init =
    -- Cipher.init |> Tuple.mapBoth (\p -> { notifications = [], page = CipherModel p }) (Cmd.map CipherMsg)
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
            (maybeList (List.head model.notifications) (Notification.notification CloseNotification) ++ body)
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

        CiphersMsg imsg ->
            case model.page of
                CiphersModel page ->
                    (Ciphers.page ciphersCallbacks CiphersMsg).update imsg page |> processPage CiphersModel

                _ ->
                    ( model, Cmd.none )

        ShowLoginPage ->
            (Login.page loginCallbacks LoginMsg).init ()
                |> Tuple.mapFirst (\pageModel -> { model | page = LoginModel pageModel })

        LoadCiphers ciphers ->
            (Ciphers.page ciphersCallbacks CiphersMsg).init ciphers
                |> Tuple.mapFirst (\pageModel -> { model | page = CiphersModel pageModel })

        OpenCiphersScreen ->
            ( { model | page = LoadingPage }, sendBridge Bridge.NeedCiphersList )

        Reset ->
            init

        ShowMasterPasswordPage { server, login } ->
            (MasterPassword.page masterPasswordCallbacks MasterPasswordMsg).init { server = server, login = login }
                |> Tuple.mapFirst (\pageModel -> { model | page = MasterPasswordModel pageModel })

        NeedsReset ->
            ( { model | page = LoadingPage }, sendBridge Bridge.NeedsReset )

        SendMasterPassword { password } ->
            ( { model | page = LoadingPage }, sendBridge (Bridge.SendMasterPassword password) )

        MasterPasswordMsg imsg ->
            case model.page of
                MasterPasswordModel page ->
                    (MasterPassword.page masterPasswordCallbacks MasterPasswordMsg).update imsg page |> processPage MasterPasswordModel

                _ ->
                    ( model, Cmd.none )

        CipherMsg imsg ->
            case model.page of
                CipherModel page ->
                    (Cipher.page cipherCallbacks CipherMsg).update imsg page |> processPage CipherModel

                _ ->
                    ( model, Cmd.none )

        ShowCipherPage cipher ->
            (Cipher.page cipherCallbacks CipherMsg).init cipher
                |> Tuple.mapFirst (\pageModel -> { model | page = CipherModel pageModel })

        RequestCipher id ->
            ( { model | page = LoadingPage }, sendBridge (Bridge.RequestCipher id) )


loginCallbacks : Login.Callbacks Msg
loginCallbacks =
    { submit = SubmitLogin }


ciphersCallbacks : Ciphers.Callbacks Msg
ciphersCallbacks =
    { selected = RequestCipher }


cipherCallbacks : Cipher.Callbacks
cipherCallbacks =
    {}


masterPasswordCallbacks : MasterPassword.Callbacks Msg
masterPasswordCallbacks =
    { submit = SendMasterPassword
    , reset = NeedsReset
    }
