# Enable the independent Experimentals link

Until Pages is enabled, use the live preview that does **not** need repository settings:

https://htmlpreview.github.io/?https://github.com/djlacavera21/harbor-os/blob/main/docs/index.html

`docs/index.html` is self-contained as of overlay 1.11.0 (CSS and station runtime inlined) so htmlpreview renders the Harbor OS / Flavors / Upload Premium+ IA.

Target URL after enable:

`https://djlacavera21.github.io/harbor-os/`

That URL is still **404** until the repository owner flips Pages on. Grok / this agent cannot flip repository settings.

## Fastest path (branch / docs)

1. Open https://github.com/djlacavera21/harbor-os/settings/pages
2. Source: **Deploy from a branch**
3. Branch: `main`
4. Folder: `/docs`
5. Save

## Actions path

1. Same Pages settings page
2. Source: **GitHub Actions**
3. Run `.github/workflows/pages.yml` on `main`

## What this is not

Enabling Pages does **not** add an Experimentals tab inside the official Grok iOS / Android / Web app. Only xAI can do that.

Until Pages is on, the live independent download is:

https://github.com/djlacavera21/harbor-os/archive/refs/heads/main.zip
