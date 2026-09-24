# Harbor OS status — 24 September 2026 (overlay 1.11.0)

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
| Live station preview | https://htmlpreview.github.io/?https://github.com/djlacavera21/harbor-os/blob/main/docs/index.html | Public, no Pages required. **Self-contained HTML as of 1.11.0.** |
| Pages station | https://djlacavera21.github.io/harbor-os/ | **Owner must enable Pages** |
| Official Grok App tab | — | **Not shippable from this repo** |

## 24 September 2026

- Overlay **1.11.0**.
- `docs/index.html` is now a single-file station (CSS + JS inlined) so htmlpreview actually renders the Experimentals rail.
- Rail submenu, flavor search, copy-download, and Premium+ lock state are wired.
- `harborctl app-contract` prints the Grok App IA plus live independent URLs.
- Official Grok App Experimentals tab remains xAI-owned. Independent download is the overlay zip.
