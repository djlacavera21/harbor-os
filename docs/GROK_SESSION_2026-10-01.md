# Grok session — 1 October 2026

## Ask

Work on a full OS with an independent download link under an Experimentals
tab in the Grok App, and a submenu for X Premium+ users to upload their own
flavors of Harbor OS.

## Hard limits (unchanged)

This session cannot:

- add a tab inside the official Grok iOS / Android / Web app
- read live X Premium+ entitlements
- enable GitHub Pages on `djlacavera21/harbor-os`
- redistribute a Linux Mint ISO

Only xAI owns Grok App chrome and entitlements. Only the repository owner
can enable Pages at https://github.com/djlacavera21/harbor-os/settings/pages

## What this session shipped

Overlay **1.17.0**.

- Experimentals station pill corrected (it still said 1.15.0) and bumped.
- Upload submenu now builds a review packet: a `catalog.community[]` draft
  with `risk: unsigned`, plus an issue body. Gate remains a local rehearsal.
- `experimentals/review_packet.py` — same packet from the CLI after
  `validate_flavor.py` rules.
- `experimentals/download-receipt.json` — stable independent-download contract.
- Catalog, manifest, and client IA dated 2026-10-01.

## Independent links live today

| Surface | URL |
| --- | --- |
| Source | https://github.com/djlacavera21/harbor-os |
| Rolling zip | https://github.com/djlacavera21/harbor-os/archive/refs/heads/main.zip |
| Station preview | https://htmlpreview.github.io/?https://github.com/djlacavera21/harbor-os/blob/main/docs/index.html |
| Pages (404 until owner enable) | https://djlacavera21.github.io/harbor-os/ |
| Catalog | https://raw.githubusercontent.com/djlacavera21/harbor-os/main/experimentals/catalog.json |
| Manifest | https://raw.githubusercontent.com/djlacavera21/harbor-os/main/experimentals/grok-app-manifest.json |
| Client IA | https://raw.githubusercontent.com/djlacavera21/harbor-os/main/experimentals/client-ia.json |
| Download receipt | https://raw.githubusercontent.com/djlacavera21/harbor-os/main/experimentals/download-receipt.json |
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
            → review packet → catalog.community[] (unsigned)
```

Personal bootable ISO remains operator-side Cubic work against an official
Linux Mint 22.3 Cinnamon image. See `iso/cubic-notes.md` and `docs/FULL_OS.md`.
