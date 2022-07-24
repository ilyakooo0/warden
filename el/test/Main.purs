module Test.Main
  ( main
  )
  where

import Prelude
import Test.Unit

import Control.El
import Control.Monad.Reader (runReaderT)
import Effect (Effect)
import Effect.Aff (launchAff_)
import Test.Unit.Assert as Assert
import Test.Unit.Output.Fancy (runTest)
import Type.Proxy (Proxy(..))

main ∷ Effect Unit
main = launchAff_ $ void $ runTest do
  suite "sync code" do
    test "arithmetic" do
      x <- runReaderT singleHandler {handle: 2, ignore: "Hello"}
      Assert.equal x 2


singleHandler :: forall r. HasL "handle" Int r => Al r Int
singleHandler = do
  l (L :: L "handle")
