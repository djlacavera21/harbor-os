#!/usr/bin/env bash
# Harbor OS flavor installer — overlays identity, visualizer, and optional orchestrator
# onto an existing Linux Mint / Debian-family desktop. Does not replace the kernel.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PREFIX="${HARBOR_PREFIX:-/opt/harbor-os}"
FLAVOR="${HARBOR_FLAVOR_ID:-zen-garden}"
FLAVOR_FILE="$ROOT/flavors/$FLAVOR/harbor.flavor.yaml"
need() { command -v "$1" >/dev/null 2>&1 || { echo "missing: $1" >&2; exit 1; }; }
echo "Harbor OS installer"
echo "  flavor : $FLAVOR"
echo "  prefix : $PREFIX"
echo "  source : $ROOT"
need python3
[[ -f "$FLAVOR_FILE" ]] || { echo "flavor not found: $FLAVOR_FILE" >&2; exit 1; }
python3 "$ROOT/experimentals/validate_flavor.py" "$FLAVOR_FILE"
if [[ "$(id -u)" -ne 0 ]]; then
  echo
  echo "User-mode install (no systemd units)."
  DEST="${HARBOR_HOME:-$HOME/.local/share/harbor-os}"
  mkdir -p "$DEST"
  cp -a "$ROOT/." "$DEST/"
  echo "Copied tree → $DEST"
  echo "Start visualizer: python3 $DEST/visualizer/server.py"
  exit 0
fi
mkdir -p "$PREFIX" /etc/harbor-os
rsync -a --delete --exclude '.git' "$ROOT/" "$PREFIX/"
install -m 0644 "$ROOT/installer/harbor-visualizer.service" /etc/systemd/system/
install -m 0644 "$ROOT/installer/harbor-zen-master.service" /etc/systemd/system/
if [[ ! -f /etc/harbor-os/zen-master.env ]]; then
  printf '%s\n' '# XAI_API_KEY=' '# HARBOR_MODEL=grok-4' >/etc/harbor-os/zen-master.env
fi
systemctl daemon-reload
systemctl enable --now harbor-visualizer.service
echo "Visualizer enabled. Open http://127.0.0.1:8080"
