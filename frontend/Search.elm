module Search exposing
    ( Query
    , Search(..)
    , SearchResult
    , combine
    , contramap
    , search
    , searchList
    )

import Set exposing (Set)


ignoredCharacters : Set Char
ignoredCharacters =
    Set.fromList [ '_', '-', '.' ]


prepareString : String -> String
prepareString =
    String.filter (\c -> Set.member c ignoredCharacters |> not)
        >> String.toLower


type SearchResult
    = Match Int
    | NoMatch {- | A search result for an empty query. It is for the most part just ignored, hance the name. -}
    | Ignore


{-| Used to combine different search results within one search entry.
-}
combine : List SearchResult -> SearchResult
combine ress =
    case ress of
        [] ->
            NoMatch

        _ ->
            if List.all ((==) Ignore) ress then
                Ignore

            else
                let
                    go : List SearchResult -> SearchResult
                    go rr =
                        case rr of
                            [] ->
                                NoMatch

                            NoMatch :: xs ->
                                go xs

                            (Match score) :: xs ->
                                case go xs of
                                    NoMatch ->
                                        Match score

                                    Match score_ ->
                                        Match (score + score_)

                                    Ignore ->
                                        Match score

                            Ignore :: xs ->
                                go xs
                in
                go ress


type alias Haystack =
    String


type alias Needle =
    String


type Query
    = Query Needle


{-| Constructs queries from an input string. (Splits on spaces and requires all words to match)
-}
constructQueries : String -> List Query
constructQueries =
    prepareString >> String.words >> List.filter (String.isEmpty >> not) >> List.filter (String.length >> (<) 1) >> List.map Query


{-| Search a search term within a search entry.
-}
search : Query -> Haystack -> SearchResult
search (Query needle) haystack =
    if String.contains needle (prepareString haystack) then
        Match 1

    else
        NoMatch


{-| Requires all search results to be matched
-}
searchAll : List SearchResult -> SearchResult
searchAll =
    let
        combineQueries : SearchResult -> SearchResult -> SearchResult
        combineQueries x y =
            case ( x, y ) of
                ( NoMatch, _ ) ->
                    NoMatch

                ( _, NoMatch ) ->
                    NoMatch

                ( Ignore, a ) ->
                    a

                ( a, Ignore ) ->
                    a

                ( Match a, Match b ) ->
                    Match (a + b)
    in
    List.foldl combineQueries Ignore


{-| A list of search inputs with the definition of what it means to search for that query.
-}
type Search a
    = Search (List ( String, Query -> a -> SearchResult ))


contramap : (b -> a) -> Search a -> Search b
contramap f (Search s) =
    List.map (\( q, g ) -> ( q, \query b -> g query (f b) )) s
        |> Search


{-| The main function of the module. Search a list with the given `Search`.
-}
searchList : Search a -> List a -> List a
searchList (Search searches) aa =
    let
        searchByTerm =
            searches
                |> List.concatMap
                    (\( s, f ) ->
                        let
                            qq =
                                constructQueries s
                        in
                        List.map (\q a -> f q a) qq
                    )

        searchEntry a =
            List.map (\f -> f a) searchByTerm |> searchAll
    in
    aa
        |> List.map (\a -> ( searchEntry a, a ))
        |> sortResult Tuple.first
        |> List.map Tuple.second


sortResult : (a -> SearchResult) -> List a -> List a
sortResult f =
    List.filterMap
        (\a ->
            case f a of
                Match score ->
                    Just ( score, a )

                NoMatch ->
                    Nothing

                Ignore ->
                    Just ( 0, a )
        )
        -- Here we assume that the sort is stable which is not true for old
        -- versions of ECMAScript which would result in undeterministic
        -- ordering for empty queries.
        >> List.sortBy Tuple.first
        >> List.map Tuple.second
