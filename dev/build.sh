#!/bin/sh


rm -r dist

mkdir -p dist

cp -r "$(nix build ".#warden-click-src" --print-out-paths)"/* dist

chmod -R 777 dist
