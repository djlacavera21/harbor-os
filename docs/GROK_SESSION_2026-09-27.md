# Grok session — 27 September 2026

## Ask

Work on a full OS with an independent download under an Experimentals tab
in the Grok App, plus a Premium+ submenu for community Harbor flavors.

## What this session can and cannot do

Grok can ship the overlay, the catalog contract, the validator, the
rehearsal station, flavor packs, module tools, a personal ISO bake
checklist, and an independent download URL.

Grok cannot add a tab to the official Grok iOS / Android / Web app,
cannot read live X Premium+ entitlements, and cannot host a relicensed
Linux Mint ISO.

## What shipped in 1.14.0

- Overlay version bump to **1.14.0**.
- Experimentals station (`docs/index.html`) now embeds the full 1.14
  catalog, searches flavors locally, copies the overlay zip, and
  rehearses the Premium+ upload submenu with a Grok-app chrome mock.
- Visualizer header aligned to overlay 1.14.
- Session, status, download, catalog, and manifest dates set to 2026-09-27.
- Independent surfaces remain the GitHub zip + htmlpreview station.

## Independent links (live today)

| Surface | URL |
| --- | --- |
| Source | https://github.com/djlacavera21/harbor-os |
| Zip | https://github.com/djlacavera21/harbor-os/archive/refs/heads/main.zip |
| Station preview | https://htmlpreview.github.io/?https://github.com/djlacavera21/harbor-os/blob/main/docs/index.html |
| Pages (after owner enable) | https://djlacavera21.github.io/harbor-os/ |
| Catalog | https://raw.githubusercontent.com/djlacavera21/harbor-os/main/experimentals/catalog.json |
| Manifest | https://raw.githubusercontent.com/djlacavera21/harbor-os/main/experimentals/grok-app-manifest.json |
| Client IA | https://raw.githubusercontent.com/djlacavera21/harbor-os/main/experimentals/client-ia.json |
| Submit flavor | https://github.com/djlacavera21/harbor-os/issues/new?template=submit-flavor.yml |

## Proposed Grok App IA (unchanged contract)

```
Grok App
 └── Experimentals
      ├── Harbor OS          catalog.official[] + overlay zip
      ├── Flavors            official[] + community[]
      └── Upload flavor      X Premium+ submenu
            harbor-flavor/v1 YAML or zip ≤ 50 MiB
```
