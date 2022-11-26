#!/bin/sh

nix run github:NixOS/nixpkgs?rev=d9a1414346059619d9e13ab93e749bbb82e5252a#elmPackages.elm-live -- $1 --start-page=index.html --proxy-prefix=/api --proxy-host=http://localhost:6009 -- --debug --output=elm.js
