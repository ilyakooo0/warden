-- File auto generated by purescript-bridge! --
module Bridge where

import Data.Argonaut.Aeson.Decode.Generic (genericDecodeAeson)
import Data.Argonaut.Aeson.Encode.Generic (genericEncodeAeson)
import Data.Argonaut.Aeson.Options as Argonaut
import Data.Argonaut.Decode.Class (class DecodeJson, decodeJson)
import Data.Argonaut.Encode.Class (class EncodeJson, encodeJson)
import Data.Generic.Rep (class Generic)
import Data.Maybe (Maybe(..))
import Data.Newtype (class Newtype)

import Prelude

newtype Cipher_CardCipher_brand_Maybe =
    Cipher_CardCipher_brand_Maybe (Maybe String)

derive instance newtypeCipher_CardCipher_brand_Maybe :: Newtype Cipher_CardCipher_brand_Maybe _
instance encodeJsonCipher_CardCipher_brand_Maybe :: EncodeJson Cipher_CardCipher_brand_Maybe where
  encodeJson = genericEncodeAeson Argonaut.defaultOptions
instance decodeJsonCipher_CardCipher_brand_Maybe :: DecodeJson Cipher_CardCipher_brand_Maybe where
  decodeJson = genericDecodeAeson Argonaut.defaultOptions
derive instance genericCipher_CardCipher_brand_Maybe :: Generic Cipher_CardCipher_brand_Maybe _
derive instance eqCipher_CardCipher_brand_Maybe :: Eq Cipher_CardCipher_brand_Maybe
derive instance ordCipher_CardCipher_brand_Maybe :: Ord Cipher_CardCipher_brand_Maybe

newtype Cipher_CardCipher_cardholderName_Maybe =
    Cipher_CardCipher_cardholderName_Maybe (Maybe String)

derive instance newtypeCipher_CardCipher_cardholderName_Maybe :: Newtype Cipher_CardCipher_cardholderName_Maybe _
instance encodeJsonCipher_CardCipher_cardholderName_Maybe :: EncodeJson Cipher_CardCipher_cardholderName_Maybe where
  encodeJson = genericEncodeAeson Argonaut.defaultOptions
instance decodeJsonCipher_CardCipher_cardholderName_Maybe :: DecodeJson Cipher_CardCipher_cardholderName_Maybe where
  decodeJson = genericDecodeAeson Argonaut.defaultOptions
derive instance genericCipher_CardCipher_cardholderName_Maybe :: Generic Cipher_CardCipher_cardholderName_Maybe _
derive instance eqCipher_CardCipher_cardholderName_Maybe :: Eq Cipher_CardCipher_cardholderName_Maybe
derive instance ordCipher_CardCipher_cardholderName_Maybe :: Ord Cipher_CardCipher_cardholderName_Maybe

newtype Cipher_CardCipher_code_Maybe =
    Cipher_CardCipher_code_Maybe (Maybe String)

derive instance newtypeCipher_CardCipher_code_Maybe :: Newtype Cipher_CardCipher_code_Maybe _
instance encodeJsonCipher_CardCipher_code_Maybe :: EncodeJson Cipher_CardCipher_code_Maybe where
  encodeJson = genericEncodeAeson Argonaut.defaultOptions
instance decodeJsonCipher_CardCipher_code_Maybe :: DecodeJson Cipher_CardCipher_code_Maybe where
  decodeJson = genericDecodeAeson Argonaut.defaultOptions
derive instance genericCipher_CardCipher_code_Maybe :: Generic Cipher_CardCipher_code_Maybe _
derive instance eqCipher_CardCipher_code_Maybe :: Eq Cipher_CardCipher_code_Maybe
derive instance ordCipher_CardCipher_code_Maybe :: Ord Cipher_CardCipher_code_Maybe

newtype Cipher_CardCipher_expMonth_Maybe =
    Cipher_CardCipher_expMonth_Maybe (Maybe String)

derive instance newtypeCipher_CardCipher_expMonth_Maybe :: Newtype Cipher_CardCipher_expMonth_Maybe _
instance encodeJsonCipher_CardCipher_expMonth_Maybe :: EncodeJson Cipher_CardCipher_expMonth_Maybe where
  encodeJson = genericEncodeAeson Argonaut.defaultOptions
instance decodeJsonCipher_CardCipher_expMonth_Maybe :: DecodeJson Cipher_CardCipher_expMonth_Maybe where
  decodeJson = genericDecodeAeson Argonaut.defaultOptions
derive instance genericCipher_CardCipher_expMonth_Maybe :: Generic Cipher_CardCipher_expMonth_Maybe _
derive instance eqCipher_CardCipher_expMonth_Maybe :: Eq Cipher_CardCipher_expMonth_Maybe
derive instance ordCipher_CardCipher_expMonth_Maybe :: Ord Cipher_CardCipher_expMonth_Maybe

newtype Cipher_CardCipher_expYear_Maybe =
    Cipher_CardCipher_expYear_Maybe (Maybe String)

