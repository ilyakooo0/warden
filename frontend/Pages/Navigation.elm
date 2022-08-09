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
import Html.Lazy as Lazy
import List.Nonempty as Nonempty exposing (Nonempty)
import Utils exposing (..)


type TopButton msg
    = BackButton msg
    | MenuButton (MenuConfig msg)


type alias Config msg =
    { topButton : Maybe (TopButton msg)
    , title : List (Html msg)
    }


navigation : Config msg -> Html msg
navigation { topButton, title } =
    div []
        ((case topButton of
            Just (MenuButton cfg) ->
                [ Lazy.lazy menu cfg ]

            _ ->
                []
         )
            ++ [ nav [ Attr.class "p-tabs p-tabs__list no-scroll-bar" ]
                    [ h3 []
                        ([ case topButton of
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
                         ]
                            ++ title
                        )
                    ]
               ]
        )


type alias MenuConfig msg =
    { title : String
    , items : List { icon : String, name : String, trigger : msg, current : Bool }
    , toggle : msg
    , visible : Bool
    , logOut : msg
    }


mapMenuConfig : (a -> b) -> MenuConfig a -> MenuConfig b
mapMenuConfig f { title, items, toggle, visible, logOut } =
    { items =
        List.map
            (\{ icon, name, trigger, current } ->
                { icon = icon, name = name, trigger = f trigger, current = current }
            )
            items
    , title = title
    , toggle = f toggle
    , visible = visible
    , logOut = f logOut
    }


menu : MenuConfig msg -> Html msg
menu { title, items, toggle, visible, logOut } =
    div [ Attr.class "p-side-navigation--icons", Attr.classList [ ( "is-drawer-expanded", visible ) ] ]
        [ div [ Attr.class "p-side-navigation__overlay" ] []
        , nav [ Attr.class "p-side-navigation__drawer" ]
            [ div [ Attr.class "p-side-navigation__drawer-header" ]
                [ a [ Attr.class "p-side-navigation__toggle--in-drawer", Ev.onClick toggle ] [ text title ]
                , button
                    [ Attr.class "p-button--negative is-inline u-float-right"
                    , Attr.style "margin-right" "1rem"
                    , Ev.onClick logOut
                    ]
                    [ text "Log out" ]
                ]
            , ul [ Attr.class "p-side-navigation__list" ]
                (items
                    |> List.map
                        (\{ icon, name, trigger, current } ->
                            li [ Attr.class "p-side-navigation__item" ]
                                [ a
                                    [ Attr.class "p-side-navigation__link"
                                    , Attr.classList [ ( "is-active", current ) ]
                                    , Ev.onClick trigger
                                    ]
                                    [ i
                                        [ Attr.class "p-side-navigation__icon"
                                        , Attr.class ("p-icon--" ++ icon)
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
            { title : List (Html msg)
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
        [ Lazy.lazy navigation
            { topButton = topButton
            , title = title
            }
        , main_ [] body
        ]
