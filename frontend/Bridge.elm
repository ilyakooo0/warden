module Bridge exposing(..)

import Json.Decode
import Json.Encode exposing (Value)
-- The following module comes from bartavelle/json-helpers
import Json.Helpers exposing (..)
import Dict exposing (Dict)
import Set exposing (Set)


type alias Cipher_CardCipher_brand_Maybe  = (Maybe String)

jsonDecCipher_CardCipher_brand_Maybe : Json.Decode.Decoder ( Cipher_CardCipher_brand_Maybe )
jsonDecCipher_CardCipher_brand_Maybe =
    Json.Decode.maybe (Json.Decode.string)

jsonEncCipher_CardCipher_brand_Maybe : Cipher_CardCipher_brand_Maybe -> Value
jsonEncCipher_CardCipher_brand_Maybe  val = (maybeEncode (Json.Encode.string)) val



type alias Cipher_CardCipher_cardholderName_Maybe  = (Maybe String)

jsonDecCipher_CardCipher_cardholderName_Maybe : Json.Decode.Decoder ( Cipher_CardCipher_cardholderName_Maybe )
jsonDecCipher_CardCipher_cardholderName_Maybe =
    Json.Decode.maybe (Json.Decode.string)

jsonEncCipher_CardCipher_cardholderName_Maybe : Cipher_CardCipher_cardholderName_Maybe -> Value
jsonEncCipher_CardCipher_cardholderName_Maybe  val = (maybeEncode (Json.Encode.string)) val



type alias Cipher_CardCipher_code_Maybe  = (Maybe String)

jsonDecCipher_CardCipher_code_Maybe : Json.Decode.Decoder ( Cipher_CardCipher_code_Maybe )
jsonDecCipher_CardCipher_code_Maybe =
    Json.Decode.maybe (Json.Decode.string)

jsonEncCipher_CardCipher_code_Maybe : Cipher_CardCipher_code_Maybe -> Value
jsonEncCipher_CardCipher_code_Maybe  val = (maybeEncode (Json.Encode.string)) val



type alias Cipher_CardCipher_expMonth_Maybe  = (Maybe String)

jsonDecCipher_CardCipher_expMonth_Maybe : Json.Decode.Decoder ( Cipher_CardCipher_expMonth_Maybe )
jsonDecCipher_CardCipher_expMonth_Maybe =
    Json.Decode.maybe (Json.Decode.string)

jsonEncCipher_CardCipher_expMonth_Maybe : Cipher_CardCipher_expMonth_Maybe -> Value
jsonEncCipher_CardCipher_expMonth_Maybe  val = (maybeEncode (Json.Encode.string)) val



type alias Cipher_CardCipher_expYear_Maybe  = (Maybe String)

jsonDecCipher_CardCipher_expYear_Maybe : Json.Decode.Decoder ( Cipher_CardCipher_expYear_Maybe )
jsonDecCipher_CardCipher_expYear_Maybe =
    Json.Decode.maybe (Json.Decode.string)

jsonEncCipher_CardCipher_expYear_Maybe : Cipher_CardCipher_expYear_Maybe -> Value
jsonEncCipher_CardCipher_expYear_Maybe  val = (maybeEncode (Json.Encode.string)) val



type alias Cipher_CardCipher_number_Maybe  = (Maybe String)

jsonDecCipher_CardCipher_number_Maybe : Json.Decode.Decoder ( Cipher_CardCipher_number_Maybe )
jsonDecCipher_CardCipher_number_Maybe =
    Json.Decode.maybe (Json.Decode.string)

jsonEncCipher_CardCipher_number_Maybe : Cipher_CardCipher_number_Maybe -> Value
jsonEncCipher_CardCipher_number_Maybe  val = (maybeEncode (Json.Encode.string)) val



type alias Cipher_CardCipher  =
   { brand: Cipher_CardCipher_brand_Maybe
   , cardholderName: Cipher_CardCipher_cardholderName_Maybe
   , code: Cipher_CardCipher_code_Maybe
   , expMonth: Cipher_CardCipher_expMonth_Maybe
   , expYear: Cipher_CardCipher_expYear_Maybe
   , number: Cipher_CardCipher_number_Maybe
   }

