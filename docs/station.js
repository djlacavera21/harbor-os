(async () => {
  const urls = [
    "../experimentals/station.js",
    "https://raw.githubusercontent.com/djlacavera21/harbor-os/main/experimentals/station.js"
  ];
  for (const url of urls) {
    try {
      const res = await fetch(url, { cache: "no-store" });
      if (!res.ok) continue;
      const src = await res.text();
      const tag = document.createElement("script");
      tag.textContent = src;
      document.head.appendChild(tag);
      return;
    } catch (_) {}
  }
  console.warn("Harbor Experimentals: station.js failed to load");
})();
