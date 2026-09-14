#!/usr/bin/env python3
"""Append a source note to the Research Wing inbox. Offline by default."""
from __future__ import annotations
import sys
from datetime import datetime, timezone
from pathlib import Path

INBOX = Path(__file__).resolve().parent / "INBOX.md"


def append(title: str, url: str = "", note: str = "") -> None:
    stamp = datetime.now(timezone.utc).isoformat(timespec="seconds")
    block = f"\n## {title}\n- captured: {stamp}\n"
    if url:
        block += f"- source: {url}\n"
    if note:
        block += f"- note: {note}\n"
    INBOX.parent.mkdir(parents=True, exist_ok=True)
    if not INBOX.exists():
        INBOX.write_text("# Research Wing inbox\nDrop sources here. Verification notes stay local.\n", encoding="utf-8")
    with INBOX.open("a", encoding="utf-8") as fh:
        fh.write(block)


def main(argv: list[str]) -> int:
    if len(argv) < 2:
        print("usage: collect.py <title> [url] [note...]", file=sys.stderr)
        return 2
    title = argv[1]
    url = argv[2] if len(argv) > 2 else ""
    note = " ".join(argv[3:]) if len(argv) > 3 else ""
    append(title, url, note)
    print(INBOX)
    return 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv))
