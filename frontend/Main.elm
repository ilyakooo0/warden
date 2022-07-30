module Main exposing (..)

import Bridge
import Browser
import FFI exposing (getBridge, sendBridge)
import Html exposing (..)
import List.Nonempty as Nonempty exposing (Nonempty(..))
import Notification
import Pages.Cipher as Cipher
import Pages.Ciphers as Ciphers
import Pages.Loader exposing (loader)
import Pages.Login as Login
import Pages.MasterPassword as MasterPassword
import Pages.Navigation as Navigation exposing (TopButton(..))
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
    | PopView


type alias CipherId =
    String


type alias Model =
    { notifications : List Notification.Config
    , pageStack : Navigation.PageStack PageModel
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


showPage :
    PageModel
    ->
        { title : String
        , body : List (Html Msg)
        , topButton : Maybe (Navigation.TopButton Msg)
        }
showPage page =
    case page of
        LoginModel model ->
            let
                p =
                    Login.page loginCallbacks LoginMsg
            in
            { title = p.title model
            , body = p.view model
            , topButton = Nothing
            }

        CiphersModel model ->
            let
                p =
                    Ciphers.page ciphersCallbacks CiphersMsg
            in
            { title = p.title model
            , body = p.view model
            , topButton =
                Ciphers.menuConfig model
                    |> Navigation.mapMenuConfig CiphersMsg
                    |> Navigation.MenuButton
                    |> Just
            }

        LoadingPage ->
            { title = ""
            , body = [ loader ]
            , topButton = Just (BackButton PopView)
            }

        MasterPasswordModel model ->
            let
                p =
                    MasterPassword.page masterPasswordCallbacks MasterPasswordMsg
            in
            { title = p.title model
            , body = p.view model
            , topButton = Nothing
            }

        CipherModel model ->
            let
                p =
                    Cipher.page cipherCallbacks CipherMsg
            in
            { title = p.title model
            , body = p.view model
            , topButton = Just (BackButton PopView)
            }


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
    ( { notifications = []
      , pageStack = Nonempty.singleton LoadingPage
      }
    , FFI.sendBridge Bridge.Init
    )


view : Model -> Html Msg
view model =
    div []
        (maybeList (List.head model.notifications) (Notification.notification CloseNotification)
            ++ [ Navigation.showNavigationView model.pageStack showPage ]
        )


mapHead : (a -> a) -> Nonempty a -> Nonempty a
mapHead f (Nonempty x xx) =
    Nonempty (f x) xx


doNotStoreInHistory : PageModel -> Bool
doNotStoreInHistory page =
    case page of
        LoginModel _ ->
            True

        MasterPasswordModel _ ->
            True

        LoadingPage ->
            True

        _ ->
            False


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        processPage : (pageModel -> PageModel) -> ( Result String pageModel, Cmd Msg ) -> ( Model, Cmd Msg )
        processPage liftModel ( resultModel, cmd ) =
            case resultModel of
                Ok mdl ->
                    ( { model | pageStack = mapHead (always (liftModel mdl)) model.pageStack }, cmd )

                Err err ->
                    ( appendNotification
                        { title = "An error had occured"
                        , message = err
                        , severity = Notification.Error
                        }
                        model
                    , cmd
                    )

        appendPageStack : PageModel -> Model
        appendPageStack mdl =
            { model | pageStack = model.pageStack |> Nonempty.toList |> List.filter (doNotStoreInHistory >> not) |> Nonempty mdl }

        currentPage =
            model.pageStack |> Nonempty.head
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
            case currentPage of
                LoginModel page ->
                    (Login.page loginCallbacks LoginMsg).update imsg page |> processPage LoginModel

                _ ->
                    ( model, Cmd.none )

        CiphersMsg imsg ->
            case currentPage of
                CiphersModel page ->
                    (Ciphers.page ciphersCallbacks CiphersMsg).update imsg page |> processPage CiphersModel

                _ ->
                    ( model, Cmd.none )

        ShowLoginPage ->
            (Login.page loginCallbacks LoginMsg).init ()
                |> Tuple.mapFirst (\pageModel -> appendPageStack <| LoginModel pageModel)

        LoadCiphers ciphers ->
            (Ciphers.page ciphersCallbacks CiphersMsg).init ciphers
                |> Tuple.mapFirst (\pageModel -> appendPageStack <| CiphersModel pageModel)

        OpenCiphersScreen ->
            ( appendPageStack <| LoadingPage, sendBridge Bridge.NeedCiphersList )

        Reset ->
            init

        ShowMasterPasswordPage { server, login } ->
            (MasterPassword.page masterPasswordCallbacks MasterPasswordMsg).init { server = server, login = login }
                |> Tuple.mapFirst (\pageModel -> appendPageStack <| MasterPasswordModel pageModel)

        NeedsReset ->
            ( appendPageStack <| LoadingPage, sendBridge Bridge.NeedsReset )

        SendMasterPassword { password } ->
            ( appendPageStack <| LoadingPage, sendBridge (Bridge.SendMasterPassword password) )

        MasterPasswordMsg imsg ->
            case currentPage of
                MasterPasswordModel page ->
                    (MasterPassword.page masterPasswordCallbacks MasterPasswordMsg).update imsg page |> processPage MasterPasswordModel

                _ ->
                    ( model, Cmd.none )

        CipherMsg imsg ->
            case currentPage of
                CipherModel page ->
                    (Cipher.page cipherCallbacks CipherMsg).update imsg page |> processPage CipherModel

                _ ->
                    ( model, Cmd.none )

        ShowCipherPage cipher ->
            (Cipher.page cipherCallbacks CipherMsg).init cipher
                |> Tuple.mapFirst (\pageModel -> appendPageStack <| CipherModel pageModel)

        RequestCipher id ->
            ( appendPageStack <| LoadingPage, sendBridge (Bridge.RequestCipher id) )

        PopView ->
            ( { model | pageStack = Navigation.popView model.pageStack }
            , Cmd.none
            )


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
