#!/bin/sh

set -e

(cd deps/bw && npm install)

(cd deps/bw/libs/common/ && npm run clean && npm exec -c "tsc -m es2020 -t es2018")
