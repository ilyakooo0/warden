#!/bin/sh

nix run github:NixOS/nixpkgs?rev=d9a1414346059619d9e13ab93e749bbb82e5252a#elmPackages.elm-live -- frontend/Main.elm --start-page=index.html --proxy-prefix=/api --proxy-host=http://localhost:6009 --pushstate -- --debug --output=elm.js
