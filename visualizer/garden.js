(() => {
  const canvas = document.getElementById("garden");
  const ctx = canvas.getContext("2d");
  const hud = document.getElementById("hud");
  const state = { load: 0.18, mem: 0.42, net: 0.25, agents: 1, t: 0 };
  function resize() {
    const dpr = Math.min(window.devicePixelRatio || 1, 2);
    canvas.width = canvas.clientWidth * dpr;
    canvas.height = canvas.clientHeight * dpr;
    ctx.setTransform(dpr, 0, 0, dpr, 0, 0);
  }
  window.addEventListener("resize", resize);
  resize();
  async function pollMetrics() {
    try {
      const res = await fetch("/api/metrics", { cache: "no-store" });
      if (res.ok) Object.assign(state, await res.json());
    } catch {
      state.load = 0.12 + 0.08 * Math.sin(state.t * 0.4);
      state.mem = 0.4 + 0.05 * Math.sin(state.t * 0.21);
      state.net = 0.2 + 0.15 * Math.abs(Math.sin(state.t * 0.33));
    }
  }
  setInterval(pollMetrics, 2000);
  pollMetrics();
  function rake(w, h, intensity) {
    const rows = 18;
    ctx.save();
    ctx.strokeStyle = "rgba(90, 70, 40, 0.28)";
    ctx.lineWidth = 1.2;
    for (let i = 0; i < rows; i++) {
      const y = (h * 0.18) + (i / rows) * h * 0.64;
      ctx.beginPath();
      for (let x = w * 0.08; x < w * 0.92; x += 6) {
        const wave = Math.sin(x * 0.018 + state.t * 0.6 + i * 0.4) * (6 + intensity * 14);
        const yy = y + wave;
        if (x === w * 0.08) ctx.moveTo(x, yy);
        else ctx.lineTo(x, yy);
      }
      ctx.stroke();
    }
    ctx.restore();
  }
  function stone(x, y, r, shade) {
    ctx.save();
    ctx.translate(x, y);
    ctx.beginPath();
    ctx.ellipse(0, 0, r * 1.15, r * 0.78, -0.3, 0, Math.PI * 2);
    ctx.fillStyle = shade;
    ctx.fill();
    ctx.beginPath();
    ctx.ellipse(-r * 0.25, -r * 0.2, r * 0.35, r * 0.18, -0.4, 0, Math.PI * 2);
    ctx.fillStyle = "rgba(255,255,255,0.08)";
    ctx.fill();
    ctx.restore();
  }
  function lantern(x, y, lit) {
    ctx.save();
    ctx.translate(x, y);
    ctx.fillStyle = "#3a342c";
    ctx.fillRect(-6, 10, 12, 18);
    ctx.fillRect(-10, 6, 20, 6);
    ctx.fillRect(-8, -10, 16, 16);
    if (lit) {
      const g = ctx.createRadialGradient(0, -2, 1, 0, -2, 28);
      g.addColorStop(0, "rgba(232,195,106,0.85)");
      g.addColorStop(1, "rgba(232,195,106,0)");
      ctx.fillStyle = g;
      ctx.beginPath();
      ctx.arc(0, -2, 28, 0, Math.PI * 2);
      ctx.fill();
      ctx.fillStyle = "#f3d48a";
      ctx.fillRect(-5, -6, 10, 10);
    }
    ctx.restore();
  }
  function bridge(w, h) {
    const y = h * 0.72;
    ctx.strokeStyle = "rgba(70,62,50,0.85)";
    ctx.lineWidth = 4;
    ctx.beginPath();
    ctx.moveTo(w * 0.18, y);
    ctx.quadraticCurveTo(w * 0.5, y - 70, w * 0.82, y);
    ctx.stroke();
  }
  function orb(w, h) {
    const x = w * 0.5;
    const y = h * 0.42;
    const pulse = 0.65 + 0.35 * Math.sin(state.t * 2);
    const rad = 22 + pulse * 6;
    const g = ctx.createRadialGradient(x, y, 4, x, y, rad * 3);
    g.addColorStop(0, `rgba(126,200,196,${0.55 + pulse * 0.25})`);
    g.addColorStop(1, "rgba(126,200,196,0)");
    ctx.fillStyle = g;
    ctx.beginPath();
    ctx.arc(x, y, rad * 3, 0, Math.PI * 2);
    ctx.fill();
    ctx.fillStyle = "#d7f3f1";
    ctx.beginPath();
    ctx.arc(x, y, rad * 0.45, 0, Math.PI * 2);
    ctx.fill();
  }
  function draw() {
    const w = canvas.clientWidth;
    const h = canvas.clientHeight;
    ctx.clearRect(0, 0, w, h);
    const sand = ctx.createLinearGradient(0, 0, 0, h);
    sand.addColorStop(0, "#3a3328");
    sand.addColorStop(0.5, "#2c271f");
    sand.addColorStop(1, "#1a1712");
    ctx.fillStyle = sand;
    ctx.fillRect(0, 0, w, h);
    rake(w, h, state.load);
    bridge(w, h);
    stone(w * 0.28, h * 0.48, 18 + state.mem * 16, "#5c564b");
    stone(w * 0.33, h * 0.52, 11 + state.mem * 8, "#6d665b");
    stone(w * 0.68, h * 0.46, 16 + state.mem * 10, "#524c43");
    lantern(w * 0.2, h * 0.62, state.net > 0.15);
    lantern(w * 0.8, h * 0.6, state.net > 0.35);
    orb(w, h);
    hud.innerHTML =
      `<b>load</b> ${(state.load * 100).toFixed(0)}% &nbsp;` +
      `<b>memory stones</b> ${(state.mem * 100).toFixed(0)}% &nbsp;` +
      `<b>lanterns</b> ${(state.net * 100).toFixed(0)}% &nbsp;` +
      `<b>agents</b> ${state.agents}`;
    state.t += 0.016;
    requestAnimationFrame(draw);
  }
  draw();
})();
