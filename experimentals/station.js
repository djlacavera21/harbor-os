(() => {
  const FALLBACK = {
    official: [{id:"zen-garden",name:"FreshOS Zen Garden Edition",version:"1.0.1",download:"https://github.com/djlacavera21/harbor-os/archive/refs/heads/main.zip",source:"https://github.com/djlacavera21/harbor-os",flavor:"https://github.com/djlacavera21/harbor-os/blob/main/flavors/zen-garden/harbor.flavor.yaml",risk:"low",summary:"Mint overlay, Zen Garden visualizer, optional Grok Zen Master."}],
    community: [
      {id:"war-room",name:"War Room Harbor",version:"0.1.0",download:"https://github.com/djlacavera21/harbor-os/archive/refs/heads/main.zip",source:"https://github.com/djlacavera21/harbor-os/tree/main/flavors/war-room",risk:"unsigned",summary:"Strategy-first module weighting."},
      {id:"research-harbor",name:"Research Harbor",version:"0.1.0",download:"https://github.com/djlacavera21/harbor-os/archive/refs/heads/main.zip",source:"https://github.com/djlacavera21/harbor-os/tree/main/flavors/research-harbor",risk:"unsigned",summary:"Research wing default."},
      {id:"airgap-tui",name:"Airgap TUI Station",version:"0.1.0",download:"https://github.com/djlacavera21/harbor-os/archive/refs/heads/main.zip",source:"https://github.com/djlacavera21/harbor-os/tree/main/flavors/airgap-tui",risk:"unsigned",summary:"Minimal TUI-oriented flavor."},
      {id:"publishing-harbor",name:"Publishing Harbor",version:"0.1.0",download:"https://github.com/djlacavera21/harbor-os/archive/refs/heads/main.zip",source:"https://github.com/djlacavera21/harbor-os/tree/main/flavors/publishing-harbor",risk:"unsigned",summary:"Outbound drafts. Upload gate proposed as X Premium+."}
    ]
  };
  const REQUIRED = ["schema","id","name","version","base","identity"];
  const DISTROS = new Set(["linuxmint","debian","ubuntu","fedora","arch","none"]);
  function parseMaybeYaml(text) {
    try { return JSON.parse(text); } catch (_) {}
    const data = {}; let key = null, buf = [];
    const take = () => {
      if (!key) return;
      const raw = buf.join("\n").trim();
      if (raw.startsWith("|") || raw.startsWith(">")) data[key] = raw.replace(/^[|>]\s*/, "");
      else if (raw.startsWith("- ")) data[key] = raw.split(/\n- /).map(s => s.replace(/^- /, ""));
      else data[key] = raw;
    };
    for (const line of text.split(/\r?\n/)) {
      if (/^[a-zA-Z0-9_]+:/.test(line) && !line.startsWith(" ")) {
        take(); const i = line.indexOf(":"); key = line.slice(0, i); buf = [line.slice(i + 1)];
      } else buf.push(line);
    }
    take();
    if (typeof data.base === "string") data.base = { distro: data.base };
    return data;
  }
  function validateFlavor(data) {
    const errors = [];
    if (!data || typeof data !== "object") return ["document is not an object"];
    for (const k of REQUIRED) if (!(k in data)) errors.push("missing " + k);
    if (data.schema && data.schema !== "harbor-flavor/v1") errors.push("schema must be harbor-flavor/v1");
    const distro = data.base && data.base.distro;
    if (distro && !DISTROS.has(distro)) errors.push("unsupported base.distro: " + distro);
    const id = data.identity || {};
    if (data.identity && (!id.os_name || !id.codename)) errors.push("identity needs os_name and codename");
    const blob = JSON.stringify(data).toLowerCase();
    for (const secret of ["api_key", "xai_api_key", "begin rsa private", "sk-"])
      if (blob.includes(secret)) errors.push("possible secret material: " + secret);
    if (/\bofficial (xai|grok) os\b/.test(blob)) errors.push("community flavors may not claim official xAI status");
    return errors;
  }
  function card(item, official) {
    const el = document.createElement("article");
    el.className = "flavor";
    el.innerHTML = `<div class="meta">${official ? "Official" : "Community"} · ${item.version || ""} · <span class="risk ${item.risk || "unsigned"}">${item.risk || "unsigned"}</span></div><h3>${item.name}</h3><p class="lead">${item.summary || ""}</p><div class="row">${item.download ? `<a class="btn" href="${item.download}">Download</a>` : ""}${item.source ? `<a class="btn ghost" href="${item.source}">Source</a>` : ""}${item.flavor ? `<a class="btn ghost" href="${item.flavor}">Flavor file</a>` : ""}</div>`;
    return el;
  }
  async function loadCatalog() {
    let catalog = null;
    const urls = ["catalog.json", "./catalog.json", "https://raw.githubusercontent.com/djlacavera21/harbor-os/main/experimentals/catalog.json"];
    for (const u of urls) {
      try { const res = await fetch(u, { cache: "no-store" }); if (res.ok) { catalog = await res.json(); break; } } catch (_) {}
    }
    if (!catalog) catalog = FALLBACK;
    const og = document.getElementById("official-grid");
    const fg = document.getElementById("flavor-grid");
    if (!og || !fg) return;
    og.innerHTML = ""; fg.innerHTML = "";
    (catalog.official || []).forEach(i => og.appendChild(card(i, true)));
    (catalog.official || []).concat(catalog.community || []).forEach(i => fg.appendChild(card(i, (catalog.official || []).some(o => o.id === i.id))));
  }
  function showTab(id) {
    document.querySelectorAll("section").forEach(s => s.classList.toggle("active", s.id === id));
    document.querySelectorAll(".tab").forEach(t => t.classList.toggle("active", t.dataset.tab === id));
    if (location.hash.replace("#", "") !== id) history.replaceState(null, "", "#" + id);
  }
  document.querySelectorAll(".tab").forEach(btn => btn.addEventListener("click", () => showTab(btn.dataset.tab)));
  window.addEventListener("hashchange", () => { const id = (location.hash || "#official").slice(1); if (document.getElementById(id)) showTab(id); });
  if (location.hash && document.getElementById(location.hash.slice(1))) showTab(location.hash.slice(1));
  const premium = document.getElementById("premium");
  const file = document.getElementById("file");
  const yaml = document.getElementById("yaml");
  const validateBtn = document.getElementById("validate");
  const packetBtn = document.getElementById("packet");
  const log = document.getElementById("log");
  function setGate(on) {
    [file, yaml, validateBtn, packetBtn].forEach(el => { if (el) el.disabled = !on; });
    if (log) log.textContent = on ? "Gate open (local Premium+ simulation). Validate before you submit a PR." : "Gate closed. Enable Premium+ simulation to upload.";
  }
  if (premium) premium.addEventListener("change", () => setGate(premium.checked));
  if (file) file.addEventListener("change", async () => {
    const f = file.files[0]; if (!f) return;
    if (f.size > 50 * 1024 * 1024) { log.innerHTML = '<span class="bad">File exceeds 50 MiB community cap.</span>'; return; }
    if (/\.(iso|img)$/i.test(f.name)) { log.innerHTML = '<span class="bad">ISO / disk images are forbidden in flavor packs.</span>'; return; }
    yaml.value = await f.text();
    log.textContent = "Loaded " + f.name + " (" + f.size + " bytes)";
  });
  function currentDoc() {
    const text = yaml.value.trim();
    if (!text) return { errors: ["nothing to validate"], data: null, text };
    try { const data = parseMaybeYaml(text); return { errors: validateFlavor(data), data, text }; }
    catch (e) { return { errors: ["parse failed: " + e.message], data: null, text }; }
  }
  if (validateBtn) validateBtn.addEventListener("click", () => {
    const { errors, data } = currentDoc();
    log.innerHTML = errors.length ? '<span class="bad">INVALID</span>\n' + errors.map(e => "  - " + e).join("\n") : '<span class="ok">VALID ' + data.id + "@" + data.version + " (" + data.name + ")</span>';
  });
  if (packetBtn) packetBtn.addEventListener("click", () => {
    const { errors, data, text } = currentDoc();
    if (errors.length) { log.innerHTML = '<span class="bad">Fix validation first.</span>\n' + errors.map(e => "  - " + e).join("\n"); return; }
    const packet = { schema: "harbor-experimentals-submission/v1", proposed_gate: "X Premium+", submitted_at: new Date().toISOString(), flavor: data, catalog_patch: { community: [{ id: data.id, name: data.name, version: data.version, channel: "community", risk: "unsigned", min_subscription: "none", summary: data.summary || "", flavor: "flavors/" + data.id + "/harbor.flavor.yaml" }] }, publish_via: "https://github.com/djlacavera21/harbor-os/issues/new?template=submit-flavor.yml" };
    const blob = new Blob([JSON.stringify(packet, null, 2) + "\n\n--- flavor ---\n" + text], { type: "text/plain" });
    const a = document.createElement("a"); a.href = URL.createObjectURL(blob); a.download = data.id + ".harbor-submission.txt"; a.click();
    log.innerHTML = '<span class="ok">Packet ready.</span> Open a PR or issue that adds flavors/' + data.id + "/harbor.flavor.yaml and catalog.community[].";
  });
  loadCatalog();
  const canvas = document.getElementById("mini-garden");
  if (!canvas) return;
  const ctx = canvas.getContext("2d");
  const state = { load: 0.18, mem: 0.42, net: 0.28, t: 0 };
  function resize() {
    const dpr = Math.min(window.devicePixelRatio || 1, 2);
    canvas.width = canvas.clientWidth * dpr; canvas.height = canvas.clientHeight * dpr;
    ctx.setTransform(dpr, 0, 0, dpr, 0, 0);
  }
  window.addEventListener("resize", resize); resize();
  function draw() {
    const w = canvas.clientWidth, h = canvas.clientHeight;
    const sand = ctx.createLinearGradient(0, 0, 0, h);
    sand.addColorStop(0, "#3a3328"); sand.addColorStop(1, "#1a1712");
    ctx.fillStyle = sand; ctx.fillRect(0, 0, w, h);
    ctx.strokeStyle = "rgba(90,70,40,0.32)"; ctx.lineWidth = 1;
    for (let i = 0; i < 12; i++) {
      const y = h * 0.18 + (i / 12) * h * 0.62; ctx.beginPath();
      for (let x = w * 0.04; x < w * 0.96; x += 5) {
        const wave = Math.sin(x * 0.02 + state.t * 0.7 + i * 0.35) * (4 + state.load * 10);
        if (x === w * 0.04) ctx.moveTo(x, y + wave); else ctx.lineTo(x, y + wave);
      }
      ctx.stroke();
    }
    function stone(x, y, r, c) { ctx.beginPath(); ctx.ellipse(x, y, r * 1.2, r * 0.72, -0.25, 0, Math.PI * 2); ctx.fillStyle = c; ctx.fill(); }
    stone(w * 0.28, h * 0.52, 10 + state.mem * 8, "#5c564b");
    stone(w * 0.34, h * 0.56, 7 + state.mem * 5, "#6d665b");
    stone(w * 0.7, h * 0.48, 12 + state.mem * 6, "#524c43");
    const ox = w * 0.5, oy = h * 0.4, pulse = 0.65 + 0.35 * Math.sin(state.t * 2);
    const g = ctx.createRadialGradient(ox, oy, 2, ox, oy, 28 + pulse * 10);
    g.addColorStop(0, "rgba(126,200,196," + (0.55 + pulse * 0.2) + ")"); g.addColorStop(1, "rgba(126,200,196,0)");
    ctx.fillStyle = g; ctx.beginPath(); ctx.arc(ox, oy, 36, 0, Math.PI * 2); ctx.fill();
    ctx.fillStyle = "#d7f3f1"; ctx.beginPath(); ctx.arc(ox, oy, 6 + pulse * 2, 0, Math.PI * 2); ctx.fill();
    function lantern(x, y, lit) {
      ctx.fillStyle = "#3a342c"; ctx.fillRect(x - 4, y, 8, 12); ctx.fillRect(x - 6, y - 8, 12, 10);
      if (lit) { const lg = ctx.createRadialGradient(x, y - 4, 1, x, y - 4, 18); lg.addColorStop(0, "rgba(232,195,106,0.8)"); lg.addColorStop(1, "rgba(232,195,106,0)"); ctx.fillStyle = lg; ctx.beginPath(); ctx.arc(x, y - 4, 18, 0, Math.PI * 2); ctx.fill(); }
    }
    lantern(w * 0.16, h * 0.62, state.net > 0.15);
    lantern(w * 0.86, h * 0.58, state.net > 0.25);
    state.t += 0.016; requestAnimationFrame(draw);
  }
  draw();
})();
