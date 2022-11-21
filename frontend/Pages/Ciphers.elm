module Pages.Ciphers exposing (Callbacks, Model, Msg, event, init, menuConfig, title, update, view)

import Bridge
import GlobalEvents
import Html exposing (..)
import Html.Attributes as Attr
import Html.Events as Ev
import Html.Keyed as Keyed
import Html.Lazy as Lazy
import InfiniteScroll
import Page exposing (..)
import Pages.Navigation as Navigation
import Search
import Utils exposing (..)


type alias Model emsg =
    { ciphers : Bridge.Sub_LoadCiphers_List
    , search : String
    , menuVisible : Bool
    , ciphersListFilter : CiphersFilter
    , scroll : InfiniteScroll.Model Msg
    , sublist : { end : Int }
    , cipherSelectDropdownVisivble : Bool
    , callbacks : Callbacks emsg
    }


type CiphersFilter
    = AllCiphers
    | SpecificCiphers Bridge.CipherType


applyCipherFilter : CiphersFilter -> Bridge.Sub_LoadCiphers_List -> Bridge.Sub_LoadCiphers_List
applyCipherFilter filter list =
    case filter of
        AllCiphers ->
            list

        SpecificCiphers t ->
            list |> List.filter (.cipherType >> (==) t)


menuConfig : String -> Model emsg -> Navigation.MenuConfig Msg
menuConfig email { ciphersListFilter, menuVisible } =
    { title = email
    , items =
        [ { icon = "units"
          , name = "All items"
          , trigger = UpdateFilter AllCiphers
          , current = ciphersListFilter == AllCiphers
          }
        , { icon = "security"
          , name = "Passwords"
          , trigger = UpdateFilter (SpecificCiphers Bridge.LoginType)
          , current = ciphersListFilter == SpecificCiphers Bridge.LoginType
          }
        , { icon = "edit"
          , name = "Notes"
          , trigger = UpdateFilter (SpecificCiphers Bridge.NoteType)
          , current = ciphersListFilter == SpecificCiphers Bridge.NoteType
          }
        , { icon = "containers"
          , name = "Cards"
          , trigger = UpdateFilter (SpecificCiphers Bridge.CardType)
          , current = ciphersListFilter == SpecificCiphers Bridge.CardType
          }
        , { icon = "user"
          , name = "Contacts"
          , trigger = UpdateFilter (SpecificCiphers Bridge.IdentityType)
          , current = ciphersListFilter == SpecificCiphers Bridge.IdentityType
          }
        ]
    , toggle = ToggleMenu
    , visible = menuVisible
    , logOut = LogOut
    }


type Msg
    = Noop
    | UpdateSearch String
    | ToggleMenu
    | UpdateFilter CiphersFilter
    | LogOut
    | LoadMore InfiniteScroll.Direction
    | InfiniteScrollMsg InfiniteScroll.Msg
    | CreateNewCipher Bridge.CipherType
    | ToggleSelectCipherTypeVisible
    | SelectCipher String


type alias Callbacks msg =
    { selected : String -> msg
    , logOut : msg
    , createNewCipher : Bridge.CipherType -> msg
    , lift : Msg -> msg
    }


event : Model emsg -> GlobalEvents.Event -> Model emsg
event model ev =
    case ev of
        GlobalEvents.UpdateCipher c ->
            { model
                | ciphers =
                    model.ciphers
                        |> List.map
                            (\cipher ->
                                if cipher.id == c.id then
                                    { cipher | name = c.name }

                                else
                                    cipher
                            )
            }

        _ ->
            model


