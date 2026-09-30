#!/usr/bin/env python3
"""Print the three-layer Harbor OS path."""
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
VERSION = (ROOT / "VERSION").read_text().strip()

TEXT = f"""Harbor OS {VERSION} — full OS kit (independent)

Layer A  Overlay substrate     LIVE
         zip  https://github.com/djlacavera21/harbor-os/archive/refs/heads/main.zip
         src  https://github.com/djlacavera21/harbor-os
         ui   https://htmlpreview.github.io/?https://github.com/djlacavera21/harbor-os/blob/main/docs/index.html

Layer B  Personal bootable ISO OPERATOR
         official Mint 22.3 Cinnamon + Cubic + iso/customize.sh
         checklist: ./scripts/harborctl.sh bake
         Harbor does not host a Mint ISO.

Layer C  Grok App Experimentals tab  XAI ONLY
         proposed:
           Grok App
            └── Experimentals
                 ├── Harbor OS
                 ├── Flavors
                 ├── Apply
                 └── Upload flavor   (X Premium+)
         catalog  https://raw.githubusercontent.com/djlacavera21/harbor-os/main/experimentals/catalog.json
         manifest https://raw.githubusercontent.com/djlacavera21/harbor-os/main/experimentals/grok-app-manifest.json

Apply overlay:
  HARBOR_FLAVOR_ID=zen-garden ./scripts/harborctl.sh apply

Author a flavor (same document the Premium+ submenu would accept):
  ./scripts/harborctl.sh new-flavor my-harbor "My Harbor"
  ./scripts/harborctl.sh validate flavors/my-harbor/harbor.flavor.yaml
  ./scripts/harborctl.sh pack-flavor my-harbor
  https://github.com/djlacavera21/harbor-os/issues/new?template=submit-flavor.yml

This overlay cannot mutate the Grok App. Enable Pages yourself:
  https://github.com/djlacavera21/harbor-os/settings/pages
"""

if __name__ == "__main__":
    print(TEXT)