derive instance newtypeCipher_CardCipher_expYear_Maybe :: Newtype Cipher_CardCipher_expYear_Maybe _
instance encodeJsonCipher_CardCipher_expYear_Maybe :: EncodeJson Cipher_CardCipher_expYear_Maybe where
  encodeJson = genericEncodeAeson Argonaut.defaultOptions
instance decodeJsonCipher_CardCipher_expYear_Maybe :: DecodeJson Cipher_CardCipher_expYear_Maybe where
  decodeJson = genericDecodeAeson Argonaut.defaultOptions
derive instance genericCipher_CardCipher_expYear_Maybe :: Generic Cipher_CardCipher_expYear_Maybe _
derive instance eqCipher_CardCipher_expYear_Maybe :: Eq Cipher_CardCipher_expYear_Maybe
derive instance ordCipher_CardCipher_expYear_Maybe :: Ord Cipher_CardCipher_expYear_Maybe

newtype Cipher_CardCipher_number_Maybe =
    Cipher_CardCipher_number_Maybe (Maybe String)

derive instance newtypeCipher_CardCipher_number_Maybe :: Newtype Cipher_CardCipher_number_Maybe _
instance encodeJsonCipher_CardCipher_number_Maybe :: EncodeJson Cipher_CardCipher_number_Maybe where
  encodeJson = genericEncodeAeson Argonaut.defaultOptions
instance decodeJsonCipher_CardCipher_number_Maybe :: DecodeJson Cipher_CardCipher_number_Maybe where
  decodeJson = genericDecodeAeson Argonaut.defaultOptions
derive instance genericCipher_CardCipher_number_Maybe :: Generic Cipher_CardCipher_number_Maybe _
derive instance eqCipher_CardCipher_number_Maybe :: Eq Cipher_CardCipher_number_Maybe
derive instance ordCipher_CardCipher_number_Maybe :: Ord Cipher_CardCipher_number_Maybe

newtype Cipher_CardCipher =
    Cipher_CardCipher {
      brand :: Cipher_CardCipher_brand_Maybe
    , cardholderName :: Cipher_CardCipher_cardholderName_Maybe
    , code :: Cipher_CardCipher_code_Maybe
    , expMonth :: Cipher_CardCipher_expMonth_Maybe
    , expYear :: Cipher_CardCipher_expYear_Maybe
    , number :: Cipher_CardCipher_number_Maybe
    }

derive instance newtypeCipher_CardCipher :: Newtype Cipher_CardCipher _
instance encodeJsonCipher_CardCipher :: EncodeJson Cipher_CardCipher where
  encodeJson = genericEncodeAeson Argonaut.defaultOptions
instance decodeJsonCipher_CardCipher :: DecodeJson Cipher_CardCipher where
  decodeJson = genericDecodeAeson Argonaut.defaultOptions
derive instance genericCipher_CardCipher :: Generic Cipher_CardCipher _
derive instance eqCipher_CardCipher :: Eq Cipher_CardCipher
derive instance ordCipher_CardCipher :: Ord Cipher_CardCipher

newtype Cipher_IdentityCipher_address1_Maybe =
    Cipher_IdentityCipher_address1_Maybe (Maybe String)

derive instance newtypeCipher_IdentityCipher_address1_Maybe :: Newtype Cipher_IdentityCipher_address1_Maybe _
instance encodeJsonCipher_IdentityCipher_address1_Maybe :: EncodeJson Cipher_IdentityCipher_address1_Maybe where
  encodeJson = genericEncodeAeson Argonaut.defaultOptions
instance decodeJsonCipher_IdentityCipher_address1_Maybe :: DecodeJson Cipher_IdentityCipher_address1_Maybe where
  decodeJson = genericDecodeAeson Argonaut.defaultOptions
derive instance genericCipher_IdentityCipher_address1_Maybe :: Generic Cipher_IdentityCipher_address1_Maybe _
derive instance eqCipher_IdentityCipher_address1_Maybe :: Eq Cipher_IdentityCipher_address1_Maybe
derive instance ordCipher_IdentityCipher_address1_Maybe :: Ord Cipher_IdentityCipher_address1_Maybe

newtype Cipher_IdentityCipher_address2_Maybe =
    Cipher_IdentityCipher_address2_Maybe (Maybe String)

derive instance newtypeCipher_IdentityCipher_address2_Maybe :: Newtype Cipher_IdentityCipher_address2_Maybe _
instance encodeJsonCipher_IdentityCipher_address2_Maybe :: EncodeJson Cipher_IdentityCipher_address2_Maybe where
  encodeJson = genericEncodeAeson Argonaut.defaultOptions
instance decodeJsonCipher_IdentityCipher_address2_Maybe :: DecodeJson Cipher_IdentityCipher_address2_Maybe where
  decodeJson = genericDecodeAeson Argonaut.defaultOptions
derive instance genericCipher_IdentityCipher_address2_Maybe :: Generic Cipher_IdentityCipher_address2_Maybe _
derive instance eqCipher_IdentityCipher_address2_Maybe :: Eq Cipher_IdentityCipher_address2_Maybe
derive instance ordCipher_IdentityCipher_address2_Maybe :: Ord Cipher_IdentityCipher_address2_Maybe

