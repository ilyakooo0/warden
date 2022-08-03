module Pages.Ciphers exposing (Callbacks, Model, Msg, menuConfig, page)

import Bridge
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


type alias Model =
    { ciphers : Bridge.Sub_LoadCiphers_List
    , search : String
    , menuVisible : Bool
    , ciphersListFilter : CiphersFilter
    , scroll : InfiniteScroll.Model Msg
    , sublist : { end : Int }
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


menuConfig : String -> Model -> Navigation.MenuConfig Msg
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
          , name = "Identities"
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


type alias Callbacks msg =
    { selected : String -> msg
    , logOut : msg
    }


page : Callbacks emsg -> Page Bridge.Sub_LoadCiphers_List Model Msg emsg
page callbacks liftMsg =
    { init = \ciphers -> Tuple.mapSecond (Cmd.map liftMsg) (init ciphers)
    , view = view callbacks liftMsg
    , update = \msg model -> update callbacks liftMsg msg model
    , subscriptions = \model -> subscriptions model |> Sub.map liftMsg
    , title =
        \{ ciphersListFilter } ->
            case ciphersListFilter of
                AllCiphers ->
                    "All items"

                SpecificCiphers cipherType ->
                    case cipherType of
                        Bridge.CardType ->
                            "Cards"

                        Bridge.IdentityType ->
                            "Identities"

                        Bridge.LoginType ->
                            "Passwords"

                        Bridge.NoteType ->
                            "Notes"
    }


init : Bridge.Sub_LoadCiphers_List -> ( Model, Cmd Msg )
init ciphers =
    ( { ciphers = ciphers
      , search = ""
      , menuVisible = False
      , ciphersListFilter = AllCiphers
      , scroll = InfiniteScroll.init (LoadMore >> pureCmd)
      , sublist = { end = 20 }
      }
    , Cmd.none
    )


update : Callbacks emsg -> (Msg -> emsg) -> Msg -> Model -> ( Result String Model, Cmd emsg )
update { logOut } liftMsg msg model =
    case msg of
        Noop ->
            ( Ok model, Cmd.none )

        UpdateSearch s ->
            ( Ok { model | search = s }, Cmd.none )

        ToggleMenu ->
            ( Ok { model | menuVisible = not model.menuVisible }, Cmd.none )

        UpdateFilter filter ->
            ( Ok { model | ciphersListFilter = filter, menuVisible = False }, Cmd.none )

        LogOut ->
            ( Ok model, pureCmd logOut )

        LoadMore direction ->
            let
                newSublist =
                    case direction of
                        InfiniteScroll.Top ->
                            { end = model.sublist.end }

                        InfiniteScroll.Bottom ->
                            { end = min (model.sublist.end + 10) (List.length model.ciphers) }
            in
            ( Ok { model | sublist = newSublist, scroll = InfiniteScroll.stopLoading model.scroll }, Cmd.none )

        InfiniteScrollMsg msg_ ->
            let
                ( scroll, cmd ) =
                    InfiniteScroll.update InfiniteScrollMsg msg_ model.scroll
            in
            ( Ok { model | scroll = scroll }, Cmd.map liftMsg cmd )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


view : Callbacks emsg -> (Msg -> emsg) -> Model -> List (Html emsg)
view { selected } liftMsg { ciphers, search, ciphersListFilter, sublist } =
    [ input
        [ Attr.type_ "search"
        , Attr.value search
        , Ev.onInput (liftMsg << UpdateSearch)
        , Attr.placeholder "Search"
        , Attr.attribute "autocomplete" "off"
        ]
        []
    , ciphers
        |> applyCipherFilter ciphersListFilter
        |> Search.searchList search .name (List.take sublist.end >> Lazy.lazy3 showCiphers liftMsg selected)
    ]


showCiphers : (Msg -> msg) -> (String -> msg) -> Bridge.Sub_LoadCiphers_List -> Html msg
showCiphers liftMsg selected ciphers =
    Keyed.ul [ Attr.class "p-list--divided", InfiniteScroll.infiniteScroll (InfiniteScrollMsg >> liftMsg), Attr.class "ciphers-list no-scroll-bar" ]
        (ciphers
            |> List.map
                (\{ name, date, id } ->
                    ( id
                    , li [ Attr.class "p-list__item cipher-row", Ev.onClick (selected id) ]
                        [ div [ Attr.class "cipher-row-container" ]
                            [ p [] [ text name ]
                            , p [ Attr.class "p-text--small u-align-text--right u-text--muted" ] [ text date ]
                            ]
                        ]
                    )
                )
        )
