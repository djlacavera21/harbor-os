#!/usr/bin/env python3
"""Local-only Harbor Finance Wing ledger. No network. No telemetry."""
from __future__ import annotations
import csv, sys
from datetime import datetime, timezone
from pathlib import Path

LEDGER = Path(__file__).resolve().parent / "ledger.csv"
FIELDS = ("ts", "account", "amount", "currency", "note")


def ensure() -> None:
    if not LEDGER.exists():
        with LEDGER.open("w", encoding="utf-8", newline="") as fh:
            csv.DictWriter(fh, fieldnames=FIELDS).writeheader()


def add(account: str, amount: str, currency: str = "USD", note: str = "") -> None:
    ensure()
    with LEDGER.open("a", encoding="utf-8", newline="") as fh:
        csv.DictWriter(fh, fieldnames=FIELDS).writerow(
            {
                "ts": datetime.now(timezone.utc).isoformat(timespec="seconds"),
                "account": account,
                "amount": amount,
                "currency": currency,
                "note": note,
            }
        )


def balance() -> dict[str, float]:
    ensure()
    totals: dict[str, float] = {}
    with LEDGER.open(encoding="utf-8", newline="") as fh:
        for row in csv.DictReader(fh):
            key = f"{row['account']}:{row['currency']}"
            totals[key] = totals.get(key, 0.0) + float(row["amount"])
    return totals


def main(argv: list[str]) -> int:
    if len(argv) < 2 or argv[1] in {"-h", "--help"}:
        print("usage: ledger.py add <account> <amount> [currency] [note...]")
        print("       ledger.py balance")
        print("       ledger.py path")
        return 0
    cmd = argv[1]
    if cmd == "add":
        if len(argv) < 4:
            print("add requires account and amount", file=sys.stderr)
            return 2
        note = " ".join(argv[5:]) if len(argv) > 5 else (argv[4] if len(argv) == 5 else "")
        currency = argv[4] if len(argv) > 5 else "USD"
        if len(argv) == 5 and argv[4].isalpha() and len(argv[4]) == 3:
            currency, note = argv[4], ""
        add(argv[2], argv[3], currency, note)
        print("recorded")
        return 0
    if cmd == "balance":
        totals = balance()
        for key, total in totals.items():
            print(f"{key:24} {total:.2f}")
        if not totals:
            print("(empty ledger)")
        return 0
    if cmd == "path":
        print(LEDGER)
        return 0
    print(f"unknown command: {cmd}", file=sys.stderr)
    return 2


if __name__ == "__main__":
    raise SystemExit(main(sys.argv))
