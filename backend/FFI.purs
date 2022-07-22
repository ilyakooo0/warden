module FFI
  ( Elm
  , createElmSubscription
  , sendElmEvent
  , startElm
  )
  where

import Prelude

import Data.Argonaut (Json)
import Effect (Effect)

foreign import data Elm :: Type

foreign import startElm :: String -> Effect Elm

foreign import createElmSubscription :: Elm -> String -> (Json -> Effect Unit) -> Effect Unit

foreign import sendElmEvent :: Elm -> String -> Json -> Effect Unit
