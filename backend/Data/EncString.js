import { EncString } from "../../bw/models/domain/enc-string"

export function fromString(str) {
  const x = new EncString(str)
  return x
}

export function toString(encStr) {
  return encStr.encryptedString
}

export function encryptionType(encStr) {
  return encStr.encryptionType
}
