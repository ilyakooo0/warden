module Logic.SecondFactor exposing (secondFactorName)

import Bridge


secondFactorName : Bridge.TwoFactorProviderType -> String
secondFactorName factor =
    case factor of
        Bridge.Authenticator ->
            "Authenticator"

        Bridge.Duo ->
            "Duo"

        Bridge.Email ->
            "Email"

        Bridge.OrganizationDuo ->
            "Organization Duo"

        Bridge.Remember ->
            "Remember (IDK what this is)"

        Bridge.U2f ->
            "U2f"

        Bridge.WebAuthn ->
            "WebAuthn"

        Bridge.Yubikey ->
            "Yubikey"
