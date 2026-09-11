#!/usr/bin/env python3
"""Validate a Harbor OS flavor document against harbor-flavor/v1."""
from __future__ import annotations
import json, sys
from pathlib import Path
try:
    import yaml
except ImportError:
    yaml = None
REQUIRED = ("schema", "id", "name", "version", "base", "identity")
ALLOWED_DISTROS = {"linuxmint", "debian", "ubuntu", "fedora", "arch", "none"}
SECRET_MARKERS = ("api_key", "xai_api_key", "begin rsa private", "begin openssh private", "sk-proj-", "sk-or-")
FORBIDDEN_CLAIMS = ("official xai os", "official grok os", "official xai operating system", "official grok operating system")

def load(path: Path) -> dict:
    text = path.read_text(encoding="utf-8")
    if path.suffix.lower() in {".iso", ".img"}:
        raise SystemExit("ISO / disk images are forbidden as flavor documents")
    if path.suffix in {".yaml", ".yml"}:
        if yaml is None:
            raise SystemExit("PyYAML is required to validate .yaml flavors")
        data = yaml.safe_load(text)
    else:
        data = json.loads(text)
    if not isinstance(data, dict):
        raise SystemExit("flavor document must be an object")
    return data

def validate(data: dict) -> list[str]:
    errors = []
    for key in REQUIRED:
        if key not in data:
            errors.append(f"missing required field: {key}")
    if data.get("schema") != "harbor-flavor/v1":
        errors.append("schema must be harbor-flavor/v1")
    ident = data.get("id", "")
    if not isinstance(ident, str) or len(ident) < 3:
        errors.append("id must be a slug at least 3 characters")
    base = data.get("base") or {}
    if base.get("distro") not in ALLOWED_DISTROS:
        errors.append(f"unsupported base.distro: {base.get('distro')}")
    identity = data.get("identity") or {}
    if "os_name" not in identity or "codename" not in identity:
        errors.append("identity requires os_name and codename")
    if data.get("experimentals", {}).get("min_subscription") not in {None, "none", "premium", "premium-plus"}:
        errors.append("experimentals.min_subscription invalid")
    blob = json.dumps(data, default=str).lower()
    for secret in SECRET_MARKERS:
        if secret in blob:
            errors.append(f"possible secret material: {secret}")
    for claim in FORBIDDEN_CLAIMS:
        if claim in blob:
            errors.append("community flavors may not claim official xAI / Grok OS status")
            break
    for key in ("iso", "disk_image", "img"):
        val = data.get(key)
        if isinstance(val, str) and val.lower().endswith((".iso", ".img")):
            errors.append("flavor documents must not reference ISO / disk images")
    return errors

def main(argv: list[str]) -> int:
    if len(argv) != 2:
        print("usage: validate_flavor.py <harbor.flavor.yaml|json>", file=sys.stderr)
        return 2
    path = Path(argv[1])
    if not path.exists():
        print(f"missing file: {path}", file=sys.stderr)
        return 2
    data = load(path)
    errors = validate(data)
    if errors:
        print(f"INVALID {path}")
        for err in errors:
            print(f"  - {err}")
        return 1
    print(f"VALID {data['id']}@{data['version']} ({data['name']})")
    return 0

if __name__ == "__main__":
    raise SystemExit(main(sys.argv))
