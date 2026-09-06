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

Visualizer: http://127.0.0.1:8080
Zen Master docs (if enabled): http://127.0.0.1:4200/docs
MSG
if command -v xdg-open >/dev/null 2>&1; then
  xdg-open "http://127.0.0.1:8080" >/dev/null 2>&1 || true
fi
touch "$FLAG"
