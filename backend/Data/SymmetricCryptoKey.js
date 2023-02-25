import { SymmetricCryptoKey } from '../../bw/models/domain/symmetric-crypto-key.js'

export function fromArrayBuffer(arr) {
  return new SymmetricCryptoKey(arr)
}
