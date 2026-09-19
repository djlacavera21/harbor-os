# Harbor OS status — 19 September 2026 (overlay 1.7.0)

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
| Live station preview | https://htmlpreview.github.io/?https://github.com/djlacavera21/harbor-os/blob/main/docs/index.html | Public, no Pages required |
| Pages station | https://djlacavera21.github.io/harbor-os/ | **Owner must enable Pages** |
| Official Grok App tab | — | **Not shippable from this repo** |

## 19 September 2026

- Overlay **1.7.0**.
- New community flavor: Archives Harbor.
- Archives remember tool and publishing draft stager.
- `harborctl status` for a local station readout.
- Visualizer APIs now publish the live overlay version from `VERSION`.
- Official Grok App Experimentals tab remains xAI-owned. Independent download is the overlay zip.

## 18 September 2026

- Overlay **1.6.0**.
- New community flavor: Crew Quarters Harbor.
- Crew briefing tool: `python3 modules/crew/briefing.py "today's watch"`.
- Official Zen Garden flavor identity 1.6.
- Official Grok App Experimentals tab remains xAI-owned. Independent download is the overlay zip.

## 17 September 2026

- Overlay **1.5.0**.
- New community flavor: Design Harbor.
- Local Premium+ ingest rehearsal: `./scripts/harborctl.sh ingest` on `:8090`.
- `harborctl selftest` validates every flavor and refuses ISO leakage.
- Design Wing `compose.py` and Archives `index.py` are runnable offline.
