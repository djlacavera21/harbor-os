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
mkdir -p "$STAGE/harbor-os"
tar -C "$ROOT" --exclude='.git' --exclude='dist' --exclude='_site' \
  --exclude='*.iso' --exclude='*.img' -cf - . | tar -C "$STAGE/harbor-os" -xf -
(
  cd "$STAGE"
  zip -r "$OUT_DIR/$NAME" harbor-os \
    -x 'harbor-os/.git/*' 'harbor-os/dist/*' 'harbor-os/_site/*'
)
cp -f "$OUT_DIR/$NAME" "$OUT_DIR/harbor-os-overlay.zip"
SUM="$(sha256sum "$OUT_DIR/$NAME" | awk '{print $1}')"
printf '%s  %s\n%s  harbor-os-overlay.zip\n' "$SUM" "$NAME" "$SUM" > "$OUT_DIR/SHA256SUMS.txt"
python3 - "$OUT_DIR" "$VERSION" "$NAME" "$SUM" <<'PY'
import json, sys
from datetime import datetime, timezone
out, version, name, digest = sys.argv[1:]
payload = {
    "schema": "harbor-overlay-digest/v1",
    "overlay_version": version,
    "generated": datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ"),
    "artifact": name,
    "sha256": digest,
    "contains_iso": False,
    "independent_download": "https://github.com/djlacavera21/harbor-os/archive/refs/heads/main.zip",
}
open(f"{out}/checksums.json", "w").write(json.dumps(payload, indent=2) + "\n")
PY
echo "$OUT_DIR/$NAME"
echo "$OUT_DIR/harbor-os-overlay.zip"
echo "sha256 $SUM"
ls -lh "$OUT_DIR/$NAME"
