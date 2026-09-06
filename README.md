# Harbor OS

**A flavorable, local-first Linux substrate with a Zen Garden visualizer and optional Grok orchestration.**

## Independent download

| Surface | URL |
| --- | --- |
| Source | [github.com/djlacavera21/harbor-os](https://github.com/djlacavera21/harbor-os) |
| Zip | [harbor-os-main.zip](https://github.com/djlacavera21/harbor-os/archive/refs/heads/main.zip) |
| Experimentals station | [djlacavera21.github.io/harbor-os](https://djlacavera21.github.io/harbor-os/) |
| Catalog (App contract) | [experimentals/catalog.json](https://raw.githubusercontent.com/djlacavera21/harbor-os/main/experimentals/catalog.json) |

> This is a real, runnable overlay and flavor protocol. It is **not** an official xAI product, and it cannot install a new tab inside the Grok iOS / Android / Web app. See [docs/GROK_APP_INTEGRATION.md](docs/GROK_APP_INTEGRATION.md).

## Experimentals information architecture

```
Grok App                         Independent station (ships today)
 └── Experimentals                experimentals/index.html
      ├── Harbor OS               official catalog + zip
      ├── Flavors                 official + community YAML
      └── Upload flavor           X Premium+ proposal
            (Premium+)            local gate + validator + PR packet
```

Until xAI ships that tab:

1. Anyone downloads the official flavor from this repo.
2. Authors draft a `harbor.flavor.yaml` from `flavors/template/` or the community examples.
3. Validate: `python3 experimentals/validate_flavor.py path.yaml`
4. Publishing into the shared catalog is a pull request against `experimentals/catalog.json`.
5. The local / Pages stand-in UI is the Experimentals station.

The upload *gate* is a product decision for xAI. The upload *format* is specified here so the tab, if it ever exists, does not need a new file type.

## What you get today

| Piece | Status |
| --- | --- |
| Flavor spec `harbor-flavor/v1` | Done |
| Official flavor: FreshOS Zen Garden | Done |
| Community flavors: War Room, Research, Airgap TUI | Done (unsigned) |
| Community template + validator | Done |
| Zen Garden visualizer (`:8080`) | Runnable |
| Grok Zen Master orchestrator (`:4200`) | Runnable, optional API key |
| One-command overlay installer | Done |
| Cubic notes for a bootable Mint ISO | Documented |
| Experimentals catalog + station | Done |
| Official Grok App Experimentals tab | **Not in this repo's power** |

The July 2026 alignment whitepaper is in [`whitepaper/FreshOS_Automation_Alignment_Whitepaper.md`](whitepaper/FreshOS_Automation_Alignment_Whitepaper.md).

## 60-second start

```bash
git clone https://github.com/djlacavera21/harbor-os.git
cd harbor-os
python3 visualizer/server.py
```

Open [http://127.0.0.1:8080](http://127.0.0.1:8080) for the garden. For the Experimentals station:

```bash
python3 -m http.server 8088
# Experimentals → http://127.0.0.1:8088/experimentals/
```

Sand = load. Stones = memory. Lanterns = network. The orb is the aligned agent.

## Install as an overlay

```bash
chmod +x installer/*.sh iso/customize.sh experimentals/validate_flavor.py
HARBOR_FLAVOR_ID=zen-garden ./installer/install-harbor.sh
```

Root on Mint/Debian copies the tree to `/opt/harbor-os` and enables a systemd unit. Without root, files land under `~/.local/share/harbor-os`.

Community examples:

```bash
HARBOR_FLAVOR_ID=war-room ./installer/install-harbor.sh
HARBOR_FLAVOR_ID=research-harbor ./installer/install-harbor.sh
HARBOR_FLAVOR_ID=airgap-tui ./installer/install-harbor.sh
```

## Flavors

A flavor is a YAML overlay, not a relicensed distro.

```text
flavors/zen-garden/harbor.flavor.yaml      official
flavors/war-room/harbor.flavor.yaml        community
flavors/research-harbor/harbor.flavor.yaml community
flavors/airgap-tui/harbor.flavor.yaml      community
flavors/template/harbor.flavor.yaml        start here
```

```bash
python3 experimentals/validate_flavor.py flavors/zen-garden/harbor.flavor.yaml
```

Schema: [`spec/harbor-flavor.schema.json`](spec/harbor-flavor.schema.json).

## Architecture

```text
┌─────────────────────────────────────────────┐
│ Operator (in command)                       │
├─────────────────────────────────────────────┴
│ Zen Garden visualizer     :8080             │
│ Grok Zen Master (optional):4200             │
├──────────┼──────────┼──────────┼────────────┤
│ Research │ Design   │ Publish  │ Strategy   │
│ Finance  │ Archives │ Crew     │            │
├─────────────────────────────────────────────┴
│ Flavor overlay (identity, units, modules)   │
├─────────────────────────────────────────────┴
│ Declared base — Linux Mint 22.3 Cinnamon    │
└─────────────────────────────────────────────┘
```

Harbor does not fork the kernel. It customizes a declared base and keeps the operator able to run offline after setup. The orchestrator stays off unless `XAI_API_KEY` is present.

## Bootable ISO

Harbor will not host a full Linux Mint ISO. Use Cubic against an official Mint image, then run [`iso/customize.sh`](iso/customize.sh). Notes: [`iso/cubic-notes.md`](iso/cubic-notes.md).

## Alignment principles

1. **Sovereignty first** — visualizer and modules work with no account.
2. **Visual clarity** — system state is a garden, not a panic dashboard.
3. **Value coherence** — flavor YAML is the source of stated goals.
4. **Graduated agency** — Zen Master drafts; systemd units are opt-in.
5. **Long-term orientation** — flavors are versioned, reviewable documents.

## License

MIT. Upstream Mint/Debian packages keep their own licenses. Do not present a community flavor as an official Grok or xAI operating system.