jsonDecCipher_CardCipher : Json.Decode.Decoder ( Cipher_CardCipher )
jsonDecCipher_CardCipher =
   Json.Decode.succeed (\pbrand pcardholderName pcode pexpMonth pexpYear pnumber -> {brand = pbrand, cardholderName = pcardholderName, code = pcode, expMonth = pexpMonth, expYear = pexpYear, number = pnumber})
   |> required "brand" (jsonDecCipher_CardCipher_brand_Maybe)
   |> required "cardholderName" (jsonDecCipher_CardCipher_cardholderName_Maybe)
   |> required "code" (jsonDecCipher_CardCipher_code_Maybe)
   |> required "expMonth" (jsonDecCipher_CardCipher_expMonth_Maybe)
   |> required "expYear" (jsonDecCipher_CardCipher_expYear_Maybe)
   |> required "number" (jsonDecCipher_CardCipher_number_Maybe)

jsonEncCipher_CardCipher : Cipher_CardCipher -> Value
jsonEncCipher_CardCipher  val =
   Json.Encode.object
   [ ("brand", jsonEncCipher_CardCipher_brand_Maybe val.brand)
   , ("cardholderName", jsonEncCipher_CardCipher_cardholderName_Maybe val.cardholderName)
   , ("code", jsonEncCipher_CardCipher_code_Maybe val.code)
   , ("expMonth", jsonEncCipher_CardCipher_expMonth_Maybe val.expMonth)
   , ("expYear", jsonEncCipher_CardCipher_expYear_Maybe val.expYear)
   , ("number", jsonEncCipher_CardCipher_number_Maybe val.number)
   ]



type alias Cipher_IdentityCipher_address1_Maybe  = (Maybe String)

jsonDecCipher_IdentityCipher_address1_Maybe : Json.Decode.Decoder ( Cipher_IdentityCipher_address1_Maybe )
jsonDecCipher_IdentityCipher_address1_Maybe =
    Json.Decode.maybe (Json.Decode.string)

jsonEncCipher_IdentityCipher_address1_Maybe : Cipher_IdentityCipher_address1_Maybe -> Value
jsonEncCipher_IdentityCipher_address1_Maybe  val = (maybeEncode (Json.Encode.string)) val



type alias Cipher_IdentityCipher_address2_Maybe  = (Maybe String)

jsonDecCipher_IdentityCipher_address2_Maybe : Json.Decode.Decoder ( Cipher_IdentityCipher_address2_Maybe )
jsonDecCipher_IdentityCipher_address2_Maybe =
    Json.Decode.maybe (Json.Decode.string)

jsonEncCipher_IdentityCipher_address2_Maybe : Cipher_IdentityCipher_address2_Maybe -> Value
jsonEncCipher_IdentityCipher_address2_Maybe  val = (maybeEncode (Json.Encode.string)) val



type alias Cipher_IdentityCipher_address3_Maybe  = (Maybe String)

jsonDecCipher_IdentityCipher_address3_Maybe : Json.Decode.Decoder ( Cipher_IdentityCipher_address3_Maybe )
jsonDecCipher_IdentityCipher_address3_Maybe =
    Json.Decode.maybe (Json.Decode.string)

jsonEncCipher_IdentityCipher_address3_Maybe : Cipher_IdentityCipher_address3_Maybe -> Value
jsonEncCipher_IdentityCipher_address3_Maybe  val = (maybeEncode (Json.Encode.string)) val



type alias Cipher_IdentityCipher_city_Maybe  = (Maybe String)

jsonDecCipher_IdentityCipher_city_Maybe : Json.Decode.Decoder ( Cipher_IdentityCipher_city_Maybe )
jsonDecCipher_IdentityCipher_city_Maybe =
    Json.Decode.maybe (Json.Decode.string)

jsonEncCipher_IdentityCipher_city_Maybe : Cipher_IdentityCipher_city_Maybe -> Value
jsonEncCipher_IdentityCipher_city_Maybe  val = (maybeEncode (Json.Encode.string)) val



type alias Cipher_IdentityCipher_company_Maybe  = (Maybe String)

jsonDecCipher_IdentityCipher_company_Maybe : Json.Decode.Decoder ( Cipher_IdentityCipher_company_Maybe )
jsonDecCipher_IdentityCipher_company_Maybe =
    Json.Decode.maybe (Json.Decode.string)

jsonEncCipher_IdentityCipher_company_Maybe : Cipher_IdentityCipher_company_Maybe -> Value
jsonEncCipher_IdentityCipher_company_Maybe  val = (maybeEncode (Json.Encode.string)) val



