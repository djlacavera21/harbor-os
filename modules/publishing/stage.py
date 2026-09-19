#!/usr/bin/env python3
"""Stage an outbound draft locally. Distribution is a separate act."""
from __future__ import annotations

import re
import sys
from datetime import datetime, timezone
from pathlib import Path

ROOT = Path(__file__).resolve().parent
DRAFTS = ROOT / "drafts"
OUTBOUND = ROOT / "OUTBOUND.md"


def slug(text: str) -> str:
    cleaned = re.sub(r"[^a-z0-9]+", "-", text.lower()).strip("-")
    return cleaned[:48] or "draft"


def main(argv: list[str]) -> int:
    title = " ".join(argv[1:]).strip()
    if not title:
        print("usage: stage.py <title>", file=sys.stderr)
        return 2
    DRAFTS.mkdir(parents=True, exist_ok=True)
    stamp = datetime.now(timezone.utc).strftime("%Y-%m-%d")
    path = DRAFTS / f"{stamp}-{slug(title)}.md"
    body = (
        f"# {title}\n\n"
        f"Staged locally on {stamp}. Status: hold.\n\n"
        "Do not put platform passwords or API keys in this file.\n"
        "Promotion to a public channel is a conscious later step.\n"
    )
    path.write_text(body, encoding="utf-8")
    if not OUTBOUND.exists():
        OUTBOUND.write_text(
            "# Publishing outbound\n\n"
            "Stage drafts locally. Distribution is a separate, conscious act.\n\n"
            "## Queue\n\n"
            "| Draft | Channel | Status | Date |\n"
            "| --- | --- | --- | --- |\n",
            encoding="utf-8",
        )
    with OUTBOUND.open("a", encoding="utf-8") as fh:
        fh.write(f"| `{path.name}` | local-archive | hold | {stamp} |\n")
    print(path)
    return 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv))