title : Model emsg -> List (Html Msg)
title { ciphersListFilter, cipherSelectDropdownVisivble } =
    [ text
        (case ciphersListFilter of
            AllCiphers ->
                "All items"

            SpecificCiphers cipherType ->
                case cipherType of
                    Bridge.CardType ->
                        "Cards"

                    Bridge.IdentityType ->
                        "Contacts"

                    Bridge.LoginType ->
                        "Passwords"

                    Bridge.NoteType ->
                        "Notes"
        )
    , span [ Attr.class "u-float-right" ]
        [ span [ Attr.class "p-contextual-menu" ]
            ([ span [] [ iconButton "plus" ToggleSelectCipherTypeVisible ]
             ]
                ++ optionals cipherSelectDropdownVisivble
                    [ div
                        [ Attr.class "overlay"
                        , Ev.onClick ToggleSelectCipherTypeVisible
                        ]
                        []
                    , span
                        [ Attr.class "p-contextual-menu__dropdown"
                        , Attr.attribute "aria-hidden" "false"
                        ]
                        (let
                            create t =
                                CreateNewCipher t
                         in
                         [ button
                            [ Attr.class "p-contextual-menu__link"
                            , Ev.onClick (create Bridge.LoginType)
                            ]
                            [ text "Login" ]
                         , button
                            [ Attr.class "p-contextual-menu__link"
                            , Ev.onClick (create Bridge.CardType)
                            ]
                            [ text "Card" ]
                         , button
                            [ Attr.class "p-contextual-menu__link"
                            , Ev.onClick (create Bridge.NoteType)
                            ]
                            [ text "Note" ]
                         , button
                            [ Attr.class "p-contextual-menu__link"
                            , Ev.onClick (create Bridge.IdentityType)
                            ]
                            [ text "Contact" ]
                         ]
                        )
                    ]
            )
        ]
    ]


init : Callbacks emsg -> Bridge.Sub_LoadCiphers_List -> Model emsg
init callbacks ciphers =
    { ciphers = ciphers
    , search = ""
    , menuVisible = False
    , ciphersListFilter = AllCiphers
    , scroll = InfiniteScroll.init (LoadMore >> pureCmd)
    , sublist = { end = 20 }
    , cipherSelectDropdownVisivble = False
    , callbacks = callbacks
    }


update : Msg -> Model emsg -> ( Model emsg, Cmd emsg )
update msg model =
    case msg of
        Noop ->
            ( model, Cmd.none )

        UpdateSearch s ->
            ( { model | search = s }, Cmd.none )

        ToggleMenu ->
            ( { model | menuVisible = not model.menuVisible }, Cmd.none )

        UpdateFilter filter ->
            ( { model | ciphersListFilter = filter, menuVisible = False }, Cmd.none )

        LogOut ->
            ( model, pureCmd model.callbacks.logOut )

        LoadMore direction ->
            let
                newSublist =
                    case direction of
                        InfiniteScroll.Top ->
                            { end = model.sublist.end }

                        InfiniteScroll.Bottom ->
                            { end = min (model.sublist.end + 10) (List.length model.ciphers) }
            in
            ( { model | sublist = newSublist, scroll = InfiniteScroll.stopLoading model.scroll }, Cmd.none )

        InfiniteScrollMsg msg_ ->
            let
                ( scroll, cmd ) =
                    InfiniteScroll.update InfiniteScrollMsg msg_ model.scroll
            in
            ( { model | scroll = scroll }, Cmd.map model.callbacks.lift cmd )

        CreateNewCipher t ->
            ( { model | cipherSelectDropdownVisivble = False }, pureCmd (model.callbacks.createNewCipher t) )

        ToggleSelectCipherTypeVisible ->
            ( { model | cipherSelectDropdownVisivble = not model.cipherSelectDropdownVisivble }
            , Cmd.none
            )

        SelectCipher id ->
            ( model, model.callbacks.selected id |> pureCmd )


view : Model emsg -> List (Html Msg)
view { ciphers, search, ciphersListFilter, sublist } =
    [ input
        [ Attr.type_ "search"
        , Attr.value search
        , Ev.onInput UpdateSearch
        , Attr.placeholder "Search"
        , Attr.attribute "autocomplete" "off"
        ]
        []
    , ciphers
        |> applyCipherFilter ciphersListFilter
        |> Search.searchList search .name (List.take sublist.end >> Lazy.lazy showCiphers)
    ]


showCiphers : Bridge.Sub_LoadCiphers_List -> Html Msg
showCiphers ciphers =
    Keyed.ul [ Attr.class "p-list--divided", InfiniteScroll.infiniteScroll InfiniteScrollMsg, Attr.class "ciphers-list no-scroll-bar" ]
        (ciphers
            |> List.map
                (\{ name, date, id } ->
                    ( id
                    , li [ Attr.class "p-list__item cipher-row", Ev.onClick (SelectCipher id) ]
                        [ div [ Attr.class "cipher-row-container" ]
                            [ p [] [ text name ]
                            , p [ Attr.class "p-text--small u-align-text--right u-text--muted hide-in-test" ] [ text date ]
                            ]
                        ]
                    )
                )
        )