type alias Cipher_IdentityCipher_country_Maybe  = (Maybe String)

jsonDecCipher_IdentityCipher_country_Maybe : Json.Decode.Decoder ( Cipher_IdentityCipher_country_Maybe )
jsonDecCipher_IdentityCipher_country_Maybe =
    Json.Decode.maybe (Json.Decode.string)

jsonEncCipher_IdentityCipher_country_Maybe : Cipher_IdentityCipher_country_Maybe -> Value
jsonEncCipher_IdentityCipher_country_Maybe  val = (maybeEncode (Json.Encode.string)) val



type alias Cipher_IdentityCipher_email_Maybe  = (Maybe String)

jsonDecCipher_IdentityCipher_email_Maybe : Json.Decode.Decoder ( Cipher_IdentityCipher_email_Maybe )
jsonDecCipher_IdentityCipher_email_Maybe =
    Json.Decode.maybe (Json.Decode.string)

jsonEncCipher_IdentityCipher_email_Maybe : Cipher_IdentityCipher_email_Maybe -> Value
jsonEncCipher_IdentityCipher_email_Maybe  val = (maybeEncode (Json.Encode.string)) val



type alias Cipher_IdentityCipher_firstName_Maybe  = (Maybe String)

jsonDecCipher_IdentityCipher_firstName_Maybe : Json.Decode.Decoder ( Cipher_IdentityCipher_firstName_Maybe )
jsonDecCipher_IdentityCipher_firstName_Maybe =
    Json.Decode.maybe (Json.Decode.string)

jsonEncCipher_IdentityCipher_firstName_Maybe : Cipher_IdentityCipher_firstName_Maybe -> Value
jsonEncCipher_IdentityCipher_firstName_Maybe  val = (maybeEncode (Json.Encode.string)) val



type alias Cipher_IdentityCipher_lastName_Maybe  = (Maybe String)

jsonDecCipher_IdentityCipher_lastName_Maybe : Json.Decode.Decoder ( Cipher_IdentityCipher_lastName_Maybe )
jsonDecCipher_IdentityCipher_lastName_Maybe =
    Json.Decode.maybe (Json.Decode.string)

jsonEncCipher_IdentityCipher_lastName_Maybe : Cipher_IdentityCipher_lastName_Maybe -> Value
jsonEncCipher_IdentityCipher_lastName_Maybe  val = (maybeEncode (Json.Encode.string)) val



type alias Cipher_IdentityCipher_licenseNumber_Maybe  = (Maybe String)

jsonDecCipher_IdentityCipher_licenseNumber_Maybe : Json.Decode.Decoder ( Cipher_IdentityCipher_licenseNumber_Maybe )
jsonDecCipher_IdentityCipher_licenseNumber_Maybe =
    Json.Decode.maybe (Json.Decode.string)

jsonEncCipher_IdentityCipher_licenseNumber_Maybe : Cipher_IdentityCipher_licenseNumber_Maybe -> Value
jsonEncCipher_IdentityCipher_licenseNumber_Maybe  val = (maybeEncode (Json.Encode.string)) val



type alias Cipher_IdentityCipher_middleName_Maybe  = (Maybe String)

jsonDecCipher_IdentityCipher_middleName_Maybe : Json.Decode.Decoder ( Cipher_IdentityCipher_middleName_Maybe )
jsonDecCipher_IdentityCipher_middleName_Maybe =
    Json.Decode.maybe (Json.Decode.string)

jsonEncCipher_IdentityCipher_middleName_Maybe : Cipher_IdentityCipher_middleName_Maybe -> Value
jsonEncCipher_IdentityCipher_middleName_Maybe  val = (maybeEncode (Json.Encode.string)) val



type alias Cipher_IdentityCipher_passportNumber_Maybe  = (Maybe String)

jsonDecCipher_IdentityCipher_passportNumber_Maybe : Json.Decode.Decoder ( Cipher_IdentityCipher_passportNumber_Maybe )
jsonDecCipher_IdentityCipher_passportNumber_Maybe =
    Json.Decode.maybe (Json.Decode.string)

jsonEncCipher_IdentityCipher_passportNumber_Maybe : Cipher_IdentityCipher_passportNumber_Maybe -> Value
jsonEncCipher_IdentityCipher_passportNumber_Maybe  val = (maybeEncode (Json.Encode.string)) val



type alias Cipher_IdentityCipher_phone_Maybe  = (Maybe String)

