import { SymmetricCryptoKey } from '../../deps/bw/libs/shared/dist/src/models/domain/symmetricCryptoKey.js'

export function fromArrayBuffer(arr) {
  return new SymmetricCryptoKey(arr)
}
