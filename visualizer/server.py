#!/usr/bin/env python3
"""Zen Garden visualizer — local static server plus live metrics."""
from __future__ import annotations
import json, os, time
from http.server import SimpleHTTPRequestHandler, ThreadingHTTPServer
from pathlib import Path
ROOT = Path(__file__).resolve().parent
PORT = int(os.environ.get("HARBOR_VISUALIZER_PORT", "8080"))
STARTED = time.time()
def read_cpu_load() -> float:
    try:
        load1, _, _ = os.getloadavg()
        cores = os.cpu_count() or 1
        return max(0.0, min(load1 / cores, 1.5))
    except OSError:
        return 0.2
def read_mem() -> float:
    try:
        info = {}
        with open("/proc/meminfo", encoding="utf-8") as fh:
            for line in fh:
                key, raw, *_ = line.replace(":", " ").split()
                if key in {"MemTotal", "MemAvailable"}:
                    info[key] = int(raw)
        total = info.get("MemTotal") or 1
        avail = info.get("MemAvailable") or 0
        return max(0.0, min(1.0, 1.0 - (avail / total)))
    except OSError:
        return 0.4
class Handler(SimpleHTTPRequestHandler):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, directory=str(ROOT), **kwargs)
    def do_GET(self):
        if self.path.startswith("/api/metrics"):
            payload = {
                "load": round(read_cpu_load(), 3),
                "mem": round(read_mem(), 3),
                "net": 0.22,
                "agents": 1 if os.environ.get("XAI_API_KEY") else 0,
                "uptime_s": int(time.time() - STARTED),
                "flavor": "zen-garden",
            }
            body = json.dumps(payload).encode()
            self.send_response(200)
            self.send_header("Content-Type", "application/json")
            self.send_header("Cache-Control", "no-store")
            self.send_header("Content-Length", str(len(body)))
            self.end_headers()
            self.wfile.write(body)
            return
        return super().do_GET()
    def log_message(self, fmt, *args):
        return
def main() -> None:
    httpd = ThreadingHTTPServer(("127.0.0.1", PORT), Handler)
    print(f"Zen Garden visualizer → http://127.0.0.1:{PORT}")
    httpd.serve_forever()
if __name__ == "__main__":
    main()
