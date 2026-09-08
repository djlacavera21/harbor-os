#!/usr/bin/env bash
# Harbor OS flavor installer — overlays identity, visualizer, modules, and optional orchestrator
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

install_tree() {
  local dest="$1"
  mkdir -p "$dest"
  if command -v rsync >/dev/null 2>&1; then
    rsync -a --delete --exclude '.git' --exclude '_site' "$ROOT/" "$dest/"
  else
    find "$dest" -mindepth 1 -maxdepth 1 ! -name '.git' -exec rm -rf {} +
    cp -a "$ROOT/." "$dest/"
    rm -rf "$dest/.git"
  fi
  mkdir -p "$dest/modules/research" "$dest/modules/design" \
           "$dest/modules/publishing" "$dest/modules/war-room" \
           "$dest/modules/finance" "$dest/modules/archives" "$dest/modules/crew"
  chmod +x "$dest/installer/"*.sh "$dest/iso/customize.sh" \
           "$dest/experimentals/validate_flavor.py" "$dest/visualizer/server.py" \
           "$dest/scripts/harborctl.sh" 2>/dev/null || true
}

write_identity() {
  local dest="$1"
  mkdir -p "$dest"
  cat >"$dest/identity.env" <<EOF
HARBOR_FLAVOR_ID=$FLAVOR
HARBOR_OS_NAME=FreshOS
HARBOR_CODENAME=Zen Garden
HARBOR_PRETTY_NAME=FreshOS 1.0 Zen Garden
HARBOR_VISUALIZER=http://127.0.0.1:8080
HARBOR_ZEN_MASTER=http://127.0.0.1:4200/docs
EOF
}

write_desktop() {
  local apps="$1"
  mkdir -p "$apps"
  cat >"$apps/harbor-garden.desktop" <<EOF
[Desktop Entry]
Type=Application
Name=Harbor Zen Garden
Comment=Living system garden for Harbor OS
Exec=python3 $2/visualizer/server.py
Terminal=false
Categories=System;Monitor;
EOF
  cat >"$apps/harbor-experimentals.desktop" <<EOF
[Desktop Entry]
Type=Application
Name=Harbor Experimentals
Comment=Independent Experimentals station
Exec=xdg-open $2/experimentals/index.html
Terminal=false
Categories=System;
EOF
}

seed_modules() {
  local dest="$1"
  [[ -f "$dest/modules/research/INBOX.md" ]] || cat >"$dest/modules/research/INBOX.md" <<'EOF'
# Research Wing inbox
Drop sources here. Verification notes stay local.
EOF
  [[ -f "$dest/modules/design/BRIEF.md" ]] || echo "# Design Wing" >"$dest/modules/design/BRIEF.md"
  [[ -f "$dest/modules/publishing/OUTBOUND.md" ]] || echo "# Publishing drafts" >"$dest/modules/publishing/OUTBOUND.md"
  [[ -f "$dest/modules/war-room/BOARD.md" ]] || echo "# Strategy board" >"$dest/modules/war-room/BOARD.md"
  [[ -f "$dest/modules/finance/LEDGER.md" ]] || echo "# Sovereignty ledger" >"$dest/modules/finance/LEDGER.md"
  [[ -f "$dest/modules/archives/INDEX.md" ]] || echo "# Archives" >"$dest/modules/archives/INDEX.md"
  [[ -f "$dest/modules/crew/STANDING-ORDERS.md" ]] || cat >"$dest/modules/crew/STANDING-ORDERS.md" <<'EOF'
# Crew Quarters
Operator remains in command. Grok is Vizier, not Emperor.
EOF
}

if [[ "$(id -u)" -ne 0 ]]; then
  echo
  echo "User-mode install (no systemd units)."
  DEST="${HARBOR_HOME:-$HOME/.local/share/harbor-os}"
  install_tree "$DEST"
  write_identity "$HOME/.config/harbor-os"
  write_desktop "$HOME/.local/share/applications" "$DEST"
  seed_modules "$DEST"
  mkdir -p "$HOME/.config/autostart"
  cat >"$HOME/.config/autostart/harbor-first-boot.desktop" <<EOF
[Desktop Entry]
Type=Application
Name=Harbor First Boot
Exec=$DEST/installer/first-boot.sh
X-GNOME-Autostart-enabled=true
EOF
  echo "Copied tree → $DEST"
  echo "Start visualizer: python3 $DEST/visualizer/server.py"
  echo "Or:               $DEST/scripts/harborctl.sh garden"
  exit 0
fi

install_tree "$PREFIX"
write_identity /etc/harbor-os
seed_modules "$PREFIX"
mkdir -p /usr/local/share/applications /etc/skel/.config/autostart /etc/skel/.local/share/applications
write_desktop /usr/local/share/applications "$PREFIX"
write_desktop /etc/skel/.local/share/applications "$PREFIX"
install -m 0755 "$PREFIX/installer/first-boot.sh" /usr/local/bin/harbor-first-boot || true
cat >/etc/skel/.config/autostart/harbor-first-boot.desktop <<EOF
[Desktop Entry]
Type=Application
Name=Harbor First Boot
Exec=$PREFIX/installer/first-boot.sh
X-GNOME-Autostart-enabled=true
EOF
if [[ ! -f /etc/harbor-os/zen-master.env ]]; then
  printf '%s\n' '# XAI_API_KEY=' '# HARBOR_MODEL=grok-4' >/etc/harbor-os/zen-master.env
fi
install -m 0644 "$ROOT/installer/harbor-visualizer.service" /etc/systemd/system/
install -m 0644 "$ROOT/installer/harbor-zen-master.service" /etc/systemd/system/
systemctl daemon-reload
systemctl enable --now harbor-visualizer.service
echo "Visualizer enabled. Open http://127.0.0.1:8080"
echo "Zen Master stays disabled until XAI_API_KEY is set in /etc/harbor-os/zen-master.env"
