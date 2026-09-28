# Apply Harbor OS

Harbor OS is a declared-base overlay. It is not a kernel and not a relicensed Mint ISO.

## Fast path

```bash
curl -L -o harbor-os.zip https://github.com/djlacavera21/harbor-os/archive/refs/heads/main.zip
unzip harbor-os.zip
cd harbor-os-main
chmod +x scripts/harborctl.sh installer/*.sh iso/customize.sh experimentals/validate_flavor.py
./scripts/harborctl.sh garden
```

Open http://127.0.0.1:8080 for the Zen Garden.

## Install a flavor onto a Mint / Debian host

```bash
HARBOR_FLAVOR_ID=zen-garden ./scripts/harborctl.sh apply
```

Root copies the tree to `/opt/harbor-os` and can enable systemd units.
Without root, files land under `~/.local/share/harbor-os`.

Community examples:

```bash
HARBOR_FLAVOR_ID=war-room ./scripts/harborctl.sh apply
HARBOR_FLAVOR_ID=research-harbor ./scripts/harborctl.sh apply
HARBOR_FLAVOR_ID=airgap-tui ./scripts/harborctl.sh apply
```

## What this is not

- Not an official xAI or Grok OS.
- Not a tab inside the production Grok App.
- Not a downloadable Linux Mint ISO from this repository.
