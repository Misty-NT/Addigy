#!/bin/bash

# =========================
# Firefox Dev Auto Update
# =========================

APP="/Applications/Firefox Developer Edition.app"
PLIST="$APP/Contents/Info.plist"
URL="https://download.mozilla.org/?product=firefox-devedition-latest-ssl&os=osx&lang=en-US"
DMG="/tmp/firefox-dev.dmg"
VOL="/Volumes/Firefox Developer Edition"
LOG="/var/log/firefox_dev_update.log"

echo "==============================" | tee -a "$LOG"
echo "$(date) - Starting Firefox Dev Update" | tee -a "$LOG"

# Get current version (if installed)
if [ -d "$APP" ]; then
    CURRENT_VERSION=$(defaults read "$PLIST" CFBundleShortVersionString 2>/dev/null)
    echo "Current Version: $CURRENT_VERSION" | tee -a "$LOG"
else
    echo "Firefox Developer Edition not installed. Proceeding with install." | tee -a "$LOG"
    CURRENT_VERSION="Not Installed"
fi

# Get latest version from Mozilla
LATEST_VERSION=$(curl -s https://product-details.mozilla.org/1.0/firefox_versions.json | \
/usr/bin/python3 -c "import sys, json; print(json.load(sys.stdin)['FIREFOX_DEVEDITION'])")

echo "Latest Version: $LATEST_VERSION" | tee -a "$LOG"

# Compare versions
if [ "$CURRENT_VERSION" == "$LATEST_VERSION" ]; then
    echo "Already up to date. Exiting." | tee -a "$LOG"
    exit 0
fi

echo "Update required. Proceeding..." | tee -a "$LOG"

# Close Firefox if running
pkill -x "Firefox Developer Edition" 2>/dev/null

# Download latest version
echo "Downloading..." | tee -a "$LOG"
curl -L "$URL" -o "$DMG"

if [ ! -f "$DMG" ]; then
    echo "Download failed!" | tee -a "$LOG"
    exit 1
fi

# Mount DMG
echo "Mounting DMG..." | tee -a "$LOG"
hdiutil attach "$DMG" -nobrowse -quiet

if [ ! -d "$VOL" ]; then
    echo "Mount failed!" | tee -a "$LOG"
    exit 1
fi

# Install (overwrite existing app)
echo "Installing..." | tee -a "$LOG"
cp -R "$VOL/Firefox Developer Edition.app" /Applications/

# Unmount DMG
echo "Unmounting..." | tee -a "$LOG"
hdiutil detach "$VOL" -quiet

# Cleanup
rm -f "$DMG"

# Verify new version
if [ -d "$APP" ]; then
    NEW_VERSION=$(defaults read "$PLIST" CFBundleShortVersionString 2>/dev/null)
    echo "Updated Version: $NEW_VERSION" | tee -a "$LOG"
else
    echo "Installation failed!" | tee -a "$LOG"
    exit 1
fi

echo "$(date) - Update Completed Successfully" | tee -a "$LOG"
echo "==============================" | tee -a "$LOG"

exit 0
