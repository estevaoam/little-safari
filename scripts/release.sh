#!/bin/zsh
# Builds the app and zips it for a GitHub release: build/LittleSafari.zip
# The name has no version so https://github.com/estevaoam/little-safari/releases/latest/download/LittleSafari.zip
# always points at the newest build.
set -euo pipefail

ROOT=${0:A:h:h}
"$ROOT/scripts/build.sh"
ZIP="$ROOT/build/LittleSafari.zip"
rm -f "$ZIP"
ditto -c -k --keepParent "$ROOT/build/Little Safari.app" "$ZIP"
echo "✓ $ZIP"
