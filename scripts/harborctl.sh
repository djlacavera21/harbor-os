#!/usr/bin/env bash
# Harbor OS station control — garden, flavor apply, Experimentals rehearsal.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cmd="${1:-help}"
if [[ $# -gt 0 ]]; then
  shift
fi

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
  app-contract    Print the proposed Grok App Experimentals IA + live URLs
  pack            Build dist/harbor-os-<version>-overlay.zip
  pack-flavor     Build a Premium+ upload zip for flavors/<id>
  new-flavor      Scaffold flavors/<slug>/harbor.flavor.yaml
  ingest          Local Premium+ upload rehearsal on :8090
  selftest        Validate every flavor and refuse ISO leakage
  status          Print overlay version, flavor, wings, and ports
  card            Print the independent Experimentals download card
  bake            Print the personal Mint+Cubic ISO bake checklist
  help            This text
EOF
}

app_contract() {
  HARBOR_ROOT="$ROOT" python3 -c '
import json, os
from pathlib import Path
root = Path(os.environ["HARBOR_ROOT"])
manifest = json.loads((root / "experimentals/grok-app-manifest.json").read_text())
ia = json.loads((root / "experimentals/client-ia.json").read_text())
print("Harbor OS app-contract")
print("overlay        " + str(manifest.get("overlay_version")))
print("affiliation    %s  official_xai=%s" % (manifest.get("affiliation"), manifest.get("official_xai_product")))
print("can_mutate_app %s" % (not manifest.get("cannot_mutate_grok_app", True)))
print("proposed tab   Grok App -> Experimentals")
for item in manifest.get("proposed_grok_app_ia", {}).get("items", []):
    gate = item.get("min_subscription", "none")
    action = item.get("primary_action", item.get("on_success", ""))
    print("  - %-16s gate=%-13s action=%s" % (item.get("label"), gate, action))
print("independent download")
for key, url in (manifest.get("surfaces") or {}).items():
    print("  %-28s %s" % (key, url))
print("client rules")
for rule in ia.get("client_rules", []):
    print("  * " + rule)
print("note: only xAI can render the tab or check live Premium+ entitlements.")
'
}

print_status() {
  HARBOR_ROOT="$ROOT" python3 -c '
import os
from pathlib import Path
root = Path(os.environ["HARBOR_ROOT"])
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
print("Harbor OS " + version)
print("flavor     " + flavor)
print("garden     http://127.0.0.1:8080")
print("vizier     http://127.0.0.1:4200/docs  (needs XAI_API_KEY)")
print("station    http://127.0.0.1:8088/docs/")
print("ingest     http://127.0.0.1:8090/upload")
print("api_key    " + ("set" if os.environ.get("XAI_API_KEY") else "absent"))
print("wings      " + ", ".join(wings))
print("download   https://github.com/djlacavera21/harbor-os/archive/refs/heads/main.zip")
print("note       Independent overlay. Cannot add an Experimentals tab to the Grok App.")
'
}

print_catalog() {
  HARBOR_ROOT="$ROOT" python3 -c '
import json, os
from pathlib import Path
root = Path(os.environ["HARBOR_ROOT"])
c = json.loads((root / "experimentals/catalog.json").read_text())
print("official:")
for item in c.get("official", []):
    print("  %-20s %s" % (item["id"], item["name"]))
print("community:")
for item in c.get("community", []):
    print("  %-20s %s  [%s]" % (item["id"], item["name"], item.get("risk", "unknown")))
print("download:", c.get("independent_download"))
print("pages:", c.get("pages"))
print("preview:", c.get("independent_station_preview"))
'
}

print_links() {
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
}

case "$cmd" in
  garden) exec python3 "$ROOT/visualizer/server.py" ;;
  vizier) exec python3 "$ROOT/orchestrator/zen_master.py" ;;
  apply)
    export HARBOR_FLAVOR_ID="${1:-zen-garden}"
    exec bash "$ROOT/installer/install-harbor.sh"
    ;;
  validate)
    target="${1:-$ROOT/flavors/zen-garden/harbor.flavor.yaml}"
    exec python3 "$ROOT/experimentals/validate_flavor.py" "$target"
    ;;
  experimentals)
    echo "Experimentals station -> http://127.0.0.1:8088/docs/"
    echo "                     -> http://127.0.0.1:8088/experimentals/"
    cd "$ROOT" && exec python3 -m http.server 8088
    ;;
  station) exec bash "$ROOT/scripts/agent-station.sh" ;;
  links) print_links ;;
  pack) exec bash "$ROOT/scripts/pack-overlay.sh" "${1:-$ROOT/dist}" ;;
  pack-flavor) exec bash "$ROOT/scripts/pack-flavor.sh" "${1:-}" "${2:-$ROOT/dist/flavors}" ;;
  app-contract) app_contract ;;
  ingest) exec python3 "$ROOT/experimentals/ingest.py" ;;
  selftest) exec bash "$ROOT/scripts/selftest.sh" ;;
  status) print_status ;;
  card) exec python3 "$ROOT/modules/gateway/card.py" ;;
  bake) exec python3 "$ROOT/modules/oskit/bake.py" ;;
  new-flavor) exec bash "$ROOT/scripts/new-flavor.sh" "${1:-}" "${2:-}" ;;
  catalog) print_catalog ;;
  help|-h|--help) usage ;;
  *)
    echo "unknown command: $cmd" >&2
    usage
    exit 2
    ;;
esac
