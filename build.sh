#!/bin/bash

set -e

cp -r "$(nix build "$SRC_DIR#warden-click-src" --print-out-paths)/*" "$INSTALL_DIR"
