#!/usr/bin/env bash
set -euo pipefail
FLAG="$HOME/.config/harbor-os/first-boot-done"
mkdir -p "$(dirname "$FLAG")"
if [[ -f "$FLAG" ]]; then
  exit 0
fi
cat <<'MSG'
Harbor OS / FreshOS Zen Garden

The garden is raked.
The lanterns can be lit.
The operator remains in command.

Visualizer:            http://127.0.0.1:8080
Zen Master (optional): http://127.0.0.1:4200/docs
Experimentals station: open experimentals/index.html from the tree
Independent download:  https://github.com/djlacavera21/harbor-os
MSG
if command -v xdg-open >/dev/null 2>&1; then
  xdg-open "http://127.0.0.1:8080" >/dev/null 2>&1 || true
fi
touch "$FLAG"
