const Home = {
  render() {
    if (!state.user) { go('scr-auth'); return; }
    const rooms = state.rooms.filter(r => r.active);
    document.getElementById('home-greeting').textContent = 'Hola, ' + state.user.name.split(' ')[0];
    document.getElementById('home-sub').textContent = rooms.length > 0 ? rooms.length + ' opciones verificadas para ti.' : 'No hay cuartos disponibles aún.';
    
    let html = '<div style="background:var(--pri-t);margin:0 18px 14px;padding:14px;border-radius:14px;display:flex;align-items:center;gap:12px;cursor:pointer" onclick="go(\'scr-settings\')"><div style="width:40px;height:40px;background:var(--pri);border-radius:10px;display:flex;align-items:center;justify-content:center;color:#fff">' + I.settings + '</div><div style="flex:1"><div style="font-size:14px;font-weight:700">Ajusta tus prioridades</div><div style="font-size:11px;color:var(--txt2)">Pesos balanceados (recomendado)</div></div></div>';
    
    if (rooms.length > 0) {
      html += '<div class="stl">Para ti</div>';
      rooms.slice(0, 3).forEach(r => html += Components.roomCard(r));
      const verified = rooms.filter(r => r.verified >= 2);
      if (verified.length > 0) {
        html += '<div class="stl">Verificados recientemente</div>';
        verified.slice(0, 2).forEach(r => html += Components.roomCard(r));
      }
    }
    document.getElementById('home-content').innerHTML = html;
  }
};
