module Data.SymmetricCryptoKey where

import Prelude
import Data.ArrayBuffer.Types (ArrayBuffer)
import Data.Nullable (Nullable)

type SymmetricCryptoKey
  = { key :: ArrayBuffer
    , encKey :: Nullable ArrayBuffer
    , macKey :: Nullable ArrayBuffer
    , encType :: EncryptionType
    , keyB64 :: String
    , encKeyB64 :: String
    , macKeyB64 :: String
    }

encryptionTypeAesCbc256_B64 = 0 :: EncryptionType

encryptionTypeAesCbc128_HmacSha256_B64 = 1 :: EncryptionType

encryptionTypeAesCbc256_HmacSha256_B64 = 2 :: EncryptionType

encryptionTypeRsa2048_OaepSha256_B64 = 3 :: EncryptionType

encryptionTypeRsa2048_OaepSha1_B64 = 4 :: EncryptionType

encryptionTypeRsa2048_OaepSha256_HmacSha256_B64 = 5 :: EncryptionType

encryptionTypeRsa2048_OaepSha1_HmacSha256_B64 = 6 :: EncryptionType

type EncryptionType
  = Int

foreign import fromArrayBuffer :: ArrayBuffer -> SymmetricCryptoKey
