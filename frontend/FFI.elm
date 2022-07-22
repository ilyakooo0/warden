port module FFI exposing (..)


port getString : (String -> msg) -> Sub msg
