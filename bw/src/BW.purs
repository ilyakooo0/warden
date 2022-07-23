module BW where

import Prelude

import Control.Promise (Promise)
import Data.Date (Date)
import Data.List (List)
import Data.Nullable (Nullable)
import Effect (Effect)

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

type ApiService = {
  postPrelogin :: PreloginRequest -> Promise PreloginResponse,
  getProfile :: Unit -> Promise ProfileResponse
}

foreign import getAPI :: Urls -> Effect ApiService
