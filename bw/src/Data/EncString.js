import { EncString } from "../../../deps/bw/libs/shared/dist/src/models/domain/encString"

export function fromString(str) {
  return new EncString(str)
}
