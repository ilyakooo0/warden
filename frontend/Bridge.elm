module Bridge exposing(..)

import Json.Decode
import Json.Encode exposing (Value)
-- The following module comes from bartavelle/json-helpers
import Json.Helpers exposing (..)
import Dict exposing (Dict)
import Set exposing (Set)


type alias Cmd_Login  =
   { email: String
   , password: String
   , server: String
   }

jsonDecCmd_Login : Json.Decode.Decoder ( Cmd_Login )
jsonDecCmd_Login =
   Json.Decode.succeed (\pemail ppassword pserver -> {email = pemail, password = ppassword, server = pserver})
   |> required "email" (Json.Decode.string)
   |> required "password" (Json.Decode.string)
   |> required "server" (Json.Decode.string)

jsonEncCmd_Login : Cmd_Login -> Value
jsonEncCmd_Login  val =
   Json.Encode.object
   [ ("email", Json.Encode.string val.email)
   , ("password", Json.Encode.string val.password)
   , ("server", Json.Encode.string val.server)
   ]



type Cmd  =
    Login Cmd_Login

jsonDecCmd : Json.Decode.Decoder ( Cmd )
jsonDecCmd =
    Json.Decode.lazy (\_ -> Json.Decode.map Login (jsonDecCmd_Login))


jsonEncCmd : Cmd -> Value
jsonEncCmd (Login v1) =
    jsonEncCmd_Login v1



type Sub  =
    GotEverything String
    | Hello 

jsonDecSub : Json.Decode.Decoder ( Sub )
jsonDecSub =
    let jsonDecDictSub = Dict.fromList
            [ ("GotEverything", Json.Decode.lazy (\_ -> Json.Decode.map GotEverything (Json.Decode.string)))
            , ("Hello", Json.Decode.lazy (\_ -> Json.Decode.succeed Hello))
            ]
        jsonDecObjectSetSub = Set.fromList []
    in  decodeSumTaggedObject "Sub" "tag" "contents" jsonDecDictSub jsonDecObjectSetSub

jsonEncSub : Sub -> Value
jsonEncSub  val =
    let keyval v = case v of
                    GotEverything v1 -> ("GotEverything", encodeValue (Json.Encode.string v1))
                    Hello  -> ("Hello", encodeValue (Json.Encode.list identity []))
    in encodeSumTaggedObject "tag" "contents" keyval val

