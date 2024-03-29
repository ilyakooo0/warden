module Main exposing (main)

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
import Pages.SecondFactor as SecondFactor
import Pages.SecondFactorSelect as SecondFactorSelect
import Task
import Time
import Types exposing (CipherId)
import Utils exposing (..)


notificationLingerSeconds : Int
notificationLingerSeconds =
    15


type Msg
    = ShowLoginPage
    | ShowError String String
    | ShowInfo String String
    | CloseNotification
    | SubmitLogin Bridge.Cmd_Login
    | LoadCiphers Bridge.Sub_LoadCiphers_List
    | LoginSuccessful
    | Reset
    | NeedsReset
    | SendMasterPassword { password : String }
    | ShowMasterPasswordPage { server : String, login : String }
    | ShowCipherPage Bridge.FullCipher
    | RequestCipher CipherId
    | PopView
    | RecieveEmail String
    | Copy String
    | Open String
    | ShowCaptcha Captcha.HCaptchSiteKey
    | ClearNotification { currentTime : Time.Posix }
    | UpdateLastNotificatioTime Time.Posix
    | EditCipher Bridge.FullCipher
    | UpdateCipher Bridge.FullCipher
    | CreateCipher Bridge.FullCipher
    | FireGlobalEvent Event
    | GeneratePassword Bridge.PasswordGeneratorConfig
    | OpenNewCipherEditPage Bridge.CipherType
    | WrongPassword
    | DeleteCipher Bridge.FullCipher
    | RequestTotp String
    | ShowSecondFactorSelect (List Bridge.TwoFactorProviderType)
    | SelectSecondFactor
        { provider : Bridge.TwoFactorProviderType
        , requestFromServer : Bool
        }
    | PageMsg PageMsg


type PageMsg
    = LoginMsg Login.Msg
    | CiphersMsg Ciphers.Msg
    | MasterPasswordMsg MasterPassword.Msg
    | CipherMsg Cipher.Msg
    | EditCipherMsg EditCipher.Msg
    | SecondFactorSelectMsg SecondFactorSelect.Msg
    | SecondFactorMsg SecondFactor.Msg


type alias Model =
    { notifications : List Notification.Config
    , pageStack : Navigation.PageStack PageModel
    , userEmail : Maybe String
    , lastNotificationTime : Time.Posix
    }


findLoginDetails :
    List PageModel
    ->
        Maybe
            { server : String
            , email : String
            , password : String
            }
findLoginDetails xs =
    case xs of
        (LoginModel { server, email, password }) :: _ ->
            Just
                { server = server
                , email = email
                , password = password
                }

        _ :: rest ->
            findLoginDetails rest

        [] ->
            Nothing


appendNotification : Notification.Config -> Model -> ( Model, Cmd Msg )
appendNotification cfg model =
    ( { model | notifications = cfg :: model.notifications }, Task.perform UpdateLastNotificatioTime Time.now )


