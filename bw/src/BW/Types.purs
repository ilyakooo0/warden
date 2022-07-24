module BW.Types where

import Prelude

import Data.ArrayBuffer.Types (ArrayBuffer)
import Data.Date (Date)
import Data.List (List)
import Data.Nullable (Nullable)

kdfPBKDF2_SHA256 = 0 :: KDF
type KDF = Int

type PreloginResponse = {
  kdf :: KDF,
  kdfIterations :: Int
}

type PreloginRequest = {
  email :: String
}

type ProfileResponse = {
  id :: String,
  name :: String,
  email :: String,
  emailVerified :: Boolean,
  masterPasswordHint :: String,
  premiumPersonally :: Boolean,
  premiumFromOrganization :: Boolean,
  culture :: String,
  twoFactorEnabled :: Boolean,
  key :: String,
  privateKey :: String,
  securityStamp :: String,
  forcePasswordReset :: Boolean,
  usesKeyConnector :: Boolean,
  organizations :: List ProfileOrganizationResponse,
  providers :: List ProfileProviderResponse,
  providerOrganizations :: List ProfileProviderOrganizationResponse
}

type ProfileOrganizationResponse = {
  id :: String,
  name :: String,
  usePolicies :: Boolean,
  useGroups :: Boolean,
  useDirectory :: Boolean,
  useEvents :: Boolean,
  useTotp :: Boolean,
  use2fa :: Boolean,
  useApi :: Boolean,
  useSso :: Boolean,
  useKeyConnector :: Boolean,
  useResetPassword :: Boolean,
  selfHost :: Boolean,
  usersGetPremium :: Boolean,
  seats :: Int,
  maxCollections :: Int,
  maxStorageGb :: Nullable Int,
  key :: String,
  hasPublicAndPrivateKeys :: Boolean,
  status :: OrganizationUserStatusType,
  type :: OrganizationUserType,
  enabled :: Boolean,
  ssoBound :: Boolean,
  identifier :: String,
  permissions :: PermissionsApi,
  resetPasswordEnrolled :: Boolean,
  userId :: String,
  providerId :: String,
  providerName :: String,
  familySponsorshipFriendlyName :: String,
  familySponsorshipAvailable :: Boolean,
  planProductType :: ProductType,
  keyConnectorEnabled :: Boolean,
  keyConnectorUrl :: String,
  familySponsorshipLastSyncDate :: Nullable Date,
  familySponsorshipValidUntil :: Nullable Date,
  familySponsorshipToDelete :: Nullable Boolean
  }

organizationUserStatusTypeInvited = 0 :: OrganizationUserStatusType
organizationUserStatusTypeAccepted = 0 :: OrganizationUserStatusType
organizationUserStatusTypeConfirmed = 0 :: OrganizationUserStatusType
type OrganizationUserStatusType = Int

organizationUserTypeOwner = 0 :: OrganizationUserType
organizationUserTypeAdmin = 1 :: OrganizationUserType
organizationUserTypeUser = 2 :: OrganizationUserType
organizationUserTypeManager = 3 :: OrganizationUserType
organizationUserTypeCustom = 4 :: OrganizationUserType
type OrganizationUserType = Int

type PermissionsApi = {
  accessEventLogs :: Boolean,
  accessImportExport :: Boolean,
  accessReports :: Boolean,
  manageAllCollections :: Boolean,
  createNewCollections :: Boolean,
  editAnyCollection :: Boolean,
  deleteAnyCollection :: Boolean,
  manageAssignedCollections :: Boolean,
  editAssignedCollections :: Boolean,
  deleteAssignedCollections :: Boolean,
  manageCiphers :: Boolean,
  manageGroups :: Boolean,
  manageSso :: Boolean,
  managePolicies :: Boolean,
  manageUsers :: Boolean,
  manageResetPassword :: Boolean
}

productTypeFree = 0 :: ProductType
productTypeFamilies = 1 :: ProductType
productTypeTeams = 2 :: ProductType
productTypeEnterprise = 3 :: ProductType
type ProductType = Int

type ProfileProviderResponse = {
  id :: String,
  name :: String,
  key :: String,
  status :: ProviderUserStatusType,
  type :: ProviderUserType,
  enabled :: Boolean,
  permissions :: PermissionsApi,
  userId :: String,
  useEvents :: Boolean
}

providerUserStatusTypeInvited = 0 :: ProviderUserStatusType
providerUserStatusTypeAccepted = 1 :: ProviderUserStatusType
providerUserStatusTypeConfirmed = 2 :: ProviderUserStatusType
type ProviderUserStatusType = Int

providerUserTypeProviderAdmin = 0 :: ProviderUserType
providerUserTypeServiceUser = 1 :: ProviderUserType
type ProviderUserType = Int

