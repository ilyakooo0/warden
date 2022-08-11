import { EncString } from "../../deps/bw/libs/shared/dist/src/models/domain/encString"

export function fromString(str) {
  console.log("fromString " + str)
  const x = new EncString(str)
  return x
}

export function toString(encStr) {
  return encStr.encryptedString
}

export function encryptionType(encStr) {
  return encStr.encryptionType
}
