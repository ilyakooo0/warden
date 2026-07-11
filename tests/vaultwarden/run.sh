#!/bin/sh

set -e

cd "$(dirname "$0")"

tmp="$(mktemp -d)"

cp -r data .env "$tmp"

cd "$tmp"

nix run github:NixOS/nixpkgs?rev=d9a1414346059619d9e13ab93e749bbb82e5252a#vaultwarden
