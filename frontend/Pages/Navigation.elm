module Pages.Navigation exposing
    ( Config
    , MenuConfig
    , PageStack
    , TopButton(..)
    , mapMenuConfig
    , popView
    , pushView
    , showNavigationView
    )

import Html exposing (..)
import Html.Attributes as Attr
import Html.Events as Ev
import List.Nonempty as Nonempty exposing (Nonempty)
import Utils exposing (..)


type TopButton msg
    = BackButton msg
    | MenuButton (MenuConfig msg)


type alias Config msg =
    { topButton : Maybe (TopButton msg)
    , title : String
    }


navigation : Config msg -> List (Html msg)
navigation { topButton, title } =
    (case topButton of
        Just (MenuButton cfg) ->
            optional cfg.visible (menu cfg)

        _ ->
            []
    )
        ++ [ nav [ Attr.class "p-tabs p-tabs__list" ]
                [ h3 [ Attr.class "u-no-margin u-no-padding" ]
                    [ case topButton of
                        Nothing ->
                            button
                                [ Attr.class "p-button--base is-inline u-no-margin", Attr.style "visibility" "hidden" ]
                                []

                        Just (BackButton msg) ->
                            button
                                [ Attr.class "p-button--base is-inline u-no-margin", Ev.onClick msg ]
                                [ i [ Attr.class "p-icon--chevron-up ninety-counter" ] [] ]

                        Just (MenuButton cfg) ->
                            button
                                [ Attr.class "p-button--base is-inline u-no-margin", Ev.onClick cfg.toggle ]
                                [ i [ Attr.class "p-icon--menu" ] [] ]
                    , text title
                    ]
                ]
           ]


type alias MenuConfig msg =
    { title : String
    , items : List { icon : String, name : String, trigger : msg, current : Bool }
    , toggle : msg
    , visible : Bool
    }


mapMenuConfig : (a -> b) -> MenuConfig a -> MenuConfig b
mapMenuConfig f { title, items, toggle, visible } =
    { items =
        List.map
            (\{ icon, name, trigger, current } ->
                { icon = icon, name = name, trigger = f trigger, current = current }
            )
            items
    , title = title
    , toggle = f toggle
    , visible = visible
    }


menu : MenuConfig msg -> Html msg
menu { title, items, toggle } =
    div [ Attr.class "p-side-navigation--icons is-drawer-expanded" ]
        [ div [ Attr.class "p-side-navigation__overlay" ] []
        , nav [ Attr.class "p-side-navigation__drawer" ]
            [ div [ Attr.class "p-side-navigation__drawer-header" ]
                [ a [ Attr.class "p-side-navigation__toggle--in-drawer", Ev.onClick toggle ] [ text title ]
                ]
            , ul [ Attr.class "p-side-navigation__list" ]
                (items
                    |> List.map
                        (\{ icon, name, trigger, current } ->
                            li [ Attr.class "p-side-navigation__item" ]
                                [ a [ Attr.class "p-side-navigation__link", Ev.onClick trigger ]
                                    [ i
                                        [ Attr.class "p-side-navigation__icon"
                                        , Attr.class ("p-icon--" ++ icon)
                                        , Attr.classList [ ( "is-active", current ) ]
                                        ]
                                        []
                                    , text name
                                    ]
                                ]
                        )
                )
            ]
        ]


type alias PageStack model =
    Nonempty model


pushView : model -> PageStack model -> PageStack model
pushView model stack =
    Nonempty.cons model stack


popView : PageStack model -> PageStack model
popView stack =
    Nonempty.tail stack |> Nonempty.fromList |> Maybe.withDefault stack


showNavigationView :
    PageStack model
    ->
        (model
         ->
            { title : String
            , body : List (Html msg)
            , topButton : Maybe (TopButton msg)
            }
        )
    -> Html msg
showNavigationView stack render =
    let
        { title, body, topButton } =
            render (Nonempty.head stack)
    in
    div []
        (navigation
            { topButton = topButton
            , title = title
            }
            ++ [ main_ [] body ]
        )
