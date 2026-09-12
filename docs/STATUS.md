# Harbor OS status — 12 September 2026 (Experimentals station v1.1)

Harbor OS is a **declared-base overlay + flavor protocol**, not a from-scratch kernel
and not an official xAI product.

## What is live today

| Surface | URL | State |
| --- | --- | --- |
| Source | https://github.com/djlacavera21/harbor-os | Public |
| Independent zip | https://github.com/djlacavera21/harbor-os/archive/refs/heads/main.zip | Public, no login |
| Catalog (app contract) | https://raw.githubusercontent.com/djlacavera21/harbor-os/main/experimentals/catalog.json | Public |
| Manifest | https://raw.githubusercontent.com/djlacavera21/harbor-os/main/experimentals/grok-app-manifest.json | Public |
| Flavor submit | https://github.com/djlacavera21/harbor-os/issues/new?template=submit-flavor.yml | Public |
| Pages station | https://djlacavera21.github.io/harbor-os/ | **Owner must enable Pages** |
| Official Grok App tab | — | **Not shippable from this repo** |

## What Harbor is

- Overlay for Linux Mint 22.3 Cinnamon (Debian-family also accepted)
- Official flavor: FreshOS Zen Garden (`flavors/zen-garden`)
- Community flavors: War Room, Research, Airgap TUI, Publishing
- Zen Garden visualizer on `127.0.0.1:8080`
- Optional Grok Zen Master on `127.0.0.1:4200` (needs `XAI_API_KEY`)
- `harbor-flavor/v1` YAML + validator
- Experimentals station UI that rehearses the proposed Grok App IA (`#official`, `#flavors`, `#upload`)
- Cubic notes so an operator can bake their own bootable ISO from an official Mint image

## What Harbor is not

- Not a kernel fork
- Not a redistributable Linux Mint ISO (legal: derived work of Ubuntu/Mint)
- Not an official Grok / xAI operating system
- Not able to insert an Experimentals tab into the Grok iOS, Android, or Web apps
- Not able to read live X Premium+ entitlements

## Experimentals IA (proposed for Grok App, implemented independently)

```
Grok App                         Independent station (ships today)
 └── Experimentals                docs/index.html (hash routes #official #flavors #upload) + experimentals/
      ├── Harbor OS               official catalog + zip
      ├── Flavors                 official + community YAML
      └── Upload flavor           X Premium+ only
            accepts harbor-flavor/v1 YAML or zip ≤ 50 MiB
```

xAI owns chrome and entitlements. This repo owns the overlay, the catalog schema,
the validator, and the rehearsal UI.

## Operator commands

```bash
git clone https://github.com/djlacavera21/harbor-os.git
cd harbor-os
chmod +x scripts/harborctl.sh installer/*.sh iso/customize.sh experimentals/validate_flavor.py
./scripts/harborctl.sh garden          # http://127.0.0.1:8080
./scripts/harborctl.sh experimentals   # http://127.0.0.1:8088/docs/  and /experimentals/
./scripts/harborctl.sh station         # TUI agent station
HARBOR_FLAVOR_ID=zen-garden ./scripts/harborctl.sh apply
./scripts/harborctl.sh validate flavors/template/harbor.flavor.yaml
```

## 12 September 2026 evening

- Experimentals station now uses Grok-app rehearsal chrome (Chat/Imagine/Voice muted; Experimentals active).
- `docs/station.js` is a full copy of `experimentals/station.js` so branch-based Pages works without a second fetch.
- Overlay zip artifact workflow added (not a Mint ISO).
- Pages URL remains 404 until the owner enables Settings → Pages.
