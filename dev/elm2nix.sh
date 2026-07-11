#!/bin/sh

set -e

cd "$(dirname "$0")/.."

nix run github:NixOS/nixpkgs#elm2nix -- snapshot
nix run github:NixOS/nixpkgs#elm2nix -- convert > elm-srcs.nix