jsonDecCipher_IdentityCipher_phone_Maybe : Json.Decode.Decoder ( Cipher_IdentityCipher_phone_Maybe )
jsonDecCipher_IdentityCipher_phone_Maybe =
    Json.Decode.maybe (Json.Decode.string)

jsonEncCipher_IdentityCipher_phone_Maybe : Cipher_IdentityCipher_phone_Maybe -> Value
jsonEncCipher_IdentityCipher_phone_Maybe  val = (maybeEncode (Json.Encode.string)) val



type alias Cipher_IdentityCipher_postalCode_Maybe  = (Maybe String)

jsonDecCipher_IdentityCipher_postalCode_Maybe : Json.Decode.Decoder ( Cipher_IdentityCipher_postalCode_Maybe )
jsonDecCipher_IdentityCipher_postalCode_Maybe =
    Json.Decode.maybe (Json.Decode.string)

jsonEncCipher_IdentityCipher_postalCode_Maybe : Cipher_IdentityCipher_postalCode_Maybe -> Value
jsonEncCipher_IdentityCipher_postalCode_Maybe  val = (maybeEncode (Json.Encode.string)) val



type alias Cipher_IdentityCipher_ssn_Maybe  = (Maybe String)

jsonDecCipher_IdentityCipher_ssn_Maybe : Json.Decode.Decoder ( Cipher_IdentityCipher_ssn_Maybe )
jsonDecCipher_IdentityCipher_ssn_Maybe =
    Json.Decode.maybe (Json.Decode.string)

jsonEncCipher_IdentityCipher_ssn_Maybe : Cipher_IdentityCipher_ssn_Maybe -> Value
jsonEncCipher_IdentityCipher_ssn_Maybe  val = (maybeEncode (Json.Encode.string)) val



type alias Cipher_IdentityCipher_state_Maybe  = (Maybe String)

jsonDecCipher_IdentityCipher_state_Maybe : Json.Decode.Decoder ( Cipher_IdentityCipher_state_Maybe )
jsonDecCipher_IdentityCipher_state_Maybe =
    Json.Decode.maybe (Json.Decode.string)

jsonEncCipher_IdentityCipher_state_Maybe : Cipher_IdentityCipher_state_Maybe -> Value
jsonEncCipher_IdentityCipher_state_Maybe  val = (maybeEncode (Json.Encode.string)) val



type alias Cipher_IdentityCipher_title_Maybe  = (Maybe String)

jsonDecCipher_IdentityCipher_title_Maybe : Json.Decode.Decoder ( Cipher_IdentityCipher_title_Maybe )
jsonDecCipher_IdentityCipher_title_Maybe =
    Json.Decode.maybe (Json.Decode.string)

jsonEncCipher_IdentityCipher_title_Maybe : Cipher_IdentityCipher_title_Maybe -> Value
jsonEncCipher_IdentityCipher_title_Maybe  val = (maybeEncode (Json.Encode.string)) val



type alias Cipher_IdentityCipher_username_Maybe  = (Maybe String)

jsonDecCipher_IdentityCipher_username_Maybe : Json.Decode.Decoder ( Cipher_IdentityCipher_username_Maybe )
jsonDecCipher_IdentityCipher_username_Maybe =
    Json.Decode.maybe (Json.Decode.string)

jsonEncCipher_IdentityCipher_username_Maybe : Cipher_IdentityCipher_username_Maybe -> Value
jsonEncCipher_IdentityCipher_username_Maybe  val = (maybeEncode (Json.Encode.string)) val



type alias Cipher_IdentityCipher  =
   { address1: Cipher_IdentityCipher_address1_Maybe
   , address2: Cipher_IdentityCipher_address2_Maybe
   , address3: Cipher_IdentityCipher_address3_Maybe
   , city: Cipher_IdentityCipher_city_Maybe
   , company: Cipher_IdentityCipher_company_Maybe
   , country: Cipher_IdentityCipher_country_Maybe
   , email: Cipher_IdentityCipher_email_Maybe
   , firstName: Cipher_IdentityCipher_firstName_Maybe
   , lastName: Cipher_IdentityCipher_lastName_Maybe
   , licenseNumber: Cipher_IdentityCipher_licenseNumber_Maybe
   , middleName: Cipher_IdentityCipher_middleName_Maybe
   , passportNumber: Cipher_IdentityCipher_passportNumber_Maybe
   , phone: Cipher_IdentityCipher_phone_Maybe
   , postalCode: Cipher_IdentityCipher_postalCode_Maybe
   , ssn: Cipher_IdentityCipher_ssn_Maybe
   , state: Cipher_IdentityCipher_state_Maybe
   , title: Cipher_IdentityCipher_title_Maybe
   , username: Cipher_IdentityCipher_username_Maybe
   }

