#!/bin/sh

set -e

spago build

export out="$(pwd)/backend.js"

$(nix build .#backendBuildScript --print-out-paths) "$(pwd)/output"
