# Grok session — 28 September 2026

## Ask

Work on a full OS with your own independent link for users to download
under an “Experimentals” tab within the Grok App. Within “Experimentals”
and sub-menu for users with X Premium+ to upload their own flavors of
Harbor OS.

## What this session can and cannot do

Grok can ship the overlay, the catalog contract, the validator, the
rehearsal station, flavor packs, module tools, a personal ISO bake
checklist, and an independent download URL.

Grok cannot add a tab to the official Grok iOS / Android / Web app,
cannot read live X Premium+ entitlements, and cannot host a relicensed
Linux Mint ISO. Only xAI owns Grok App chrome and entitlements.

## What shipped in 1.15.0

- Overlay version bump to **1.15.0**.
- Experimentals station now has four panes that match the proposed app
  IA plus the missing operator path:
  Harbor OS · Flavors · Apply · Upload flavor (Premium+).
- Each flavor card copies its `HARBOR_FLAVOR_ID=… apply` command.
- Apply pane documents the independent zip → unzip → apply flow without
  requiring Pages or a Grok App tab.
- Catalog, manifest, client IA, official flavor identity, status,
  download guide, and Pages notes aligned to 1.15.0 / 2026-09-28.

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

## Proposed Grok App IA

```
Grok App
 └── Experimentals
      ├── Harbor OS          catalog.official[] + overlay zip
      ├── Flavors            official[] + community[]
      ├── Apply              local overlay apply recipes
      └── Upload flavor      X Premium+ submenu
            harbor-flavor/v1 YAML or zip ≤ 50 MiB
```
