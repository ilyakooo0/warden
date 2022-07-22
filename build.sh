#!/bin/sh

cp -r "$SRC_DIR"/static/* "$INSTALL_DIR"

rm "$INSTALL_DIR/elm.js"

elm make --debug "$SRC_DIR/frontend/Main.elm" --output="$INSTALL_DIR/elm.js"

rm "$INSTALL_DIR/backend.js"

(cd "$SRC_DIR" && spago bundle-app --to "$INSTALL_DIR/backend.js")
