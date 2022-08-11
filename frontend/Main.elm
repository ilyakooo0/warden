module Main exposing (..)

import Bridge
import Browser
import FFI exposing (getBridge, sendBridge)
import GlobalEvents exposing (Event)
import Html exposing (..)
import Html.Lazy as Lazy
import List.Nonempty as Nonempty exposing (Nonempty(..))
import Notification
import Pages.Captcha as Captcha
import Pages.Cipher as Cipher
import Pages.Ciphers as Ciphers
import Pages.EditCipher as EditCipher exposing (Msg(..))
import Pages.Loader exposing (loader)
import Pages.Login as Login
import Pages.MasterPassword as MasterPassword
import Pages.Navigation as Navigation exposing (TopButton(..))
import Task
import Time
import Types exposing (CipherId)
import Utils exposing (..)


notificationLingerSeconds : Int
notificationLingerSeconds =
    15


type Msg
    = Noop
    | RecieveMessage String
    | ShowLoginPage
    | ShowError String
    | ShowInfo String String
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
    | ShowCipherPage Bridge.FullCipher
    | RequestCipher CipherId
    | PopView
    | RecieveEmail String
    | Copy String
    | Open String
    | CaptchaMsg Captcha.Msg
    | EditCipherMsg EditCipher.Msg
    | ShowCaptcha Captcha.HCaptchSiteKey
    | ClearNotification { currentTime : Time.Posix }
    | UpdateLastNotificatioTime Time.Posix
    | EditCipher Bridge.FullCipher
    | UpdateCipher Bridge.FullCipher
    | FireGlobalEvent Event


type alias Model =
    { notifications : List Notification.Config
    , pageStack : Navigation.PageStack PageModel
    , userEmail : Maybe String
    , lastNotificationTime : Time.Posix
    }


appendNotification : Notification.Config -> Model -> ( Model, Cmd Msg )
appendNotification cfg model =
    ( { model | notifications = cfg :: model.notifications }, Task.perform UpdateLastNotificatioTime Time.now )


type PageModel
    = LoginModel Login.Model
    | LoadingPage
    | CiphersModel Ciphers.Model
    | EditCipherModel EditCipher.Model
    | MasterPasswordModel MasterPassword.Model
    | CipherModel Cipher.Model
    | CaptchaModel Captcha.Model


showPage :
    String
    -> PageModel
    ->
        { title : List (Html Msg)
        , body : List (Html Msg)
        , topButton : Maybe (Navigation.TopButton Msg)
        }
showPage email page =
    let
        simpleBackButton =
            BackButton { action = PopView, icon = Nothing }
    in
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
                Ciphers.menuConfig email model
                    |> Navigation.mapMenuConfig CiphersMsg
                    |> Navigation.MenuButton
                    |> Just
            }

        LoadingPage ->
            { title = []
            , body = [ loader ]
            , topButton = Just simpleBackButton
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
            , topButton = Just simpleBackButton
            }

        CaptchaModel model ->
            let
                p =
                    Captcha.page captchaCallbacks CaptchaMsg
            in
            { title = p.title model
            , body = p.view model
            , topButton = Just simpleBackButton
            }

        EditCipherModel model ->
            let
                p =
                    EditCipher.page editCipherCallbacks EditCipherMsg
            in
            { title = p.title model
            , body = p.view model
            , topButton = Just (BackButton { action = PopView, icon = Just "close" })
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
subscriptions model =
    Sub.batch
        ([ getBridge ShowError
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

                    Bridge.RecieveEmail email ->
                        RecieveEmail email

                    Bridge.NeedsCaptcha uri ->
                        ShowCaptcha uri

                    Bridge.CaptchaDone ->
                        PopView

                    Bridge.CipherChanged c ->
                        ShowInfo "Entry updated" ("The entry \"" ++ c.name ++ "\" has been successfully updated.")
            )
         ]
            ++ optional (List.isEmpty model.notifications |> not) (Time.every 1000 (\t -> ClearNotification { currentTime = t }))
        )


init : ( Model, Cmd Msg )
init =
    ( { notifications = []
      , pageStack = Nonempty.singleton LoadingPage
      , userEmail = Nothing
      , lastNotificationTime = Time.millisToPosix 0
      }
    , FFI.sendBridge Bridge.Init
    )


