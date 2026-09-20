# Harbor OS modules

These directories are the empire organs described in the FreshOS alignment whitepaper.
They are workspaces, not daemons. The visualizer watches the machine; the operator fills the folders.

| Path | Wing | Starter file |
| --- | --- | --- |
| `research/` | Source inbox and verification notes | `INBOX.md`, `PROTOCOL.md` |
| `design/` | Emblems, posters, visual assets | `BRIEF.md`, `compose.py` |
| `publishing/` | Outbound drafts and archive staging | `OUTBOUND.md`, `stage.py` |
| `war-room/` | Scenario board and alliance notes | `BOARD.md` |
| `finance/` | Sovereignty ledger | `LEDGER.md` |
| `archives/` | Long-term memory | `INDEX.md`, `index.py`, `remember.py` |
| `crew/` | Standing orders for the operator | `STANDING-ORDERS.md` |
| `gateway/` | Experimentals download card and Grok App contract | `CONTRACT.md`, `card.py` |

A community flavor may enable or disable wings in `harbor.flavor.yaml`.
Do not put API keys or secrets in these files.

Open them from the TUI with `./scripts/harborctl.sh station`.

```bash
python3 modules/design/compose.py "Harbor mark" --mark orb --format emblem
python3 modules/archives/index.py
python3 modules/archives/remember.py "stone that should remain"
python3 modules/publishing/stage.py "draft title"
python3 modules/gateway/card.py
```