jsonDecCipher_IdentityCipher : Json.Decode.Decoder ( Cipher_IdentityCipher )
jsonDecCipher_IdentityCipher =
   Json.Decode.succeed (\paddress1 paddress2 paddress3 pcity pcompany pcountry pemail pfirstName plastName plicenseNumber pmiddleName ppassportNumber pphone ppostalCode pssn pstate ptitle pusername -> {address1 = paddress1, address2 = paddress2, address3 = paddress3, city = pcity, company = pcompany, country = pcountry, email = pemail, firstName = pfirstName, lastName = plastName, licenseNumber = plicenseNumber, middleName = pmiddleName, passportNumber = ppassportNumber, phone = pphone, postalCode = ppostalCode, ssn = pssn, state = pstate, title = ptitle, username = pusername})
   |> required "address1" (jsonDecCipher_IdentityCipher_address1_Maybe)
   |> required "address2" (jsonDecCipher_IdentityCipher_address2_Maybe)
   |> required "address3" (jsonDecCipher_IdentityCipher_address3_Maybe)
   |> required "city" (jsonDecCipher_IdentityCipher_city_Maybe)
   |> required "company" (jsonDecCipher_IdentityCipher_company_Maybe)
   |> required "country" (jsonDecCipher_IdentityCipher_country_Maybe)
   |> required "email" (jsonDecCipher_IdentityCipher_email_Maybe)
   |> required "firstName" (jsonDecCipher_IdentityCipher_firstName_Maybe)
   |> required "lastName" (jsonDecCipher_IdentityCipher_lastName_Maybe)
   |> required "licenseNumber" (jsonDecCipher_IdentityCipher_licenseNumber_Maybe)
   |> required "middleName" (jsonDecCipher_IdentityCipher_middleName_Maybe)
   |> required "passportNumber" (jsonDecCipher_IdentityCipher_passportNumber_Maybe)
   |> required "phone" (jsonDecCipher_IdentityCipher_phone_Maybe)
   |> required "postalCode" (jsonDecCipher_IdentityCipher_postalCode_Maybe)
   |> required "ssn" (jsonDecCipher_IdentityCipher_ssn_Maybe)
   |> required "state" (jsonDecCipher_IdentityCipher_state_Maybe)
   |> required "title" (jsonDecCipher_IdentityCipher_title_Maybe)
   |> required "username" (jsonDecCipher_IdentityCipher_username_Maybe)

jsonEncCipher_IdentityCipher : Cipher_IdentityCipher -> Value
jsonEncCipher_IdentityCipher  val =
   Json.Encode.object
   [ ("address1", jsonEncCipher_IdentityCipher_address1_Maybe val.address1)
   , ("address2", jsonEncCipher_IdentityCipher_address2_Maybe val.address2)
   , ("address3", jsonEncCipher_IdentityCipher_address3_Maybe val.address3)
   , ("city", jsonEncCipher_IdentityCipher_city_Maybe val.city)
   , ("company", jsonEncCipher_IdentityCipher_company_Maybe val.company)
   , ("country", jsonEncCipher_IdentityCipher_country_Maybe val.country)
   , ("email", jsonEncCipher_IdentityCipher_email_Maybe val.email)
   , ("firstName", jsonEncCipher_IdentityCipher_firstName_Maybe val.firstName)
   , ("lastName", jsonEncCipher_IdentityCipher_lastName_Maybe val.lastName)
   , ("licenseNumber", jsonEncCipher_IdentityCipher_licenseNumber_Maybe val.licenseNumber)
   , ("middleName", jsonEncCipher_IdentityCipher_middleName_Maybe val.middleName)
   , ("passportNumber", jsonEncCipher_IdentityCipher_passportNumber_Maybe val.passportNumber)
   , ("phone", jsonEncCipher_IdentityCipher_phone_Maybe val.phone)
   , ("postalCode", jsonEncCipher_IdentityCipher_postalCode_Maybe val.postalCode)
   , ("ssn", jsonEncCipher_IdentityCipher_ssn_Maybe val.ssn)
   , ("state", jsonEncCipher_IdentityCipher_state_Maybe val.state)
   , ("title", jsonEncCipher_IdentityCipher_title_Maybe val.title)
   , ("username", jsonEncCipher_IdentityCipher_username_Maybe val.username)
   ]