type PageModel
    = LoginModel (Login.Model Msg)
    | LoadingPage
    | CiphersModel (Ciphers.Model Msg)
    | EditCipherModel (EditCipher.Model Msg)
    | MasterPasswordModel (MasterPassword.Model Msg)
    | CipherModel (Cipher.Model Msg)
    | CaptchaModel Captcha.Model
    | SecondFactorSelectModel (SecondFactorSelect.Model Msg)
    | SecondFactorModel (SecondFactor.Model Msg)


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

        liftPageWith :
            (pageMsg -> PageMsg)
            ->
                { title : List (Html pageMsg)
                , body : List (Html pageMsg)
                , topButton : Maybe (Navigation.TopButton Msg)
                }
            ->
                { title : List (Html Msg)
                , body : List (Html Msg)
                , topButton : Maybe (Navigation.TopButton Msg)
                }
        liftPageWith lift { title, body, topButton } =
            { title = title |> List.map (Html.map (lift >> PageMsg))
            , body = body |> List.map (Html.map (lift >> PageMsg))
            , topButton = topButton
            }
    in
    case page of
        LoginModel model ->
            liftPageWith LoginMsg
                { title = [ text Login.title ]
                , body = Login.view model
                , topButton = Nothing
                }

        CiphersModel model ->
            liftPageWith CiphersMsg
                { title = Ciphers.title model
                , body = Ciphers.view model
                , topButton =
                    Ciphers.menuConfig email model
                        |> Navigation.mapMenuConfig (CiphersMsg >> PageMsg)
                        |> Navigation.MenuButton
                        |> Just
                }

        LoadingPage ->
            { title = []
            , body = [ loader ]
            , topButton = Just simpleBackButton
            }

        MasterPasswordModel model ->
            liftPageWith MasterPasswordMsg
                { title = [ text MasterPassword.title ]
                , body = MasterPassword.view model
                , topButton = Nothing
                }

        CipherModel model ->
            liftPageWith CipherMsg
                { title = Cipher.title model
                , body = Cipher.view model
                , topButton = Just simpleBackButton
                }

        CaptchaModel model ->
            { title = [ text Captcha.title ]
            , body = Captcha.view model
            , topButton = Just simpleBackButton
            }

        EditCipherModel model ->
            liftPageWith EditCipherMsg
                { title = EditCipher.title model
                , body = EditCipher.view model
                , topButton = Just (BackButton { action = PopView, icon = Just "close" })
                }

        SecondFactorSelectModel model ->
            liftPageWith SecondFactorSelectMsg
                { title = [ text SecondFactorSelect.title ]
                , body = SecondFactorSelect.view model
                , topButton = Just simpleBackButton
                }

        SecondFactorModel model ->
            liftPageWith SecondFactorMsg
                { title = [ SecondFactor.title model |> text ]
                , body = [ SecondFactor.view model ]
                , topButton = Just simpleBackButton
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
        ([ getBridge (ShowError "Something went wrong!")
            (\msg ->
                case msg of
                    Bridge.NeedsLogin ->
                        ShowLoginPage

                    Bridge.Error err ->
                        ShowError "Something went wrong!" err

                    Bridge.LoadCiphers ciphers ->
                        LoadCiphers ciphers

                    Bridge.LoginSuccessful ->
                        LoginSuccessful

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
                        ShowInfo "Entry updated" ("The entry “" ++ c.name ++ "” has been successfully updated.")

                    Bridge.GeneratedPassword password ->
                        GlobalEvents.GeneratedPassword password |> FireGlobalEvent

                    Bridge.WrongPassword ->
                        WrongPassword

                    Bridge.CipherDeleted c ->
                        ShowInfo "Entry deleted" ("The entry “" ++ c.name ++ "” has been successfully deleted.")

                    Bridge.Totp totp ->
                        GlobalEvents.DecodedTotp totp |> FireGlobalEvent

                    Bridge.NeedsSecondFactor secondFactors ->
                        case secondFactors of
                            [ provider ] ->
                                SelectSecondFactor
                                    { provider = provider
                                    , requestFromServer = False
                                    }

                            _ ->
                                ShowSecondFactorSelect secondFactors
            )
         ]
            ++ optional (List.isEmpty model.notifications |> not) (Time.every 1000 (\t -> ClearNotification { currentTime = t }))
            ++ (model.pageStack
                    |> Nonempty.toList
                    |> List.map
                        (\x ->
                            case x of
                                LoginModel _ ->
                                    Sub.none

                                LoadingPage ->
                                    Sub.none

                                CiphersModel _ ->
                                    Sub.none

                                EditCipherModel _ ->
                                    Sub.none

                                MasterPasswordModel _ ->
                                    Sub.none

                                CipherModel m ->
                                    Cipher.subscriptions m

                                CaptchaModel _ ->
                                    Sub.none

                                SecondFactorSelectModel _ ->
                                    Sub.none

                                SecondFactorModel _ ->
                                    Sub.none
                        )
               )
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
            ++ [ Lazy.lazy2 Navigation.showNavigationView
                    model.pageStack
                    (showPage (Maybe.withDefault "" model.userEmail))
               ]
        )


mapHead : (a -> a) -> Nonempty a -> Nonempty a
mapHead f (Nonempty x xx) =
    Nonempty (f x) xx


doNotStoreInHistory : PageModel -> Bool
doNotStoreInHistory page =
    case page of
        LoadingPage ->
            True

        _ ->
            False


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        updatePageStackHead : PageModel -> Model
        updatePageStackHead mdl =
            { model | pageStack = mapHead (always mdl) model.pageStack }

        appendPageStack : PageModel -> Model
        appendPageStack mdl =
            { model | pageStack = model.pageStack |> Nonempty.toList |> List.filter (doNotStoreInHistory >> not) |> Nonempty mdl }

        keepStackWith : PageModel -> Model
        keepStackWith mdl =
            { model | pageStack = Nonempty.cons mdl model.pageStack }
    in
    case msg of
        ShowError title err ->
            appendNotification
                { title = title
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
            ( keepStackWith <| LoadingPage
            , FFI.sendBridge (Bridge.Login data)
            )

        ShowLoginPage ->
            ( Login.init loginCallbacks |> LoginModel |> appendPageStack
            , Cmd.none
            )

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
            in
            ( if ciphersShown then
                { model
                    | pageStack =
                        model.pageStack
                            |> Nonempty.map
                                (\x ->
                                    case x of
                                        CiphersModel pageModel ->
                                            CiphersModel (Ciphers.updateCiphers ciphers pageModel)

                                        other ->
                                            other
                                )
                }

              else
                appendPageStack <| CiphersModel (Ciphers.init ciphersCallbacks ciphers)
            , Cmd.none
            )

        LoginSuccessful ->
            ( { model | pageStack = Nonempty.singleton LoadingPage }
            , Cmd.batch [ sendBridge Bridge.NeedCiphersList, sendBridge Bridge.NeedEmail ]
            )

        Reset ->
            init

        ShowMasterPasswordPage { server, login } ->
            ( MasterPassword.init masterPasswordCallbacks { server = server, login = login }
                |> MasterPasswordModel
                |> appendPageStack
            , Cmd.none
            )

        NeedsReset ->
            ( appendPageStack <| LoadingPage, sendBridge Bridge.NeedsReset )

        SendMasterPassword { password } ->
            ( appendPageStack <| LoadingPage, sendBridge (Bridge.SendMasterPassword password) )

        ShowCipherPage cipher ->
            Cipher.init cipherCallbacks cipher
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
            ( Captcha.init uri |> CaptchaModel |> appendPageStack, Cmd.none )

        ClearNotification { currentTime } ->
            if Time.posixToMillis model.lastNotificationTime + notificationLingerSeconds * 1000 > Time.posixToMillis currentTime then
                ( model, Cmd.none )

            else
                ( { model | notifications = List.tail model.notifications |> Maybe.withDefault [] }
                , Task.perform UpdateLastNotificatioTime Time.now
                )

        UpdateLastNotificatioTime time ->
            ( { model | lastNotificationTime = time }, Cmd.none )

        EditCipher cipher ->
            EditCipher.init { fullCipher = cipher, callbacks = editCipherCallbacks }
                |> Tuple.mapFirst (\pageModel -> keepStackWith <| EditCipherModel pageModel)

        UpdateCipher cipher ->
            ( model
            , Cmd.batch
                [ Bridge.UpdateCipher cipher |> sendBridge
                , cipher |> GlobalEvents.UpdateCipher |> FireGlobalEvent |> pureCmd
                , PopView |> pureCmd
                ]
            )

        CreateCipher cipher ->
            ( model
            , Cmd.batch
                [ Bridge.CreateCipher cipher |> sendBridge
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
                                        LoginModel m

                                    CiphersModel m ->
                                        Ciphers.event m ev |> CiphersModel

                                    MasterPasswordModel m ->
                                        MasterPasswordModel m

                                    CipherModel m ->
                                        Cipher.event m ev |> CipherModel

                                    EditCipherModel m ->
                                        EditCipher.event m ev |> EditCipherModel

                                    CaptchaModel m ->
                                        CaptchaModel m

                                    SecondFactorSelectModel m ->
                                        SecondFactorSelectModel m

                                    SecondFactorModel m ->
                                        SecondFactorModel m
                            )
              }
            , Cmd.none
            )

        GeneratePassword cfg ->
            ( model, FFI.sendBridge (Bridge.GeneratePassword cfg) )

        OpenNewCipherEditPage t ->
            EditCipher.init
                { callbacks = createCipherCallbacks
                , fullCipher =
                    { reprompt = 0
                    , favorite = False
                    , id = ""
                    , name = ""
                    , collectionIds = []
                    , cipher =
                        case t of
                            Bridge.LoginType ->
                                Bridge.LoginCipher
                                    { uris = []
                                    , username = Nothing
                                    , password = Nothing
                                    , totp = Nothing
                                    }

                            Bridge.NoteType ->
                                Bridge.NoteCipher ""

                            Bridge.CardType ->
                                Bridge.CardCipher
                                    { cardholderName = Nothing
                                    , brand = Nothing
                                    , number = Nothing
                                    , expMonth = Nothing
                                    , expYear = Nothing
                                    , code = Nothing
                                    }

                            Bridge.IdentityType ->
                                Bridge.IdentityCipher
                                    { title = Nothing
                                    , firstName = Nothing
                                    , middleName = Nothing
                                    , lastName = Nothing
                                    , address1 = Nothing
                                    , address2 = Nothing
                                    , address3 = Nothing
                                    , city = Nothing
                                    , state = Nothing
                                    , postalCode = Nothing
                                    , country = Nothing
                                    , company = Nothing
                                    , email = Nothing
                                    , phone = Nothing
                                    , ssn = Nothing
                                    , username = Nothing
                                    , passportNumber = Nothing
                                    , licenseNumber = Nothing
                                    }
                    }
                }
                |> Tuple.mapFirst (\pageModel -> keepStackWith <| EditCipherModel pageModel)

        WrongPassword ->
            ( model
            , Cmd.batch
                [ pureCmd PopView
                , pureCmd (ShowError "Login failed" "The login details you provided are not valid. Please try again.")
                ]
            )

        DeleteCipher cipher ->
            ( model
            , Cmd.batch
                [ pureCmd PopView
                , pureCmd PopView
                , FFI.sendBridge (Bridge.DeleteCipher cipher)
                ]
            )

        RequestTotp totp ->
            ( model, FFI.sendBridge (Bridge.RequestTotp totp) )

        ShowSecondFactorSelect secondFactors ->
            ( SecondFactorSelect.init secondFactorSelectCallbacks secondFactors
                |> SecondFactorSelectModel
                |> appendPageStack
            , Cmd.none
            )

        SelectSecondFactor { provider, requestFromServer } ->
            case Nonempty.toList model.pageStack |> findLoginDetails of
                Just { email, password, server } ->
                    ( SecondFactor.init
                        { provider = provider
                        , callbacks =
                            { submit =
                                \{ token, remember } ->
                                    SubmitLogin
                                        { email = email
                                        , password = password
                                        , server = server
                                        , secondFactor =
                                            Just
                                                { provider = provider
                                                , token = token
                                                , remember = remember
                                                }
                                        }
                            }
                        }
                        |> SecondFactorModel
                        |> appendPageStack
                    , Bridge.ChooseSecondFactor
                        { factor = provider
                        , email = email
                        , password = password
                        , server = server
                        , requestFromServer = requestFromServer
                        }
                        |> FFI.sendBridge
                    )

                Nothing ->
                    ( model, Cmd.none )

        PageMsg pageMsg ->
            case ( pageMsg, model.pageStack |> Nonempty.head ) of
                ( SecondFactorMsg imsg, SecondFactorModel m ) ->
                    SecondFactor.update m imsg
                        |> Tuple.mapBoth
                            (SecondFactorModel >> updatePageStackHead)
                            (Maybe.map pureCmd >> Maybe.withDefault Cmd.none)

                ( LoginMsg imsg, LoginModel page ) ->
                    Login.update imsg page
                        |> Tuple.mapFirst (LoginModel >> updatePageStackHead)

                ( CiphersMsg imsg, CiphersModel page ) ->
                    Ciphers.update imsg page
                        |> Tuple.mapFirst (CiphersModel >> updatePageStackHead)

                ( MasterPasswordMsg imsg, MasterPasswordModel page ) ->
                    MasterPassword.update imsg page
                        |> Tuple.mapFirst (MasterPasswordModel >> updatePageStackHead)

                ( CipherMsg imsg, CipherModel page ) ->
                    Cipher.update imsg page
                        |> Tuple.mapFirst (CipherModel >> updatePageStackHead)

                ( EditCipherMsg imsg, EditCipherModel page ) ->
                    EditCipher.update imsg page
                        |> Tuple.mapFirst (EditCipherModel >> updatePageStackHead)

                ( SecondFactorSelectMsg imsg, SecondFactorSelectModel m ) ->
                    SecondFactorSelect.update imsg m
                        |> Tuple.mapFirst (SecondFactorSelectModel >> updatePageStackHead)

                _ ->
                    ( model, Cmd.none )


loginCallbacks : Login.Callbacks Msg
loginCallbacks =
    { submit =
        \{ email, server, password } ->
            SubmitLogin
                { email = email
                , password = password
                , server = server
                , secondFactor = Nothing
                }
    }


ciphersCallbacks : Ciphers.Callbacks Msg
ciphersCallbacks =
    { selected = RequestCipher
    , logOut = NeedsReset
    , createNewCipher = OpenNewCipherEditPage
    , lift = CiphersMsg >> PageMsg
    }


cipherCallbacks : Cipher.Callbacks Msg
cipherCallbacks =
    { copy = Copy, open = Open, edit = EditCipher, needTotp = RequestTotp }


editCipherCallbacks : EditCipher.Callbacks Msg
editCipherCallbacks =
    { save = UpdateCipher, generatePassword = GeneratePassword, delete = Just DeleteCipher }


createCipherCallbacks : EditCipher.Callbacks Msg
createCipherCallbacks =
    { save = CreateCipher, generatePassword = GeneratePassword, delete = Nothing }


masterPasswordCallbacks : MasterPassword.Callbacks Msg
masterPasswordCallbacks =
    { submit = SendMasterPassword
    , reset = NeedsReset
    }


secondFactorSelectCallbacks : SecondFactorSelect.Callbacks Msg
secondFactorSelectCallbacks =
    { selectFactor =
        \provider ->
            SelectSecondFactor { provider = provider, requestFromServer = True }
    }
