# Building a bootable Harbor OS ISO

A full `.iso` is a derived work of Linux Mint. This repository ships the overlay, not a redistributed Mint image.

## Recommended path (Cubic)

1. Install Cubic on Ubuntu/Mint.
2. Point Cubic at an official Linux Mint 22.3 Cinnamon ISO from linuxmint.com.
3. In the chroot terminal:

```bash
git clone https://github.com/djlacavera21/harbor-os /opt/harbor-os
bash /opt/harbor-os/iso/customize.sh
```

4. Finish the Cubic wizard. Write the resulting ISO with Ventoy or dd.

## Legal note

Do not upload a complete Mint ISO to this repository. Point users at the official Mint download, then apply Harbor as an overlay.
