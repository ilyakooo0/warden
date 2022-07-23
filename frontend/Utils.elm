module Utils exposing (..)

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


optionals : Bool -> a -> List a
optionals b a =
    if b then
        [ a ]

    else
        []


maybeList : Maybe a -> (a -> b) -> List b
maybeList m f =
    case m of
        Just a ->
            [ f a ]

        Nothing ->
            []
