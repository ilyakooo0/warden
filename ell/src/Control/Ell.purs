module Control.Ell where

import Prelude

import Control.Monad.Reader (ReaderT, asks)
import Effect (Effect)
import Prim.Row (class Cons, class Union, class Nub)

type Ell r a = ReaderT {  | r } Effect a

l :: forall r a res. ApplyEll r a res => ({ | r } -> a) -> res
l f = appEll (asks f)

class EllHas row r

instance (Union row r r', Nub r' r) => EllHas row r

class ApplyEll r a res | r a -> res where
  appEll :: Ell r a -> res

instance ApplyEll r b c => ApplyEll r (a -> b) (a -> c) where
  appEll f a = appEll ((\g -> g a) <$> f)

else instance ApplyEll r (Ell r a) (Ell r a) where
  appEll = join

else instance ApplyEll r a (Ell r a) where
  appEll = identity

foo ∷ ∀ (t55 ∷ Type) (t56 ∷ Row Type). { foo ∷ t55 | t56 } → t55
foo = _.foo
