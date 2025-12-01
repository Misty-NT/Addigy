#!/bin/bash

echo "Stopping CCleaner services..."
launchctl unload /Library/LaunchDaemons/com.piriform.ccleaner.plist 2>/dev/null
launchctl unload /Library/LaunchAgents/com.piriform.ccleaner.plist 2>/dev/null

echo "Removing CCleaner application..."
rm -rf "/Applications/CCleaner.app"

echo "Removing CCleaner files (system-wide)..."
rm -f /Library/LaunchDaemons/com.piriform.ccleaner.plist
rm -f /Library/LaunchAgents/com.piriform.ccleaner.plist

echo "Removing CCleaner files (user)..."
rm -rf "/Library/Application Support/CCleaner"
rm -rf "/Library/Caches/com.piriform.ccleaner"
rm -rf "/Library/Preferences/com.piriform.ccleaner.plist"

for user in /Users/*; do
  if [ -d "$user" ]; then
    rm -rf "$user/Library/Application Support/CCleaner"
    rm -rf "$user/Library/Caches/com.piriform.ccleaner"
    rm -f "$user/Library/Preferences/com.piriform.ccleaner.plist"
  fi
done

echo "CCleaner removal complete."
exit 0
