#!/bin/bash

APP="/Applications/Firefox Developer Edition.app"
PLIST="$APP/Contents/Info.plist"
URL="https://download.mozilla.org/?product=firefox-devedition-latest-ssl&os=osx&lang=en-US"
DMG="/tmp/firefox-dev.dmg"
VOL="/Volumes/Firefox Developer Edition"

echo "==== Firefox Developer Edition Update ===="

# Close app if running
pkill -x "Firefox Developer Edition" 2>/dev/null

# Download latest
curl -L "$URL" -o "$DMG"

# Mount DMG
hdiutil attach "$DMG" -nobrowse -quiet

# Install
cp -R "$VOL/Firefox Developer Edition.app" /Applications/

# Unmount
hdiutil detach "$VOL" -quiet

# Cleanup
rm -f "$DMG"

echo "Update complete"
