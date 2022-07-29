module Pages.Ciphers exposing (Callbacks, Model, Msg, menuConfig, page)

import Bridge
import Html exposing (..)
import Html.Attributes as Attr
import Html.Events as Ev
import Page exposing (..)
import Pages.Navigation as Navigation
import Search
import Utils exposing (..)


type alias Model =
    { ciphers : Bridge.Sub_LoadCiphers_List
    , search : String
    , menuVisible : Bool
    , ciphersListFilter : CiphersFilter
    }


type CiphersFilter
    = AllCiphers
    | SpecificCiphers Bridge.Sub_LoadCiphers_cipherType


applyCipherFilter : CiphersFilter -> Bridge.Sub_LoadCiphers_List -> Bridge.Sub_LoadCiphers_List
applyCipherFilter filter list =
    case filter of
        AllCiphers ->
            list

        SpecificCiphers t ->
            list |> List.filter (.cipherType >> (==) t)


menuConfig : Model -> Navigation.MenuConfig Msg
menuConfig { ciphersListFilter, menuVisible } =
    { title = "TODO"
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
    }


type Msg
    = Noop
    | UpdateSearch String
    | ToggleMenu
    | UpdateFilter CiphersFilter


type alias Callbacks msg =
    { selected : String -> msg
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
      }
    , Cmd.none
    )


update : Callbacks emsg -> (Msg -> emsg) -> Msg -> Model -> ( Result String Model, Cmd emsg )
update {} liftMsg msg model =
    case msg of
        Noop ->
            ( Ok model, Cmd.none )

        UpdateSearch s ->
            ( Ok { model | search = s }, Cmd.none )

        ToggleMenu ->
            ( Ok { model | menuVisible = not model.menuVisible }, Cmd.none )

        UpdateFilter filter ->
            ( Ok { model | ciphersListFilter = filter, menuVisible = False }, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


view : Callbacks emsg -> (Msg -> emsg) -> Model -> List (Html emsg)
view { selected } liftMsg { ciphers, search, ciphersListFilter } =
    [ input
        [ Attr.type_ "search"
        , Attr.value search
        , Ev.onInput (liftMsg << UpdateSearch)
        , Attr.placeholder "Search"
        , Attr.attribute "autocomplete" "off"
        ]
        []
    , ul [ Attr.class "p-list--divided" ]
        (ciphers
            |> applyCipherFilter ciphersListFilter
            |> Search.searchList (cipherSearch search)
            |> List.map
                (\{ name, date, id } ->
                    li [ Attr.class "p-list__item cipher-row", Ev.onClick (selected id) ]
                        [ div [ Attr.class "cipher-row-container" ]
                            [ p [] [ text name ]
                            , p [ Attr.class "p-text--small u-align-text--right u-text--muted" ] [ text date ]
                            ]
                        ]
                )
        )
    ]


cipherSearch : String -> Search.Search Bridge.Sub_LoadCiphers
cipherSearch query =
    Search.Search
        [ ( query, \q { name } -> Search.search q name )
        ]
