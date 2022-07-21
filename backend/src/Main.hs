module Main (main) where

import Data.JSString
import qualified FFI

main :: IO ()
main = do
  FFI.launchElm "elm"
  putStrLn "Hello, Haskell!"
