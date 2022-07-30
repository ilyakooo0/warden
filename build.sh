#!/bin/bash

set -e

TEMP=$(mktemp -d)

cp -r "$SRC_DIR"/{vanilla,appname.apparmor,appname.desktop,manifest.json,logo.svg,index.html,style.css} "$INSTALL_DIR"

elm make "$SRC_DIR/frontend/Main.elm" --optimize --output="$TEMP/elm.js"

terser "$TEMP/elm.js" --ecma 2018 --compress 'pure_funcs=[F2,F3,F4,F5,F6,F7,F8,F9,A2,A3,A4,A5,A6,A7,A8,A9],pure_getters,keep_fargs=false,unsafe_comps,unsafe' | terser --ecma 2018 --mangle --compress --output "$INSTALL_DIR/elm.js"

(cd "$SRC_DIR" && spago bundle-app --minify --to "$INSTALL_DIR/backend.js")
