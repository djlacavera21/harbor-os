# Live apply — full OS without hosting a Mint ISO

Harbor OS 1.18.0 does not ship a bootable image. The full OS path is:

1. Download the independent overlay zip:
   https://github.com/djlacavera21/harbor-os/archive/refs/heads/main.zip
2. Download official Linux Mint 22.3 Cinnamon from linuxmint.com.
3. Boot that ISO from Ventoy or a VM.
4. On the Mint session:

```bash
unzip harbor-os-main.zip
cd harbor-os-main
bash iso/live-apply.sh
./scripts/harborctl.sh garden
```

`iso/live-apply.sh` applies the selected flavor (`HARBOR_FLAVOR_ID`, default `zen-garden`). As root it writes `/etc/harbor-os/os-release` and does not replace upstream `/etc/os-release`.

Cubic remains optional: chroot, `bash iso/customize.sh`, write your own ISO. Do not publish that ISO as an xAI or Grok product.

The Experimentals upload submenu is unrelated to the ISO. Premium+ flavor packs are `harbor-flavor/v1` YAML or zip ≤ 50 MiB, never `.iso` or `.img`.
