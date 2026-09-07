# Enable the independent Experimentals link

The catalog and station already exist. GitHub Pages is currently **404** because the repository has a deploy workflow but Pages is not switched on.

Target URL after enable:

`https://djlacavera21.github.io/harbor-os/`

## Fastest path (branch / docs, no Actions required)

1. Open https://github.com/djlacavera21/harbor-os/settings/pages
2. Under **Build and deployment → Source**, choose **Deploy from a branch**
3. Branch: `main`
4. Folder: `/docs`
5. Save

`docs/index.html` is a self-contained Experimentals station (Harbor OS / Flavors / Upload Premium+ / About).

## Actions path (already in the repo)

1. Same Pages settings page
2. Source: **GitHub Actions**
3. Open https://github.com/djlacavera21/harbor-os/actions/workflows/pages.yml
4. Run workflow on `main`

The workflow copies `experimentals/index.html` to the site root and also publishes visualizer, flavors, docs, and the whitepaper.

## What this is not

Enabling Pages does **not** add an Experimentals tab inside the official Grok iOS / Android / Web app. Only xAI can do that. The Pages site is the independent stand-in plus the catalog contract (`experimentals/catalog.json`) that tab would consume.