type alias Cipher_LoginCipher_password_Maybe  = (Maybe String)

jsonDecCipher_LoginCipher_password_Maybe : Json.Decode.Decoder ( Cipher_LoginCipher_password_Maybe )
jsonDecCipher_LoginCipher_password_Maybe =
    Json.Decode.maybe (Json.Decode.string)

jsonEncCipher_LoginCipher_password_Maybe : Cipher_LoginCipher_password_Maybe -> Value
jsonEncCipher_LoginCipher_password_Maybe  val = (maybeEncode (Json.Encode.string)) val



type alias Cipher_LoginCipher_uris_List  = (List String)

jsonDecCipher_LoginCipher_uris_List : Json.Decode.Decoder ( Cipher_LoginCipher_uris_List )
jsonDecCipher_LoginCipher_uris_List =
    Json.Decode.list (Json.Decode.string)

jsonEncCipher_LoginCipher_uris_List : Cipher_LoginCipher_uris_List -> Value
jsonEncCipher_LoginCipher_uris_List  val = (Json.Encode.list Json.Encode.string) val



type alias Cipher_LoginCipher_username_Maybe  = (Maybe String)

jsonDecCipher_LoginCipher_username_Maybe : Json.Decode.Decoder ( Cipher_LoginCipher_username_Maybe )
jsonDecCipher_LoginCipher_username_Maybe =
    Json.Decode.maybe (Json.Decode.string)

jsonEncCipher_LoginCipher_username_Maybe : Cipher_LoginCipher_username_Maybe -> Value
jsonEncCipher_LoginCipher_username_Maybe  val = (maybeEncode (Json.Encode.string)) val



type alias Cipher_LoginCipher  =
   { password: Cipher_LoginCipher_password_Maybe
   , uris: Cipher_LoginCipher_uris_List
   , username: Cipher_LoginCipher_username_Maybe
   }

jsonDecCipher_LoginCipher : Json.Decode.Decoder ( Cipher_LoginCipher )
jsonDecCipher_LoginCipher =
   Json.Decode.succeed (\ppassword puris pusername -> {password = ppassword, uris = puris, username = pusername})
   |> required "password" (jsonDecCipher_LoginCipher_password_Maybe)
   |> required "uris" (jsonDecCipher_LoginCipher_uris_List)
   |> required "username" (jsonDecCipher_LoginCipher_username_Maybe)

jsonEncCipher_LoginCipher : Cipher_LoginCipher -> Value
jsonEncCipher_LoginCipher  val =
   Json.Encode.object
   [ ("password", jsonEncCipher_LoginCipher_password_Maybe val.password)
   , ("uris", jsonEncCipher_LoginCipher_uris_List val.uris)
   , ("username", jsonEncCipher_LoginCipher_username_Maybe val.username)
   ]



type Cipher  =
    CardCipher Cipher_CardCipher
    | IdentityCipher Cipher_IdentityCipher
    | LoginCipher Cipher_LoginCipher
    | NoteCipher String

jsonDecCipher : Json.Decode.Decoder ( Cipher )
jsonDecCipher =
    let jsonDecDictCipher = Dict.fromList
            [ ("CardCipher", Json.Decode.lazy (\_ -> Json.Decode.map CardCipher (jsonDecCipher_CardCipher)))
            , ("IdentityCipher", Json.Decode.lazy (\_ -> Json.Decode.map IdentityCipher (jsonDecCipher_IdentityCipher)))
            , ("LoginCipher", Json.Decode.lazy (\_ -> Json.Decode.map LoginCipher (jsonDecCipher_LoginCipher)))
            , ("NoteCipher", Json.Decode.lazy (\_ -> Json.Decode.map NoteCipher (Json.Decode.string)))
            ]
        jsonDecObjectSetCipher = Set.fromList []
    in  decodeSumTaggedObject "Cipher" "tag" "contents" jsonDecDictCipher jsonDecObjectSetCipher