type ProfileProviderOrganizationResponse = {
  id :: String,
  name :: String,
  usePolicies :: Boolean,
  useGroups :: Boolean,
  useDirectory :: Boolean,
  useEvents :: Boolean,
  useTotp :: Boolean,
  use2fa :: Boolean,
  useApi :: Boolean,
  useSso :: Boolean,
  useKeyConnector :: Boolean,
  useResetPassword :: Boolean,
  selfHost :: Boolean,
  usersGetPremium :: Boolean,
  seats :: Int,
  maxCollections :: Int,
  maxStorageGb :: Nullable Int,
  key :: String,
  hasPublicAndPrivateKeys :: Boolean,
  status :: OrganizationUserStatusType,
  type :: OrganizationUserType,
  enabled :: Boolean,
  ssoBound :: Boolean,
  identifier :: String,
  permissions :: PermissionsApi,
  resetPasswordEnrolled :: Boolean,
  userId :: String,
  providerId :: String,
  providerName :: String,
  familySponsorshipFriendlyName :: String,
  familySponsorshipAvailable :: Boolean,
  planProductType :: ProductType,
  keyConnectorEnabled :: Boolean,
  keyConnectorUrl :: String,
  familySponsorshipLastSyncDate :: Nullable Date,
  familySponsorshipValidUntil :: Nullable Date,
  familySponsorshipToDelete :: Nullable Boolean
}

type Urls = {
  base :: Nullable String,
  webVault :: Nullable String,
  api :: Nullable String,
  identity :: Nullable String,
  icons :: Nullable String,
  notifications :: Nullable String,
  events :: Nullable String,
  keyConnector :: Nullable String
}

type PasswordTokenRequest = {
  email :: Email,
  masterPasswordHash :: String,
  captchaResponse :: String,
  twoFactor :: TokenRequestTwoFactor,
  device :: DeviceRequest
}

type DeviceRequest = {
  type :: DeviceType,
  name :: String,
  identifier :: String,
  pushToken :: Nullable String
}

deviceTypeAndroid = 0 :: DeviceType
deviceTypeiOS = 1 :: DeviceType
deviceTypeChromeExtension = 2 :: DeviceType
deviceTypeFirefoxExtension = 3 :: DeviceType
deviceTypeOperaExtension = 4 :: DeviceType
deviceTypeEdgeExtension = 5 :: DeviceType
deviceTypeWindowsDesktop = 6 :: DeviceType
deviceTypeMacOsDesktop = 7 :: DeviceType
deviceTypeLinuxDesktop = 8 :: DeviceType
deviceTypeChromeBrowser = 9 :: DeviceType
deviceTypeFirefoxBrowser = 10 :: DeviceType
deviceTypeOperaBrowser = 11 :: DeviceType
deviceTypeEdgeBrowser = 12 :: DeviceType
deviceTypeIEBrowser = 13 :: DeviceType
deviceTypeUnknownBrowser = 14 :: DeviceType
deviceTypeAndroidAmazon = 15 :: DeviceType
deviceTypeUWP = 16 :: DeviceType
deviceTypeSafariBrowser = 17 :: DeviceType
deviceTypeVivaldiBrowser = 18 :: DeviceType
deviceTypeVivaldiExtension = 19 :: DeviceType
deviceTypeSafariExtension = 20 :: DeviceType
type DeviceType = Int

type TokenRequestTwoFactor = {
  provider :: TwoFactorProviderType,
  token :: String,
  remember :: Boolean
}

twoFactorProviderTypeAuthenticator = 0 :: TwoFactorProviderType
twoFactorProviderTypeEmail = 1 :: TwoFactorProviderType
twoFactorProviderTypeDuo = 2 :: TwoFactorProviderType
twoFactorProviderTypeYubikey = 3 :: TwoFactorProviderType
twoFactorProviderTypeU2f = 4 :: TwoFactorProviderType
twoFactorProviderTypeRemember = 5 :: TwoFactorProviderType
twoFactorProviderTypeOrganizationDuo = 6 :: TwoFactorProviderType
twoFactorProviderTypeWebAuthn = 7 :: TwoFactorProviderType
type TwoFactorProviderType = Int


type SymmetricCryptoKey = {
  key :: ArrayBuffer,
  encKey :: Nullable ArrayBuffer,
  macKey :: Nullable ArrayBuffer,
  encType :: EncryptionType,
  keyB64 :: String,
  encKeyB64 :: String,
  macKeyB64 :: String
}

encryptionTypeAesCbc256_B64 = 0 :: EncryptionType
encryptionTypeAesCbc128_HmacSha256_B64 = 1 :: EncryptionType
encryptionTypeAesCbc256_HmacSha256_B64 = 2 :: EncryptionType
encryptionTypeRsa2048_OaepSha256_B64 = 3 :: EncryptionType
encryptionTypeRsa2048_OaepSha1_B64 = 4 :: EncryptionType
encryptionTypeRsa2048_OaepSha256_HmacSha256_B64 = 5 :: EncryptionType
encryptionTypeRsa2048_OaepSha1_HmacSha256_B64 = 6 :: EncryptionType
type EncryptionType = Int

newtype Password = Password String

hashPurposeServerAuthorization = 1 :: HashPurpose
hashPurposeLocalAuthorization = 2 :: HashPurpose
type HashPurpose = Int

newtype Hash = Hash String

type IdentityTokenResponse = {
  accessToken :: String,
  expiresIn :: Int,
  refreshToken :: String,
  tokenType :: String,
  resetMasterPassword :: Boolean,
  privateKey :: String,
  key :: String,
  twoFactorToken :: Nullable String,
  kdf :: KDF,
  kdfIterations :: Int,
  forcePasswordReset :: Nullable Boolean,
  apiUseKeyConnector :: Nullable Boolean,
  keyConnectorUrl :: Nullable String
}

newtype Email = Email String
