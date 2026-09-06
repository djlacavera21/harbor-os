# Harbor flavor specification

A **flavor** is an inspectable overlay. It is not a kernel and not a relicensed copy of Linux Mint.

## File

`harbor.flavor.yaml` at the root of a flavor directory.

## Required fields

| Field | Meaning |
| --- | --- |
| `schema` | Must be `harbor-flavor/v1` |
| `id` | URL-safe slug |
| `name` | Display name |
| `version` | Semver |
| `base` | Honest upstream distro |
| `identity` | What the operator sees after install |

## Alignment block

Optional but recommended. Records who is in command (`operator_role`) and who advises (`agent_role`). Harbor treats the operator as sovereign: agents may draft and orchestrate, they may not silently persist privileges.

## Validation

```bash
python3 experimentals/validate_flavor.py flavors/zen-garden/harbor.flavor.yaml
```

JSON Schema lives at `spec/harbor-flavor.schema.json`.

## Community uploads

Use `flavors/template/`. Set `experimentals.upload_allowed: true` and `risk: unsigned` until a maintainer reviews the flavor.
