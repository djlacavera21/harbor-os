# Independent Harbor OS download

Harbor OS is an overlay, not a relicensed Linux Mint ISO and not an official xAI product.

## Live links (no Grok App required)

| Surface | URL | Auth |
| --- | --- | --- |
| Source | https://github.com/djlacavera21/harbor-os | none |
| Rolling zip | https://github.com/djlacavera21/harbor-os/archive/refs/heads/main.zip | none |
| Versioned overlay zip | produced by `scripts/pack-overlay.sh` and the overlay-artifact workflow | none |
| Live station preview | https://htmlpreview.github.io/?https://github.com/djlacavera21/harbor-os/blob/main/docs/index.html | none |
| Experimentals Pages | https://djlacavera21.github.io/harbor-os/ | none, after Pages enable |
| Catalog (App contract) | https://raw.githubusercontent.com/djlacavera21/harbor-os/main/experimentals/catalog.json | none |
| Manifest | https://raw.githubusercontent.com/djlacavera21/harbor-os/main/experimentals/grok-app-manifest.json | none |
| Submit a flavor | https://github.com/djlacavera21/harbor-os/issues/new?template=submit-flavor.yml | GitHub account |

Local rehearsal of the proposed Grok App IA:

```bash
./scripts/harborctl.sh experimentals
# Harbor OS   → http://127.0.0.1:8088/docs/#official
# Flavors     → http://127.0.0.1:8088/docs/#flavors
# Upload      → http://127.0.0.1:8088/docs/#upload   (Premium+ gate is simulated)
```

## What the Grok App would consume

If xAI ships an Experimentals tab, the client should read `catalog.json` and
`grok-app-manifest.json`. Do not invent a new artifact type.

```
Grok App
 └── Experimentals
      ├── Harbor OS          catalog.official[] + overlay zip
      ├── Flavors            official[] + community[]
      └── Upload flavor      X Premium+ submenu
            harbor-flavor/v1 YAML or zip ≤ 50 MiB
```

Only xAI can render that tab or check live Premium+ entitlements. This repository
owns the overlay, the catalog, the validator, and the rehearsal UI.

## Operator install

```bash
curl -L -o harbor-os.zip https://github.com/djlacavera21/harbor-os/archive/refs/heads/main.zip
unzip harbor-os.zip
cd harbor-os-main
chmod +x scripts/*.sh installer/*.sh experimentals/validate_flavor.py
./scripts/harborctl.sh garden
HARBOR_FLAVOR_ID=zen-garden ./scripts/harborctl.sh apply
```

Bake a personal bootable ISO with official Linux Mint 22.3 + Cubic. See `iso/cubic-notes.md`.
