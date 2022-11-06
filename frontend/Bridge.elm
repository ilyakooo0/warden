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



type alias Cipher_LoginCipher_totp_Maybe  = (Maybe String)

jsonDecCipher_LoginCipher_totp_Maybe : Json.Decode.Decoder ( Cipher_LoginCipher_totp_Maybe )
jsonDecCipher_LoginCipher_totp_Maybe =
    Json.Decode.maybe (Json.Decode.string)

jsonEncCipher_LoginCipher_totp_Maybe : Cipher_LoginCipher_totp_Maybe -> Value
jsonEncCipher_LoginCipher_totp_Maybe  val = (maybeEncode (Json.Encode.string)) val



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
   , totp: Cipher_LoginCipher_totp_Maybe
   , uris: Cipher_LoginCipher_uris_List
   , username: Cipher_LoginCipher_username_Maybe
   }

jsonDecCipher_LoginCipher : Json.Decode.Decoder ( Cipher_LoginCipher )
jsonDecCipher_LoginCipher =
   Json.Decode.succeed (\ppassword ptotp puris pusername -> {password = ppassword, totp = ptotp, uris = puris, username = pusername})
   |> required "password" (jsonDecCipher_LoginCipher_password_Maybe)
   |> required "totp" (jsonDecCipher_LoginCipher_totp_Maybe)
   |> required "uris" (jsonDecCipher_LoginCipher_uris_List)
   |> required "username" (jsonDecCipher_LoginCipher_username_Maybe)

