# What “full OS” means in Harbor — 1.19.0

Harbor OS is three layers. Only the overlay ships from this repository.

```
Layer A  Overlay substrate      independent zip, no login
Layer B  Personal bootable ISO  operator verifies official Mint, then applies Harbor
Layer C  Grok App chrome        xAI product decision
```

## Independent download

No Grok account and no X Premium+ required:

https://github.com/djlacavera21/harbor-os/archive/refs/heads/main.zip

Live Experimentals stand-in (not the Grok app):

https://htmlpreview.github.io/?https://github.com/djlacavera21/harbor-os/blob/main/docs/index.html

## Layer B — Full OS path

Declared base, not hosted here:

- file: `linuxmint-22.3-cinnamon-64bit.iso`
- sha256: `a081ab202cfda17f6924128dbd2de8b63518ac0531bcfe3f1a1b88097c459bd4`
- index: https://www.linuxmint.com/download.php

```bash
curl -L -o harbor-os.zip https://github.com/djlacavera21/harbor-os/archive/refs/heads/main.zip
unzip harbor-os.zip && cd harbor-os-main
bash iso/full-os-kit.sh /path/to/linuxmint-22.3-cinnamon-64bit.iso
# boot that verified Mint image, then:
bash iso/live-apply.sh
```

`iso/full-os-kit.sh` refuses a mismatched filename or checksum. It does not fetch the ISO.

## Layer C — proposed Experimentals tab

```
Grok App
 └── Experimentals
      ├── Harbor OS          catalog.official[] + overlay zip
      ├── Full OS            official Mint 22.3 + iso/full-os-kit.sh
      ├── Flavors            official[] + community[]
      ├── Apply              local overlay apply recipes
      └── Upload flavor      X Premium+ submenu
            harbor-flavor/v1 YAML or zip ≤ 50 MiB
            → review packet → catalog.community[] (unsigned)
```

This repository cannot add that tab, read live Premium+ entitlements, or publish a Grok-app download. The upload gate stays an xAI product decision. The format is in `experimentals/premium-plus-upload.json` so the submenu does not need a new file type.

Machine contract:

- https://raw.githubusercontent.com/djlacavera21/harbor-os/main/experimentals/full-os.json
- https://raw.githubusercontent.com/djlacavera21/harbor-os/main/experimentals/premium-plus-upload.json
- https://raw.githubusercontent.com/djlacavera21/harbor-os/main/experimentals/grok-app-manifest.json
