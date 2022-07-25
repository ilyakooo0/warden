{ name = "bw"
, dependencies =
  [ "aff"
  , "aff-promise"
  , "argonaut"
  , "argonaut-generic"
  , "arraybuffer-types"
  , "console"
  , "effect"
  , "el"
  , "foreign"
  , "maybe"
  , "newtype"
  , "prelude"
  , "undefined-is-not-a-problem"
  ]
, packages = ../packages.dhall
, sources = [ "src/**/*.purs" ]
}
