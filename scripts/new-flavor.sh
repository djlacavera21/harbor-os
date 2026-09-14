#!/usr/bin/env bash
# Scaffold a community Harbor flavor from flavors/template.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
id="${1:-}"
name="${2:-}"
if [[ -z "$id" || -z "$name" ]]; then
  echo "usage: new-flavor.sh <slug> <display name>" >&2
  exit 2
fi
if [[ ! "$id" =~ ^[a-z0-9-]{3,40}$ ]]; then
  echo "id must be a 3-40 char lowercase slug" >&2
  exit 2
fi
dest="$ROOT/flavors/$id"
if [[ -e "$dest" ]]; then
  echo "already exists: $dest" >&2
  exit 1
fi
mkdir -p "$dest"
sed -e "s/my-harbor-flavor/$id/g" \
    -e "s/My Harbor Flavor/$name/g" \
    "$ROOT/flavors/template/harbor.flavor.yaml" > "$dest/harbor.flavor.yaml"
echo "$dest/harbor.flavor.yaml"
echo "Next: edit the YAML, then ./scripts/harborctl.sh validate $dest/harbor.flavor.yaml"
