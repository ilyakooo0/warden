module BW.Types where

import Prelude
import Data.ArrayBuffer.Types (ArrayBuffer)
import Data.Date (Date)
import Data.Nullable (Nullable)
import Data.ShowableJson (ShowableJson)
import Data.Undefined.NoProblem (Opt)

newtype EncryptedString
  = EncryptedString String

derive newtype instance Show EncryptedString

kdfPBKDF2_SHA256 = 0 :: KDF

type KDF
  = Int

type PreloginResponse
  = { kdf :: KDF
    , kdfIterations :: Int
    }

type PreloginRequest
  = { email :: String
    }

type ProfileResponse
  = { id :: String
    , name :: String
    , email :: String
    , emailVerified :: Boolean
    , masterPasswordHint :: String
    , premiumPersonally :: Boolean
    , premiumFromOrganization :: Boolean
    , culture :: String
    , twoFactorEnabled :: Boolean
    , key :: EncryptedString
    , privateKey :: EncryptedString
    , securityStamp :: String
    , forcePasswordReset :: Boolean
    , usesKeyConnector :: Boolean
    , organizations :: Array ProfileOrganizationResponse
    , providers :: Array ProfileProviderResponse
    , providerOrganizations :: Array ProfileProviderOrganizationResponse
    }

type ProfileOrganizationResponse
  = { id :: String
    , name :: String
    , usePolicies :: Boolean
    , useGroups :: Boolean
    , useDirectory :: Boolean
    , useEvents :: Boolean
    , useTotp :: Boolean
    , use2fa :: Boolean
    , useApi :: Boolean
    , useSso :: Boolean
    , useKeyConnector :: Boolean
    , useResetPassword :: Boolean
    , selfHost :: Boolean
    , usersGetPremium :: Boolean
    , seats :: Int
    , maxCollections :: Int
    , maxStorageGb :: Nullable Int
    , key :: String
    , hasPublicAndPrivateKeys :: Boolean
    , status :: OrganizationUserStatusType
    , type :: OrganizationUserType
    , enabled :: Boolean
    , ssoBound :: Boolean
    , identifier :: String
    , permissions :: PermissionsApi
    , resetPasswordEnrolled :: Boolean
    , userId :: String
    , providerId :: String
    , providerName :: String
    , familySponsorshipFriendlyName :: String
    , familySponsorshipAvailable :: Boolean
    , planProductType :: ProductType
    , keyConnectorEnabled :: Boolean
    , keyConnectorUrl :: String
    , familySponsorshipLastSyncDate :: Nullable Date
    , familySponsorshipValidUntil :: Nullable Date
    , familySponsorshipToDelete :: Nullable Boolean
    }

organizationUserStatusTypeInvited = 0 :: OrganizationUserStatusType

organizationUserStatusTypeAccepted = 0 :: OrganizationUserStatusType

organizationUserStatusTypeConfirmed = 0 :: OrganizationUserStatusType

type OrganizationUserStatusType
  = Int

organizationUserTypeOwner = 0 :: OrganizationUserType

organizationUserTypeAdmin = 1 :: OrganizationUserType

organizationUserTypeUser = 2 :: OrganizationUserType

organizationUserTypeManager = 3 :: OrganizationUserType

organizationUserTypeCustom = 4 :: OrganizationUserType

type OrganizationUserType
  = Int

type PermissionsApi
  = { accessEventLogs :: Boolean
    , accessImportExport :: Boolean
    , accessReports :: Boolean
    , manageAllCollections :: Boolean
    , createNewCollections :: Boolean
    , editAnyCollection :: Boolean
    , deleteAnyCollection :: Boolean
    , manageAssignedCollections :: Boolean
    , editAssignedCollections :: Boolean
    , deleteAssignedCollections :: Boolean
    , manageCiphers :: Boolean
    , manageGroups :: Boolean
    , manageSso :: Boolean
    , managePolicies :: Boolean
    , manageUsers :: Boolean
    , manageResetPassword :: Boolean
    }

productTypeFree = 0 :: ProductType

productTypeFamilies = 1 :: ProductType

productTypeTeams = 2 :: ProductType

productTypeEnterprise = 3 :: ProductType

type ProductType
  = Int

type ProfileProviderResponse
  = { id :: String
    , name :: String
    , key :: String
    , status :: ProviderUserStatusType
    , type :: ProviderUserType
    , enabled :: Boolean
    , permissions :: PermissionsApi
    , userId :: String
    , useEvents :: Boolean
    }

