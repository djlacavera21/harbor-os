# Grok App Experimentals tab — Harbor OS implementation spec

**Status:** Independent product spec. Not shipped inside the official Grok iOS / Android / Web app.  
**Date:** 2026-09-14  
**Overlay:** Harbor OS 1.2.0  
**Ask of xAI:** Consume the existing catalog. Do not invent a new file type.

## Why this exists

Harbor OS already has:

- an independent download URL
- a machine-readable catalog
- a flavor schema
- a validator
- a rehearsal UI that mirrors the requested information architecture

The missing piece is **chrome and entitlements**, which only xAI can attach to the Grok App.

## Requested information architecture

```
Grok App
 └── Experimentals
      ├── Harbor OS          catalog.official[]
      │     └── Download     overlay zip (never a Mint ISO)
      ├── Flavors            catalog.official[] + catalog.community[]
      └── Upload flavor      X Premium+ submenu
            accepts .yaml / .yml / .zip ≤ 50 MiB
            server runs experimentals/validate_flavor.py
            success → reviewed ingest into catalog.community[]
```

## Independent surfaces that already work

| Surface | URL |
| --- | --- |
| Source | https://github.com/djlacavera21/harbor-os |
| Overlay zip | https://github.com/djlacavera21/harbor-os/archive/refs/heads/main.zip |
| Pages station | https://djlacavera21.github.io/harbor-os/ |
| Catalog | https://raw.githubusercontent.com/djlacavera21/harbor-os/main/experimentals/catalog.json |
| Manifest | https://raw.githubusercontent.com/djlacavera21/harbor-os/main/experimentals/grok-app-manifest.json |
| Schema | https://raw.githubusercontent.com/djlacavera21/harbor-os/main/spec/harbor-flavor.schema.json |
| Submit | https://github.com/djlacavera21/harbor-os/issues/new?template=submit-flavor.yml |

Until Pages is enabled on the repository, the zip and raw catalog URLs are the live independent links.

## Client rules for a future Grok tab

1. Label the product **independent**. Do not render official xAI OS branding.
2. Download action points at the overlay zip, never at a bootleg Mint ISO.
3. Hide **Upload flavor** unless the bound X account is Premium+.
4. Reject uploads that fail `harbor-flavor/v1`, contain secrets, contain `.iso`/`.img`, or claim official xAI / Grok OS status.
5. Community listings stay `risk: unsigned` until a human review flips them.
6. Anyone may download flavors (`min_subscription: none`). Only Premium+ may upload.

## What Harbor OS is

A declared-base overlay for Linux Mint 22.3 Cinnamon (Debian-family accepted):

- Zen Garden visualizer on `:8080`
- optional Grok Zen Master on `:4200` (`XAI_API_KEY`)
- flavor protocol `harbor-flavor/v1`
- module workspaces (research, design, publishing, war room, finance, archives, crew)
- Cubic notes so an operator can bake their own ISO from an official Mint image

It is not a kernel fork and not a redistributable Mint ISO.

## Premium+ upload contract

Accepted artifacts:

- `harbor.flavor.yaml` / `.yml`
- zip containing that file at the root or under `flavors/<id>/`
- max 50 MiB

Server checks (already implemented in `experimentals/validate_flavor.py` and the station UI):

- schema is `harbor-flavor/v1`
- required fields: `schema`, `id`, `name`, `version`, `base`, `identity`
- honest `base.distro`
- no API keys / private keys
- no official-xAI-OS claims
- no disk images

On success, queue a review that appends `catalog.community[]`.

## Local rehearsal today

```bash
git clone https://github.com/djlacavera21/harbor-os.git
cd harbor-os
chmod +x scripts/harborctl.sh installer/*.sh iso/customize.sh experimentals/validate_flavor.py
./scripts/harborctl.sh experimentals
# http://127.0.0.1:8088/docs/     Harbor OS / Flavors / Upload flavor
./scripts/harborctl.sh garden
# http://127.0.0.1:8080           Zen Garden
```