newtype Cipher_IdentityCipher_address3_Maybe =
    Cipher_IdentityCipher_address3_Maybe (Maybe String)

derive instance newtypeCipher_IdentityCipher_address3_Maybe :: Newtype Cipher_IdentityCipher_address3_Maybe _
instance encodeJsonCipher_IdentityCipher_address3_Maybe :: EncodeJson Cipher_IdentityCipher_address3_Maybe where
  encodeJson = genericEncodeAeson Argonaut.defaultOptions
instance decodeJsonCipher_IdentityCipher_address3_Maybe :: DecodeJson Cipher_IdentityCipher_address3_Maybe where
  decodeJson = genericDecodeAeson Argonaut.defaultOptions
derive instance genericCipher_IdentityCipher_address3_Maybe :: Generic Cipher_IdentityCipher_address3_Maybe _
derive instance eqCipher_IdentityCipher_address3_Maybe :: Eq Cipher_IdentityCipher_address3_Maybe
derive instance ordCipher_IdentityCipher_address3_Maybe :: Ord Cipher_IdentityCipher_address3_Maybe

newtype Cipher_IdentityCipher_city_Maybe =
    Cipher_IdentityCipher_city_Maybe (Maybe String)

derive instance newtypeCipher_IdentityCipher_city_Maybe :: Newtype Cipher_IdentityCipher_city_Maybe _
instance encodeJsonCipher_IdentityCipher_city_Maybe :: EncodeJson Cipher_IdentityCipher_city_Maybe where
  encodeJson = genericEncodeAeson Argonaut.defaultOptions
instance decodeJsonCipher_IdentityCipher_city_Maybe :: DecodeJson Cipher_IdentityCipher_city_Maybe where
  decodeJson = genericDecodeAeson Argonaut.defaultOptions
derive instance genericCipher_IdentityCipher_city_Maybe :: Generic Cipher_IdentityCipher_city_Maybe _
derive instance eqCipher_IdentityCipher_city_Maybe :: Eq Cipher_IdentityCipher_city_Maybe
derive instance ordCipher_IdentityCipher_city_Maybe :: Ord Cipher_IdentityCipher_city_Maybe

newtype Cipher_IdentityCipher_company_Maybe =
    Cipher_IdentityCipher_company_Maybe (Maybe String)

derive instance newtypeCipher_IdentityCipher_company_Maybe :: Newtype Cipher_IdentityCipher_company_Maybe _
instance encodeJsonCipher_IdentityCipher_company_Maybe :: EncodeJson Cipher_IdentityCipher_company_Maybe where
  encodeJson = genericEncodeAeson Argonaut.defaultOptions
instance decodeJsonCipher_IdentityCipher_company_Maybe :: DecodeJson Cipher_IdentityCipher_company_Maybe where
  decodeJson = genericDecodeAeson Argonaut.defaultOptions
derive instance genericCipher_IdentityCipher_company_Maybe :: Generic Cipher_IdentityCipher_company_Maybe _
derive instance eqCipher_IdentityCipher_company_Maybe :: Eq Cipher_IdentityCipher_company_Maybe
derive instance ordCipher_IdentityCipher_company_Maybe :: Ord Cipher_IdentityCipher_company_Maybe

newtype Cipher_IdentityCipher_country_Maybe =
    Cipher_IdentityCipher_country_Maybe (Maybe String)

derive instance newtypeCipher_IdentityCipher_country_Maybe :: Newtype Cipher_IdentityCipher_country_Maybe _
instance encodeJsonCipher_IdentityCipher_country_Maybe :: EncodeJson Cipher_IdentityCipher_country_Maybe where
  encodeJson = genericEncodeAeson Argonaut.defaultOptions
instance decodeJsonCipher_IdentityCipher_country_Maybe :: DecodeJson Cipher_IdentityCipher_country_Maybe where
  decodeJson = genericDecodeAeson Argonaut.defaultOptions
derive instance genericCipher_IdentityCipher_country_Maybe :: Generic Cipher_IdentityCipher_country_Maybe _
derive instance eqCipher_IdentityCipher_country_Maybe :: Eq Cipher_IdentityCipher_country_Maybe
derive instance ordCipher_IdentityCipher_country_Maybe :: Ord Cipher_IdentityCipher_country_Maybe

newtype Cipher_IdentityCipher_email_Maybe =
    Cipher_IdentityCipher_email_Maybe (Maybe String)

derive instance newtypeCipher_IdentityCipher_email_Maybe :: Newtype Cipher_IdentityCipher_email_Maybe _
instance encodeJsonCipher_IdentityCipher_email_Maybe :: EncodeJson Cipher_IdentityCipher_email_Maybe where
  encodeJson = genericEncodeAeson Argonaut.defaultOptions
instance decodeJsonCipher_IdentityCipher_email_Maybe :: DecodeJson Cipher_IdentityCipher_email_Maybe where
  decodeJson = genericDecodeAeson Argonaut.defaultOptions
