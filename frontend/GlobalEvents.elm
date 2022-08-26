module GlobalEvents exposing (..)

import Bridge


type Event
    = UpdateCipher Bridge.FullCipher
    | GeneratedPassword String
    | DecodedTotp Bridge.Sub_Totp
