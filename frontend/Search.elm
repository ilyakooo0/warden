module Search exposing (searchList)

import Html exposing (..)
import Html.Lazy as Lazy


type alias Needle =
    String


type alias Haystack =
    String


search : List Needle -> Haystack -> Bool
search needles haystack =
    let
        haystack_ =
            haystack |> String.toLower
    in
    List.all (\needle -> String.contains needle haystack_) needles


prepareNeedles : String -> List Needle
prepareNeedles =
    String.toLower
        >> String.words
        >> List.map String.trim
        >> List.filter (String.isEmpty >> not)
        >> List.filter (String.length >> (<) 1)


searchList : Needle -> (a -> Haystack) -> (List a -> Html msg) -> List a -> Html msg
searchList needle getHaystack show aa =
    case prepareNeedles needle of
        [] ->
            Lazy.lazy show aa

        needles ->
            aa |> List.filter (\a -> search needles (getHaystack a)) |> show
