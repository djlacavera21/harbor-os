#!/usr/bin/env python3
"""Rebuild modules/archives/INDEX.md from local module notes."""
from __future__ import annotations

from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
OUT = Path(__file__).resolve().parent / "INDEX.md"


def main() -> int:
    lines = ["# Archives index", "", "Generated locally. Nothing leaves the host.", ""]
    for wing in ("research", "design", "publishing", "war-room", "finance", "crew", "archives"):
        folder = ROOT / wing
        if not folder.exists():
            continue
        lines.append(f"## {wing}")
        for path in sorted(folder.rglob("*")):
            if path.is_file() and path.name not in {"index.py"}:
                rel = path.relative_to(ROOT)
                lines.append(f"- `{rel}` ({path.stat().st_size} B)")
        lines.append("")
    OUT.write_text("\n".join(lines), encoding="utf-8")
    print(OUT)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
