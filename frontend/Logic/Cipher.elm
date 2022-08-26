module Logic.Cipher exposing (normalizeCipher)

import Bridge


normalizeCipher : Bridge.Cipher -> Bridge.Cipher
normalizeCipher x =
    case x of
        Bridge.CardCipher c ->
            Bridge.CardCipher (normalizeCardCipher c)

        Bridge.IdentityCipher c ->
            Bridge.IdentityCipher (normalizeIdentityCipher c)

        Bridge.LoginCipher c ->
            Bridge.LoginCipher (normalizeLoginCipher c)

        Bridge.NoteCipher c ->
            Bridge.NoteCipher c


normalizeCardCipher : Bridge.Cipher_CardCipher -> Bridge.Cipher_CardCipher
normalizeCardCipher { brand, cardholderName, code, expMonth, expYear, number } =
    { brand = normalizeStringMaybe brand
    , cardholderName = normalizeStringMaybe cardholderName
    , code = normalizeStringMaybe code
    , expMonth = normalizeStringMaybe expMonth
    , expYear = normalizeStringMaybe expYear
    , number = normalizeStringMaybe number
    }


normalizeIdentityCipher : Bridge.Cipher_IdentityCipher -> Bridge.Cipher_IdentityCipher
normalizeIdentityCipher { address1, address2, address3, city, company, country, email, firstName, lastName, licenseNumber, middleName, passportNumber, phone, postalCode, ssn, state, title, username } =
    { address1 = normalizeStringMaybe address1
    , address2 = normalizeStringMaybe address2
    , address3 = normalizeStringMaybe address3
    , city = normalizeStringMaybe city
    , company = normalizeStringMaybe company
    , country = normalizeStringMaybe country
    , email = normalizeStringMaybe email
    , firstName = normalizeStringMaybe firstName
    , lastName = normalizeStringMaybe lastName
    , licenseNumber = normalizeStringMaybe licenseNumber
    , middleName = normalizeStringMaybe middleName
    , passportNumber = normalizeStringMaybe passportNumber
    , phone = normalizeStringMaybe phone
    , postalCode = normalizeStringMaybe postalCode
    , ssn = normalizeStringMaybe ssn
    , state = normalizeStringMaybe state
    , title = normalizeStringMaybe title
    , username = normalizeStringMaybe username
    }


normalizeLoginCipher : Bridge.Cipher_LoginCipher -> Bridge.Cipher_LoginCipher
normalizeLoginCipher { password, totp, uris, username } =
    { password = password
    , uris = uris |> List.map String.trim |> List.filter String.isEmpty
    , totp = normalizeStringMaybe totp
    , username = username
    }


normalizeStringMaybe : Maybe String -> Maybe String
normalizeStringMaybe =
    Maybe.andThen
        (\x ->
            let
                y =
                    String.trim x
            in
            if String.isEmpty y then
                Nothing

            else
                Just y
        )