providerUserStatusTypeInvited = 0 :: ProviderUserStatusType

providerUserStatusTypeAccepted = 1 :: ProviderUserStatusType

providerUserStatusTypeConfirmed = 2 :: ProviderUserStatusType

type ProviderUserStatusType
  = Int

providerUserTypeProviderAdmin = 0 :: ProviderUserType

providerUserTypeServiceUser = 1 :: ProviderUserType

type ProviderUserType
  = Int

type ProfileProviderOrganizationResponse
  = { id :: String
    , name :: String
    , usePolicies :: Boolean
    , useGroups :: Boolean
    , useDirectory :: Boolean
    , useEvents :: Boolean
    , useTotp :: Boolean
    , use2fa :: Boolean
    , useApi :: Boolean
    , useSso :: Boolean
    , useKeyConnector :: Boolean
    , useResetPassword :: Boolean
    , selfHost :: Boolean
    , usersGetPremium :: Boolean
    , seats :: Int
    , maxCollections :: Int
    , maxStorageGb :: Nullable Int
    , key :: String
    , hasPublicAndPrivateKeys :: Boolean
    , status :: OrganizationUserStatusType
    , type :: OrganizationUserType
    , enabled :: Boolean
    , ssoBound :: Boolean
    , identifier :: String
    , permissions :: PermissionsApi
    , resetPasswordEnrolled :: Boolean
    , userId :: String
    , providerId :: String
    , providerName :: String
    , familySponsorshipFriendlyName :: String
    , familySponsorshipAvailable :: Boolean
    , planProductType :: ProductType
    , keyConnectorEnabled :: Boolean
    , keyConnectorUrl :: String
    , familySponsorshipLastSyncDate :: Nullable Date
    , familySponsorshipValidUntil :: Nullable Date
    , familySponsorshipToDelete :: Nullable Boolean
    }

type Urls
  = { base :: Nullable String
    , webVault :: Nullable String
    , api :: Nullable String
    , identity :: Nullable String
    , icons :: Nullable String
    , notifications :: Nullable String
    , events :: Nullable String
    , keyConnector :: Nullable String
    }

type PasswordTokenRequest
  = { email :: Email
    , masterPasswordHash :: String
    , captchaResponse :: String
    , twoFactor :: TokenRequestTwoFactor
    , device :: DeviceRequest
    }

