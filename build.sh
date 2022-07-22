#!/bin/sh

cp -r "$SRC_DIR"/static/* "$INSTALL_DIR"

rm "$INSTALL_DIR/elm.js"

BUILDDIR=$(mktemp -d)

cp -r $SRC_DIR/* $BUILDDIR

ls $BUILDDIR

elm make --debug "$BUILDDIR/frontend/Main.elm" --output="$INSTALL_DIR/elm.js"

rm "$INSTALL_DIR/backend.js"

(cd "$BUILDDIR" && spago bundle-app --to "$INSTALL_DIR/backend.js")
