# Grok App Integration Limitations and Proposed Contract

## Integration Limitations

- **Repository Scope**: This repository provides a Mint-family overlay, flavor protocol, Cubic notes, GitHub source, zip downloads, and an Experimentals interface in `docs/index.html` / `experimentals/` with `catalog.json`. It supports independent downloads via GitHub (and GitHub Pages after the owner enables it).
- **App Tab Limitation**: The repository **cannot** add a tab inside the official Grok iOS, Android, or Web application. Only xAI can render the Experimentals tab in the Grok App.
- **Premium+ Features**: The repository includes a local gate, validator, and submission packet for the Premium+ upload submenu, but only xAI can read live X Premium+ entitlements.
- **Pages Limitation**: `has_pages` is currently false. The owner must open [Settings → Pages](https://github.com/djlacavera21/harbor-os/settings/pages) and deploy `main` / `docs`. See `docs/PAGES.md`.

Full product contract: [GROK_APP_CONTRACT.md](GROK_APP_CONTRACT.md)  
Machine manifest: [experimentals/grok-app-manifest.json](../experimentals/grok-app-manifest.json)

## Independent Links

- Source: https://github.com/djlacavera21/harbor-os
- Zip: https://github.com/djlacavera21/harbor-os/archive/refs/heads/main.zip
- Experimentals station (after Pages enable): https://djlacavera21.github.io/harbor-os/
- Catalog JSON: https://raw.githubusercontent.com/djlacavera21/harbor-os/main/experimentals/catalog.json
- App manifest: https://raw.githubusercontent.com/djlacavera21/harbor-os/main/experimentals/grok-app-manifest.json

## Proposed App Information Architecture

```
Grok App
  └── Experimentals
        ├── Harbor OS          official[] from catalog.json
        ├── Flavors            official[] + community[]
        └── Upload flavor      X Premium+ only
              accepts harbor-flavor/v1 YAML or zip ≤ 50 MiB
              server: validate_flavor.py + secret / ISO scan
              listing: catalog.community[]
```

## Proposed Entitlement and Policy

- **Entitlement Check (Server-Side)**:
  - Identity: X account bound to Grok
  - Plan: Premium+
  - Artifact: `harbor.flavor.yaml` plus optional overlay tarball ≤ 50 MiB
- **Policy for Community Uploads**:
  - No bundled API keys
  - No required telemetry
  - No “official xAI OS” branding
  - No ISO / disk images in the pack

## Local Rehearsal

- The Upload tab in `docs/index.html` and `experimentals/index.html` simulates the Premium+ gate for validating and emitting submission packets before pull requests.
- `./scripts/harborctl.sh experimentals` serves the station on `:8088`.

## Naming Collisions

- harboros.ai TrueNAS SCALE images
- gianlucamazza/harbor-kernel (Rust Pi-4 microkernel)
- av/harbor (Docker LLM toolkit)
