#!/usr/bin/env bash
# Validate every flavor and refuse ISO leakage in the overlay tree.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
fail=0
echo "Harbor OS selftest $(tr -d '[:space:]' < "$ROOT/VERSION")"
if find "$ROOT" \( -iname '*.iso' -o -iname '*.img' \) | grep -q .; then
  echo "FAIL overlay contains ISO/IMG artifacts" >&2
  fail=1
else
  echo "OK no ISO/IMG in tree"
fi
for flavor in "$ROOT"/flavors/*/harbor.flavor.yaml; do
  if python3 "$ROOT/experimentals/validate_flavor.py" "$flavor"; then
    :
  else
    fail=1
  fi
done
python3 -m json.tool "$ROOT/experimentals/catalog.json" >/dev/null
python3 -m json.tool "$ROOT/experimentals/grok-app-manifest.json" >/dev/null
python3 -m json.tool "$ROOT/spec/harbor-flavor.schema.json" >/dev/null
echo "OK catalog + manifest + schema parse"
if [[ "$fail" -ne 0 ]]; then
  echo "SELFTEST FAILED" >&2
  exit 1
fi
echo "SELFTEST PASSED"
