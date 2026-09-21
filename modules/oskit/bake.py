#!/usr/bin/env python3
"""Print the personal ISO bake checklist. Never fetches or writes a Mint ISO."""
from __future__ import annotations

from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
VERSION = (ROOT / "VERSION").read_text(encoding="utf-8").strip()


def main() -> int:
    print(f"Harbor OS {VERSION} — personal ISO bake checklist")
    print("affiliation     independent overlay (not an official xAI product)")
    print()
    print("Why there is no Harbor .iso download")
    print("  A complete Mint image is a derived work of Ubuntu/Mint packages.")
    print("  This repo ships the overlay + flavor protocol only.")
    print()
    print("Operator path")
    print("  1. Download official Linux Mint 22.3 Cinnamon from linuxmint.com")
    print("  2. Download overlay zip:")
    print("     https://github.com/djlacavera21/harbor-os/archive/refs/heads/main.zip")
    print("  3. Install Cubic on Ubuntu/Mint")
    print("  4. Point Cubic at the official Mint ISO")
    print("  5. In the Cubic chroot:")
    print("       git clone https://github.com/djlacavera21/harbor-os /opt/harbor-os")
    print("       HARBOR_FLAVOR_ID=empire-stack bash /opt/harbor-os/iso/customize.sh")
    print("  6. Finish Cubic. Write the result with Ventoy or VirtualBox EFI")
    print()
    print("Live overlay without baking")
    print("  git clone https://github.com/djlacavera21/harbor-os.git && cd harbor-os")
    print("  ./scripts/harborctl.sh garden")
    print("  HARBOR_FLAVOR_ID=empire-stack ./scripts/harborctl.sh apply")
    print()
    print("Experimentals contract")
    print("  Grok App → Experimentals → Harbor OS     download overlay zip")
    print("  Grok App → Experimentals → Flavors       official + community YAML")
    print("  Grok App → Experimentals → Upload flavor X Premium+ submenu")
    print("  Only xAI can ship that tab. This checklist cannot.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