derive instance genericCipher_IdentityCipher_email_Maybe :: Generic Cipher_IdentityCipher_email_Maybe _
derive instance eqCipher_IdentityCipher_email_Maybe :: Eq Cipher_IdentityCipher_email_Maybe
derive instance ordCipher_IdentityCipher_email_Maybe :: Ord Cipher_IdentityCipher_email_Maybe

newtype Cipher_IdentityCipher_firstName_Maybe =
    Cipher_IdentityCipher_firstName_Maybe (Maybe String)

derive instance newtypeCipher_IdentityCipher_firstName_Maybe :: Newtype Cipher_IdentityCipher_firstName_Maybe _
instance encodeJsonCipher_IdentityCipher_firstName_Maybe :: EncodeJson Cipher_IdentityCipher_firstName_Maybe where
  encodeJson = genericEncodeAeson Argonaut.defaultOptions
instance decodeJsonCipher_IdentityCipher_firstName_Maybe :: DecodeJson Cipher_IdentityCipher_firstName_Maybe where
  decodeJson = genericDecodeAeson Argonaut.defaultOptions
derive instance genericCipher_IdentityCipher_firstName_Maybe :: Generic Cipher_IdentityCipher_firstName_Maybe _
derive instance eqCipher_IdentityCipher_firstName_Maybe :: Eq Cipher_IdentityCipher_firstName_Maybe
derive instance ordCipher_IdentityCipher_firstName_Maybe :: Ord Cipher_IdentityCipher_firstName_Maybe

newtype Cipher_IdentityCipher_lastName_Maybe =
    Cipher_IdentityCipher_lastName_Maybe (Maybe String)

derive instance newtypeCipher_IdentityCipher_lastName_Maybe :: Newtype Cipher_IdentityCipher_lastName_Maybe _
instance encodeJsonCipher_IdentityCipher_lastName_Maybe :: EncodeJson Cipher_IdentityCipher_lastName_Maybe where
  encodeJson = genericEncodeAeson Argonaut.defaultOptions
instance decodeJsonCipher_IdentityCipher_lastName_Maybe :: DecodeJson Cipher_IdentityCipher_lastName_Maybe where
  decodeJson = genericDecodeAeson Argonaut.defaultOptions
derive instance genericCipher_IdentityCipher_lastName_Maybe :: Generic Cipher_IdentityCipher_lastName_Maybe _
derive instance eqCipher_IdentityCipher_lastName_Maybe :: Eq Cipher_IdentityCipher_lastName_Maybe
derive instance ordCipher_IdentityCipher_lastName_Maybe :: Ord Cipher_IdentityCipher_lastName_Maybe

newtype Cipher_IdentityCipher_licenseNumber_Maybe =
    Cipher_IdentityCipher_licenseNumber_Maybe (Maybe String)

derive instance newtypeCipher_IdentityCipher_licenseNumber_Maybe :: Newtype Cipher_IdentityCipher_licenseNumber_Maybe _
instance encodeJsonCipher_IdentityCipher_licenseNumber_Maybe :: EncodeJson Cipher_IdentityCipher_licenseNumber_Maybe where
  encodeJson = genericEncodeAeson Argonaut.defaultOptions
instance decodeJsonCipher_IdentityCipher_licenseNumber_Maybe :: DecodeJson Cipher_IdentityCipher_licenseNumber_Maybe where
  decodeJson = genericDecodeAeson Argonaut.defaultOptions
derive instance genericCipher_IdentityCipher_licenseNumber_Maybe :: Generic Cipher_IdentityCipher_licenseNumber_Maybe _
derive instance eqCipher_IdentityCipher_licenseNumber_Maybe :: Eq Cipher_IdentityCipher_licenseNumber_Maybe
derive instance ordCipher_IdentityCipher_licenseNumber_Maybe :: Ord Cipher_IdentityCipher_licenseNumber_Maybe

newtype Cipher_IdentityCipher_middleName_Maybe =
    Cipher_IdentityCipher_middleName_Maybe (Maybe String)

derive instance newtypeCipher_IdentityCipher_middleName_Maybe :: Newtype Cipher_IdentityCipher_middleName_Maybe _
instance encodeJsonCipher_IdentityCipher_middleName_Maybe :: EncodeJson Cipher_IdentityCipher_middleName_Maybe where
  encodeJson = genericEncodeAeson Argonaut.defaultOptions
instance decodeJsonCipher_IdentityCipher_middleName_Maybe :: DecodeJson Cipher_IdentityCipher_middleName_Maybe where
  decodeJson = genericDecodeAeson Argonaut.defaultOptions
derive instance genericCipher_IdentityCipher_middleName_Maybe :: Generic Cipher_IdentityCipher_middleName_Maybe _
derive instance eqCipher_IdentityCipher_middleName_Maybe :: Eq Cipher_IdentityCipher_middleName_Maybe
derive instance ordCipher_IdentityCipher_middleName_Maybe :: Ord Cipher_IdentityCipher_middleName_Maybe

