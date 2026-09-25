#!/usr/bin/env bash
# Pack a single Harbor flavor into the exact artifact a Grok App
# Premium+ "Upload flavor" submenu would accept: zip ≤ 50 MiB containing
# harbor.flavor.yaml. Never includes an ISO.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
ID="${1:-}"
OUT_DIR="${2:-$ROOT/dist/flavors}"
MAX_BYTES=52428800

if [[ -z "$ID" ]]; then
  echo "usage: pack-flavor.sh <flavor-id> [out-dir]" >&2
  echo "example: pack-flavor.sh zen-garden" >&2
  exit 2
fi

SRC="$ROOT/flavors/$ID"
YAML="$SRC/harbor.flavor.yaml"
if [[ ! -f "$YAML" ]]; then
  echo "missing flavor: $YAML" >&2
  exit 1
fi

python3 "$ROOT/experimentals/validate_flavor.py" "$YAML"

VERSION="$(python3 - <<PY
from pathlib import Path
text = Path("$YAML").read_text(encoding="utf-8")
version = "0.0.0"
for line in text.splitlines():
    if line.startswith("version:"):
        version = line.split(":", 1)[1].strip().strip('"').strip("'")
        break
print(version)
PY
)"

mkdir -p "$OUT_DIR"
STAGE="$(mktemp -d)"
trap 'rm -rf "$STAGE"' EXIT
mkdir -p "$STAGE/$ID"
cp -a "$SRC/." "$STAGE/$ID/"
find "$STAGE/$ID" \( -iname '*.iso' -o -iname '*.img' \) -delete
rm -rf "$STAGE/$ID/.git"
if [[ ! -f "$STAGE/$ID/harbor.flavor.yaml" ]]; then
  echo "pack missing harbor.flavor.yaml" >&2
  exit 1
fi

NAME="harbor-flavor-${ID}-${VERSION}.zip"
(
  cd "$STAGE"
  zip -r "$OUT_DIR/$NAME" "$ID"
)
SIZE="$(wc -c < "$OUT_DIR/$NAME")"
if [[ "$SIZE" -gt "$MAX_BYTES" ]]; then
  echo "FAIL pack exceeds 50 MiB ($SIZE bytes)" >&2
  rm -f "$OUT_DIR/$NAME"
  exit 1
fi
python3 - <<PY
import hashlib
from pathlib import Path
p = Path("$OUT_DIR/$NAME")
digest = hashlib.sha256(p.read_bytes()).hexdigest()
Path("$OUT_DIR/${NAME}.sha256").write_text(f"{digest}  {p.name}\n")
print(f"{digest}  {p.name}")
PY
echo "$OUT_DIR/$NAME"
echo "bytes $SIZE / $MAX_BYTES"
echo "upload target: Grok App → Experimentals → Upload flavor (Premium+)"
echo "local rehearsal: ./scripts/harborctl.sh ingest"
