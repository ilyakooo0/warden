{-
Welcome to a Spago project!
You can edit this file as you like.

Need help? See the following resources:
- Spago documentation: https://github.com/purescript/spago
- Dhall language tour: https://docs.dhall-lang.org/tutorials/Language-Tour.html

When creating a new Spago project, you can use
`spago init --no-comments` or `spago init -C`
to generate this file without the comments in this block.
-}
{ name = "backend"
, dependencies =
  [ "aff"
  , "aff-promise"
  , "argonaut"
  , "argonaut-aeson-generic"
  , "argonaut-codecs"
  , "bw"
  , "console"
  , "datetime"
  , "effect"
  , "either"
  , "exceptions"
  , "foldable-traversable"
  , "foreign"
  , "lists"
  , "maybe"
  , "newtype"
  , "nullable"
  , "prelude"
  , "transformers"
  , "unsafe-coerce"
  ]
, packages = ./packages.dhall
, sources = [ "backend/**/*.purs" ]
}
