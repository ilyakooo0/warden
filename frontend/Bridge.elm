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
    | NeedCiphersList 
    | NeedsReset 
    | RequestCipher String
    | SendMasterPassword String

jsonDecCmd : Json.Decode.Decoder ( Cmd )
jsonDecCmd =
    let jsonDecDictCmd = Dict.fromList
            [ ("Init", Json.Decode.lazy (\_ -> Json.Decode.succeed Init))
            , ("Login", Json.Decode.lazy (\_ -> Json.Decode.map Login (jsonDecCmd_Login)))
            , ("NeedCiphersList", Json.Decode.lazy (\_ -> Json.Decode.succeed NeedCiphersList))
            , ("NeedsReset", Json.Decode.lazy (\_ -> Json.Decode.succeed NeedsReset))
            , ("RequestCipher", Json.Decode.lazy (\_ -> Json.Decode.map RequestCipher (Json.Decode.string)))
            , ("SendMasterPassword", Json.Decode.lazy (\_ -> Json.Decode.map SendMasterPassword (Json.Decode.string)))
            ]
        jsonDecObjectSetCmd = Set.fromList []
    in  decodeSumTaggedObject "Cmd" "tag" "contents" jsonDecDictCmd jsonDecObjectSetCmd

jsonEncCmd : Cmd -> Value
jsonEncCmd  val =
    let keyval v = case v of
                    Init  -> ("Init", encodeValue (Json.Encode.list identity []))
                    Login v1 -> ("Login", encodeValue (jsonEncCmd_Login v1))
                    NeedCiphersList  -> ("NeedCiphersList", encodeValue (Json.Encode.list identity []))
                    NeedsReset  -> ("NeedsReset", encodeValue (Json.Encode.list identity []))
                    RequestCipher v1 -> ("RequestCipher", encodeValue (Json.Encode.string v1))
                    SendMasterPassword v1 -> ("SendMasterPassword", encodeValue (Json.Encode.string v1))
    in encodeSumTaggedObject "tag" "contents" keyval val



type alias Sub_LoadCipher_cipherType_CardCipher  =
   { brand: String
   , cardholderName: String
   , code: String
   , expMonth: String
   , expYear: String
   , number: String
   }

jsonDecSub_LoadCipher_cipherType_CardCipher : Json.Decode.Decoder ( Sub_LoadCipher_cipherType_CardCipher )
jsonDecSub_LoadCipher_cipherType_CardCipher =
   Json.Decode.succeed (\pbrand pcardholderName pcode pexpMonth pexpYear pnumber -> {brand = pbrand, cardholderName = pcardholderName, code = pcode, expMonth = pexpMonth, expYear = pexpYear, number = pnumber})
   |> required "brand" (Json.Decode.string)
   |> required "cardholderName" (Json.Decode.string)
   |> required "code" (Json.Decode.string)
   |> required "expMonth" (Json.Decode.string)
   |> required "expYear" (Json.Decode.string)
   |> required "number" (Json.Decode.string)

jsonEncSub_LoadCipher_cipherType_CardCipher : Sub_LoadCipher_cipherType_CardCipher -> Value
jsonEncSub_LoadCipher_cipherType_CardCipher  val =
   Json.Encode.object
   [ ("brand", Json.Encode.string val.brand)
   , ("cardholderName", Json.Encode.string val.cardholderName)
   , ("code", Json.Encode.string val.code)
   , ("expMonth", Json.Encode.string val.expMonth)
   , ("expYear", Json.Encode.string val.expYear)
   , ("number", Json.Encode.string val.number)
   ]



type alias Sub_LoadCipher_cipherType_LoginCipher_uris_List  = (List String)

jsonDecSub_LoadCipher_cipherType_LoginCipher_uris_List : Json.Decode.Decoder ( Sub_LoadCipher_cipherType_LoginCipher_uris_List )
jsonDecSub_LoadCipher_cipherType_LoginCipher_uris_List =
    Json.Decode.list (Json.Decode.string)

jsonEncSub_LoadCipher_cipherType_LoginCipher_uris_List : Sub_LoadCipher_cipherType_LoginCipher_uris_List -> Value
jsonEncSub_LoadCipher_cipherType_LoginCipher_uris_List  val = (Json.Encode.list Json.Encode.string) val



type alias Sub_LoadCipher_cipherType_LoginCipher  =
   { password: String
   , uris: Sub_LoadCipher_cipherType_LoginCipher_uris_List
   , username: String
   }

