# Deployment

## Fastest path (no ISO)

On Linux, from a clone:

```bash
chmod +x installer/install-harbor.sh installer/first-boot.sh
./installer/install-harbor.sh
python3 visualizer/server.py
```

Open http://127.0.0.1:8080

Optional orchestrator:

```bash
pip install -r orchestrator/requirements.txt
# export XAI_API_KEY=...   # only if you want live Grok
python3 orchestrator/zen_master.py
```

Open http://127.0.0.1:4200/docs

## Systemd path (root on Mint/Debian)

```bash
sudo ./installer/install-harbor.sh
```

This copies the tree to `/opt/harbor-os` and enables `harbor-visualizer.service`.

## Bootable ISO path

See `iso/cubic-notes.md`. Harbor does not vendor a Mint ISO.

## Virtual machine

1. Download official Linux Mint 22.3 Cinnamon.
2. Install into VirtualBox/QEMU with EFI.
3. Run the installer inside the guest.
4. Snapshot before enabling the Zen Master service.
