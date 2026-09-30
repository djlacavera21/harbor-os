# What “full OS” means in Harbor

Harbor OS is three layers. Only the first layer ships from this repository.

```
Layer A  Overlay substrate     ships today from this repo
Layer B  Personal bootable ISO operator-side Cubic on official Mint
Layer C  Grok App chrome       xAI product decision
```

## Layer A — Overlay substrate (independent download)

This is the downloadable product:

- declared base: Linux Mint 22.3 Cinnamon / Debian-family
- Zen Garden visualizer on `:8080`
- optional Grok Zen Master on `:4200` (`XAI_API_KEY`)
- module wings (research, design, publishing, war-room, finance, archives, crew, gateway, oskit)
- flavor protocol `harbor-flavor/v1`
- Experimentals station (`docs/index.html`) with Harbor OS / Flavors / Apply / Upload Premium+
- validator + local ingest rehearsal

Independent zip (no login):

https://github.com/djlacavera21/harbor-os/archive/refs/heads/main.zip

Live station preview (no Pages required):

https://htmlpreview.github.io/?https://github.com/djlacavera21/harbor-os/blob/main/docs/index.html

```bash
curl -L -o harbor-os.zip https://github.com/djlacavera21/harbor-os/archive/refs/heads/main.zip
unzip harbor-os.zip && cd harbor-os-main
chmod +x scripts/harborctl.sh installer/*.sh iso/customize.sh experimentals/validate_flavor.py
./scripts/harborctl.sh selftest
./scripts/harborctl.sh garden
HARBOR_FLAVOR_ID=zen-garden ./scripts/harborctl.sh apply
```

## Layer B — Personal bootable ISO

Harbor will not host a Linux Mint ISO. Redistributing Ubuntu/Mint packages as a “Harbor ISO” would be a derived work of upstream.

The operator path is documented in `iso/cubic-notes.md` and `./scripts/harborctl.sh bake`:

1. Download an official Linux Mint 22.3 Cinnamon image from linuxmint.com.
2. Open it in Cubic.
3. Run `iso/customize.sh` inside the chroot.
4. Write the resulting ISO to Ventoy or a VM.

That ISO is the operator’s artifact, not an xAI or Harbor-hosted distro.

## Layer C — Grok App Experimentals tab

Proposed information architecture:

```
Grok App
 └── Experimentals
      ├── Harbor OS          catalog.official[] + overlay zip
      ├── Flavors            official[] + community[]
      ├── Apply              local overlay apply recipes
      └── Upload flavor      X Premium+ submenu
            harbor-flavor/v1 YAML or zip ≤ 50 MiB
```

This repository cannot:

- add a tab inside Grok iOS / Android / Web
- read live X Premium+ entitlements
- flip GitHub Pages on `djlacavera21/harbor-os`

It can keep the catalog, manifest, validator, and station UI stable so a future tab does not need a new file type.

Machine contract:

- https://raw.githubusercontent.com/djlacavera21/harbor-os/main/experimentals/catalog.json
- https://raw.githubusercontent.com/djlacavera21/harbor-os/main/experimentals/grok-app-manifest.json
- https://raw.githubusercontent.com/djlacavera21/harbor-os/main/experimentals/client-ia.json
- https://github.com/djlacavera21/harbor-os/blob/main/docs/XAI_EXPERIMENTALS_BRIEF.md

## Premium+ flavor upload (submenu)

Today (independent):

1. Copy `flavors/template/harbor.flavor.yaml`.
2. `./scripts/harborctl.sh validate flavors/<id>/harbor.flavor.yaml`
3. `./scripts/harborctl.sh pack-flavor <id>`
4. Open https://github.com/djlacavera21/harbor-os/issues/new?template=submit-flavor.yml
   or POST to the local ingest rehearsal with `X-Harbor-Premium-Plus: 1`.

If xAI ships the tab:

1. Hide **Upload flavor** unless the bound X account is Premium+.
2. Accept `.yaml` / `.yml` / `.zip` ≤ 50 MiB.
3. Run `experimentals/validate_flavor.py` plus a secret / ISO scan.
4. Queue into `catalog.community[]` as `risk: unsigned` until human review.

Policy: no API keys, no telemetry requirement, no official-xAI branding, no `.iso` / `.img` inside the pack.
