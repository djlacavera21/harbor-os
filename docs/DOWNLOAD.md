# Independent Harbor OS download

Harbor OS is an overlay, not a relicensed Linux Mint ISO and not an official xAI product.

## Live links (no Grok App required)

| Surface | URL | Auth |
| --- | --- | --- |
| Source | https://github.com/djlacavera21/harbor-os | none |
| Rolling zip | https://github.com/djlacavera21/harbor-os/archive/refs/heads/main.zip | none |
| Live station preview | https://htmlpreview.github.io/?https://github.com/djlacavera21/harbor-os/blob/main/docs/index.html | none |
| Experimentals Pages | https://djlacavera21.github.io/harbor-os/ | none, after Pages enable |
| Catalog (App contract) | https://raw.githubusercontent.com/djlacavera21/harbor-os/main/experimentals/catalog.json | none |
| Manifest | https://raw.githubusercontent.com/djlacavera21/harbor-os/main/experimentals/grok-app-manifest.json | none |
| Client IA | https://raw.githubusercontent.com/djlacavera21/harbor-os/main/experimentals/client-ia.json | none |
| Submit a flavor | https://github.com/djlacavera21/harbor-os/issues/new?template=submit-flavor.yml | GitHub account |

```
Grok App
 └── Experimentals
      ├── Harbor OS          catalog.official[] + overlay zip
      ├── Flavors            official[] + community[]
      └── Upload flavor      X Premium+ submenu
            harbor-flavor/v1 YAML or zip ≤ 50 MiB
```

Only xAI can render that tab or check live Premium+ entitlements.

## Overlay 1.11.0

The Experimentals station at `docs/index.html` is a single HTML file.
htmlpreview can render Harbor OS / Flavors / Upload flavor without Pages
and without sibling assets.

Local rehearsal:

```
./scripts/harborctl.sh experimentals
# Harbor OS   → http://127.0.0.1:8088/docs/#official
# Flavors     → http://127.0.0.1:8088/docs/#flavors
# Upload      → http://127.0.0.1:8088/docs/#upload
./scripts/harborctl.sh app-contract
```
