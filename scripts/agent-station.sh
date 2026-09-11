#!/usr/bin/env bash
# Harbor OS TUI Agent Station — Phase 3 sketch from the alignment whitepaper.
# No API key required. Works on a tty, air-gapped after clone.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
CATALOG="$ROOT/experimentals/catalog.json"

banner() {
  cat <<'EOF'
+----------------------------------------------+
|  Harbor OS · Agent Station                   |
|  Operator in command. Vizier optional.       |
+----------------------------------------------+
EOF
}

menu() {
  cat <<'EOF'

  1) Catalog (official + community)
  2) Open Research inbox
  3) Open Strategy board
  4) Open Publishing outbound
  5) Validate a flavor YAML
  6) Start Zen Garden visualizer (:8080)
  7) Print independent download links
  q) Quit

EOF
}

show_catalog() {
  python3 - <<PY
import json
from pathlib import Path
p = Path("$CATALOG")
c = json.loads(p.read_text())
print("independent download:", c.get("independent_download"))
print("pages:", c.get("pages"))
print()
print("official")
for item in c.get("official", []):
    print(f"  {item['id']:20} {item['name']}  {item.get('version','')}")
print("community")
for item in c.get("community", []):
    print(f"  {item['id']:20} {item['name']}  [{item.get('risk','?')}]")
print()
print("upload gate:", c.get("community_upload", {}).get("proposed_grok_app_gate"))
PY
}

open_file() {
  local f="$1"
  mkdir -p "$(dirname "$f")"
  [[ -f "$f" ]] || printf '# created by agent-station\n' >"$f"
  ${EDITOR:-less} "$f"
}

links() {
  cat <<'EOF'
Source     https://github.com/djlacavera21/harbor-os
Zip        https://github.com/djlacavera21/harbor-os/archive/refs/heads/main.zip
Catalog    https://raw.githubusercontent.com/djlacavera21/harbor-os/main/experimentals/catalog.json
Pages      https://djlacavera21.github.io/harbor-os/
Submit     https://github.com/djlacavera21/harbor-os/issues/new?template=submit-flavor.yml

Grok App Experimentals tab: not shippable from this repository.
EOF
}

banner
while true; do
  menu
  read -r -p "station> " choice || exit 0
  case "$choice" in
    1) show_catalog ;;
    2) open_file "$ROOT/modules/research/INBOX.md" ;;
    3) open_file "$ROOT/modules/war-room/BOARD.md" ;;
    4) open_file "$ROOT/modules/publishing/OUTBOUND.md" ;;
    5)
      read -r -p "path to harbor.flavor.yaml: " yaml
      python3 "$ROOT/experimentals/validate_flavor.py" "$yaml" || true
      ;;
    6)
      echo "Starting garden on http://127.0.0.1:8080"
      python3 "$ROOT/visualizer/server.py" &
      echo "pid $!"
      ;;
    7) links ;;
    q|Q|quit|exit) exit 0 ;;
    *) echo "unknown: $choice" ;;
  esac
done
