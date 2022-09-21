#!/bin/sh

nix run github:ilyakooo0/elm-ps-bridge -- --input bridge.yaml --elmOutput=frontend/Bridge.elm --psOutput=backend/Bridge.purs
