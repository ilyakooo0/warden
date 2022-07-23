#!/bin/sh

cp -r "$SRC_DIR"/{appname.apparmor,appname.desktop,vanilla,index.html,style.css} "$INSTALL_DIR"

BUILDDIR=$(mktemp -d)

cp -r $SRC_DIR/* $BUILDDIR

ls $BUILDDIR

elm make --debug "$BUILDDIR/frontend/Main.elm" --output="$INSTALL_DIR/elm.js"

(cd "$BUILDDIR" && ./dev/build-bw.sh)

(cd "$BUILDDIR" && spago bundle-app --to "$INSTALL_DIR/backend.js")
