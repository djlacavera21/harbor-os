#!/usr/bin/env bash
# Apply Harbor OS onto an official Linux Mint 22.3 live session or install.
# Does not download, modify, or redistribute a Mint ISO.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
FLAVOR="${HARBOR_FLAVOR_ID:-zen-garden}"
echo "Harbor OS live-apply — overlay 1.18.0 — flavor ${FLAVOR}"
echo "Declared base: Linux Mint 22.3 Cinnamon (Debian-family). This script never fetches an ISO."
if [[ ! -f /etc/os-release ]]; then
  echo "No /etc/os-release. Boot official Mint, then run this script there." >&2
  exit 1
fi
chmod +x "$ROOT/scripts/harborctl.sh" "$ROOT/installer/"*.sh "$ROOT/iso/customize.sh" 2>/dev/null || true
HARBOR_FLAVOR_ID="$FLAVOR" bash "$ROOT/scripts/harborctl.sh" apply
if [[ "$(id -u)" -eq 0 ]]; then
  mkdir -p /etc/harbor-os /etc/skel/.config/autostart
  cat >/etc/harbor-os/os-release <<'EOF'
NAME="FreshOS"
VERSION="1.18.0 Zen Garden"
ID=freshos
ID_LIKE="linuxmint ubuntu debian"
PRETTY_NAME="FreshOS 1.18.0 Zen Garden (Harbor overlay)"
HOME_URL="https://github.com/djlacavera21/harbor-os"
SUPPORT_URL="https://github.com/djlacavera21/harbor-os/issues"
VARIANT="Harbor OS Experimentals"
EOF
  echo freshos >/etc/hostname || true
  if [[ -x /opt/harbor-os/installer/first-boot.sh ]]; then
    cat >/etc/skel/.config/autostart/harbor-first-boot.desktop <<'EOF'
[Desktop Entry]
Type=Application
Name=Harbor First Boot
Exec=/opt/harbor-os/installer/first-boot.sh
X-GNOME-Autostart-enabled=true
EOF
  fi
fi
echo "Overlay applied for flavor ${FLAVOR}."
echo "Garden: ./scripts/harborctl.sh garden  →  http://127.0.0.1:8080"
echo "Bootable path: official Mint 22.3 Cinnamon ISO on Ventoy, then re-run iso/live-apply.sh."
