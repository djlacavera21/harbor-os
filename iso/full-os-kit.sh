#!/usr/bin/env bash
# Harbor OS 1.19.0 — Full OS kit.
# Stages a personal bootable workspace on top of an official Linux Mint 22.3
# Cinnamon ISO. Does not download, modify, or redistribute that ISO.
set -euo pipefail

VERSION="1.19.0"
EXPECTED_NAME="linuxmint-22.3-cinnamon-64bit.iso"
EXPECTED_SHA="a081ab202cfda17f6924128dbd2de8b63518ac0531bcfe3f1a1b88097c459bd4"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
WORK="${HARBOR_FULL_OS_WORK:-$HOME/harbor-full-os}"
ISO_PATH="${1:-}"

mkdir -p "$WORK"

cat >"$WORK/DECLARED_BASE.txt" <<EOF
Harbor OS Full OS kit ${VERSION}
Declared base: Linux Mint 22.3 Cinnamon (Zena)
Expected file: ${EXPECTED_NAME}
Expected sha256: ${EXPECTED_SHA}
Upstream index: https://www.linuxmint.com/download.php
Independent overlay: https://github.com/djlacavera21/harbor-os/archive/refs/heads/main.zip
This kit does not contain the Mint ISO.
EOF

if [[ -z "$ISO_PATH" ]]; then
  echo "Harbor OS ${VERSION} Full OS kit"
  echo "No ISO path given. Download the official Cinnamon image, then re-run:"
  echo "  bash iso/full-os-kit.sh /path/to/${EXPECTED_NAME}"
  echo "Expected sha256: ${EXPECTED_SHA}"
  echo "Workspace notes written to ${WORK}/DECLARED_BASE.txt"
  exit 2
fi

if [[ ! -f "$ISO_PATH" ]]; then
  echo "ISO not found: $ISO_PATH" >&2
  exit 1
fi

base="$(basename "$ISO_PATH")"
if [[ "$base" != "$EXPECTED_NAME" ]]; then
  echo "Refusing non-declared image name: $base" >&2
  echo "Expected ${EXPECTED_NAME}. Harbor will not wrap an undeclared base." >&2
  exit 1
fi

echo "Verifying sha256 (this reads ~2.9 GiB)..."
actual="$(sha256sum "$ISO_PATH" | awk '{print $1}')"
if [[ "$actual" != "$EXPECTED_SHA" ]]; then
  echo "Checksum mismatch." >&2
  echo "  expected ${EXPECTED_SHA}" >&2
  echo "  actual   ${actual}" >&2
  exit 1
fi

cp -n "$ROOT/iso/MINT_BASE.txt" "$WORK/MINT_BASE.txt" 2>/dev/null || true
cat >"$WORK/VENTOY.txt" <<EOF
Verified ${EXPECTED_NAME}
sha256 ${actual}
Next:
  1. Copy the verified ISO onto a Ventoy disk, or attach it to a VM (EFI).
  2. Boot the official Mint session. Do not boot a Harbor-branded ISO from this repo.
  3. Unzip the Harbor overlay and run: bash iso/live-apply.sh
  4. Optional Cubic path: open the same verified ISO in Cubic and run iso/customize.sh in the chroot.
The resulting personal ISO is the operator's artifact. Do not upload it as a flavor pack.
EOF

echo "Verified. Workspace: $WORK"
echo "Boot official Mint, then: bash iso/live-apply.sh"
echo "Flavor upload is not part of the ISO. See experimentals/premium-plus-upload.json"
