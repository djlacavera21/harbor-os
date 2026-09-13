#!/usr/bin/env bash
# Pack the Harbor overlay. Never includes a Linux Mint ISO.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
VERSION="$(tr -d '[:space:]' < "$ROOT/VERSION" 2>/dev/null || echo 0.0.0)"
OUT_DIR="${1:-$ROOT/dist}"
NAME="harbor-os-${VERSION}-overlay.zip"
mkdir -p "$OUT_DIR"
STAGE="$(mktemp -d)"
trap 'rm -rf "$STAGE"' EXIT
rsync -a --exclude '.git' --exclude 'dist' --exclude '_site' --exclude '*.iso' --exclude '*.img' \
  "$ROOT/" "$STAGE/harbor-os/"
(
  cd "$STAGE"
  zip -r "$OUT_DIR/$NAME" harbor-os \
    -x 'harbor-os/.git/*' 'harbor-os/dist/*' 'harbor-os/_site/*'
)
cp -f "$OUT_DIR/$NAME" "$OUT_DIR/harbor-os-overlay.zip"
echo "$OUT_DIR/$NAME"
echo "$OUT_DIR/harbor-os-overlay.zip"
ls -lh "$OUT_DIR/$NAME"
