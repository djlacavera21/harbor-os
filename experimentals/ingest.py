#!/usr/bin/env python3
"""Local Experimentals upload rehearsal.

This is not the Grok App. It implements the same contract a future
Premium+ submenu would use: accept harbor-flavor/v1 YAML or a zip that
contains that file, validate, refuse secrets / ISO claims, write a receipt.

Premium+ is simulated with the header X-Harbor-Premium-Plus: 1
or query ?premium_plus=1. Live X entitlements are owned by xAI.
"""
from __future__ import annotations

import json
import os
import tempfile
import time
import zipfile
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
from pathlib import Path
from urllib.parse import parse_qs, urlparse

ROOT = Path(__file__).resolve().parents[1]
INBOX = Path(os.environ.get("HARBOR_INGEST_INBOX", ROOT / "experimentals" / "inbox"))
PORT = int(os.environ.get("HARBOR_INGEST_PORT", "8090"))
MAX_BYTES = 52_428_800

import sys
sys.path.insert(0, str(Path(__file__).resolve().parent))
from validate_flavor import load, validate  # noqa: E402


def extract_flavor(raw: bytes, filename: str) -> tuple[dict, str]:
    name = filename.lower()
    if name.endswith((".iso", ".img")):
        raise ValueError("ISO / disk images are forbidden")
    if len(raw) > MAX_BYTES:
        raise ValueError(f"payload exceeds {MAX_BYTES} bytes")
    if name.endswith(".zip"):
        with tempfile.TemporaryDirectory() as tmp:
            zpath = Path(tmp) / "pack.zip"
            zpath.write_bytes(raw)
            with zipfile.ZipFile(zpath) as zf:
                members = [m for m in zf.namelist() if m.endswith(("harbor.flavor.yaml", "harbor.flavor.yml", "harbor.flavor.json"))]
                if not members:
                    raise ValueError("zip must contain harbor.flavor.yaml")
                target = Path(tmp) / "harbor.flavor.yaml"
                target.write_bytes(zf.read(members[0]))
                data = load(target)
                return data, members[0]
    suffix = ".yaml" if name.endswith((".yaml", ".yml")) else ".json"
    with tempfile.NamedTemporaryFile("wb", suffix=suffix, delete=False) as fh:
        fh.write(raw)
        path = Path(fh.name)
    try:
        return load(path), filename
    finally:
        path.unlink(missing_ok=True)


class Handler(BaseHTTPRequestHandler):
    def _json(self, code: int, payload: dict) -> None:
        body = json.dumps(payload, indent=2).encode()
        self.send_response(code)
        self.send_header("Content-Type", "application/json")
        self.send_header("Access-Control-Allow-Origin", "*")
        self.send_header("Access-Control-Allow-Headers", "Content-Type, X-Harbor-Premium-Plus")
        self.send_header("Content-Length", str(len(body)))
        self.end_headers()
        self.wfile.write(body)

    def do_OPTIONS(self) -> None:
        self._json(204, {})

    def do_GET(self) -> None:
        if self.path.startswith("/health"):
            self._json(200, {
                "ok": True,
                "service": "harbor-experimentals-ingest",
                "version": (ROOT / "VERSION").read_text(encoding="utf-8").strip() if (ROOT / "VERSION").exists() else "unknown",
                "note": "Premium+ gate is local rehearsal only. xAI owns live entitlements.",
                "inbox": str(INBOX),
            })
            return
        self._json(404, {"ok": False, "error": "not found"})

    def premium_ok(self) -> bool:
        if self.headers.get("X-Harbor-Premium-Plus") in {"1", "true", "yes"}:
            return True
        qs = parse_qs(urlparse(self.path).query)
        return qs.get("premium_plus", ["0"])[0] in {"1", "true", "yes"}

    def do_POST(self) -> None:
        if not self.path.startswith("/upload"):
            self._json(404, {"ok": False, "error": "not found"})
            return
        if not self.premium_ok():
            self._json(403, {
                "ok": False,
                "error": "upload requires X Premium+ (rehearsal: send X-Harbor-Premium-Plus: 1)",
                "proposed_grok_app_gate": "premium-plus",
            })
            return
        length = int(self.headers.get("Content-Length", "0"))
        if length <= 0 or length > MAX_BYTES:
            self._json(413, {"ok": False, "error": "invalid content length"})
            return
        raw = self.rfile.read(length)
        filename = self.headers.get("X-Harbor-Filename", "upload.yaml")
        try:
            data, inner = extract_flavor(raw, filename)
        except Exception as exc:
            self._json(400, {"ok": False, "error": str(exc)})
            return
        errors = validate(data)
        if errors:
            self._json(422, {"ok": False, "error": "invalid flavor", "details": errors})
            return
        INBOX.mkdir(parents=True, exist_ok=True)
        stamp = time.strftime("%Y%m%dT%H%M%SZ", time.gmtime())
        receipt_id = f"{stamp}-{data['id']}"
        receipt = {
            "id": receipt_id,
            "accepted": True,
            "queued": "catalog.community[] review",
            "flavor_id": data["id"],
            "flavor_name": data["name"],
            "version": data["version"],
            "inner_path": inner,
            "risk": "unsigned",
            "note": "Not merged into the public catalog. Open a submit-flavor issue or PR.",
            "submit": "https://github.com/djlacavera21/harbor-os/issues/new?template=submit-flavor.yml",
        }
        (INBOX / f"{receipt_id}.json").write_text(json.dumps(receipt, indent=2) + "\n", encoding="utf-8")
        (INBOX / f"{receipt_id}.flavor.json").write_text(json.dumps(data, indent=2) + "\n", encoding="utf-8")
        self._json(202, receipt)

    def log_message(self, fmt: str, *args) -> None:
        return


def main() -> None:
    INBOX.mkdir(parents=True, exist_ok=True)
    httpd = ThreadingHTTPServer(("127.0.0.1", PORT), Handler)
    print(f"Experimentals ingest rehearsal → http://127.0.0.1:{PORT}/upload")
    print("Premium+ rehearsal header: X-Harbor-Premium-Plus: 1")
    httpd.serve_forever()


if __name__ == "__main__":
    main()