newtype Cipher_IdentityCipher_passportNumber_Maybe =
    Cipher_IdentityCipher_passportNumber_Maybe (Maybe String)

derive instance newtypeCipher_IdentityCipher_passportNumber_Maybe :: Newtype Cipher_IdentityCipher_passportNumber_Maybe _
instance encodeJsonCipher_IdentityCipher_passportNumber_Maybe :: EncodeJson Cipher_IdentityCipher_passportNumber_Maybe where
  encodeJson = genericEncodeAeson Argonaut.defaultOptions
instance decodeJsonCipher_IdentityCipher_passportNumber_Maybe :: DecodeJson Cipher_IdentityCipher_passportNumber_Maybe where
  decodeJson = genericDecodeAeson Argonaut.defaultOptions
derive instance genericCipher_IdentityCipher_passportNumber_Maybe :: Generic Cipher_IdentityCipher_passportNumber_Maybe _
derive instance eqCipher_IdentityCipher_passportNumber_Maybe :: Eq Cipher_IdentityCipher_passportNumber_Maybe
derive instance ordCipher_IdentityCipher_passportNumber_Maybe :: Ord Cipher_IdentityCipher_passportNumber_Maybe

newtype Cipher_IdentityCipher_phone_Maybe =
    Cipher_IdentityCipher_phone_Maybe (Maybe String)

derive instance newtypeCipher_IdentityCipher_phone_Maybe :: Newtype Cipher_IdentityCipher_phone_Maybe _
instance encodeJsonCipher_IdentityCipher_phone_Maybe :: EncodeJson Cipher_IdentityCipher_phone_Maybe where
  encodeJson = genericEncodeAeson Argonaut.defaultOptions
instance decodeJsonCipher_IdentityCipher_phone_Maybe :: DecodeJson Cipher_IdentityCipher_phone_Maybe where
  decodeJson = genericDecodeAeson Argonaut.defaultOptions
derive instance genericCipher_IdentityCipher_phone_Maybe :: Generic Cipher_IdentityCipher_phone_Maybe _
derive instance eqCipher_IdentityCipher_phone_Maybe :: Eq Cipher_IdentityCipher_phone_Maybe
derive instance ordCipher_IdentityCipher_phone_Maybe :: Ord Cipher_IdentityCipher_phone_Maybe

newtype Cipher_IdentityCipher_postalCode_Maybe =
    Cipher_IdentityCipher_postalCode_Maybe (Maybe String)

derive instance newtypeCipher_IdentityCipher_postalCode_Maybe :: Newtype Cipher_IdentityCipher_postalCode_Maybe _
instance encodeJsonCipher_IdentityCipher_postalCode_Maybe :: EncodeJson Cipher_IdentityCipher_postalCode_Maybe where
  encodeJson = genericEncodeAeson Argonaut.defaultOptions
instance decodeJsonCipher_IdentityCipher_postalCode_Maybe :: DecodeJson Cipher_IdentityCipher_postalCode_Maybe where
  decodeJson = genericDecodeAeson Argonaut.defaultOptions
derive instance genericCipher_IdentityCipher_postalCode_Maybe :: Generic Cipher_IdentityCipher_postalCode_Maybe _
derive instance eqCipher_IdentityCipher_postalCode_Maybe :: Eq Cipher_IdentityCipher_postalCode_Maybe
derive instance ordCipher_IdentityCipher_postalCode_Maybe :: Ord Cipher_IdentityCipher_postalCode_Maybe

newtype Cipher_IdentityCipher_ssn_Maybe =
    Cipher_IdentityCipher_ssn_Maybe (Maybe String)

derive instance newtypeCipher_IdentityCipher_ssn_Maybe :: Newtype Cipher_IdentityCipher_ssn_Maybe _
instance encodeJsonCipher_IdentityCipher_ssn_Maybe :: EncodeJson Cipher_IdentityCipher_ssn_Maybe where
  encodeJson = genericEncodeAeson Argonaut.defaultOptions
instance decodeJsonCipher_IdentityCipher_ssn_Maybe :: DecodeJson Cipher_IdentityCipher_ssn_Maybe where
  decodeJson = genericDecodeAeson Argonaut.defaultOptions
derive instance genericCipher_IdentityCipher_ssn_Maybe :: Generic Cipher_IdentityCipher_ssn_Maybe _
derive instance eqCipher_IdentityCipher_ssn_Maybe :: Eq Cipher_IdentityCipher_ssn_Maybe
derive instance ordCipher_IdentityCipher_ssn_Maybe :: Ord Cipher_IdentityCipher_ssn_Maybe

newtype Cipher_IdentityCipher_state_Maybe =
    Cipher_IdentityCipher_state_Maybe (Maybe String)

derive instance newtypeCipher_IdentityCipher_state_Maybe :: Newtype Cipher_IdentityCipher_state_Maybe _
instance encodeJsonCipher_IdentityCipher_state_Maybe :: EncodeJson Cipher_IdentityCipher_state_Maybe where
  encodeJson = genericEncodeAeson Argonaut.defaultOptions
