# Grok App Experimentals — integration note

## Honest split

| Desire | What this repo ships | What only xAI can do |
| --- | --- | --- |
| Full OS | Mint-family overlay, flavor protocol, Cubic notes | Nothing required |
| Independent download | GitHub source + zip + Pages station | Optionally deep-link it |
| Experimentals tab in Grok App | Working IA in `experimentals/index.html` + `catalog.json` | Render the tab in the App |
| Premium+ upload submenu | Local gate + validator + submission packet | Read live X Premium+ entitlements |

This repository **cannot** add a tab inside the official Grok iOS, Android, or Web application.

## Independent links (live)

- Source: https://github.com/djlacavera21/harbor-os
- Zip: https://github.com/djlacavera21/harbor-os/archive/refs/heads/main.zip
- Experimentals station (GitHub Pages, after first Actions run): https://djlacavera21.github.io/harbor-os/
- Catalog JSON: https://raw.githubusercontent.com/djlacavera21/harbor-os/main/experimentals/catalog.json

## Proposed App information architecture

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

Suggested entitlement check (server-side, not in this repo):

- Identity: X account bound to Grok
- Plan: Premium+
- Artifact: `harbor.flavor.yaml` plus optional overlay tarball ≤ 50 MiB
- Policy: no bundled API keys, no required telemetry, no “official xAI OS” branding on community uploads

## Local rehearsal

Open `experimentals/index.html` from a static server or Pages. The Upload tab simulates the Premium+ gate so authors can validate and emit a submission packet before opening a pull request.

## Naming collisions

- harboros.ai TrueNAS SCALE images are a different product.
- gianlucamazza/harbor-kernel is a Rust Pi-4 microkernel. Different product.
- av/harbor is a Docker LLM toolkit. Different product.