jsonEncCipher : Cipher -> Value
jsonEncCipher  val =
    let keyval v = case v of
                    CardCipher v1 -> ("CardCipher", encodeValue (jsonEncCipher_CardCipher v1))
                    IdentityCipher v1 -> ("IdentityCipher", encodeValue (jsonEncCipher_IdentityCipher v1))
                    LoginCipher v1 -> ("LoginCipher", encodeValue (jsonEncCipher_LoginCipher v1))
                    NoteCipher v1 -> ("NoteCipher", encodeValue (Json.Encode.string v1))
    in encodeSumTaggedObject "tag" "contents" keyval val



type CipherType  =
    CardType 
    | IdentityType 
    | LoginType 
    | NoteType 

jsonDecCipherType : Json.Decode.Decoder ( CipherType )
jsonDecCipherType = 
    let jsonDecDictCipherType = Dict.fromList [("CardType", CardType), ("IdentityType", IdentityType), ("LoginType", LoginType), ("NoteType", NoteType)]
    in  decodeSumUnaries "CipherType" jsonDecDictCipherType

jsonEncCipherType : CipherType -> Value
jsonEncCipherType  val =
    case val of
        CardType -> Json.Encode.string "CardType"
        IdentityType -> Json.Encode.string "IdentityType"
        LoginType -> Json.Encode.string "LoginType"
        NoteType -> Json.Encode.string "NoteType"



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
    Copy String
    | Init 
    | Login Cmd_Login
    | NeedCiphersList 
    | NeedEmail 
    | NeedsReset 
    | Open String
    | RequestCipher String
    | SendMasterPassword String

jsonDecCmd : Json.Decode.Decoder ( Cmd )
jsonDecCmd =
    let jsonDecDictCmd = Dict.fromList
            [ ("Copy", Json.Decode.lazy (\_ -> Json.Decode.map Copy (Json.Decode.string)))
            , ("Init", Json.Decode.lazy (\_ -> Json.Decode.succeed Init))
            , ("Login", Json.Decode.lazy (\_ -> Json.Decode.map Login (jsonDecCmd_Login)))
            , ("NeedCiphersList", Json.Decode.lazy (\_ -> Json.Decode.succeed NeedCiphersList))
            , ("NeedEmail", Json.Decode.lazy (\_ -> Json.Decode.succeed NeedEmail))
            , ("NeedsReset", Json.Decode.lazy (\_ -> Json.Decode.succeed NeedsReset))
            , ("Open", Json.Decode.lazy (\_ -> Json.Decode.map Open (Json.Decode.string)))
            , ("RequestCipher", Json.Decode.lazy (\_ -> Json.Decode.map RequestCipher (Json.Decode.string)))
            , ("SendMasterPassword", Json.Decode.lazy (\_ -> Json.Decode.map SendMasterPassword (Json.Decode.string)))
            ]
        jsonDecObjectSetCmd = Set.fromList []
    in  decodeSumTaggedObject "Cmd" "tag" "contents" jsonDecDictCmd jsonDecObjectSetCmd

jsonEncCmd : Cmd -> Value
jsonEncCmd  val =
    let keyval v = case v of
                    Copy v1 -> ("Copy", encodeValue (Json.Encode.string v1))
                    Init  -> ("Init", encodeValue (Json.Encode.list identity []))
                    Login v1 -> ("Login", encodeValue (jsonEncCmd_Login v1))
                    NeedCiphersList  -> ("NeedCiphersList", encodeValue (Json.Encode.list identity []))
                    NeedEmail  -> ("NeedEmail", encodeValue (Json.Encode.list identity []))
                    NeedsReset  -> ("NeedsReset", encodeValue (Json.Encode.list identity []))
                    Open v1 -> ("Open", encodeValue (Json.Encode.string v1))
                    RequestCipher v1 -> ("RequestCipher", encodeValue (Json.Encode.string v1))
                    SendMasterPassword v1 -> ("SendMasterPassword", encodeValue (Json.Encode.string v1))
    in encodeSumTaggedObject "tag" "contents" keyval val



type alias Sub_LoadCipher  =
   { cipherType: Cipher
   , id: String
   , name: String
   }

jsonDecSub_LoadCipher : Json.Decode.Decoder ( Sub_LoadCipher )
jsonDecSub_LoadCipher =
   Json.Decode.succeed (\pcipherType pid pname -> {cipherType = pcipherType, id = pid, name = pname})
   |> required "cipherType" (jsonDecCipher)
   |> required "id" (Json.Decode.string)
   |> required "name" (Json.Decode.string)

