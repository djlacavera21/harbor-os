#!/usr/bin/env bash
# Harbor OS station control — garden, flavor apply, Experimentals rehearsal.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cmd="${1:-help}"
shift || true

usage() {
  cat <<'EOF'
Usage: harborctl.sh <command>

  garden          Start Zen Garden visualizer on :8080
  vizier          Start Grok Zen Master on :4200 (needs XAI_API_KEY)
  apply [id]      Overlay a flavor (default zen-garden)
  validate [yaml] Validate harbor-flavor/v1 document
  experimentals   Serve the Experimentals station on :8088
  catalog         Print official + community flavor ids
  help            This text
EOF
}

case "$cmd" in
  garden)
    exec python3 "$ROOT/visualizer/server.py"
    ;;
  vizier)
    exec python3 "$ROOT/orchestrator/zen_master.py"
    ;;
  apply)
    export HARBOR_FLAVOR_ID="${1:-zen-garden}"
    exec bash "$ROOT/installer/install-harbor.sh"
    ;;
  validate)
    target="${1:-$ROOT/flavors/zen-garden/harbor.flavor.yaml}"
    exec python3 "$ROOT/experimentals/validate_flavor.py" "$target"
    ;;
  experimentals)
    echo "Experimentals station → http://127.0.0.1:8088/experimentals/"
    cd "$ROOT" && exec python3 -m http.server 8088
    ;;
  catalog)
    python3 - <<PY
import json
from pathlib import Path
c = json.loads(Path("$ROOT/experimentals/catalog.json").read_text())
print("official:")
for item in c.get("official", []):
    print(f"  {item['id']:20} {item['name']}")
print("community:")
for item in c.get("community", []):
    print(f"  {item['id']:20} {item['name']}  [{item.get('risk','?')}]")
print("download:", c.get("independent_download"))
PY
    ;;
  help|-h|--help)
    usage
    ;;
  *)
    echo "unknown command: $cmd" >&2
    usage
    exit 2
    ;;
esac
