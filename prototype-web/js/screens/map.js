const MapScreen = {
  render() {
    let h = '<svg style="position:absolute;inset:0;opacity:.3" viewBox="0 0 400 400"><defs><pattern id="g" width="40" height="40" patternUnits="userSpaceOnUse"><path d="M40 0L0 0 0 40" fill="none" stroke="rgba(0,0,0,0.06)" stroke-width="1"/></pattern></defs><rect width="400" height="400" fill="url(#g)"/><path d="M0 180 Q100 160 200 200 T400 210" stroke="rgba(196,69,54,0.15)" stroke-width="8" fill="none"/><circle cx="180" cy="160" r="25" fill="rgba(45,106,79,0.1)" stroke="rgba(45,106,79,0.2)" stroke-width="2"/></svg>';
    state.rooms.forEach((r, i) => {
      const x = 50 + (i * 70) % 300, y = 80 + Math.floor(i / 4) * 100;
      h += '<div class="map-pin ' + (r.verified >= 2 ? 'verified' : '') + '" style="left:' + x + 'px;top:' + y + 'px" onclick="Detail.open(\'' + r.id + '\')"><div class="pp">S/' + r.price + '</div></div>';
    });
    document.getElementById('map-area').innerHTML = h;
    document.getElementById('map-card').innerHTML = '<div style="background:var(--srf);border:1px solid var(--bdr-l);border-radius:12px;padding:10px;display:flex;align-items:center;gap:8px"><div style="width:12px;height:12px;background:var(--suc);border-radius:50%"></div><span style="font-size:12px;color:var(--txt2)">Verificado</span><div style="width:12px;height:12px;background:var(--pri);border-radius:50%;margin-left:12px"></div><span style="font-size:12px;color:var(--txt2)">Básico</span><div style="flex:1"></div><span style="font-size:12px;font-weight:700">' + state.rooms.length + ' cuartos</span></div>';
  }
};
