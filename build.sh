#!/bin/sh

elm make ${DEBUG_BUILD:+--debug} "$SRC_DIR/src/Main.elm" --output="$INSTALL_DIR/index.html"

cp -r "$SRC_DIR"/static/* "$INSTALL_DIR"
