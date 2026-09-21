# Grok session — 21 September 2026

## Ask

Work on a full OS with an independent download under an Experimentals tab
in the Grok App, plus a Premium+ submenu for community Harbor flavors.

## What this session can and cannot do

Grok can ship the overlay, the catalog contract, the validator, the
rehearsal station, module tools, a personal ISO bake checklist, and an
independent download URL.

Grok cannot add a tab to the official Grok iOS / Android / Web app,
cannot read live X Premium+ entitlements, and cannot host a relicensed
Linux Mint ISO.

## What shipped in 1.9.0

- Overlay version bump to **1.9.0**.
- New community flavor: **Empire Stack Harbor** (`flavors/empire-stack`).
- New wing: `modules/oskit/` with `bake.py` and the Cubic checklist.
- `harborctl bake` prints the operator path to a personal bootable ISO.
- Experimentals station strings moved off the stale 1.6 overlay label.
- Official Zen Garden flavor identity 1.9.
- Catalog + Grok App manifest updated to 1.9.0 so a future Experimentals
  tab still consumes the same JSON.

## Independent links (live today)

| Surface | URL |
| --- | --- |
| Source | https://github.com/djlacavera21/harbor-os |
| Zip | https://github.com/djlacavera21/harbor-os/archive/refs/heads/main.zip |
| Station preview | https://htmlpreview.github.io/?https://github.com/djlacavera21/harbor-os/blob/main/docs/index.html |
| Pages (after owner enable) | https://djlacavera21.github.io/harbor-os/ |
| Catalog | https://raw.githubusercontent.com/djlacavera21/harbor-os/main/experimentals/catalog.json |
| Manifest | https://raw.githubusercontent.com/djlacavera21/harbor-os/main/experimentals/grok-app-manifest.json |
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
