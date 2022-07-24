{ name = "bw"
, dependencies =
  [ "aff"
  , "effect"
  , "newtype"
  , "prelude"
  , "record"
  , "test-unit"
  , "transformers"
  , "unsafe-coerce"
  ]
, packages = ../packages.dhall
, sources = [ "src/**/*.purs", "test/**/*.purs" ]
}
