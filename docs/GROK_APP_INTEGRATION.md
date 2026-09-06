# Grok App Experimentals — integration note

## What this repository can do

- Ship an independent download URL.
- Define a flavor file format and validator.
- Host an official flavor (Zen Garden) and a community template.
- Run a local Experimentals station (`experimentals/station.html`).

## What this repository cannot do

It cannot add a tab, submenu, or upload control inside the official Grok iOS, Android, or Web application. Those binaries and backend entitlements are owned by xAI. Claiming otherwise would be false.

## Proposed contract if xAI ever adds the tab

```
Grok App
  └── Experimentals
        ├── Harbor OS   ← official catalog.official[]
        └── Upload flavor (X Premium+)
              accepts harbor-flavor/v1 YAML or zip
              gate: X subscription == premium-plus
              server: validate_flavor.py + malware/secret scan
              listing: catalog.community[]
```

Suggested entitlement check (server-side, not in this repo):

- Identity: X account bound to Grok.
- Plan: Premium+.
- Artifact: `harbor.flavor.yaml` plus optional overlay tarball ≤ 50 MiB.
- Policy: no bundled API keys, no required telemetry, no "official xAI OS" branding on community uploads.

The catalog schema in `experimentals/catalog.json` is deliberately boring so an app client can render it without a custom protocol.

## Independent download (available now)

- Source: https://github.com/djlacavera21/harbor-os
- Zip: https://github.com/djlacavera21/harbor-os/archive/refs/heads/main.zip
