#!/bin/sh

elm make ${DEBUG_BUILD:+--debug} "$SRC_DIR/src/Main.elm" --output="$INSTALL_DIR/elm.js"

rm "$SRC_DIR"/static/elm.js

cp -r "$SRC_DIR"/static/* "$INSTALL_DIR"
