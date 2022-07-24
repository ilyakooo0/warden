module Control.El (El, Al, l, class HasL, L(..)) where


import Control.Monad.Reader (class MonadAsk, ReaderT, asks)
import Data.Symbol (class IsSymbol, reflectSymbol)
import Effect (Effect)
import Effect.Aff (Aff)
import Prim.Row (class Cons, class Nub)
import Record.Unsafe (unsafeGet)
import Type.Proxy (Proxy(..))

data L :: forall k. k -> Type
data L t = L

type El r = ReaderT (Record r) Effect
type Al r = ReaderT (Record r) Aff

l :: forall res r field m. MonadAsk (Record r) m => HasL field res r => IsSymbol field => L field -> m res
l L = asks (unsafeGet (reflectSymbol (Proxy :: Proxy field)))

class HasL :: forall k1 k2 k3. k1 -> k2 -> k3 -> Constraint
class HasL field t r | field r -> t
instance (Cons field t r r', Nub r' r) => HasL field t r
