# Grok session — 29 September 2026

## Ask

Work on a full OS with your own independent link for users to download
under an “Experimentals” tab within the Grok App. Within “Experimentals”
and sub-menu for users with X Premium+ to upload their own flavors of
Harbor OS.

## Hard limits (unchanged)

Grok cannot:

- add a tab inside the official Grok iOS / Android / Web app
- read live X Premium+ entitlements
- flip GitHub Pages on `djlacavera21/harbor-os`
- redistribute a Linux Mint ISO

Only xAI owns Grok App chrome and entitlements. Only the repository owner
can enable Pages at https://github.com/djlacavera21/harbor-os/settings/pages

## What already ships (verified this session)

Selftest passed on overlay **1.15.0**. Every flavor validates against
`harbor-flavor/v1`. No `.iso` / `.img` in the tree.

Packed overlay:

- `harbor-os-1.15.0-overlay.zip` (124 KiB)
- SHA-256 `98764abedc76c0aaf6cb0b1c78e44d11d73934a6917f69945237614c44c91b3e`

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
| Submit flavor | https://github.com/djlacavera21/harbor-os/issues/new?template=submit-flavor.yml |

## Proposed Grok App IA (consume existing catalog)

```
Grok App
 └── Experimentals
      ├── Harbor OS          catalog.official[] + overlay zip
      ├── Flavors            official[] + community[]
      ├── Apply              local overlay apply recipes
      └── Upload flavor      X Premium+ submenu
            harbor-flavor/v1 YAML or zip ≤ 50 MiB
```

## Operator apply path (no Grok App required)

```bash
curl -L -o harbor-os.zip https://github.com/djlacavera21/harbor-os/archive/refs/heads/main.zip
unzip harbor-os.zip
cd harbor-os-main
chmod +x scripts/harborctl.sh installer/*.sh iso/customize.sh experimentals/validate_flavor.py
./scripts/harborctl.sh garden          # http://127.0.0.1:8080
HARBOR_FLAVOR_ID=zen-garden ./scripts/harborctl.sh apply
```

Personal bootable ISO remains operator-side Cubic work against an official
Linux Mint 22.3 Cinnamon image. See `iso/cubic-notes.md`.
