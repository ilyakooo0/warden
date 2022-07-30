port module FFI exposing (getBridge, sendBridge)

import Bridge
import Json.Decode as D
import Json.Encode as E


port bridgeSub : (D.Value -> msg) -> Sub msg


port bridgeCmd : D.Value -> Cmd msg


getBridge : (String -> msg) -> (Bridge.Sub -> msg) -> Sub msg
getBridge err f =
    bridgeSub
        (D.decodeValue Bridge.jsonDecSub
            >> (\res ->
                    case res of
                        Ok a ->
                            f a

                        Err e ->
                            e |> D.errorToString |> err
               )
        )


sendBridge : Bridge.Cmd -> Cmd msg
sendBridge cmd =
    Bridge.jsonEncCmd cmd |> bridgeCmd
