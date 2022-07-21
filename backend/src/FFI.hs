{-# LANGUAGE CPP #-}

module FFI (launchElm) where
import Data.JSString (JSString)

#ifdef __GHCJS__
foreign import javascript unsafe "Elm.Main.init({node: document.getElementById($1)})"
  launchElm
#else
launchElm = undefined
#endif
  :: JSString -> IO ()
