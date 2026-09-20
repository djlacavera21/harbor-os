#!/usr/bin/env python3
"""Print the independent Experimentals download card."""
from __future__ import annotations

import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
VERSION = (ROOT / "VERSION").read_text(encoding="utf-8").strip()
CATALOG = ROOT / "experimentals" / "catalog.json"


def main() -> int:
    catalog = json.loads(CATALOG.read_text(encoding="utf-8"))
    official = catalog.get("official") or []
    community = catalog.get("community") or []
    print(f"Harbor OS {VERSION} — independent Experimentals card")
    print("affiliation     independent (not an official xAI product)")
    print(f"source          {catalog.get('source')}")
    print(f"download        {catalog.get('independent_download')}")
    print(f"station         {catalog.get('independent_station_preview')}")
    print(f"pages           {catalog.get('pages')}")
    print(f"catalog         {catalog.get('source')}/blob/main/experimentals/catalog.json")
    print(f"manifest        {catalog.get('manifest')}")
    print("proposed tab    Grok App → Experimentals")
    print("  Harbor OS     catalog.official[] + overlay zip")
    print("  Flavors       official[] + community[]")
    print("  Upload flavor X Premium+ submenu · harbor-flavor/v1 ≤ 50 MiB")
    print(f"official        {len(official)}  " + ", ".join(item.get("id", "?") for item in official))
    print(f"community       {len(community)}  " + ", ".join(item.get("id", "?") for item in community))
    print("note            This card cannot install a tab inside the Grok App.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