jsonDecSub_LoadCipher_cipherType_LoginCipher : Json.Decode.Decoder ( Sub_LoadCipher_cipherType_LoginCipher )
jsonDecSub_LoadCipher_cipherType_LoginCipher =
   Json.Decode.succeed (\ppassword puris pusername -> {password = ppassword, uris = puris, username = pusername})
   |> required "password" (Json.Decode.string)
   |> required "uris" (jsonDecSub_LoadCipher_cipherType_LoginCipher_uris_List)
   |> required "username" (Json.Decode.string)

jsonEncSub_LoadCipher_cipherType_LoginCipher : Sub_LoadCipher_cipherType_LoginCipher -> Value
jsonEncSub_LoadCipher_cipherType_LoginCipher  val =
   Json.Encode.object
   [ ("password", Json.Encode.string val.password)
   , ("uris", jsonEncSub_LoadCipher_cipherType_LoginCipher_uris_List val.uris)
   , ("username", Json.Encode.string val.username)
   ]



type Sub_LoadCipher_cipherType  =
    CardCipher Sub_LoadCipher_cipherType_CardCipher
    | LoginCipher Sub_LoadCipher_cipherType_LoginCipher
    | NoteCipher String

jsonDecSub_LoadCipher_cipherType : Json.Decode.Decoder ( Sub_LoadCipher_cipherType )
jsonDecSub_LoadCipher_cipherType =
    let jsonDecDictSub_LoadCipher_cipherType = Dict.fromList
            [ ("CardCipher", Json.Decode.lazy (\_ -> Json.Decode.map CardCipher (jsonDecSub_LoadCipher_cipherType_CardCipher)))
            , ("LoginCipher", Json.Decode.lazy (\_ -> Json.Decode.map LoginCipher (jsonDecSub_LoadCipher_cipherType_LoginCipher)))
            , ("NoteCipher", Json.Decode.lazy (\_ -> Json.Decode.map NoteCipher (Json.Decode.string)))
            ]
        jsonDecObjectSetSub_LoadCipher_cipherType = Set.fromList []
    in  decodeSumTaggedObject "Sub_LoadCipher_cipherType" "tag" "contents" jsonDecDictSub_LoadCipher_cipherType jsonDecObjectSetSub_LoadCipher_cipherType

jsonEncSub_LoadCipher_cipherType : Sub_LoadCipher_cipherType -> Value
jsonEncSub_LoadCipher_cipherType  val =
    let keyval v = case v of
                    CardCipher v1 -> ("CardCipher", encodeValue (jsonEncSub_LoadCipher_cipherType_CardCipher v1))
                    LoginCipher v1 -> ("LoginCipher", encodeValue (jsonEncSub_LoadCipher_cipherType_LoginCipher v1))
                    NoteCipher v1 -> ("NoteCipher", encodeValue (Json.Encode.string v1))
    in encodeSumTaggedObject "tag" "contents" keyval val



type alias Sub_LoadCipher  =
   { cipherType: Sub_LoadCipher_cipherType
   , id: String
   , name: String
   }

jsonDecSub_LoadCipher : Json.Decode.Decoder ( Sub_LoadCipher )
jsonDecSub_LoadCipher =
   Json.Decode.succeed (\pcipherType pid pname -> {cipherType = pcipherType, id = pid, name = pname})
   |> required "cipherType" (jsonDecSub_LoadCipher_cipherType)
   |> required "id" (Json.Decode.string)
   |> required "name" (Json.Decode.string)

jsonEncSub_LoadCipher : Sub_LoadCipher -> Value
jsonEncSub_LoadCipher  val =
   Json.Encode.object
   [ ("cipherType", jsonEncSub_LoadCipher_cipherType val.cipherType)
   , ("id", Json.Encode.string val.id)
   , ("name", Json.Encode.string val.name)
   ]



type Sub_LoadCiphers_cipherType  =
    CardType 
    | IdentityType 
    | LoginType 
    | NoteType 

jsonDecSub_LoadCiphers_cipherType : Json.Decode.Decoder ( Sub_LoadCiphers_cipherType )
jsonDecSub_LoadCiphers_cipherType = 
    let jsonDecDictSub_LoadCiphers_cipherType = Dict.fromList [("CardType", CardType), ("IdentityType", IdentityType), ("LoginType", LoginType), ("NoteType", NoteType)]
    in  decodeSumUnaries "Sub_LoadCiphers_cipherType" jsonDecDictSub_LoadCiphers_cipherType

jsonEncSub_LoadCiphers_cipherType : Sub_LoadCiphers_cipherType -> Value
jsonEncSub_LoadCiphers_cipherType  val =
    case val of
        CardType -> Json.Encode.string "CardType"
        IdentityType -> Json.Encode.string "IdentityType"
        LoginType -> Json.Encode.string "LoginType"
        NoteType -> Json.Encode.string "NoteType"



type alias Sub_LoadCiphers  =
   { cipherType: Sub_LoadCiphers_cipherType
   , date: String
   , id: String
   , name: String
   }

