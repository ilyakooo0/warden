{ name = "bw"
, dependencies =
  [ "aff"
  , "aff-promise"
  , "argonaut"
  , "argonaut-generic"
  , "console"
  , "effect"
  , "foreign"
  , "maybe"
  , "newtype"
  , "prelude"
  , "ell"
  ]
, packages = ../packages.dhall
, sources = [ "src/**/*.purs" ]
}
