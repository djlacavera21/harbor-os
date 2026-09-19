#!/usr/bin/env python3
"""Append a local memory note and refresh INDEX.md."""
from __future__ import annotations

import subprocess
import sys
from datetime import datetime, timezone
from pathlib import Path

ROOT = Path(__file__).resolve().parent
MEMORY = ROOT / "MEMORY.md"
INDEXER = ROOT / "index.py"


def main(argv: list[str]) -> int:
    note = " ".join(argv[1:]).strip()
    if not note:
        print("usage: remember.py <note>", file=sys.stderr)
        return 2
    stamp = datetime.now(timezone.utc).strftime("%Y-%m-%d %H:%M UTC")
    if not MEMORY.exists():
        MEMORY.write_text(
            "# Local memory\n\nNotes stay on this host. Do not put API keys here.\n\n",
            encoding="utf-8",
        )
    with MEMORY.open("a", encoding="utf-8") as fh:
        fh.write(f"- {stamp} — {note}\n")
    print(MEMORY)
    if INDEXER.exists():
        subprocess.run([sys.executable, str(INDEXER)], check=False)
    return 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv))