instance decodeJsonCipher_IdentityCipher_state_Maybe :: DecodeJson Cipher_IdentityCipher_state_Maybe where
  decodeJson = genericDecodeAeson Argonaut.defaultOptions
derive instance genericCipher_IdentityCipher_state_Maybe :: Generic Cipher_IdentityCipher_state_Maybe _
derive instance eqCipher_IdentityCipher_state_Maybe :: Eq Cipher_IdentityCipher_state_Maybe
derive instance ordCipher_IdentityCipher_state_Maybe :: Ord Cipher_IdentityCipher_state_Maybe

newtype Cipher_IdentityCipher_title_Maybe =
    Cipher_IdentityCipher_title_Maybe (Maybe String)

derive instance newtypeCipher_IdentityCipher_title_Maybe :: Newtype Cipher_IdentityCipher_title_Maybe _
instance encodeJsonCipher_IdentityCipher_title_Maybe :: EncodeJson Cipher_IdentityCipher_title_Maybe where
  encodeJson = genericEncodeAeson Argonaut.defaultOptions
instance decodeJsonCipher_IdentityCipher_title_Maybe :: DecodeJson Cipher_IdentityCipher_title_Maybe where
  decodeJson = genericDecodeAeson Argonaut.defaultOptions
derive instance genericCipher_IdentityCipher_title_Maybe :: Generic Cipher_IdentityCipher_title_Maybe _
derive instance eqCipher_IdentityCipher_title_Maybe :: Eq Cipher_IdentityCipher_title_Maybe
derive instance ordCipher_IdentityCipher_title_Maybe :: Ord Cipher_IdentityCipher_title_Maybe

newtype Cipher_IdentityCipher_username_Maybe =
    Cipher_IdentityCipher_username_Maybe (Maybe String)

derive instance newtypeCipher_IdentityCipher_username_Maybe :: Newtype Cipher_IdentityCipher_username_Maybe _
instance encodeJsonCipher_IdentityCipher_username_Maybe :: EncodeJson Cipher_IdentityCipher_username_Maybe where
  encodeJson = genericEncodeAeson Argonaut.defaultOptions
instance decodeJsonCipher_IdentityCipher_username_Maybe :: DecodeJson Cipher_IdentityCipher_username_Maybe where
  decodeJson = genericDecodeAeson Argonaut.defaultOptions
derive instance genericCipher_IdentityCipher_username_Maybe :: Generic Cipher_IdentityCipher_username_Maybe _
derive instance eqCipher_IdentityCipher_username_Maybe :: Eq Cipher_IdentityCipher_username_Maybe
derive instance ordCipher_IdentityCipher_username_Maybe :: Ord Cipher_IdentityCipher_username_Maybe

newtype Cipher_IdentityCipher =
    Cipher_IdentityCipher {
      address1 :: Cipher_IdentityCipher_address1_Maybe
    , address2 :: Cipher_IdentityCipher_address2_Maybe
    , address3 :: Cipher_IdentityCipher_address3_Maybe
    , city :: Cipher_IdentityCipher_city_Maybe
    , company :: Cipher_IdentityCipher_company_Maybe
    , country :: Cipher_IdentityCipher_country_Maybe
    , email :: Cipher_IdentityCipher_email_Maybe
    , firstName :: Cipher_IdentityCipher_firstName_Maybe
    , lastName :: Cipher_IdentityCipher_lastName_Maybe
    , licenseNumber :: Cipher_IdentityCipher_licenseNumber_Maybe
    , middleName :: Cipher_IdentityCipher_middleName_Maybe
    , passportNumber :: Cipher_IdentityCipher_passportNumber_Maybe
    , phone :: Cipher_IdentityCipher_phone_Maybe
    , postalCode :: Cipher_IdentityCipher_postalCode_Maybe
    , ssn :: Cipher_IdentityCipher_ssn_Maybe
    , state :: Cipher_IdentityCipher_state_Maybe
    , title :: Cipher_IdentityCipher_title_Maybe
    , username :: Cipher_IdentityCipher_username_Maybe
    }

derive instance newtypeCipher_IdentityCipher :: Newtype Cipher_IdentityCipher _
instance encodeJsonCipher_IdentityCipher :: EncodeJson Cipher_IdentityCipher where
  encodeJson = genericEncodeAeson Argonaut.defaultOptions
instance decodeJsonCipher_IdentityCipher :: DecodeJson Cipher_IdentityCipher where
  decodeJson = genericDecodeAeson Argonaut.defaultOptions
derive instance genericCipher_IdentityCipher :: Generic Cipher_IdentityCipher _
derive instance eqCipher_IdentityCipher :: Eq Cipher_IdentityCipher
derive instance ordCipher_IdentityCipher :: Ord Cipher_IdentityCipher

newtype Cipher_LoginCipher_password_Maybe =
    Cipher_LoginCipher_password_Maybe (Maybe String)

