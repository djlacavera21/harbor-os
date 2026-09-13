#!/usr/bin/env bash
set -euo pipefail
FLAG="$HOME/.config/harbor-os/first-boot-done"
mkdir -p "$(dirname "$FLAG")"
if [[ -f "$FLAG" ]]; then
  exit 0
fi

find_root() {
  local candidates=(
    "${HARBOR_HOME:-}"
    "$HOME/.local/share/harbor-os"
    /opt/harbor-os
  )
  local here
  here="$(cd "$(dirname "$0")/.." && pwd)"
  candidates+=("$here")
  for c in "${candidates[@]}"; do
    [[ -n "$c" && -x "$c/scripts/harborctl.sh" ]] && { echo "$c"; return 0; }
  done
  return 1
}

ROOT="$(find_root || true)"

cat <<MSG
Harbor OS / FreshOS Zen Garden

The garden is raked.
The lanterns can be lit.
The operator remains in command.

Visualizer:            http://127.0.0.1:8080
Zen Master (optional): http://127.0.0.1:4200/docs
Experimentals station: ${ROOT:+$ROOT/docs/index.html}
Independent download:  https://github.com/djlacavera21/harbor-os/archive/refs/heads/main.zip
MSG

if [[ -n "${ROOT:-}" ]]; then
  if ! curl -fsS --max-time 1 http://127.0.0.1:8080/api/metrics >/dev/null 2>&1; then
    nohup python3 "$ROOT/visualizer/server.py" >/tmp/harbor-garden.log 2>&1 &
    sleep 1
  fi
fi

if command -v xdg-open >/dev/null 2>&1; then
  xdg-open "http://127.0.0.1:8080" >/dev/null 2>&1 || true
  if [[ -n "${ROOT:-}" && -f "$ROOT/docs/index.html" ]]; then
    xdg-open "$ROOT/docs/index.html" >/dev/null 2>&1 || true
  fi
fi
touch "$FLAG"