jsonDecSub_LoadCiphers : Json.Decode.Decoder ( Sub_LoadCiphers )
jsonDecSub_LoadCiphers =
   Json.Decode.succeed (\pcipherType pdate pid pname -> {cipherType = pcipherType, date = pdate, id = pid, name = pname})
   |> required "cipherType" (jsonDecSub_LoadCiphers_cipherType)
   |> required "date" (Json.Decode.string)
   |> required "id" (Json.Decode.string)
   |> required "name" (Json.Decode.string)

jsonEncSub_LoadCiphers : Sub_LoadCiphers -> Value
jsonEncSub_LoadCiphers  val =
   Json.Encode.object
   [ ("cipherType", jsonEncSub_LoadCiphers_cipherType val.cipherType)
   , ("date", Json.Encode.string val.date)
   , ("id", Json.Encode.string val.id)
   , ("name", Json.Encode.string val.name)
   ]



type alias Sub_LoadCiphers_List  = (List Sub_LoadCiphers)

jsonDecSub_LoadCiphers_List : Json.Decode.Decoder ( Sub_LoadCiphers_List )
jsonDecSub_LoadCiphers_List =
    Json.Decode.list (jsonDecSub_LoadCiphers)

jsonEncSub_LoadCiphers_List : Sub_LoadCiphers_List -> Value
jsonEncSub_LoadCiphers_List  val = (Json.Encode.list jsonEncSub_LoadCiphers) val



type alias Sub_NeedsMasterPassword  =
   { login: String
   , server: String
   }

jsonDecSub_NeedsMasterPassword : Json.Decode.Decoder ( Sub_NeedsMasterPassword )
jsonDecSub_NeedsMasterPassword =
   Json.Decode.succeed (\plogin pserver -> {login = plogin, server = pserver})
   |> required "login" (Json.Decode.string)
   |> required "server" (Json.Decode.string)

jsonEncSub_NeedsMasterPassword : Sub_NeedsMasterPassword -> Value
jsonEncSub_NeedsMasterPassword  val =
   Json.Encode.object
   [ ("login", Json.Encode.string val.login)
   , ("server", Json.Encode.string val.server)
   ]



type Sub  =
    Error String
    | LoadCipher Sub_LoadCipher
    | LoadCiphers Sub_LoadCiphers_List
    | LoginSuccessful 
    | NeedsLogin 
    | NeedsMasterPassword Sub_NeedsMasterPassword
    | Reset 

jsonDecSub : Json.Decode.Decoder ( Sub )
jsonDecSub =
    let jsonDecDictSub = Dict.fromList
            [ ("Error", Json.Decode.lazy (\_ -> Json.Decode.map Error (Json.Decode.string)))
            , ("LoadCipher", Json.Decode.lazy (\_ -> Json.Decode.map LoadCipher (jsonDecSub_LoadCipher)))
            , ("LoadCiphers", Json.Decode.lazy (\_ -> Json.Decode.map LoadCiphers (jsonDecSub_LoadCiphers_List)))
            , ("LoginSuccessful", Json.Decode.lazy (\_ -> Json.Decode.succeed LoginSuccessful))
            , ("NeedsLogin", Json.Decode.lazy (\_ -> Json.Decode.succeed NeedsLogin))
            , ("NeedsMasterPassword", Json.Decode.lazy (\_ -> Json.Decode.map NeedsMasterPassword (jsonDecSub_NeedsMasterPassword)))
            , ("Reset", Json.Decode.lazy (\_ -> Json.Decode.succeed Reset))
            ]
        jsonDecObjectSetSub = Set.fromList []
    in  decodeSumTaggedObject "Sub" "tag" "contents" jsonDecDictSub jsonDecObjectSetSub

jsonEncSub : Sub -> Value
jsonEncSub  val =
    let keyval v = case v of
                    Error v1 -> ("Error", encodeValue (Json.Encode.string v1))
                    LoadCipher v1 -> ("LoadCipher", encodeValue (jsonEncSub_LoadCipher v1))
                    LoadCiphers v1 -> ("LoadCiphers", encodeValue (jsonEncSub_LoadCiphers_List v1))
                    LoginSuccessful  -> ("LoginSuccessful", encodeValue (Json.Encode.list identity []))
                    NeedsLogin  -> ("NeedsLogin", encodeValue (Json.Encode.list identity []))
                    NeedsMasterPassword v1 -> ("NeedsMasterPassword", encodeValue (jsonEncSub_NeedsMasterPassword v1))
                    Reset  -> ("Reset", encodeValue (Json.Encode.list identity []))
    in encodeSumTaggedObject "tag" "contents" keyval val