jsonEncCipher_LoginCipher : Cipher_LoginCipher -> Value
jsonEncCipher_LoginCipher  val =
   Json.Encode.object
   [ ("password", jsonEncCipher_LoginCipher_password_Maybe val.password)
   , ("totp", jsonEncCipher_LoginCipher_totp_Maybe val.totp)
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



type alias Cmd_ChooseSecondFactor  =
   { email: String
   , factor: TwoFactorProviderType
   , password: String
   , requestFromServer: Bool
   , server: String
   }

jsonDecCmd_ChooseSecondFactor : Json.Decode.Decoder ( Cmd_ChooseSecondFactor )
jsonDecCmd_ChooseSecondFactor =
   Json.Decode.succeed (\pemail pfactor ppassword prequestFromServer pserver -> {email = pemail, factor = pfactor, password = ppassword, requestFromServer = prequestFromServer, server = pserver})
   |> required "email" (Json.Decode.string)
   |> required "factor" (jsonDecTwoFactorProviderType)
   |> required "password" (Json.Decode.string)
   |> required "requestFromServer" (Json.Decode.bool)
   |> required "server" (Json.Decode.string)

jsonEncCmd_ChooseSecondFactor : Cmd_ChooseSecondFactor -> Value
jsonEncCmd_ChooseSecondFactor  val =
   Json.Encode.object
   [ ("email", Json.Encode.string val.email)
   , ("factor", jsonEncTwoFactorProviderType val.factor)
   , ("password", Json.Encode.string val.password)
   , ("requestFromServer", Json.Encode.bool val.requestFromServer)
   , ("server", Json.Encode.string val.server)
   ]



type alias Cmd_Login_secondFactor  =
   { provider: TwoFactorProviderType
   , remember: Bool
   , token: String
   }

jsonDecCmd_Login_secondFactor : Json.Decode.Decoder ( Cmd_Login_secondFactor )
jsonDecCmd_Login_secondFactor =
   Json.Decode.succeed (\pprovider premember ptoken -> {provider = pprovider, remember = premember, token = ptoken})
   |> required "provider" (jsonDecTwoFactorProviderType)
   |> required "remember" (Json.Decode.bool)
   |> required "token" (Json.Decode.string)

jsonEncCmd_Login_secondFactor : Cmd_Login_secondFactor -> Value
jsonEncCmd_Login_secondFactor  val =
   Json.Encode.object
   [ ("provider", jsonEncTwoFactorProviderType val.provider)
   , ("remember", Json.Encode.bool val.remember)
   , ("token", Json.Encode.string val.token)
   ]



type alias Cmd_Login_secondFactor_Maybe  = (Maybe Cmd_Login_secondFactor)

jsonDecCmd_Login_secondFactor_Maybe : Json.Decode.Decoder ( Cmd_Login_secondFactor_Maybe )
jsonDecCmd_Login_secondFactor_Maybe =
    Json.Decode.maybe (jsonDecCmd_Login_secondFactor)

jsonEncCmd_Login_secondFactor_Maybe : Cmd_Login_secondFactor_Maybe -> Value
jsonEncCmd_Login_secondFactor_Maybe  val = (maybeEncode (jsonEncCmd_Login_secondFactor)) val



type alias Cmd_Login  =
   { email: String
   , password: String
   , secondFactor: Cmd_Login_secondFactor_Maybe
   , server: String
   }

jsonDecCmd_Login : Json.Decode.Decoder ( Cmd_Login )
jsonDecCmd_Login =
   Json.Decode.succeed (\pemail ppassword psecondFactor pserver -> {email = pemail, password = ppassword, secondFactor = psecondFactor, server = pserver})
   |> required "email" (Json.Decode.string)
   |> required "password" (Json.Decode.string)
   |> required "secondFactor" (jsonDecCmd_Login_secondFactor_Maybe)
   |> required "server" (Json.Decode.string)

jsonEncCmd_Login : Cmd_Login -> Value
jsonEncCmd_Login  val =
   Json.Encode.object
   [ ("email", Json.Encode.string val.email)
   , ("password", Json.Encode.string val.password)
   , ("secondFactor", jsonEncCmd_Login_secondFactor_Maybe val.secondFactor)
   , ("server", Json.Encode.string val.server)
   ]



type Cmd  =
    ChooseSecondFactor Cmd_ChooseSecondFactor
    | Copy String
    | CreateCipher FullCipher
    | DeleteCipher FullCipher
    | GeneratePassword PasswordGeneratorConfig
    | Init 
    | Login Cmd_Login
    | NeedCiphersList 
    | NeedEmail 
    | NeedsReset 
    | Open String
    | RequestCipher String
    | RequestTotp String
    | SendMasterPassword String
    | UpdateCipher FullCipher

jsonDecCmd : Json.Decode.Decoder ( Cmd )
jsonDecCmd =
    let jsonDecDictCmd = Dict.fromList
            [ ("ChooseSecondFactor", Json.Decode.lazy (\_ -> Json.Decode.map ChooseSecondFactor (jsonDecCmd_ChooseSecondFactor)))
            , ("Copy", Json.Decode.lazy (\_ -> Json.Decode.map Copy (Json.Decode.string)))
            , ("CreateCipher", Json.Decode.lazy (\_ -> Json.Decode.map CreateCipher (jsonDecFullCipher)))
            , ("DeleteCipher", Json.Decode.lazy (\_ -> Json.Decode.map DeleteCipher (jsonDecFullCipher)))
            , ("GeneratePassword", Json.Decode.lazy (\_ -> Json.Decode.map GeneratePassword (jsonDecPasswordGeneratorConfig)))
            , ("Init", Json.Decode.lazy (\_ -> Json.Decode.succeed Init))
            , ("Login", Json.Decode.lazy (\_ -> Json.Decode.map Login (jsonDecCmd_Login)))
            , ("NeedCiphersList", Json.Decode.lazy (\_ -> Json.Decode.succeed NeedCiphersList))
            , ("NeedEmail", Json.Decode.lazy (\_ -> Json.Decode.succeed NeedEmail))
            , ("NeedsReset", Json.Decode.lazy (\_ -> Json.Decode.succeed NeedsReset))
            , ("Open", Json.Decode.lazy (\_ -> Json.Decode.map Open (Json.Decode.string)))
            , ("RequestCipher", Json.Decode.lazy (\_ -> Json.Decode.map RequestCipher (Json.Decode.string)))
            , ("RequestTotp", Json.Decode.lazy (\_ -> Json.Decode.map RequestTotp (Json.Decode.string)))
            , ("SendMasterPassword", Json.Decode.lazy (\_ -> Json.Decode.map SendMasterPassword (Json.Decode.string)))
            , ("UpdateCipher", Json.Decode.lazy (\_ -> Json.Decode.map UpdateCipher (jsonDecFullCipher)))
            ]
        jsonDecObjectSetCmd = Set.fromList []
    in  decodeSumTaggedObject "Cmd" "tag" "contents" jsonDecDictCmd jsonDecObjectSetCmd

jsonEncCmd : Cmd -> Value
jsonEncCmd  val =
    let keyval v = case v of
                    ChooseSecondFactor v1 -> ("ChooseSecondFactor", encodeValue (jsonEncCmd_ChooseSecondFactor v1))
                    Copy v1 -> ("Copy", encodeValue (Json.Encode.string v1))
                    CreateCipher v1 -> ("CreateCipher", encodeValue (jsonEncFullCipher v1))
                    DeleteCipher v1 -> ("DeleteCipher", encodeValue (jsonEncFullCipher v1))
                    GeneratePassword v1 -> ("GeneratePassword", encodeValue (jsonEncPasswordGeneratorConfig v1))
                    Init  -> ("Init", encodeValue (Json.Encode.list identity []))
                    Login v1 -> ("Login", encodeValue (jsonEncCmd_Login v1))
                    NeedCiphersList  -> ("NeedCiphersList", encodeValue (Json.Encode.list identity []))
                    NeedEmail  -> ("NeedEmail", encodeValue (Json.Encode.list identity []))
                    NeedsReset  -> ("NeedsReset", encodeValue (Json.Encode.list identity []))
                    Open v1 -> ("Open", encodeValue (Json.Encode.string v1))
                    RequestCipher v1 -> ("RequestCipher", encodeValue (Json.Encode.string v1))
                    RequestTotp v1 -> ("RequestTotp", encodeValue (Json.Encode.string v1))
                    SendMasterPassword v1 -> ("SendMasterPassword", encodeValue (Json.Encode.string v1))
                    UpdateCipher v1 -> ("UpdateCipher", encodeValue (jsonEncFullCipher v1))
    in encodeSumTaggedObject "tag" "contents" keyval val



type alias FullCipher_collectionIds_List  = (List String)

jsonDecFullCipher_collectionIds_List : Json.Decode.Decoder ( FullCipher_collectionIds_List )
jsonDecFullCipher_collectionIds_List =
    Json.Decode.list (Json.Decode.string)

jsonEncFullCipher_collectionIds_List : FullCipher_collectionIds_List -> Value
jsonEncFullCipher_collectionIds_List  val = (Json.Encode.list Json.Encode.string) val



type alias FullCipher  =
   { cipher: Cipher
   , collectionIds: FullCipher_collectionIds_List
   , favorite: Bool
   , id: String
   , name: String
   , reprompt: Int
   }

jsonDecFullCipher : Json.Decode.Decoder ( FullCipher )
jsonDecFullCipher =
   Json.Decode.succeed (\pcipher pcollectionIds pfavorite pid pname preprompt -> {cipher = pcipher, collectionIds = pcollectionIds, favorite = pfavorite, id = pid, name = pname, reprompt = preprompt})
   |> required "cipher" (jsonDecCipher)
   |> required "collectionIds" (jsonDecFullCipher_collectionIds_List)
   |> required "favorite" (Json.Decode.bool)
   |> required "id" (Json.Decode.string)
   |> required "name" (Json.Decode.string)
   |> required "reprompt" (Json.Decode.int)

jsonEncFullCipher : FullCipher -> Value
jsonEncFullCipher  val =
   Json.Encode.object
   [ ("cipher", jsonEncCipher val.cipher)
   , ("collectionIds", jsonEncFullCipher_collectionIds_List val.collectionIds)
   , ("favorite", Json.Encode.bool val.favorite)
   , ("id", Json.Encode.string val.id)
   , ("name", Json.Encode.string val.name)
   , ("reprompt", Json.Encode.int val.reprompt)
   ]



type alias PasswordGeneratorConfig  =
   { ambiguous: Bool
   , capitalize: Bool
   , includeNumber: Bool
   , length: Int
   , lowercase: Bool
   , minLowercase: Int
   , minNumber: Int
   , minSpecial: Int
   , minUppercase: Int
   , numWords: Int
   , number: Bool
   , special: Bool
   , type_: String
   , uppercase: Bool
   , wordSeparator: String
   }

jsonDecPasswordGeneratorConfig : Json.Decode.Decoder ( PasswordGeneratorConfig )
jsonDecPasswordGeneratorConfig =
   Json.Decode.succeed (\pambiguous pcapitalize pincludeNumber plength plowercase pminLowercase pminNumber pminSpecial pminUppercase pnumWords pnumber pspecial ptype puppercase pwordSeparator -> {ambiguous = pambiguous, capitalize = pcapitalize, includeNumber = pincludeNumber, length = plength, lowercase = plowercase, minLowercase = pminLowercase, minNumber = pminNumber, minSpecial = pminSpecial, minUppercase = pminUppercase, numWords = pnumWords, number = pnumber, special = pspecial, type_ = ptype, uppercase = puppercase, wordSeparator = pwordSeparator})
   |> required "ambiguous" (Json.Decode.bool)
   |> required "capitalize" (Json.Decode.bool)
   |> required "includeNumber" (Json.Decode.bool)
   |> required "length" (Json.Decode.int)
   |> required "lowercase" (Json.Decode.bool)
   |> required "minLowercase" (Json.Decode.int)
   |> required "minNumber" (Json.Decode.int)
   |> required "minSpecial" (Json.Decode.int)
   |> required "minUppercase" (Json.Decode.int)
   |> required "numWords" (Json.Decode.int)
   |> required "number" (Json.Decode.bool)
   |> required "special" (Json.Decode.bool)
   |> required "type" (Json.Decode.string)
   |> required "uppercase" (Json.Decode.bool)
   |> required "wordSeparator" (Json.Decode.string)

jsonEncPasswordGeneratorConfig : PasswordGeneratorConfig -> Value
jsonEncPasswordGeneratorConfig  val =
   Json.Encode.object
   [ ("ambiguous", Json.Encode.bool val.ambiguous)
   , ("capitalize", Json.Encode.bool val.capitalize)
   , ("includeNumber", Json.Encode.bool val.includeNumber)
   , ("length", Json.Encode.int val.length)
   , ("lowercase", Json.Encode.bool val.lowercase)
   , ("minLowercase", Json.Encode.int val.minLowercase)
   , ("minNumber", Json.Encode.int val.minNumber)
   , ("minSpecial", Json.Encode.int val.minSpecial)
   , ("minUppercase", Json.Encode.int val.minUppercase)
   , ("numWords", Json.Encode.int val.numWords)
   , ("number", Json.Encode.bool val.number)
   , ("special", Json.Encode.bool val.special)
   , ("type", Json.Encode.string val.type_)
   , ("uppercase", Json.Encode.bool val.uppercase)
   , ("wordSeparator", Json.Encode.string val.wordSeparator)
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



type alias Sub_NeedsSecondFactor_List  = (List TwoFactorProviderType)

jsonDecSub_NeedsSecondFactor_List : Json.Decode.Decoder ( Sub_NeedsSecondFactor_List )
jsonDecSub_NeedsSecondFactor_List =
    Json.Decode.list (jsonDecTwoFactorProviderType)

jsonEncSub_NeedsSecondFactor_List : Sub_NeedsSecondFactor_List -> Value
jsonEncSub_NeedsSecondFactor_List  val = (Json.Encode.list jsonEncTwoFactorProviderType) val



type alias Sub_Totp  =
   { code: String
   , interval: Int
   , source: String
   }

jsonDecSub_Totp : Json.Decode.Decoder ( Sub_Totp )
jsonDecSub_Totp =
   Json.Decode.succeed (\pcode pinterval psource -> {code = pcode, interval = pinterval, source = psource})
   |> required "code" (Json.Decode.string)
   |> required "interval" (Json.Decode.int)
   |> required "source" (Json.Decode.string)

jsonEncSub_Totp : Sub_Totp -> Value
jsonEncSub_Totp  val =
   Json.Encode.object
   [ ("code", Json.Encode.string val.code)
   , ("interval", Json.Encode.int val.interval)
   , ("source", Json.Encode.string val.source)
   ]



type Sub  =
    CaptchaDone 
    | CipherChanged FullCipher
    | CipherDeleted FullCipher
    | Error String
    | GeneratedPassword String
    | LoadCipher FullCipher
    | LoadCiphers Sub_LoadCiphers_List
    | LoginSuccessful 
    | NeedsCaptcha String
    | NeedsLogin 
    | NeedsMasterPassword Sub_NeedsMasterPassword
    | NeedsSecondFactor Sub_NeedsSecondFactor_List
    | RecieveEmail String
    | Reset 
    | Totp Sub_Totp
    | WrongPassword 

jsonDecSub : Json.Decode.Decoder ( Sub )
jsonDecSub =
    let jsonDecDictSub = Dict.fromList
            [ ("CaptchaDone", Json.Decode.lazy (\_ -> Json.Decode.succeed CaptchaDone))
            , ("CipherChanged", Json.Decode.lazy (\_ -> Json.Decode.map CipherChanged (jsonDecFullCipher)))
            , ("CipherDeleted", Json.Decode.lazy (\_ -> Json.Decode.map CipherDeleted (jsonDecFullCipher)))
            , ("Error", Json.Decode.lazy (\_ -> Json.Decode.map Error (Json.Decode.string)))
            , ("GeneratedPassword", Json.Decode.lazy (\_ -> Json.Decode.map GeneratedPassword (Json.Decode.string)))
            , ("LoadCipher", Json.Decode.lazy (\_ -> Json.Decode.map LoadCipher (jsonDecFullCipher)))
            , ("LoadCiphers", Json.Decode.lazy (\_ -> Json.Decode.map LoadCiphers (jsonDecSub_LoadCiphers_List)))
            , ("LoginSuccessful", Json.Decode.lazy (\_ -> Json.Decode.succeed LoginSuccessful))
            , ("NeedsCaptcha", Json.Decode.lazy (\_ -> Json.Decode.map NeedsCaptcha (Json.Decode.string)))
            , ("NeedsLogin", Json.Decode.lazy (\_ -> Json.Decode.succeed NeedsLogin))
            , ("NeedsMasterPassword", Json.Decode.lazy (\_ -> Json.Decode.map NeedsMasterPassword (jsonDecSub_NeedsMasterPassword)))
            , ("NeedsSecondFactor", Json.Decode.lazy (\_ -> Json.Decode.map NeedsSecondFactor (jsonDecSub_NeedsSecondFactor_List)))
            , ("RecieveEmail", Json.Decode.lazy (\_ -> Json.Decode.map RecieveEmail (Json.Decode.string)))
            , ("Reset", Json.Decode.lazy (\_ -> Json.Decode.succeed Reset))
            , ("Totp", Json.Decode.lazy (\_ -> Json.Decode.map Totp (jsonDecSub_Totp)))
            , ("WrongPassword", Json.Decode.lazy (\_ -> Json.Decode.succeed WrongPassword))
            ]
        jsonDecObjectSetSub = Set.fromList []
    in  decodeSumTaggedObject "Sub" "tag" "contents" jsonDecDictSub jsonDecObjectSetSub

jsonEncSub : Sub -> Value
jsonEncSub  val =
    let keyval v = case v of
                    CaptchaDone  -> ("CaptchaDone", encodeValue (Json.Encode.list identity []))
                    CipherChanged v1 -> ("CipherChanged", encodeValue (jsonEncFullCipher v1))
                    CipherDeleted v1 -> ("CipherDeleted", encodeValue (jsonEncFullCipher v1))
                    Error v1 -> ("Error", encodeValue (Json.Encode.string v1))
                    GeneratedPassword v1 -> ("GeneratedPassword", encodeValue (Json.Encode.string v1))
                    LoadCipher v1 -> ("LoadCipher", encodeValue (jsonEncFullCipher v1))
                    LoadCiphers v1 -> ("LoadCiphers", encodeValue (jsonEncSub_LoadCiphers_List v1))
                    LoginSuccessful  -> ("LoginSuccessful", encodeValue (Json.Encode.list identity []))
                    NeedsCaptcha v1 -> ("NeedsCaptcha", encodeValue (Json.Encode.string v1))
                    NeedsLogin  -> ("NeedsLogin", encodeValue (Json.Encode.list identity []))
                    NeedsMasterPassword v1 -> ("NeedsMasterPassword", encodeValue (jsonEncSub_NeedsMasterPassword v1))
                    NeedsSecondFactor v1 -> ("NeedsSecondFactor", encodeValue (jsonEncSub_NeedsSecondFactor_List v1))
                    RecieveEmail v1 -> ("RecieveEmail", encodeValue (Json.Encode.string v1))
                    Reset  -> ("Reset", encodeValue (Json.Encode.list identity []))
                    Totp v1 -> ("Totp", encodeValue (jsonEncSub_Totp v1))
                    WrongPassword  -> ("WrongPassword", encodeValue (Json.Encode.list identity []))
    in encodeSumTaggedObject "tag" "contents" keyval val



type TwoFactorProviderType  =
    Authenticator 
    | Duo 
    | Email 
    | OrganizationDuo 
    | Remember 
    | U2f 
    | WebAuthn 
    | Yubikey 

jsonDecTwoFactorProviderType : Json.Decode.Decoder ( TwoFactorProviderType )
jsonDecTwoFactorProviderType = 
    let jsonDecDictTwoFactorProviderType = Dict.fromList [("Authenticator", Authenticator), ("Duo", Duo), ("Email", Email), ("OrganizationDuo", OrganizationDuo), ("Remember", Remember), ("U2f", U2f), ("WebAuthn", WebAuthn), ("Yubikey", Yubikey)]
    in  decodeSumUnaries "TwoFactorProviderType" jsonDecDictTwoFactorProviderType

jsonEncTwoFactorProviderType : TwoFactorProviderType -> Value
jsonEncTwoFactorProviderType  val =
    case val of
        Authenticator -> Json.Encode.string "Authenticator"
        Duo -> Json.Encode.string "Duo"
        Email -> Json.Encode.string "Email"
        OrganizationDuo -> Json.Encode.string "OrganizationDuo"
        Remember -> Json.Encode.string "Remember"
        U2f -> Json.Encode.string "U2f"
        WebAuthn -> Json.Encode.string "WebAuthn"
        Yubikey -> Json.Encode.string "Yubikey"

