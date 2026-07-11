module BW where

import BW.Types
import Bridge
import Prelude

import Bridge as Bridge
import Control.Promise (Promise)
import Data.Argonaut (class DecodeJson, class EncodeJson, decodeJson, encodeJson)
import Data.ArrayBuffer.Typed as AB
import Data.ArrayBuffer.Types (ArrayBuffer, ArrayView, Int32)
import Data.EncString (EncString)
import Data.Function.Uncurried (Fn2, Fn3, Fn4)
import Data.JNullable (JNullable)
import Data.SymmetricCryptoKey (SymmetricCryptoKey)
import Effect (Effect)
import Effect.Unsafe (unsafePerformEffect)
import Untagged.Union (type (|+|))

type TotpService =
  { getCode :: String -> Promise String
  , getTimeInterval :: String -> Int
  }

type CryptoService =
  { makeKey :: Fn4 Password String KDF KdfConfig (Promise SymmetricCryptoKey)
  , hashPassword :: Fn3 Password SymmetricCryptoKey (JNullable HashPurpose) (Promise StringHash)
  , decryptToUtf8 :: Fn2 EncString SymmetricCryptoKey (Promise String)
  , decryptToBytes :: Fn2 EncString SymmetricCryptoKey (Promise ArrayBuffer)
  , encrypt :: Fn2 String SymmetricCryptoKey (Promise EncString)
  , stretchKey :: SymmetricCryptoKey -> Promise SymmetricCryptoKey
  }

type ApiService =
  { postPrelogin :: PreloginRequest -> Promise PreloginResponse
  , getProfile :: Unit -> Promise ProfileResponse
  -- TODO: There can really be more request and response types. Maybe handle this later.
  , postIdentityToken :: PasswordTokenRequest -> Promise (IdentityCaptchaResponse |+| IdentityTwoFactorResponse |+| IdentityTokenResponse)
  , getSync :: Unit -> Promise SyncResponse
  , postCipherCreate :: CipherResponse -> Promise CipherResponse
  , putCipher :: CipherResponse -> Promise CipherResponse
  , deleteCipher :: String -> Promise Unit
  , postTwoFactorEmail :: TwoFactorEmailRequest -> Promise Unit
  }

type PasswordGeneration =
  { generatePassword :: Bridge.PasswordGeneratorConfig -> Promise String
  }

cryptoFunctionsTypeSha1 = "sha1" :: CryptoFunctionsType

cryptoFunctionsTypeSha256 = "sha256" :: CryptoFunctionsType

cryptoFunctionsTypeSha512 = "sha512" :: CryptoFunctionsType

cryptoFunctionsTypeMd5 = "md5" :: CryptoFunctionsType

type CryptoFunctionsType = String

type CryptoFunctions =
  { hash :: Fn2 String CryptoFunctionsType (Promise Hash)
  }

newtype Hash = Hash (ArrayBuffer)

hashToArray :: Hash -> Array Int
hashToArray (Hash buf) =
  unsafePerformEffect do
    av :: ArrayView Int32 <- AB.whole buf
    AB.toArray av

arrayToHash :: Array Int -> Hash
arrayToHash arr =
  unsafePerformEffect do
    av :: ArrayView Int32 <- AB.fromArray arr
    pure $ Hash $ AB.buffer av

instance Eq Hash where
  eq a b = eq (hashToArray a) (hashToArray b)

instance EncodeJson Hash where
  encodeJson = hashToArray >>> encodeJson

instance DecodeJson Hash where
  decodeJson = decodeJson >>> map arrayToHash

type Services =
  { crypto :: CryptoService
  , getApi :: Urls -> JNullable IdentityTokenResponse -> Promise ApiService
  , cryptoFunctions :: CryptoFunctions
  , passwordGeneration :: PasswordGeneration
  , totpService :: TotpService
  }

foreign import getServices :: Effect Services