type DeviceRequest
  = { type :: DeviceType
    , name :: String
    , identifier :: String
    , pushToken :: Nullable String
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

type DeviceType
  = Int

type TokenRequestTwoFactor
  = { provider :: TwoFactorProviderType
    , token :: String
    , remember :: Boolean
    }

twoFactorProviderTypeAuthenticator = 0 :: TwoFactorProviderType

twoFactorProviderTypeEmail = 1 :: TwoFactorProviderType

twoFactorProviderTypeDuo = 2 :: TwoFactorProviderType

twoFactorProviderTypeYubikey = 3 :: TwoFactorProviderType

twoFactorProviderTypeU2f = 4 :: TwoFactorProviderType

twoFactorProviderTypeRemember = 5 :: TwoFactorProviderType

twoFactorProviderTypeOrganizationDuo = 6 :: TwoFactorProviderType

twoFactorProviderTypeWebAuthn = 7 :: TwoFactorProviderType

type TwoFactorProviderType
  = Int

newtype Password
  = Password String

hashPurposeServerAuthorization = 1 :: HashPurpose

hashPurposeLocalAuthorization = 2 :: HashPurpose

type HashPurpose
  = Int

newtype Hash
  = Hash String

newtype AccessToken
  = AccessToken String

derive newtype instance Show AccessToken

newtype RefreshToken
  = RefreshToken String

derive newtype instance Show RefreshToken


type IdentityTokenResponse
  = { accessToken :: AccessToken
    , expiresIn :: Int
    , refreshToken :: RefreshToken
    , tokenType :: String
    , resetMasterPassword :: Boolean
    , privateKey :: EncryptedString
    , key :: EncryptedString
    , twoFactorToken :: Nullable String
    , kdf :: KDF
    , kdfIterations :: Int
    , forcePasswordReset :: Nullable Boolean
    , apiUseKeyConnector :: Nullable Boolean
    , keyConnectorUrl :: Nullable String
    }

newtype Email
  = Email String

type SyncResponse
  = { profile :: ProfileResponse
    , folders :: Array FolderResponse
    , collections :: Array CollectionDetailsResponse
    , ciphers :: Array CipherResponse
    , domains :: Nullable DomainsResponse
    , policies :: Nullable (Array PolicyResponse)
    , sends :: Array SendResponse
    }

type FolderResponse
  = { id :: String
    , name :: String
    , revisionDate :: String
    }

type CollectionDetailsResponse
  = { id :: String
    , organizationId :: Nullable String
    , name :: String
    , externalId :: Nullable String
    , readOnly :: Boolean
    }

type CipherResponse
  = { id :: String
    , organizationId :: Nullable String
    , folderId :: Nullable String
    , type :: CipherType
    , name :: EncryptedString
    , notes :: Nullable EncryptedString
    , fields :: Nullable (Array FieldApi)
    , login :: Nullable LoginApi
    , card :: Nullable CardApi
    , identity :: Nullable IdentityApi
    , secureNote :: Nullable SecureNoteApi
    , favorite :: Boolean
    , edit :: Boolean
    , viewPassword :: Boolean
    , organizationUseTotp :: Boolean
    , revisionDate :: String
    , attachments :: Nullable (Array AttachmentResponse)
    , passwordHistory :: Nullable (Array PasswordHistoryResponse)
    , collectionIds :: Nullable (Array String)
    , deletedDate :: Nullable String
    , reprompt :: CipherRepromptType
    }

cipherTypeLogin = 1 :: CipherType

cipherTypeSecureNote = 2 :: CipherType

cipherTypeCard = 3 :: CipherType

cipherTypeIdentity = 4 :: CipherType

type CipherType
  = Int

type FieldApi
  = { name :: String
    , value :: String
    , type :: FieldType
    , linkedId :: Nullable LinkedIdType
    }

fieldTypeText = 0 :: FieldType

fieldTypeHidden = 1 :: FieldType

fieldTypeBoolean = 2 :: FieldType

fieldTypeLinked = 3 :: FieldType

type FieldType
  = Int

linkedIdTypeLoginLinkedIdUsername = 100 :: LinkedIdType

linkedIdTypeLoginLinkedIdPassword = 101 :: LinkedIdType

linkedIdTypeCardLinkedIdCardholderName = 300 :: LinkedIdType

linkedIdTypeCardLinkedIdExpMonth = 301 :: LinkedIdType

linkedIdTypeCardLinkedIdExpYear = 302 :: LinkedIdType

linkedIdTypeCardLinkedIdCode = 303 :: LinkedIdType

linkedIdTypeCardLinkedIdBrand = 304 :: LinkedIdType

linkedIdTypeCardLinkedIdNumber = 305 :: LinkedIdType

linkedIdTypeIdentityLinkedIdTitle = 400 :: LinkedIdType

linkedIdTypeIdentityLinkedIdMiddleName = 401 :: LinkedIdType

linkedIdTypeIdentityLinkedIdAddress1 = 402 :: LinkedIdType

linkedIdTypeIdentityLinkedIdAddress2 = 403 :: LinkedIdType

linkedIdTypeIdentityLinkedIdAddress3 = 404 :: LinkedIdType

linkedIdTypeIdentityLinkedIdCity = 405 :: LinkedIdType

linkedIdTypeIdentityLinkedIdState = 406 :: LinkedIdType

linkedIdTypeIdentityLinkedIdPostalCode = 407 :: LinkedIdType

linkedIdTypeIdentityLinkedIdCountry = 408 :: LinkedIdType

linkedIdTypeIdentityLinkedIdCompany = 409 :: LinkedIdType

linkedIdTypeIdentityLinkedIdEmail = 410 :: LinkedIdType

linkedIdTypeIdentityLinkedIdPhone = 411 :: LinkedIdType

linkedIdTypeIdentityLinkedIdSsn = 412 :: LinkedIdType

linkedIdTypeIdentityLinkedIdUsername = 413 :: LinkedIdType

linkedIdTypeIdentityLinkedIdPassportNumber = 414 :: LinkedIdType

linkedIdTypeIdentityLinkedIdLicenseNumber = 415 :: LinkedIdType

linkedIdTypeIdentityLinkedIdFirstName = 416 :: LinkedIdType

linkedIdTypeIdentityLinkedIdLastName = 417 :: LinkedIdType

linkedIdTypeIdentityLinkedIdFullName = 418 :: LinkedIdType

type LinkedIdType
  = Int

type LoginApi
  = { uris :: Opt (Array LoginUriApi)
    , username :: Nullable EncryptedString
    , password :: Nullable EncryptedString
    , passwordRevisionDate :: Nullable String
    , totp :: Nullable EncryptedString
    -- This thing is undefined in some cases for some reson. Just ignoring it
    , autofillOnPageLoad :: Opt (Nullable Boolean)
    }

type LoginUriApi
  = { uri :: String
    , match :: Nullable UriMatchType
    }

uriMatchTypeDomain = 0 :: UriMatchType

uriMatchTypeHost = 1 :: UriMatchType

uriMatchTypeStartsWith = 2 :: UriMatchType

uriMatchTypeExact = 3 :: UriMatchType

uriMatchTypeRegularExpression = 4 :: UriMatchType

uriMatchTypeNever = 5 :: UriMatchType

type UriMatchType
  = Int

type CardApi
  = { cardholderName :: Nullable String
    , brand :: Nullable String
    , number :: Nullable String
    , expMonth :: Nullable String
    , expYear :: Nullable String
    , code :: Nullable String
    }

type IdentityApi
  = { title :: String
    , firstName :: String
    , middleName :: String
    , lastName :: String
    , address1 :: String
    , address2 :: String
    , address3 :: String
    , city :: String
    , state :: String
    , postalCode :: String
    , country :: String
    , company :: String
    , email :: String
    , phone :: String
    , ssn :: String
    , username :: String
    , passportNumber :: String
    , licenseNumber :: String
    }

secureNoteApiGeneric = 0 :: SecureNoteApi

type SecureNoteApi
  = Int

type AttachmentResponse
  = { id :: String
    , url :: String
    , fileName :: String
    , key :: String
    , size :: String
    , sizeName :: String
    }

type PasswordHistoryResponse
  = { password :: String
    , lastUsedDate :: String
    }

cipherRepromptTypeNone = 0 :: CipherRepromptType

cipherRepromptTypePassword = 1 :: CipherRepromptType

type CipherRepromptType
  = Int

type DomainsResponse
  = { equivalentDomains :: Array (Array String)
    , globalEquivalentDomains :: Array GlobalDomainResponse
    }

type GlobalDomainResponse
  = { type :: Int
    , domains :: Array String
    , excluded :: Boolean
    }

type PolicyResponse
  = { id :: String
    , organizationId :: Nullable String
    , type :: PolicyType
    , data :: ShowableJson
    , enabled :: Boolean
    }

policyTypeTwoFactorAuthentication = 0 :: PolicyType -- Requires users to have 2fa enabled

policyTypeMasterPassword = 1 :: PolicyType -- Sets minimum requirements for master password complexity

policyTypePasswordGenerator = 2 :: PolicyType -- Sets minimum requirements/default type for generated passwords/passphrases

policyTypeSingleOrg = 3 :: PolicyType -- Allows users to only be apart of one organization

policyTypeRequireSso = 4 :: PolicyType -- Requires users to authenticate with SSO

policyTypePersonalOwnership = 5 :: PolicyType -- Disables personal vault ownership for adding/cloning items

policyTypeDisableSend = 6 :: PolicyType -- Disables the ability to create and edit Bitwarden Sends

policyTypeSendOptions = 7 :: PolicyType -- Sets restrictions or defaults for Bitwarden Sends

policyTypeResetPassword = 8 :: PolicyType -- Allows orgs to use reset password : also can enable auto-enrollment during invite flow

policyTypeMaximumVaultTimeout = 9 :: PolicyType -- Sets the maximum allowed vault timeout

policyTypeDisablePersonalVaultExport = 10 :: PolicyType -- Disable personal vault export

type PolicyType
  = Int

type SendResponse
  = { id :: String
    , accessId :: String
    , type :: SendType
    , name :: String
    , notes :: Nullable String
    , file :: Nullable SendFileApi
    , text :: Nullable SendTextApi
    , key :: String
    , maxAccessCount :: Nullable Int
    , accessCount :: Int
    , revisionDate :: String
    , expirationDate :: String
    , deletionDate :: Nullable String
    , password :: String
    , disable :: Boolean
    , hideEmail :: Boolean
    }

sendTypeText = 0 :: SendType

sendTypeFile = 1 :: SendType

type SendType
  = Int

type SendFileApi
  = { id :: String
    , fileName :: String
    , size :: String
    , sizeName :: String
    }

type SendTextApi
  = { text :: String
    , hidden :: Boolean
    }
