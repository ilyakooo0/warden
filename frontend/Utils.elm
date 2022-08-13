module Utils exposing (..)

import Html exposing (..)
import Html.Attributes as Attr
import Html.Events as Ev
import Task


flip : (a -> b -> c) -> b -> a -> c
flip f b a =
    f a b


const : a -> b -> a
const a _ =
    a


uncurry : (a -> b -> c) -> ( a, b ) -> c
uncurry f ( a, b ) =
    f a b


pureCmd : a -> Cmd a
pureCmd a =
    Task.perform identity <| Task.succeed a


result : (e -> a) -> (x -> a) -> Result e x -> a
result err ok r =
    case r of
        Result.Ok x ->
            ok x

        Result.Err e ->
            err e


optional : Bool -> a -> List a
optional b a =
    if b then
        [ a ]

    else
        []


optionals : Bool -> List a -> List a
optionals b a =
    if b then
        a

    else
        []


maybeList : Maybe a -> (a -> b) -> List b
maybeList m f =
    case m of
        Just a ->
            [ f a ]

        Nothing ->
            []


alignRight : List (Html msg) -> Html msg
alignRight inner =
    div [ Attr.class "u-align--right" ] inner


flexCenter : List (Html msg) -> Html msg
flexCenter =
    div [ Attr.class "simple-flex-center" ]


tailEmpty : List a -> List a
tailEmpty x =
    case x of
        [] ->
            []

        _ :: xs ->
            xs


unwords : List String -> String
unwords =
    String.join " "


zip : List a -> List b -> List ( a, b )
zip =
    List.map2 (\a b -> ( a, b ))


mapIndex : (a -> a) -> Int -> List a -> List a
mapIndex f i xs =
    case ( i, xs ) of
        ( _, [] ) ->
            []

        ( 0, x :: xx ) ->
            f x :: xx

        ( j, x :: xx ) ->
            x :: mapIndex f (j - 1) xx


replace : Int -> a -> List a -> List a
replace i a xs =
    case ( i, xs ) of
        ( 0, _ :: xx ) ->
            a :: xx

        ( j, x :: xx ) ->
            x :: replace (j - 1) a xx

        ( _, [] ) ->
            []


index : Int -> List a -> Maybe a
index i xs =
    case ( i, xs ) of
        ( 0, x :: _ ) ->
            Just x

        ( j, _ :: xx ) ->
            index (j - 1) xx

        ( _, [] ) ->
            Nothing


spanList : (a -> Bool) -> List a -> ( List a, List a )
spanList f aa =
    case aa of
        [] ->
            ( aa, aa )

        a :: rest ->
            if f a then
                spanList f rest |> Tuple.mapFirst ((::) a)

            else
                ( [], aa )


iconButton : String -> msg -> Html msg
iconButton name msg =
    button [ Attr.class "p-button is-inline is-dense has-icon", Ev.onClick msg ]
        [ i [ Attr.class ("p-icon--" ++ name) ] [] ]
