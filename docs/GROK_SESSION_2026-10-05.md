# Grok session — 5 October 2026

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

Overlay **1.18.0**.

- The public Experimentals station (`docs/index.html`) was still labeled
  overlay 1.15.0 even though contracts said 1.17.0. The pill, footer, and
  embedded official flavor now say 1.18.0.
- New Full OS pane: independent zip, official Mint 22.3 boot, then
  `bash iso/live-apply.sh`. Cubic remains the optional bake path.
- `iso/live-apply.sh` writes `/etc/harbor-os/os-release` when root and does
  not overwrite upstream `/etc/os-release`.
- Upload flavor submenu now emits a review packet
  (`channel: community`, `risk: unsigned`) after a harbor-flavor/v1 check.
- Catalog, manifest, client IA, and download receipt dated 2026-10-05.
- Client IA gained a Full OS child under the proposed Experimentals tab.

## Independent links live today

| Surface | URL |
| --- | --- |
| Source | https://github.com/djlacavera21/harbor-os |
| Rolling zip | https://github.com/djlacavera21/harbor-os/archive/refs/heads/main.zip |
| Station preview | https://htmlpreview.github.io/?https://github.com/djlacavera21/harbor-os/blob/main/docs/index.html |
| Full OS pane | https://htmlpreview.github.io/?https://github.com/djlacavera21/harbor-os/blob/main/docs/index.html#full-os |
| Upload rehearsal | https://htmlpreview.github.io/?https://github.com/djlacavera21/harbor-os/blob/main/docs/index.html#upload |
| Pages (404 until owner enable) | https://djlacavera21.github.io/harbor-os/ |
| Catalog | https://raw.githubusercontent.com/djlacavera21/harbor-os/main/experimentals/catalog.json |
| Submit flavor | https://github.com/djlacavera21/harbor-os/issues/new?template=submit-flavor.yml |

Personal bootable ISO remains operator-side work against an official
Linux Mint 22.3 Cinnamon image. See `iso/live-apply.sh` and `iso/cubic-notes.md`.
