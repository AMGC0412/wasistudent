const Trust = {
  render() {
    const score = state.user?.trustScore || 25;
    const dims = [{n:'Identidad verificada',v:30,w:.3},{n:'Contratos cumplidos',v:0,w:.3},{n:'Reseñas recibidas',v:0,w:.25},{n:'Antigüedad',v:15,w:.15}];
    let html = '<div class="trust-ring"><svg viewBox="0 0 100 100"><circle cx="50" cy="50" r="42" fill="none" stroke="var(--srf2)" stroke-width="8"/><circle cx="50" cy="50" r="42" fill="none" stroke="var(--pri)" stroke-width="8" stroke-linecap="round" stroke-dasharray="' + (score/100*264) + ' 264"/></svg><div class="val"><div class="num">' + score + '</div><div class="lab">/ 100</div></div></div>';
    html += '<div style="text-align:center;margin-bottom:20px"><div style="display:inline-block;background:var(--pri-t);color:var(--pri);padding:6px 16px;border-radius:20px;font-size:14px;font-weight:800">' + (score >= 90 ? 'Excelente' : score >= 70 ? 'Bueno' : score >= 50 ? 'Intermedio' : 'Básico') + '</div></div>';
    html += '<div class="stl" style="padding-left:0">Desglose por dimensiones</div>';
    dims.forEach(d => { html += '<div class="dim-bar"><div class="dl"><span>' + d.n + '</span><span>' + Math.round(d.v * d.w) + ' pts</span></div><div class="db"><div class="df" style="width:' + d.v + '%"></div></div></div>'; });
    document.getElementById('trust-content').innerHTML = html;
  }
};
