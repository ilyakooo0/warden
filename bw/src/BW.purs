module BW where

import Prelude

import Control.Promise (Promise)
import Data.Argonaut.Core (Json)
import Data.Date (Date)
import Data.List (List)
import Data.Nullable (Nullable)
import Effect (Effect)

type PreloginResponse = {
  "Kdf" :: Int, -- seems to be always PBKDF2_SHA256
  "KdfIterations" :: Int
}

type PreloginRequest = {
  email :: String
}

type ProfileResponse = {
  "Id" :: String,
  "Name" :: String,
  "Email" :: String,
  "EmailVerified" :: Boolean,
  "MasterPasswordHint" :: String,
  "Premium" :: Boolean,
  "PremiumFromOrganization" :: Boolean,
  "Culture" :: String,
  "TwoFactorEnabled" :: Boolean,
  "Key" :: String,
  "PrivateKey" :: String,
  "SecurityStamp" :: String,
  "ForcePasswordReset" :: Boolean,
  "UsesKeyConnector" :: Boolean,
  "Organizations" :: List ProfileOrganizationResponse,
  "Providers" :: List ProfileProviderResponse,
  "ProviderOrganizations" :: List ProfileProviderOrganizationResponse
}

type ProfileOrganizationResponse = {
  "Id" :: String,
  "Name" :: String,
  "UsePolicies" :: Boolean,
  "UseGroups" :: Boolean,
  "UseDirectory" :: Boolean,
  "UseEvents" :: Boolean,
  "UseTotp" :: Boolean,
  "Use2fa" :: Boolean,
  "UseApi" :: Boolean,
  "UseSso" :: Boolean,
  "UseKeyConnector" :: Boolean,
  "UseResetPassword" :: Boolean,
  "SelfHost" :: Boolean,
  "UsersGetPremium" :: Boolean,
  "Seats" :: Int,
  "MaxCollections" :: Int,
  "MaxStorageGb" :: Int,
  "Key" :: String,
  "HasPublicAndPrivateKeys" :: Boolean,
  "Status" :: OrganizationUserStatusType,
  "Type" :: OrganizationUserType,
  "Enabled" :: Boolean,
  "SsoBound" :: Boolean,
  "Identifier" :: String,
  "permissions" :: PermissionsApi,
  "ResetPasswordEnrolled" :: Boolean,
  "UserId" :: String,
  "ProviderId" :: String,
  "ProviderName" :: String,
  "FamilySponsorshipFriendlyName" :: String,
  "FamilySponsorshipAvailable" :: Boolean,
  "PlanProductType" :: ProductType,
  "KeyConnectorEnabled" :: Boolean,
  "KeyConnectorUrl" :: String,
  "FamilySponsorshipLastSyncDate" :: Date,
  "FamilySponsorshipValidUntil" :: Date,
  "FamilySponsorshipToDelete" :: Boolean
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
  "AccessEventLogs" :: Boolean,
  "AccessImportExport" :: Boolean,
  "AccessReports" :: Boolean,
  "ManageAllCollections" :: Boolean,
  "ManageAssignedCollections" :: Boolean,
  "CreateNewCollections" :: Boolean,
  "EditAnyCollection" :: Boolean,
  "DeleteAnyCollection" :: Boolean,
  "EditAssignedCollections" :: Boolean,
  "DeleteAssignedCollections" :: Boolean,
  "ManageCiphers" :: Boolean,
  "ManageGroups" :: Boolean,
  "ManageSso" :: Boolean,
  "ManagePolicies" :: Boolean,
  "ManageUsers" :: Boolean,
  "ManageResetPassword" :: Boolean
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

type ProfileProviderOrganizationResponse = {}

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
