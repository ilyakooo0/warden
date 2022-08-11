module Data.EncString where

import Prelude
import BW.Types (EncryptedString)

foreign import data EncString :: Type

foreign import encryptionType :: EncString -> EncryptionType

encryptionTypeAesCbc256_B64 = 0 :: EncryptionType

encryptionTypeAesCbc128_HmacSha256_B64 = 1 :: EncryptionType

encryptionTypeAesCbc256_HmacSha256_B64 = 2 :: EncryptionType

encryptionTypeRsa2048_OaepSha256_B64 = 3 :: EncryptionType

encryptionTypeRsa2048_OaepSha1_B64 = 4 :: EncryptionType

encryptionTypeRsa2048_OaepSha256_HmacSha256_B64 = 5 :: EncryptionType

encryptionTypeRsa2048_OaepSha1_HmacSha256_B64 = 6 :: EncryptionType

type EncryptionType
  = Int

foreign import fromString :: EncryptedString -> EncString

foreign import toString :: EncString -> EncryptedString
