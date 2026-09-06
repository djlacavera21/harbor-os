#!/usr/bin/env python3
"""Validate a Harbor OS flavor document against harbor-flavor/v1."""

from __future__ import annotations

import json
import sys
from pathlib import Path

try:
    import yaml
except ImportError:
    yaml = None  # type: ignore

REQUIRED = ("schema", "id", "name", "version", "base", "identity")
ALLOWED_DISTROS = {"linuxmint", "debian", "ubuntu", "fedora", "arch", "none"}


def load(path: Path) -> dict:
    text = path.read_text(encoding="utf-8")
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
    errors: list[str] = []
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
    return errors


def main(argv: list[str]) -> int:
    if len(argv) != 2:
        print("usage: validate_flavor.py <harbor.flavor.yaml|json>", file=sys.stderr)
        return 2
    path = Path(argv[1])
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
