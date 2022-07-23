port module FFI exposing (getBridge)

import Bridge
import Json.Decode as D


port bridge : (D.Value -> msg) -> Sub msg


getBridge : (String -> msg) -> (Bridge.Sub -> msg) -> Sub msg
getBridge err f =
    bridge
        (D.decodeValue Bridge.jsonDecSub
            >> (\res ->
                    case res of
                        Ok a ->
                            f a

                        Err e ->
                            e |> D.errorToString |> err
               )
        )
