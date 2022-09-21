#!/bin/sh

if test -f /Applications/Chromium.app/Contents/MacOS/Chromium; then
  /Applications/Chromium.app/Contents/MacOS/Chromium --args --user-data-dir="/tmp/chrome_dev_test" --disable-web-security
else
  flatpak run com.github.Eloston.UngoogledChromium --args --user-data-dir="/tmp/chrome_dev_test" --disable-web-security
fi
