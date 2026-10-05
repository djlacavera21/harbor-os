# Harbor OS status — 5 October 2026 (overlay 1.18.0)

Harbor OS is a **declared-base overlay + flavor protocol**, not a from-scratch kernel
and not an official xAI product.

## What is live today

| Surface | URL | State |
| --- | --- | --- |
| Source | https://github.com/djlacavera21/harbor-os | Public |
| Independent zip | https://github.com/djlacavera21/harbor-os/archive/refs/heads/main.zip | Public, no login |
| Download receipt | https://raw.githubusercontent.com/djlacavera21/harbor-os/main/experimentals/download-receipt.json | Public |
| Catalog (app contract) | https://raw.githubusercontent.com/djlacavera21/harbor-os/main/experimentals/catalog.json | Public |
| Manifest | https://raw.githubusercontent.com/djlacavera21/harbor-os/main/experimentals/grok-app-manifest.json | Public |
| Client IA | https://raw.githubusercontent.com/djlacavera21/harbor-os/main/experimentals/client-ia.json | Public |
| Flavor submit | https://github.com/djlacavera21/harbor-os/issues/new?template=submit-flavor.yml | Public |
| Live station preview | https://htmlpreview.github.io/?https://github.com/djlacavera21/harbor-os/blob/main/docs/index.html | Public, no Pages required |
| Pages station | https://djlacavera21.github.io/harbor-os/ | **Owner must enable Pages** |
| Official Grok App tab | — | **Not shippable from this repo** |

## 5 October 2026

- Overlay **1.18.0**.
- Experimentals station pill was still 1.15.0 on `docs/index.html`. Corrected, and a Full OS pane was added.
- `iso/live-apply.sh` applies the overlay onto an official Mint 22.3 live session or install. Still does not redistribute a Mint ISO.
- Premium+ upload submenu builds a `catalog.community[]` review packet (`risk: unsigned`) instead of a boolean string check.
- Official Grok App Experimentals tab remains xAI-owned. Independent download is the overlay zip.

## Proposed Grok App IA

```
Grok App
 └── Experimentals
      ├── Harbor OS          catalog.official[] + overlay zip
      ├── Full OS            official Mint 22.3 + iso/live-apply.sh
      ├── Flavors            official[] + community[]
      ├── Apply              local overlay apply recipes
      └── Upload flavor      X Premium+ submenu
            harbor-flavor/v1 YAML or zip ≤ 50 MiB
            → review packet → catalog.community[] (unsigned)
```