derive instance newtypeCipher_LoginCipher_password_Maybe :: Newtype Cipher_LoginCipher_password_Maybe _
instance encodeJsonCipher_LoginCipher_password_Maybe :: EncodeJson Cipher_LoginCipher_password_Maybe where
  encodeJson = genericEncodeAeson Argonaut.defaultOptions
instance decodeJsonCipher_LoginCipher_password_Maybe :: DecodeJson Cipher_LoginCipher_password_Maybe where
  decodeJson = genericDecodeAeson Argonaut.defaultOptions
derive instance genericCipher_LoginCipher_password_Maybe :: Generic Cipher_LoginCipher_password_Maybe _
derive instance eqCipher_LoginCipher_password_Maybe :: Eq Cipher_LoginCipher_password_Maybe
derive instance ordCipher_LoginCipher_password_Maybe :: Ord Cipher_LoginCipher_password_Maybe

newtype Cipher_LoginCipher_uris_List =
    Cipher_LoginCipher_uris_List (Array String)

derive instance newtypeCipher_LoginCipher_uris_List :: Newtype Cipher_LoginCipher_uris_List _
instance encodeJsonCipher_LoginCipher_uris_List :: EncodeJson Cipher_LoginCipher_uris_List where
  encodeJson = genericEncodeAeson Argonaut.defaultOptions
instance decodeJsonCipher_LoginCipher_uris_List :: DecodeJson Cipher_LoginCipher_uris_List where
  decodeJson = genericDecodeAeson Argonaut.defaultOptions
derive instance genericCipher_LoginCipher_uris_List :: Generic Cipher_LoginCipher_uris_List _
derive instance eqCipher_LoginCipher_uris_List :: Eq Cipher_LoginCipher_uris_List
derive instance ordCipher_LoginCipher_uris_List :: Ord Cipher_LoginCipher_uris_List

newtype Cipher_LoginCipher_username_Maybe =
    Cipher_LoginCipher_username_Maybe (Maybe String)

derive instance newtypeCipher_LoginCipher_username_Maybe :: Newtype Cipher_LoginCipher_username_Maybe _
instance encodeJsonCipher_LoginCipher_username_Maybe :: EncodeJson Cipher_LoginCipher_username_Maybe where
  encodeJson = genericEncodeAeson Argonaut.defaultOptions
instance decodeJsonCipher_LoginCipher_username_Maybe :: DecodeJson Cipher_LoginCipher_username_Maybe where
  decodeJson = genericDecodeAeson Argonaut.defaultOptions
derive instance genericCipher_LoginCipher_username_Maybe :: Generic Cipher_LoginCipher_username_Maybe _
derive instance eqCipher_LoginCipher_username_Maybe :: Eq Cipher_LoginCipher_username_Maybe
derive instance ordCipher_LoginCipher_username_Maybe :: Ord Cipher_LoginCipher_username_Maybe

newtype Cipher_LoginCipher =
    Cipher_LoginCipher {
      password :: Cipher_LoginCipher_password_Maybe
    , uris :: Cipher_LoginCipher_uris_List
    , username :: Cipher_LoginCipher_username_Maybe
    }

derive instance newtypeCipher_LoginCipher :: Newtype Cipher_LoginCipher _
instance encodeJsonCipher_LoginCipher :: EncodeJson Cipher_LoginCipher where
  encodeJson = genericEncodeAeson Argonaut.defaultOptions
instance decodeJsonCipher_LoginCipher :: DecodeJson Cipher_LoginCipher where
  decodeJson = genericDecodeAeson Argonaut.defaultOptions
derive instance genericCipher_LoginCipher :: Generic Cipher_LoginCipher _
derive instance eqCipher_LoginCipher :: Eq Cipher_LoginCipher
derive instance ordCipher_LoginCipher :: Ord Cipher_LoginCipher

data Cipher =
    CardCipher Cipher_CardCipher
  | IdentityCipher Cipher_IdentityCipher
  | LoginCipher Cipher_LoginCipher
  | NoteCipher String

instance encodeJsonCipher :: EncodeJson Cipher where
  encodeJson = genericEncodeAeson Argonaut.defaultOptions
instance decodeJsonCipher :: DecodeJson Cipher where
  decodeJson = genericDecodeAeson Argonaut.defaultOptions
derive instance genericCipher :: Generic Cipher _
derive instance eqCipher :: Eq Cipher
derive instance ordCipher :: Ord Cipher

data CipherType =
    CardType
  | IdentityType
  | LoginType
  | NoteType

instance encodeJsonCipherType :: EncodeJson CipherType where
  encodeJson = genericEncodeAeson Argonaut.defaultOptions
instance decodeJsonCipherType :: DecodeJson CipherType where
  decodeJson = genericDecodeAeson Argonaut.defaultOptions
derive instance genericCipherType :: Generic CipherType _
derive instance eqCipherType :: Eq CipherType
derive instance ordCipherType :: Ord CipherType

newtype Cmd_Login =
    Cmd_Login {
      email :: String
    , password :: String
    , server :: String
    }

