module Storage where

import Prelude

import BW (Hash(..))
import BW.Types (IdentityTokenResponse, SyncResponse, PreloginResponse)
import Localstorage (class StorageKey)

data SyncKey
  = SyncKey

instance StorageKey SyncKey SyncResponse where
  storageKey SyncKey = "sync"

data TokenKey
  = TokenKey

instance StorageKey TokenKey IdentityTokenResponse where
  storageKey TokenKey = "token"

data UrlsKey
  = UrlsKey

instance StorageKey UrlsKey String where
  storageKey UrlsKey = "urls"

data PreloginResponseKey
  = PreloginResponseKey

instance StorageKey PreloginResponseKey PreloginResponse where
  storageKey PreloginResponseKey = "prelogin-reponse"

data MasterPasswordHashKey
  = MasterPasswordHashKey

instance StorageKey MasterPasswordHashKey Hash where
  storageKey MasterPasswordHashKey = "master-password-hash"
