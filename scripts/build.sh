#!/bin/zsh
# Builds "Little Safari.app" (with its Safari web extension) using only the Command Line Tools.
# Usage: scripts/build.sh [--install]   (--install copies it to ~/Applications and launches it)
set -euo pipefail

ROOT=${0:A:h:h}
BUILD="$ROOT/build"
APP="$BUILD/Little Safari.app"
APPEX="$APP/Contents/PlugIns/LittleSafariExtension.appex"
SDK=$(xcrun --show-sdk-path)
ARCHS=(arm64 x86_64)
OBJ="$BUILD/obj"

rm -rf "$APP" "$OBJ"
mkdir -p "$OBJ"
mkdir -p "$APP/Contents/MacOS" "$APP/Contents/Resources" "$APPEX/Contents/MacOS" "$APPEX/Contents/Resources"

# Compiles one Swift target for every architecture and merges the results into a universal binary.
compile() {
  local output=$1; shift
  local slices=()
  for arch in $ARCHS; do
    swiftc -O -sdk "$SDK" -target "$arch-apple-macos14.0" "$@" -o "$OBJ/${output:t}-$arch"
    slices+=("$OBJ/${output:t}-$arch")
  done
  lipo -create $slices -output "$output"
}

echo "→ Compiling extension"
compile "$APPEX/Contents/MacOS/LittleSafariExtension" \
  -application-extension -parse-as-library \
  -module-name LittleSafariExtension \
  -Xlinker -e -Xlinker _NSExtensionMain \
  -framework Foundation -framework SafariServices \
  "$ROOT/Extension/SafariWebExtensionHandler.swift"
cp "$ROOT/Extension/Info.plist" "$APPEX/Contents/Info.plist"
cp -R "$ROOT/Extension/Resources/." "$APPEX/Contents/Resources/"

echo "→ Compiling app"
compile "$APP/Contents/MacOS/LittleSafari" \
  -module-name LittleSafari \
  -framework AppKit -framework SwiftUI -framework SafariServices \
  "$ROOT"/App/*.swift
cp "$ROOT/App/Info.plist" "$APP/Contents/Info.plist"

echo "→ Signing (ad-hoc)"
codesign --force --sign - --entitlements "$ROOT/Extension/Extension.entitlements" "$APPEX"
codesign --force --sign - "$APP"

echo "✓ Built $APP"

if [[ "${1:-}" == "--install" ]]; then
  DEST="$HOME/Applications/Little Safari.app"
  mkdir -p "$HOME/Applications"
  pkill -x LittleSafari 2>/dev/null || true
  rm -rf "$DEST"
  cp -R "$APP" "$DEST"
  /System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -f "$DEST"
  open "$DEST"
  echo "✓ Installed to $DEST"
fi
