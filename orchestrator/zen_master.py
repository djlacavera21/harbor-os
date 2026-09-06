#!/usr/bin/env python3
"""Grok Zen Master — optional local orchestrator for Harbor OS flavors."""
from __future__ import annotations
import os
from pathlib import Path
from typing import Any
import yaml
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel, Field
FLAVOR_PATH = Path(os.environ.get("HARBOR_FLAVOR", Path(__file__).resolve().parents[1] / "flavors/zen-garden/harbor.flavor.yaml"))
XAI_API_KEY = os.environ.get("XAI_API_KEY", "")
XAI_BASE = os.environ.get("XAI_BASE_URL", "https://api.x.ai/v1")
MODEL = os.environ.get("HARBOR_MODEL", "grok-4")
flavor: dict[str, Any] = {}
if FLAVOR_PATH.exists():
    flavor = yaml.safe_load(FLAVOR_PATH.read_text()) or {}
app = FastAPI(title="Harbor OS — Grok Zen Master", version="1.0.0",
              description="Optional natural-language orchestrator. Disabled unless XAI_API_KEY is set.")
app.add_middleware(CORSMiddleware, allow_origins=["http://127.0.0.1:8080", "http://localhost:8080"], allow_methods=["*"], allow_headers=["*"])
class ChatIn(BaseModel):
    message: str = Field(min_length=1, max_length=8000)
    module: str | None = None
def system_prompt() -> str:
    identity = flavor.get("identity", {})
    alignment = flavor.get("alignment", {})
    modules = ", ".join(m.get("name", m.get("id", "?")) for m in flavor.get("modules", []))
    return (
        "You are the Grok Zen Master for Harbor OS / FreshOS Zen Garden. "
        f"OS identity: {identity.get('pretty_name', 'Harbor OS')}. "
        f"Operator role: {alignment.get('operator_role', 'Operator')}. "
        f"Your role: {alignment.get('agent_role', 'Advisor')}. "
        f"Modules present: {modules or 'none declared'}. "
        "Stay calm, strategic, and long-horizon. Never claim you control the host OS. "
        "Never require cloud services when a local action exists. "
        "The operator remains in command; you advise and draft."
    )
@app.get("/health")
def health() -> dict[str, Any]:
    return {"ok": True, "flavor": flavor.get("id"), "api_key_configured": bool(XAI_API_KEY),
            "model": MODEL, "offline_capable": not bool(flavor.get("orchestrator", {}).get("requires_api_key") and not XAI_API_KEY)}
@app.get("/flavor")
def get_flavor() -> dict[str, Any]:
    return flavor
@app.post("/chat")
async def chat(body: ChatIn) -> dict[str, Any]:
    if not XAI_API_KEY:
        return {"ok": False,
                "reason": "XAI_API_KEY not set. Visualizer and modules still run offline.",
                "draft": f"[offline] Noted for module={body.module or 'general'}: {body.message}\nConfigure an API key only if you want live Grok orchestration."}
    import httpx
    payload = {"model": MODEL, "messages": [{"role": "system", "content": system_prompt()}, {"role": "user", "content": body.message}], "temperature": 0.4}
    async with httpx.AsyncClient(timeout=60.0) as client:
        res = await client.post(f"{XAI_BASE}/chat/completions", headers={"Authorization": f"Bearer {XAI_API_KEY}"}, json=payload)
        res.raise_for_status()
        data = res.json()
    return {"ok": True, "draft": data["choices"][0]["message"]["content"], "module": body.module}
if __name__ == "__main__":
    import uvicorn
    port = int(os.environ.get("HARBOR_ZEN_MASTER_PORT", "4200"))
    uvicorn.run("zen_master:app", host="127.0.0.1", port=port, reload=False)
