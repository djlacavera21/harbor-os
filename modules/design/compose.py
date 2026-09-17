#!/usr/bin/env python3
"""Design Wing — write a local production brief. No network."""
from __future__ import annotations

import argparse
from datetime import datetime, timezone
from pathlib import Path

ROOT = Path(__file__).resolve().parent


def main() -> int:
    parser = argparse.ArgumentParser(description="Compose a local Design Wing brief")
    parser.add_argument("title")
    parser.add_argument("--mark", default="orb", help="primary mark: orb, lantern, stone, bridge")
    parser.add_argument("--format", default="poster", help="poster, emblem, banner")
    parser.add_argument("--intent", default="sovereign signal, calm, long-horizon")
    args = parser.parse_args()
    stamp = datetime.now(timezone.utc).strftime("%Y-%m-%d")
    slug = "".join(ch.lower() if ch.isalnum() else "-" for ch in args.title).strip("-")
    path = ROOT / f"{stamp}-{slug}.md"
    path.write_text(
        f"# {args.title}\n\n"
        f"- date: {stamp}\n"
        f"- format: {args.format}\n"
        f"- mark: {args.mark}\n"
        f"- intent: {args.intent}\n"
        f"- constraint: local assets only; no required cloud account\n\n"
        "## Notes\n\nDraft here. The garden stays raked.\n",
        encoding="utf-8",
    )
    print(path)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
