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
  , "arraybuffer"
  , "arraybuffer-types"
  , "arrays"
  , "bifunctors"
  , "console"
  , "datetime"
  , "datetime-parsing"
  , "effect"
  , "either"
  , "el"
  , "exceptions"
  , "foldable-traversable"
  , "foreign"
  , "functions"
  , "lists"
  , "maybe"
  , "newtype"
  , "nullable"
  , "prelude"
  , "refs"
  , "strings"
  , "subtlecrypto"
  , "transformers"
  , "tuples"
  , "typelevel-prelude"
  , "undefined-is-not-a-problem"
  , "unsafe-coerce"
  , "web-html"
  , "web-storage"
  ]
, packages = ./packages.dhall
, sources = [ "backend/**/*.purs" ]
}
