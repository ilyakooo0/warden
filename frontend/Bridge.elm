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



type alias Sub_LoadCiphers  =
   { date: String
   , name: String
   }

jsonDecSub_LoadCiphers : Json.Decode.Decoder ( Sub_LoadCiphers )
jsonDecSub_LoadCiphers =
   Json.Decode.succeed (\pdate pname -> {date = pdate, name = pname})
   |> required "date" (Json.Decode.string)
   |> required "name" (Json.Decode.string)

jsonEncSub_LoadCiphers : Sub_LoadCiphers -> Value
jsonEncSub_LoadCiphers  val =
   Json.Encode.object
   [ ("date", Json.Encode.string val.date)
   , ("name", Json.Encode.string val.name)
   ]



type alias Sub_LoadCiphers_List  = (List Sub_LoadCiphers)

jsonDecSub_LoadCiphers_List : Json.Decode.Decoder ( Sub_LoadCiphers_List )
jsonDecSub_LoadCiphers_List =
    Json.Decode.list (jsonDecSub_LoadCiphers)

jsonEncSub_LoadCiphers_List : Sub_LoadCiphers_List -> Value
jsonEncSub_LoadCiphers_List  val = (Json.Encode.list jsonEncSub_LoadCiphers) val



type Sub  =
    Error String
    | LoadCiphers Sub_LoadCiphers_List
    | NeedsLogin 

jsonDecSub : Json.Decode.Decoder ( Sub )
jsonDecSub =
    let jsonDecDictSub = Dict.fromList
            [ ("Error", Json.Decode.lazy (\_ -> Json.Decode.map Error (Json.Decode.string)))
            , ("LoadCiphers", Json.Decode.lazy (\_ -> Json.Decode.map LoadCiphers (jsonDecSub_LoadCiphers_List)))
            , ("NeedsLogin", Json.Decode.lazy (\_ -> Json.Decode.succeed NeedsLogin))
            ]
        jsonDecObjectSetSub = Set.fromList []
    in  decodeSumTaggedObject "Sub" "tag" "contents" jsonDecDictSub jsonDecObjectSetSub

jsonEncSub : Sub -> Value
jsonEncSub  val =
    let keyval v = case v of
                    Error v1 -> ("Error", encodeValue (Json.Encode.string v1))
                    LoadCiphers v1 -> ("LoadCiphers", encodeValue (jsonEncSub_LoadCiphers_List v1))
                    NeedsLogin  -> ("NeedsLogin", encodeValue (Json.Encode.list identity []))
    in encodeSumTaggedObject "tag" "contents" keyval val

