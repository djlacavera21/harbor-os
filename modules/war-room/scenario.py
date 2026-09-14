#!/usr/bin/env python3
"""Append a strategy scenario to the War Room board."""
from __future__ import annotations
import sys
from datetime import datetime, timezone
from pathlib import Path

BOARD = Path(__file__).resolve().parent / "BOARD.md"


def append(name: str, horizon: str = "90d", note: str = "") -> None:
    stamp = datetime.now(timezone.utc).isoformat(timespec="seconds")
    block = f"\n## {name}\n- recorded: {stamp}\n- horizon: {horizon}\n"
    if note:
        block += f"- sketch: {note}\n"
    BOARD.parent.mkdir(parents=True, exist_ok=True)
    if not BOARD.exists():
        BOARD.write_text("# Strategy board\n", encoding="utf-8")
    with BOARD.open("a", encoding="utf-8") as fh:
        fh.write(block)


def main(argv: list[str]) -> int:
    if len(argv) < 2:
        print("usage: scenario.py <name> [horizon] [note...]", file=sys.stderr)
        return 2
    name = argv[1]
    horizon = argv[2] if len(argv) > 2 else "90d"
    note = " ".join(argv[3:]) if len(argv) > 3 else ""
    append(name, horizon, note)
    print(BOARD)
    return 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv))