jsonEncSub_LoadCipher : Sub_LoadCipher -> Value
jsonEncSub_LoadCipher  val =
   Json.Encode.object
   [ ("cipherType", jsonEncCipher val.cipherType)
   , ("id", Json.Encode.string val.id)
   , ("name", Json.Encode.string val.name)
   ]



type alias Sub_LoadCiphers  =
   { cipherType: CipherType
   , date: String
   , id: String
   , name: String
   }

jsonDecSub_LoadCiphers : Json.Decode.Decoder ( Sub_LoadCiphers )
jsonDecSub_LoadCiphers =
   Json.Decode.succeed (\pcipherType pdate pid pname -> {cipherType = pcipherType, date = pdate, id = pid, name = pname})
   |> required "cipherType" (jsonDecCipherType)
   |> required "date" (Json.Decode.string)
   |> required "id" (Json.Decode.string)
   |> required "name" (Json.Decode.string)

jsonEncSub_LoadCiphers : Sub_LoadCiphers -> Value
jsonEncSub_LoadCiphers  val =
   Json.Encode.object
   [ ("cipherType", jsonEncCipherType val.cipherType)
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
    CaptchaDone 
    | Error String
    | LoadCipher Sub_LoadCipher
    | LoadCiphers Sub_LoadCiphers_List
    | LoginSuccessful 
    | NeedsCaptcha String
    | NeedsLogin 
    | NeedsMasterPassword Sub_NeedsMasterPassword
    | RecieveEmail String
    | Reset 

jsonDecSub : Json.Decode.Decoder ( Sub )
jsonDecSub =
    let jsonDecDictSub = Dict.fromList
            [ ("CaptchaDone", Json.Decode.lazy (\_ -> Json.Decode.succeed CaptchaDone))
            , ("Error", Json.Decode.lazy (\_ -> Json.Decode.map Error (Json.Decode.string)))
            , ("LoadCipher", Json.Decode.lazy (\_ -> Json.Decode.map LoadCipher (jsonDecSub_LoadCipher)))
            , ("LoadCiphers", Json.Decode.lazy (\_ -> Json.Decode.map LoadCiphers (jsonDecSub_LoadCiphers_List)))
            , ("LoginSuccessful", Json.Decode.lazy (\_ -> Json.Decode.succeed LoginSuccessful))
            , ("NeedsCaptcha", Json.Decode.lazy (\_ -> Json.Decode.map NeedsCaptcha (Json.Decode.string)))
            , ("NeedsLogin", Json.Decode.lazy (\_ -> Json.Decode.succeed NeedsLogin))
            , ("NeedsMasterPassword", Json.Decode.lazy (\_ -> Json.Decode.map NeedsMasterPassword (jsonDecSub_NeedsMasterPassword)))
            , ("RecieveEmail", Json.Decode.lazy (\_ -> Json.Decode.map RecieveEmail (Json.Decode.string)))
            , ("Reset", Json.Decode.lazy (\_ -> Json.Decode.succeed Reset))
            ]
        jsonDecObjectSetSub = Set.fromList []
    in  decodeSumTaggedObject "Sub" "tag" "contents" jsonDecDictSub jsonDecObjectSetSub

jsonEncSub : Sub -> Value
jsonEncSub  val =
    let keyval v = case v of
                    CaptchaDone  -> ("CaptchaDone", encodeValue (Json.Encode.list identity []))
                    Error v1 -> ("Error", encodeValue (Json.Encode.string v1))
                    LoadCipher v1 -> ("LoadCipher", encodeValue (jsonEncSub_LoadCipher v1))
                    LoadCiphers v1 -> ("LoadCiphers", encodeValue (jsonEncSub_LoadCiphers_List v1))
                    LoginSuccessful  -> ("LoginSuccessful", encodeValue (Json.Encode.list identity []))
                    NeedsCaptcha v1 -> ("NeedsCaptcha", encodeValue (Json.Encode.string v1))
                    NeedsLogin  -> ("NeedsLogin", encodeValue (Json.Encode.list identity []))
                    NeedsMasterPassword v1 -> ("NeedsMasterPassword", encodeValue (jsonEncSub_NeedsMasterPassword v1))
                    RecieveEmail v1 -> ("RecieveEmail", encodeValue (Json.Encode.string v1))
                    Reset  -> ("Reset", encodeValue (Json.Encode.list identity []))
    in encodeSumTaggedObject "tag" "contents" keyval val