view : Model -> Html Msg
view model =
    div []
        (maybeList (List.head model.notifications) (Lazy.lazy2 Notification.notification CloseNotification)
            ++ [ Lazy.lazy2 Navigation.showNavigationView model.pageStack (showPage (Maybe.withDefault "" model.userEmail)) ]
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
                    appendNotification
                        { title = "An error had occured"
                        , message = err
                        , severity = Notification.Error
                        }
                        model

        appendPageStack : PageModel -> Model
        appendPageStack mdl =
            { model | pageStack = model.pageStack |> Nonempty.toList |> List.filter (doNotStoreInHistory >> not) |> Nonempty mdl }

        keepStackWith : PageModel -> Model
        keepStackWith mdl =
            { model | pageStack = Nonempty.cons mdl model.pageStack }

        currentPage =
            model.pageStack |> Nonempty.head
    in
    case msg of
        RecieveMessage x ->
            appendNotification
                { title = "Got a message!"
                , message = x
                , severity = Notification.Info
                }
                model

        ShowError err ->
            appendNotification
                { title = "Something went wrong"
                , message = err
                , severity = Notification.Error
                }
                model

        ShowInfo title inf ->
            appendNotification
                { title = title
                , message = inf
                , severity = Notification.Info
                }
                model

        CloseNotification ->
            ( { model | notifications = tailEmpty model.notifications }
            , Cmd.none
            )

        SubmitLogin data ->
            ( appendPageStack <| LoadingPage
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
            let
                ciphersShown =
                    model.pageStack
                        |> Nonempty.toList
                        |> List.any
                            (\x ->
                                case x of
                                    CiphersModel _ ->
                                        True

                                    _ ->
                                        False
                            )

                ( pageModel, cmd ) =
                    (Ciphers.page ciphersCallbacks CiphersMsg).init ciphers
            in
            ( if ciphersShown then
                { model
                    | pageStack =
                        model.pageStack
                            |> Nonempty.map
                                (\x ->
                                    case x of
                                        CiphersModel _ ->
                                            CiphersModel pageModel

                                        other ->
                                            other
                                )
                }

              else
                appendPageStack <| CiphersModel pageModel
            , cmd
            )

        -- (Ciphers.page ciphersCallbacks CiphersMsg).init ciphers
        --     |> Tuple.mapFirst (\pageModel -> appendPageStack <| CiphersModel pageModel)
        OpenCiphersScreen ->
            ( appendPageStack <| LoadingPage, Cmd.batch [ sendBridge Bridge.NeedCiphersList, sendBridge Bridge.NeedEmail ] )

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

        EditCipherMsg imsg ->
            case currentPage of
                EditCipherModel page ->
                    (EditCipher.page editCipherCallbacks EditCipherMsg).update imsg page |> processPage EditCipherModel

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

        RecieveEmail email ->
            ( { model | userEmail = Just email }, Cmd.none )

        Copy text ->
            ( model, FFI.sendBridge (Bridge.Copy text) )

        Open uri ->
            ( model, FFI.sendBridge (Bridge.Open uri) )

        ShowCaptcha uri ->
            (Captcha.page captchaCallbacks CaptchaMsg).init uri
                |> Tuple.mapFirst (\pageModel -> keepStackWith <| CaptchaModel pageModel)

        CaptchaMsg imsg ->
            case currentPage of
                CaptchaModel page ->
                    (Captcha.page captchaCallbacks CaptchaMsg).update imsg page |> processPage CaptchaModel

                _ ->
                    ( model, Cmd.none )

        ClearNotification { currentTime } ->
            if Time.posixToMillis model.lastNotificationTime + notificationLingerSeconds * 1000 > Time.posixToMillis currentTime then
                ( model, Cmd.none )

            else
                ( { model | notifications = List.tail model.notifications |> Maybe.withDefault [] }
                , Task.perform UpdateLastNotificatioTime Time.now
                )

        UpdateLastNotificatioTime time ->
            ( { model | lastNotificationTime = time }, Cmd.none )

        Noop ->
            ( model, Cmd.none )

        EditCipher cipher ->
            (EditCipher.page editCipherCallbacks EditCipherMsg).init cipher
                |> Tuple.mapFirst (\pageModel -> keepStackWith <| EditCipherModel pageModel)

        UpdateCipher cipher ->
            ( model
            , Cmd.batch
                [ Bridge.UpdateCipher cipher |> sendBridge
                , cipher |> GlobalEvents.UpdateCipher |> FireGlobalEvent |> pureCmd
                , PopView |> pureCmd
                ]
            )

        FireGlobalEvent ev ->
            ( { model
                | pageStack =
                    model.pageStack
                        |> Nonempty.map
                            (\page ->
                                case page of
                                    LoadingPage ->
                                        LoadingPage

                                    LoginModel m ->
                                        (Login.page loginCallbacks LoginMsg).event m ev |> LoginModel

                                    CiphersModel m ->
                                        (Ciphers.page ciphersCallbacks CiphersMsg).event m ev |> CiphersModel

                                    MasterPasswordModel m ->
                                        (MasterPassword.page masterPasswordCallbacks MasterPasswordMsg).event m ev |> MasterPasswordModel

                                    CipherModel m ->
                                        (Cipher.page cipherCallbacks CipherMsg).event m ev |> CipherModel

                                    EditCipherModel m ->
                                        (EditCipher.page editCipherCallbacks EditCipherMsg).event m ev |> EditCipherModel

                                    CaptchaModel m ->
                                        (Captcha.page captchaCallbacks CaptchaMsg).event m ev |> CaptchaModel
                            )
              }
            , Cmd.none
            )


loginCallbacks : Login.Callbacks Msg
loginCallbacks =
    { submit = SubmitLogin }


ciphersCallbacks : Ciphers.Callbacks Msg
ciphersCallbacks =
    { selected = RequestCipher, logOut = NeedsReset }


cipherCallbacks : Cipher.Callbacks Msg
cipherCallbacks =
    { copy = Copy, open = Open, edit = EditCipher }


editCipherCallbacks : EditCipher.Callbacks Msg
editCipherCallbacks =
    { save = UpdateCipher }


captchaCallbacks : Captcha.Callbacks
captchaCallbacks =
    {}


masterPasswordCallbacks : MasterPassword.Callbacks Msg
masterPasswordCallbacks =
    { submit = SendMasterPassword
    , reset = NeedsReset
    }
