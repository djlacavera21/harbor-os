#!/usr/bin/env python3
"""Crew Quarters — write a local daily briefing. No network."""
from __future__ import annotations

import argparse
from datetime import datetime, timezone
from pathlib import Path

ROOT = Path(__file__).resolve().parent


def main() -> int:
    parser = argparse.ArgumentParser(description="Compose a local Crew Quarters briefing")
    parser.add_argument("focus", nargs="?", default="Keep the garden raked.")
    parser.add_argument("--watch", default="visualizer, archives, standing-orders")
    args = parser.parse_args()
    stamp = datetime.now(timezone.utc).strftime("%Y-%m-%d")
    path = ROOT / f"{stamp}-briefing.md"
    path.write_text(
        f"# Crew briefing — {stamp}\n\n"
        f"- focus: {args.focus}\n"
        f"- watch: {args.watch}\n"
        f"- constraint: offline-first; no telemetry; operator in command\n\n"
        "## Standing reminder\n\n"
        "Grok is Vizier. The operator remains Emperor.\n"
        "Do not present this overlay as an official xAI operating system.\n",
        encoding="utf-8",
    )
    print(path)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
