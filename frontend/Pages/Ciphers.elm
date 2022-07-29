module Pages.Ciphers exposing (Callbacks, Model, Msg, page)

import Bridge
import Html exposing (..)
import Html.Attributes as Attr
import Html.Events as Ev
import Page exposing (..)
import Search
import Utils exposing (..)


type alias Model =
    { ciphers : Bridge.Sub_LoadCiphers_List
    , search : String
    }


type Msg
    = Noop
    | UpdateSearch String


type alias Callbacks msg =
    { selected : String -> msg
    }


page : Callbacks emsg -> Page Bridge.Sub_LoadCiphers_List Model Msg emsg
page callbacks liftMsg =
    { init = \ciphers -> Tuple.mapSecond (Cmd.map liftMsg) (init ciphers)
    , view = view callbacks liftMsg
    , update = \msg model -> update callbacks liftMsg msg model
    , subscriptions = \model -> subscriptions model |> Sub.map liftMsg
    , title = always "Passwords"
    }


init : Bridge.Sub_LoadCiphers_List -> ( Model, Cmd Msg )
init ciphers =
    ( { ciphers = ciphers, search = "" }
    , Cmd.none
    )


update : Callbacks emsg -> (Msg -> emsg) -> Msg -> Model -> ( Result String Model, Cmd emsg )
update {} liftMsg msg model =
    case msg of
        Noop ->
            ( Ok model, Cmd.none )

        UpdateSearch s ->
            ( Ok { model | search = s }, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


view : Callbacks emsg -> (Msg -> emsg) -> Model -> List (Html emsg)
view { selected } liftMsg { ciphers, search } =
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
