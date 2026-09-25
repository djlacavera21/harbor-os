# Harbor OS status — 25 September 2026 (overlay 1.12.0)

Harbor OS is a **declared-base overlay + flavor protocol**, not a from-scratch kernel
and not an official xAI product.

## What is live today

| Surface | URL | State |
| --- | --- | --- |
| Source | https://github.com/djlacavera21/harbor-os | Public |
| Independent zip | https://github.com/djlacavera21/harbor-os/archive/refs/heads/main.zip | Public, no login |
| Catalog (app contract) | https://raw.githubusercontent.com/djlacavera21/harbor-os/main/experimentals/catalog.json | Public |
| Manifest | https://raw.githubusercontent.com/djlacavera21/harbor-os/main/experimentals/grok-app-manifest.json | Public |
| Client IA | https://raw.githubusercontent.com/djlacavera21/harbor-os/main/experimentals/client-ia.json | Public |
| Flavor submit | https://github.com/djlacavera21/harbor-os/issues/new?template=submit-flavor.yml | Public |
| Live station preview | https://htmlpreview.github.io/?https://github.com/djlacavera21/harbor-os/blob/main/docs/index.html | Public, no Pages required |
| Pages station | https://djlacavera21.github.io/harbor-os/ | **Owner must enable Pages** |
| Official Grok App tab | — | **Not shippable from this repo** |

## 25 September 2026

- Overlay **1.12.0**.
- `harborctl pack-flavor <id>` builds the exact zip a future Premium+ submenu would accept (≤ 50 MiB, must contain `harbor.flavor.yaml`, no ISO).
- `harborctl app-contract` is now a first-class command (prints IA + live URLs + client rules).
- Experimentals station embeds the flavor catalog so search / copy-link work on htmlpreview without a live fetch.
- Overlay packs write `SHA256SUMS.txt`. Visualizer `/api/metrics` reads `VERSION` instead of a stale 1.5.0 string.
- Official Grok App Experimentals tab remains xAI-owned. Independent download is the overlay zip.
