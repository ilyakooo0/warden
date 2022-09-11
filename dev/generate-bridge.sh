#!/bin/sh

nix run github:ilyakooo0/elm-ps-bridge -- --input bridge.yaml --elmOutput=Frontend/Bridge.elm --psOutput=backend/Bridge.purs
