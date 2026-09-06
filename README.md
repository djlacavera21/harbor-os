# Harbor OS

**A flavorable, local-first Linux substrate with a Zen Garden visualizer and optional Grok orchestration.**

Independent download: [github.com/djlacavera21/harbor-os](https://github.com/djlacavera21/harbor-os)

Zip: [harbor-os-main.zip](https://github.com/djlacavera21/harbor-os/archive/refs/heads/main.zip)

> This is a real, runnable overlay and flavor protocol. It is **not** an official xAI product, and it cannot install a new tab inside the Grok iOS/Android/Web app. See [docs/GROK_APP_INTEGRATION.md](docs/GROK_APP_INTEGRATION.md).

## What you get today

| Piece | Status |
| --- | --- |
| Flavor spec `harbor-flavor/v1` | Done |
| Official flavor: FreshOS Zen Garden | Done |
| Community flavor template + validator | Done |
| Zen Garden visualizer (`:8080`) | Runnable |
| Grok Zen Master orchestrator (`:4200`) | Runnable, optional API key |
| One-command overlay installer | Done |
| Cubic notes for a bootable Mint ISO | Documented |
| Experimentals catalog | Done (local station + JSON) |
| Official Grok App Experimentals tab | **Not in this repo's power** |

The July 2026 alignment whitepaper is preserved in [`whitepaper/`](whitepaper/FreshOS_Automation_Alignment_Whitepaper.md).

## 60-second start

```bash
git clone https://github.com/djlacavera21/harbor-os.git
cd harbor-os
python3 visualizer/server.py
```

Open [http://127.0.0.1:8080](http://127.0.0.1:8080).

Sand = load. Stones = memory. Lanterns = network. The orb is the aligned agent.

## Install as an overlay

```bash
chmod +x installer/*.sh iso/customize.sh experimentals/validate_flavor.py
./installer/install-harbor.sh
```

Root on Mint/Debian copies the tree to `/opt/harbor-os` and enables a systemd unit. Without root, files land under `~/.local/share/harbor-os`.

## Flavors

A flavor is a YAML overlay, not a relicensed distro.

```text
flavors/zen-garden/harbor.flavor.yaml   official
flavors/template/harbor.flavor.yaml     start here
```

Validate before you share:

```bash
python3 experimentals/validate_flavor.py flavors/zen-garden/harbor.flavor.yaml
```

Full schema: [`spec/harbor-flavor.schema.json`](spec/harbor-flavor.schema.json).

## Experimentals and Premium+ uploads

Proposed Grok App information architecture:

```text
Grok App
 └── Experimentals
      ├── Harbor OS          official catalog
      └── Upload flavor      X Premium+ (proposal)
```

Until xAI ships that tab:

1. Anyone downloads the official flavor from this repo.
2. X Premium+ (or any) users can author a flavor from the template.
3. Publishing into the shared catalog is a pull request against `experimentals/catalog.json`.
4. The local stand-in UI is [`experimentals/station.html`](experimentals/station.html).

The upload *gate* is a product decision for xAI. The upload *format* is already specified here so the tab, if it ever exists, does not need a new file type.

## Architecture

```text
┌─────────────────────────────────────────────┐
│ Operator (in command)                       │
├─────────────────────────────────────────────┤
│ Zen Garden visualizer     :8080             │
│ Grok Zen Master (optional):4200             │
├──────────┼──────────┼──────────┼────────────┤
│ Research │ Design   │ Publish  │ Strategy   │
│ Finance  │ Archives │ Crew     │            │
├─────────────────────────────────────────────┤
│ Flavor overlay (identity, units, modules)   │
├─────────────────────────────────────────────┤
│ Declared base — Linux Mint 22.3 Cinnamon    │
└─────────────────────────────────────────────┘
```

Harbor does not fork the kernel. It customizes a declared base and keeps the operator able to run offline after setup. The orchestrator stays off unless `XAI_API_KEY` is present.

## Bootable ISO

Harbor will not host a full Linux Mint ISO. Use Cubic against an official Mint image, then run [`iso/customize.sh`](iso/customize.sh). Notes: [`iso/cubic-notes.md`](iso/cubic-notes.md).

## Alignment principles (implemented as constraints)

1. **Sovereignty first** — visualizer and modules work with no account.
2. **Visual clarity** — system state is a garden, not a panic dashboard.
3. **Value coherence** — flavor YAML is the source of stated goals.
4. **Graduated agency** — Zen Master drafts; systemd units are opt-in.
5. **Long-term orientation** — flavors are versioned, reviewable documents.

## License

MIT. Upstream Mint/Debian packages keep their own licenses. Do not present a community flavor as an official Grok or xAI operating system.
