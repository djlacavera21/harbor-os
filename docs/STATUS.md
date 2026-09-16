# Harbor OS status — 16 September 2026 (overlay 1.4.0)

Harbor OS is a **declared-base overlay + flavor protocol**, not a from-scratch kernel
and not an official xAI product.

## What is live today

| Surface | URL | State |
| --- | --- |
| Source | https://github.com/djlacavera21/harbor-os | Public |
| Independent zip | https://github.com/djlacavera21/harbor-os/archive/refs/heads/main.zip | Public, no login |
| Catalog (app contract) | https://raw.githubusercontent.com/djlacavera21/harbor-os/main/experimentals/catalog.json | Public |
| Manifest | https://raw.githubusercontent.com/djlacavera21/harbor-os/main/experimentals/grok-app-manifest.json | Public |
| Flavor submit | https://github.com/djlacavera21/harbor-os/issues/new?template=submit-flavor.yml | Public |
| Live station preview | https://htmlpreview.github.io/?https://github.com/djlacavera21/harbor-os/blob/main/docs/index.html | Public, no Pages required |
| Pages station | https://djlacavera21.github.io/harbor-os/ | **Owner must enable Pages** |
| Official Grok App tab | — | **Not shippable from this repo** |

## 16 September 2026

- Overlay **1.4.0**.
- `docs/index.html` is now truly self-contained (inlined CSS + JS) so htmlpreview works even when the loader stub cannot fetch sibling files.
- `docs/station.js` is the full Experimentals runtime again (not a loader).
- Finance Harbor is present in the station fallback catalog.
- Official Grok App Experimentals tab remains xAI-owned. Independent download is the overlay zip.
