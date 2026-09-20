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
  station         TUI Agent Station (air-gap friendly)
  catalog         Print official + community flavor ids
  links           Print independent download URLs
  pack            Build dist/harbor-os-<version>-overlay.zip
  new-flavor      Scaffold flavors/<slug>/harbor.flavor.yaml
  ingest          Local Premium+ upload rehearsal on :8090
  selftest        Validate every flavor and refuse ISO leakage
  status          Print overlay version, flavor, wings, and ports
  card            Print the independent Experimentals download card
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
    echo "Experimentals station → http://127.0.0.1:8088/docs/"
    echo "                     → http://127.0.0.1:8088/experimentals/"
    cd "$ROOT" && exec python3 -m http.server 8088
    ;;
  station)
    exec bash "$ROOT/scripts/agent-station.sh"
    ;;
  links)
    cat <<'EOF'
source     https://github.com/djlacavera21/harbor-os
zip        https://github.com/djlacavera21/harbor-os/archive/refs/heads/main.zip
preview    https://htmlpreview.github.io/?https://github.com/djlacavera21/harbor-os/blob/main/docs/index.html
pages      https://djlacavera21.github.io/harbor-os/   (owner must enable Pages)
station    https://htmlpreview.github.io/?https://github.com/djlacavera21/harbor-os/blob/main/docs/index.html#official
flavors    https://htmlpreview.github.io/?https://github.com/djlacavera21/harbor-os/blob/main/docs/index.html#flavors
upload     https://htmlpreview.github.io/?https://github.com/djlacavera21/harbor-os/blob/main/docs/index.html#upload
catalog    https://raw.githubusercontent.com/djlacavera21/harbor-os/main/experimentals/catalog.json
manifest   https://raw.githubusercontent.com/djlacavera21/harbor-os/main/experimentals/grok-app-manifest.json
submit     https://github.com/djlacavera21/harbor-os/issues/new?template=submit-flavor.yml
guide      https://github.com/djlacavera21/harbor-os/blob/main/docs/DOWNLOAD.md
EOF
    ;;
  pack)
    exec bash "$ROOT/scripts/pack-overlay.sh" "${1:-$ROOT/dist}"
    ;;
  ingest)
    exec python3 "$ROOT/experimentals/ingest.py"
    ;;
  selftest)
    exec bash "$ROOT/scripts/selftest.sh"
    ;;
  status)
    python3 - <<PY
import os
from pathlib import Path
root = Path("$ROOT")
version = (root / "VERSION").read_text().strip()
flavor = os.environ.get("HARBOR_FLAVOR_ID", "zen-garden")
for candidate in (
    Path.home() / ".local/share/harbor-os/identity.env",
    Path("/etc/harbor-os/identity.env"),
    Path.home() / ".config/harbor-os/identity.env",
):
    if candidate.exists():
        for line in candidate.read_text().splitlines():
            if line.startswith("HARBOR_FLAVOR_ID="):
                flavor = line.split("=", 1)[1].strip()
wings = sorted(p.name for p in (root / "modules").iterdir() if p.is_dir() and not p.name.startswith("."))
print(f"Harbor OS {version}")
print(f"flavor     {flavor}")
print(f"garden     http://127.0.0.1:8080")
print(f"vizier     http://127.0.0.1:4200/docs  (needs XAI_API_KEY)")
print(f"station    http://127.0.0.1:8088/docs/")
print(f"ingest     http://127.0.0.1:8090/upload")
print(f"api_key    {'set' if os.environ.get('XAI_API_KEY') else 'absent'}")
print(f"wings      {', '.join(wings)}")
print("download   https://github.com/djlacavera21/harbor-os/archive/refs/heads/main.zip")
print("note       Independent overlay. Cannot add an Experimentals tab to the Grok App.")
PY
    ;;
  card)
    exec python3 "$ROOT/modules/gateway/card.py"
    ;;
  new-flavor)
    exec bash "$ROOT/scripts/new-flavor.sh" "${1:-}" "${2:-}"
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
print("pages:", c.get("pages"))
print("preview:", c.get("independent_station_preview"))
PY
    ;;
  help|-h|--help)
    usage()
    ;;
  *)
    echo "unknown command: $cmd" >&2
    usage
    exit 2
    ;;
esac
