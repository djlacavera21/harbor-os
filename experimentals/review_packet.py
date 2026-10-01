#!/usr/bin/env python3
"""Turn a valid harbor-flavor/v1 document into a Premium+ review packet.

The packet is what an Experimentals "Upload flavor" submenu should enqueue:
a catalog.community[] draft (risk=unsigned) plus a GitHub issue body.
It does not check live X Premium+ entitlements. That gate belongs to xAI.
"""
from __future__ import annotations

import json
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from validate_flavor import load, validate  # noqa: E402

SUBMIT = "https://github.com/djlacavera21/harbor-os/issues/new?template=submit-flavor.yml"
MAX_BYTES = 50 * 1024 * 1024


def packet(data: dict) -> dict:
    ident = data["id"]
    entry = {
        "id": ident,
        "name": data["name"],
        "version": data["version"],
        "channel": "community",
        "download": f"https://github.com/djlacavera21/harbor-os/tree/main/flavors/{ident}",
        "source": f"https://github.com/djlacavera21/harbor-os/tree/main/flavors/{ident}",
        "flavor": f"flavors/{ident}/harbor.flavor.yaml",
        "risk": "unsigned",
        "min_subscription": "none",
        "summary": (data.get("summary") or data.get("identity", {}).get("tagline") or "Community flavor. Unsigned until review.")[:240],
    }
    body = "\n".join([
        "## Flavor upload (Experimentals / Premium+ rehearsal)",
        "",
        "This packet was produced by `experimentals/review_packet.py`.",
        "It is not an official Grok App submission. Live Premium+ checks belong to xAI.",
        "",
        f"- id: `{ident}`",
        f"- name: {data['name']}",
        f"- version: {data['version']}",
        f"- base: {(data.get('base') or {}).get('distro')} {(data.get('base') or {}).get('release', '')}".rstrip(),
        "- risk: unsigned",
        "- contains ISO / disk image: no",
        "",
        "### Proposed catalog.community[] entry",
        "",
        "```json",
        json.dumps(entry, indent=2),
        "```",
        "",
        f"Submit: {SUBMIT}",
    ])
    return {"ok": True, "catalog_entry": entry, "issue_body": body, "submit": SUBMIT}


def main(argv: list[str]) -> int:
    if len(argv) != 2:
        print("usage: review_packet.py <harbor.flavor.yaml|json>", file=sys.stderr)
        return 2
    path = Path(argv[1])
    if path.stat().st_size > MAX_BYTES:
        print("INVALID over 50 MiB", file=sys.stderr)
        return 1
    data = load(path)
    errors = validate(data)
    if errors:
        print(json.dumps({"ok": False, "errors": errors}, indent=2))
        return 1
    print(json.dumps(packet(data), indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv))
