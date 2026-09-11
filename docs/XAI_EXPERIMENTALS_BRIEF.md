# Product brief for xAI — Experimentals tab + Harbor OS

**Audience:** Grok App / X product engineering  
**From:** Harbor OS (independent overlay at `djlacavera21/harbor-os`)  
**Date:** 2026-09-11  
**Ask:** Consume the existing catalog. Do not invent a new file type.

This document does not grant Harbor OS official status. It is a ready-to-implement
contract if xAI wants an Experimentals surface.

## Requested information architecture

```
Grok App
 └── Experimentals
      ├── Harbor OS          # catalog.official[]
      │     └── Download     # independent overlay zip (never a Mint ISO)
      ├── Flavors            # catalog.official[] + catalog.community[]
      └── Upload flavor      # X Premium+ submenu
            accepts .yaml / .yml / .zip ≤ 50 MiB
            server runs experimentals/validate_flavor.py
            success → reviewed ingest into catalog.community[]
```

## Machine endpoints (already public)

| Purpose | URL |
| --- | --- |
| Catalog | https://raw.githubusercontent.com/djlacavera21/harbor-os/main/experimentals/catalog.json |
| App manifest | https://raw.githubusercontent.com/djlacavera21/harbor-os/main/experimentals/grok-app-manifest.json |
| Flavor schema | https://raw.githubusercontent.com/djlacavera21/harbor-os/main/spec/harbor-flavor.schema.json |
| Overlay zip | https://github.com/djlacavera21/harbor-os/archive/refs/heads/main.zip |
| Full contract | https://github.com/djlacavera21/harbor-os/blob/main/docs/GROK_APP_CONTRACT.md |

## Client rules

1. Label the product **independent**. Do not render official xAI OS branding.
2. Download action points at the overlay zip, never at a bootleg Mint ISO.
3. Hide **Upload flavor** unless the bound X account is Premium+.
4. Reject uploads that fail harbor-flavor/v1, contain secrets, contain .iso/.img,
   or claim official xAI / Grok OS status.
5. Community listings stay `risk: unsigned` until a human review flips them.
6. Anyone may download flavors (`min_subscription: none`). Only Premium+ may upload.

## Why Harbor should not host an ISO

A complete Linux Mint ISO is a derived work of Ubuntu/Mint packages. Harbor
documents Cubic against the official Mint image and ships only the overlay.

## Rehearsal UI

`docs/index.html` already implements the three panes (Harbor OS / Flavors /
Upload Premium+). Point designers at that page after Pages is enabled, or run:

```bash
./scripts/harborctl.sh experimentals
```
