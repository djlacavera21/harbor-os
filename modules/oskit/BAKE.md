# OS Kit — personal ISO bake

Harbor does not host or redistribute a Linux Mint ISO.

A "full OS" for an operator is:

1. Official Linux Mint 22.3 Cinnamon ISO from linuxmint.com
2. This overlay (`harbor-os` zip)
3. Cubic chroot running `iso/customize.sh`
4. Ventoy / VirtualBox EFI / USB write of the operator's own ISO

```bash
./scripts/harborctl.sh bake
```

That command prints the live checklist. It never downloads Mint packages
into this repository.
