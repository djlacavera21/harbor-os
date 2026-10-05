#!/usr/bin/env bash
# Run inside a Cubic chroot against official Linux Mint 22.3 Cinnamon.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
export HARBOR_FLAVOR_ID="${HARBOR_FLAVOR_ID:-zen-garden}"
bash "$ROOT/installer/install-harbor.sh"

mkdir -p /etc/skel/.config/autostart /etc/harbor-os
cat >/etc/skel/.config/autostart/harbor-first-boot.desktop <<EOF
[Desktop Entry]
Type=Application
Name=Harbor First Boot
Exec=/opt/harbor-os/installer/first-boot.sh
X-GNOME-Autostart-enabled=true
EOF

# Identity overlay — do not overwrite upstream /etc/os-release wholesale.
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

if [[ -w /etc/hostname ]]; then
  echo "freshos" >/etc/hostname || true
fi

echo "Cubic/chroot customization complete for flavor $HARBOR_FLAVOR_ID."
echo "Write the ISO with Cubic, then boot via Ventoy or VirtualBox EFI."
echo "Non-Cubic path: boot official Mint and run iso/live-apply.sh."
