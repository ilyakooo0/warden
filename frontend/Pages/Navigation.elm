module Pages.Navigation exposing
    ( Config
    , PageStack
    , menu
    , popView
    , pushView
    , showNavigationView
    )

import Html exposing (..)
import Html.Attributes as Attr
import Html.Events as Ev
import List.Nonempty as Nonempty exposing (Nonempty)
import Utils exposing (..)


type alias Config msg =
    { back : Bool
    , title : String
    , pop : msg
    }


navigation : Config msg -> Html msg
navigation { back, title, pop } =
    nav [ Attr.class "p-tabs p-tabs__list" ]
        [ h3 [ Attr.class "u-no-margin u-no-padding" ]
            [ button
                (Attr.class "p-button--base is-inline u-no-margin" :: optional (not back) (Attr.style "visibility" "hidden"))
                [ i [ Attr.class "p-icon--chevron-up ninety-counter", Ev.onClick pop ] []
                ]
            , text title
            ]
        ]


type alias MenuConfig msg =
    { title : String
    , items : List { icon : String, name : String, trigger : msg }
    , close : msg
    }


menu : MenuConfig msg -> Html msg
menu { title, items, close } =
    div [ Attr.class "p-side-navigation--icons is-drawer-expanded" ]
        [ div [ Attr.class "p-side-navigation__overlay" ] []
        , nav [ Attr.class "p-side-navigation__drawer" ]
            [ div [ Attr.class "p-side-navigation__drawer-header" ]
                [ a [ Attr.class "p-side-navigation__toggle--in-drawer", Ev.onClick close ] [ text title ]
                ]
            , ul [ Attr.class "p-side-navigation__list" ]
                (items
                    |> List.map
                        (\{ icon, name, trigger } ->
                            li [ Attr.class "p-side-navigation__item" ]
                                [ a [ Attr.class "p-side-navigation__link", Ev.onClick trigger ]
                                    [ i [ Attr.class "p-side-navigation__icon", Attr.class ("p-icon--" ++ icon) ] []
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


showNavigationView : { popStack : msg } -> PageStack model -> (model -> ( String, List (Html msg) )) -> Html msg
showNavigationView { popStack } stack render =
    let
        ( title, body ) =
            render (Nonempty.head stack)
    in
    div []
        [ navigation { back = Nonempty.length stack > 1, title = title, pop = popStack }
        , main_ [] body
        ]
