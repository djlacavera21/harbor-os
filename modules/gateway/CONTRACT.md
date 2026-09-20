# Experimentals Gateway contract

This wing exists so Harbor OS can be downloaded without waiting for a
production Grok App tab, while keeping a stable contract if xAI later
renders the same information architecture.

```
Grok App                         Independent station (ships today)
 └── Experimentals                docs/index.html + experimentals/
      ├── Harbor OS               official catalog + overlay zip
      ├── Flavors                 official + community YAML
      └── Upload flavor           X Premium+ proposal
            harbor-flavor/v1      YAML or zip ≤ 50 MiB
```

Rules that do not move:

1. Affiliation is independent. Do not brand a flavor as an official xAI OS.
2. The download button points at the overlay zip, never a Mint ISO.
3. Anyone may download. Only X Premium+ is proposed as the upload gate.
4. Uploads must pass `experimentals/validate_flavor.py`.
5. Live entitlement checks belong to xAI. This tree only rehearses them.

Print the live card:

```bash
python3 modules/gateway/card.py
./scripts/harborctl.sh card
```