derive instance newtypeCmd_Login :: Newtype Cmd_Login _
instance encodeJsonCmd_Login :: EncodeJson Cmd_Login where
  encodeJson = genericEncodeAeson Argonaut.defaultOptions
instance decodeJsonCmd_Login :: DecodeJson Cmd_Login where
  decodeJson = genericDecodeAeson Argonaut.defaultOptions
derive instance genericCmd_Login :: Generic Cmd_Login _
derive instance eqCmd_Login :: Eq Cmd_Login
derive instance ordCmd_Login :: Ord Cmd_Login

data Cmd =
    Copy String
  | Init
  | Login Cmd_Login
  | NeedCiphersList
  | NeedEmail
  | NeedsReset
  | Open String
  | RequestCipher String
  | SendMasterPassword String

instance encodeJsonCmd :: EncodeJson Cmd where
  encodeJson = genericEncodeAeson Argonaut.defaultOptions
instance decodeJsonCmd :: DecodeJson Cmd where
  decodeJson = genericDecodeAeson Argonaut.defaultOptions
derive instance genericCmd :: Generic Cmd _
derive instance eqCmd :: Eq Cmd
derive instance ordCmd :: Ord Cmd

newtype Sub_LoadCipher =
    Sub_LoadCipher {
      cipherType :: Cipher
    , id :: String
    , name :: String
    }

derive instance newtypeSub_LoadCipher :: Newtype Sub_LoadCipher _
instance encodeJsonSub_LoadCipher :: EncodeJson Sub_LoadCipher where
  encodeJson = genericEncodeAeson Argonaut.defaultOptions
instance decodeJsonSub_LoadCipher :: DecodeJson Sub_LoadCipher where
  decodeJson = genericDecodeAeson Argonaut.defaultOptions
derive instance genericSub_LoadCipher :: Generic Sub_LoadCipher _
derive instance eqSub_LoadCipher :: Eq Sub_LoadCipher
derive instance ordSub_LoadCipher :: Ord Sub_LoadCipher

newtype Sub_LoadCiphers =
    Sub_LoadCiphers {
      cipherType :: CipherType
    , date :: String
    , id :: String
    , name :: String
    }

derive instance newtypeSub_LoadCiphers :: Newtype Sub_LoadCiphers _
instance encodeJsonSub_LoadCiphers :: EncodeJson Sub_LoadCiphers where
  encodeJson = genericEncodeAeson Argonaut.defaultOptions
instance decodeJsonSub_LoadCiphers :: DecodeJson Sub_LoadCiphers where
  decodeJson = genericDecodeAeson Argonaut.defaultOptions
derive instance genericSub_LoadCiphers :: Generic Sub_LoadCiphers _
derive instance eqSub_LoadCiphers :: Eq Sub_LoadCiphers
derive instance ordSub_LoadCiphers :: Ord Sub_LoadCiphers

newtype Sub_LoadCiphers_List =
    Sub_LoadCiphers_List (Array Sub_LoadCiphers)

derive instance newtypeSub_LoadCiphers_List :: Newtype Sub_LoadCiphers_List _
instance encodeJsonSub_LoadCiphers_List :: EncodeJson Sub_LoadCiphers_List where
  encodeJson = genericEncodeAeson Argonaut.defaultOptions
instance decodeJsonSub_LoadCiphers_List :: DecodeJson Sub_LoadCiphers_List where
  decodeJson = genericDecodeAeson Argonaut.defaultOptions
derive instance genericSub_LoadCiphers_List :: Generic Sub_LoadCiphers_List _
derive instance eqSub_LoadCiphers_List :: Eq Sub_LoadCiphers_List
derive instance ordSub_LoadCiphers_List :: Ord Sub_LoadCiphers_List

newtype Sub_NeedsMasterPassword =
    Sub_NeedsMasterPassword {
      login :: String
    , server :: String
    }

derive instance newtypeSub_NeedsMasterPassword :: Newtype Sub_NeedsMasterPassword _
instance encodeJsonSub_NeedsMasterPassword :: EncodeJson Sub_NeedsMasterPassword where
  encodeJson = genericEncodeAeson Argonaut.defaultOptions
instance decodeJsonSub_NeedsMasterPassword :: DecodeJson Sub_NeedsMasterPassword where
  decodeJson = genericDecodeAeson Argonaut.defaultOptions
derive instance genericSub_NeedsMasterPassword :: Generic Sub_NeedsMasterPassword _
derive instance eqSub_NeedsMasterPassword :: Eq Sub_NeedsMasterPassword
derive instance ordSub_NeedsMasterPassword :: Ord Sub_NeedsMasterPassword

data Sub =
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

instance encodeJsonSub :: EncodeJson Sub where
  encodeJson = genericEncodeAeson Argonaut.defaultOptions
instance decodeJsonSub :: DecodeJson Sub where
  decodeJson = genericDecodeAeson Argonaut.defaultOptions
derive instance genericSub :: Generic Sub _
derive instance eqSub :: Eq Sub
derive instance ordSub :: Ord Sub

