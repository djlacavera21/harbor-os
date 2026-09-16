# Grok session — 16 September 2026

This note records what Grok can and cannot do for Harbor OS / FreshOS.

## Ask

Ship a full OS with an independent download under an Experimentals tab in the
Grok App, plus a Premium+ submenu for community Harbor flavors.

## What Grok can own

- The overlay tree, flavor spec, validator, visualizer, optional Zen Master.
- The independent download URL (GitHub zip + catalog.json).
- A rehearsal Experimentals station that matches the proposed IA:
  Harbor OS / Flavors / Upload flavor (Premium+ gate).
- The product contract in `docs/GROK_APP_CONTRACT.md` and
  `docs/XAI_EXPERIMENTALS_BRIEF.md` so xAI does not need a new file type.

## What only xAI can own

- Rendering an Experimentals tab inside Grok iOS / Android / Web.
- Live X Premium+ entitlement checks.
- Official xAI / Grok branding on an operating system.

## Legal boundary on "full OS"

Harbor will not host a Linux Mint ISO. A complete Mint image is a derived work
of Ubuntu/Mint packages. Operators bake their own ISO with official Mint 22.3
plus Cubic and `iso/customize.sh`.

## Independent links (no Grok App required)

| Surface | URL |
| --- | --- |
| Source | https://github.com/djlacavera21/harbor-os |
| Zip | https://github.com/djlacavera21/harbor-os/archive/refs/heads/main.zip |
| Station preview | https://htmlpreview.github.io/?https://github.com/djlacavera21/harbor-os/blob/main/docs/index.html |
| Harbor OS pane | …/docs/index.html#official |
| Flavors pane | …/docs/index.html#flavors |
| Upload pane | …/docs/index.html#upload |
| Catalog | https://raw.githubusercontent.com/djlacavera21/harbor-os/main/experimentals/catalog.json |
| Manifest | https://raw.githubusercontent.com/djlacavera21/harbor-os/main/experimentals/grok-app-manifest.json |
| Submit flavor | https://github.com/djlacavera21/harbor-os/issues/new?template=submit-flavor.yml |

## This session's code change

Overlay 1.4.0 makes `docs/index.html` self-contained so the independent
htmlpreview link does not depend on GitHub Pages or on a JS loader that fails
when sibling files are not served from the same origin.
