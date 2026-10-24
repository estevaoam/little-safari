#!/bin/zsh
# Builds the app and zips it for a GitHub release: build/LittleSafari-<version>.zip
set -euo pipefail

ROOT=${0:A:h:h}
"$ROOT/scripts/build.sh"
VERSION=$(/usr/libexec/PlistBuddy -c "Print :CFBundleShortVersionString" "$ROOT/App/Info.plist")
ZIP="$ROOT/build/LittleSafari-$VERSION.zip"
rm -f "$ZIP"
ditto -c -k --keepParent "$ROOT/build/Little Safari.app" "$ZIP"
echo "✓ $ZIP"
