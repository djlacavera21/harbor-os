#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
export HARBOR_FLAVOR_ID="${HARBOR_FLAVOR_ID:-zen-garden}"
bash "$ROOT/installer/install-harbor.sh"
mkdir -p /etc/skel/.config/autostart
cat >/etc/skel/.config/autostart/harbor-first-boot.desktop <<EOF
[Desktop Entry]
Type=Application
Name=Harbor First Boot
Exec=/opt/harbor-os/installer/first-boot.sh
X-GNOME-Autostart-enabled=true
EOF
echo "Cubic/chroot customization complete."
