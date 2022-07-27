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
    Init 
    | Login Cmd_Login

jsonDecCmd : Json.Decode.Decoder ( Cmd )
jsonDecCmd =
    let jsonDecDictCmd = Dict.fromList
            [ ("Init", Json.Decode.lazy (\_ -> Json.Decode.succeed Init))
            , ("Login", Json.Decode.lazy (\_ -> Json.Decode.map Login (jsonDecCmd_Login)))
            ]
        jsonDecObjectSetCmd = Set.fromList []
    in  decodeSumTaggedObject "Cmd" "tag" "contents" jsonDecDictCmd jsonDecObjectSetCmd

jsonEncCmd : Cmd -> Value
jsonEncCmd  val =
    let keyval v = case v of
                    Init  -> ("Init", encodeValue (Json.Encode.list identity []))
                    Login v1 -> ("Login", encodeValue (jsonEncCmd_Login v1))
    in encodeSumTaggedObject "tag" "contents" keyval val



type alias Sub_Hello  =
   { first: String
   , second: String
   }

jsonDecSub_Hello : Json.Decode.Decoder ( Sub_Hello )
jsonDecSub_Hello =
   Json.Decode.succeed (\pfirst psecond -> {first = pfirst, second = psecond})
   |> required "first" (Json.Decode.string)
   |> required "second" (Json.Decode.string)

jsonEncSub_Hello : Sub_Hello -> Value
jsonEncSub_Hello  val =
   Json.Encode.object
   [ ("first", Json.Encode.string val.first)
   , ("second", Json.Encode.string val.second)
   ]



type Sub  =
    Empty 
    | Error String
    | GotEverything String
    | Hello Sub_Hello
    | NeedsLogin 

jsonDecSub : Json.Decode.Decoder ( Sub )
jsonDecSub =
    let jsonDecDictSub = Dict.fromList
            [ ("Empty", Json.Decode.lazy (\_ -> Json.Decode.succeed Empty))
            , ("Error", Json.Decode.lazy (\_ -> Json.Decode.map Error (Json.Decode.string)))
            , ("GotEverything", Json.Decode.lazy (\_ -> Json.Decode.map GotEverything (Json.Decode.string)))
            , ("Hello", Json.Decode.lazy (\_ -> Json.Decode.map Hello (jsonDecSub_Hello)))
            , ("NeedsLogin", Json.Decode.lazy (\_ -> Json.Decode.succeed NeedsLogin))
            ]
        jsonDecObjectSetSub = Set.fromList []
    in  decodeSumTaggedObject "Sub" "tag" "contents" jsonDecDictSub jsonDecObjectSetSub

jsonEncSub : Sub -> Value
jsonEncSub  val =
    let keyval v = case v of
                    Empty  -> ("Empty", encodeValue (Json.Encode.list identity []))
                    Error v1 -> ("Error", encodeValue (Json.Encode.string v1))
                    GotEverything v1 -> ("GotEverything", encodeValue (Json.Encode.string v1))
                    Hello v1 -> ("Hello", encodeValue (jsonEncSub_Hello v1))
                    NeedsLogin  -> ("NeedsLogin", encodeValue (Json.Encode.list identity []))
    in encodeSumTaggedObject "tag" "contents" keyval val

