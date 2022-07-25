#!/bin/bash

set -e

cp -r "$SRC_DIR"/{appname.apparmor,appname.desktop,vanilla,index.html,style.css,manifest.json,logo.svg} "$INSTALL_DIR"

elm make --debug "$SRC_DIR/frontend/Main.elm" --output="$INSTALL_DIR/elm.js"

(cd "$SRC_DIR" && spago bundle-app --to "$INSTALL_DIR/backend.js")
