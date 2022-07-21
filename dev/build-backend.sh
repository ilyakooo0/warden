#!/bin/sh

cp "$(nix build --print-out-paths ./backend)/bin/backend.jsexe/all.js" static/backend.js
