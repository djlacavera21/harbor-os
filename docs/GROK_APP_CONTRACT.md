# Grok App Experimentals contract — Harbor OS

**Status:** Independent specification. Not shipped in the official Grok iOS / Android / Web app.  
**Owner of chrome and entitlements:** xAI  
**Owner of this overlay + catalog:** `djlacavera21/harbor-os`

This document is the product contract a future **Experimentals** tab would implement. The live stand-in already exists:

| Surface | URL |
|---|---|
| Source | https://github.com/djlacavera21/harbor-os |
| Independent zip | https://github.com/djlacavera21/harbor-os/archive/refs/heads/main.zip |
| Pages station (after owner enable) | https://djlacavera21.github.io/harbor-os/ |
| Machine catalog | https://raw.githubusercontent.com/djlacavera21/harbor-os/main/experimentals/catalog.json |
| App manifest | https://raw.githubusercontent.com/djlacavera21/harbor-os/main/experimentals/grok-app-manifest.json |

Enabling Pages does **not** add a tab inside Grok. Only an xAI client release can do that.

---

## 1. Information architecture

```
Grok App
 └── Experimentals                         # proposed first-class tab
      ├── Harbor OS                        # official[] from catalog
      │     └── Download                   # independent zip / overlay
      ├── Flavors                          # official[] + community[]
      └── Upload flavor                    # X Premium+ only submenu
            accepts harbor-flavor/v1 YAML or zip ≤ 50 MiB
            server: validate_flavor.py + secret / ISO scan
            listing: catalog.community[]
```

The independent station in `docs/index.html` and `experimentals/` implements the same three panes so authors can rehearse before any app tab exists.

---

## 2. What Harbor OS actually is

Harbor OS is **not** a from-scratch kernel and **not** a relicensed Linux Mint ISO.

It is:

- a declared-base overlay (Linux Mint 22.3 Cinnamon / Debian-family)
- a flavor protocol (`harbor-flavor/v1`)
- a Zen Garden visualizer (`:8080`)
- an optional Grok Zen Master orchestrator (`:4200`, needs `XAI_API_KEY`)
- systemd units that are opt-in
- Cubic notes so an operator can bake an ISO themselves from an official Mint image

A Grok App download button should point at the **overlay zip**, never at a bootleg Mint ISO.

---

## 3. Entitlement model for Upload

| Check | Who owns it | Today |
|---|---|---|
| X account bound to Grok | xAI | Not readable from this repo |
| Plan = X Premium+ | xAI | Local checkbox rehearsal only |
| Artifact = `harbor.flavor.yaml` ± overlay tarball ≤ 50 MiB | this repo | Validator ships |
| Policy scan (no keys, no ISO, no official-xAI branding) | this repo | `experimentals/validate_flavor.py` |

If xAI ships the tab, the client should:

1. Hide **Upload flavor** unless Premium+ is live.
2. POST the file to an xAI endpoint that runs the same validator.
3. On success, append to `catalog.community[]` or open a reviewed ingest queue.

Community flavors stay `risk: unsigned` until a human review flips them.

---

## 4. Catalog contract

Schema: `harbor-experimentals-catalog/v1`

Required top-level keys:

- `official[]` — curated Harbor / FreshOS Zen Garden line
- `community[]` — unsigned flavor packs
- `community_upload` — gate, max bytes, accept list, rules
- `independent_download` — always-on zip URL

Each entry:

```
id, name, version, channel, download, source, flavor, risk, min_subscription, summary
```

`min_subscription` on **download** is `none` (anyone can pull a flavor file).  
`min_subscription` on **upload** is `premium-plus`.

---

## 5. Policy for community uploads

Must:

- validate against `harbor-flavor/v1`
- declare `base.distro` honestly
- keep orchestrator optional
- remain offline-capable after first setup

Must not:

- ship API keys, tokens, or private keys
- require telemetry
- embed `.iso` / `.img` disk images
- claim “official xAI OS” or “official Grok OS”
- replace the host kernel

---

## 6. Why this cannot be done from the repo alone

- Grok App navigation is compiled / configured by xAI.
- X Premium+ entitlements are server-side.
- GitHub Pages for the independent station is a **repository settings** switch the owner must flip (`Settings → Pages → Deploy from branch main / docs`).
- A full bootable distro ISO would redistribute Ubuntu/Mint packages; Harbor therefore documents Cubic instead of hosting one.

What this repo *can* keep shipping: the overlay, the flavor format, the validator, the station UI, and this contract so a future tab does not need a new file type.

---

## 7. Operator path that works today

```bash
git clone https://github.com/djlacavera21/harbor-os.git
cd harbor-os
chmod +x scripts/harborctl.sh installer/*.sh iso/customize.sh experimentals/validate_flavor.py
./scripts/harborctl.sh garden          # http://127.0.0.1:8080
./scripts/harborctl.sh experimentals   # http://127.0.0.1:8088/experimentals/
HARBOR_FLAVOR_ID=zen-garden ./scripts/harborctl.sh apply
./scripts/harborctl.sh validate flavors/template/harbor.flavor.yaml
```

The garden is raked. The tab, if it ever exists, should look like this station.
