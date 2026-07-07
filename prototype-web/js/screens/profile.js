const Profile = {
  render() {
    if (!state.user) { go('scr-auth'); return; }
    const u = state.user;
    let html = '<div style="text-align:center;padding:20px 0"><div style="width:80px;height:80px;background:var(--pri-t);border-radius:50%;display:flex;align-items:center;justify-content:center;font-size:24px;font-weight:800;color:var(--pri);margin:0 auto 12px">' + u.avatar + '</div><h2 style="font-size:20px;font-weight:800">' + u.name + '</h2><p style="font-size:13px;color:var(--txt2);margin-top:4px">' + u.email + '</p><div style="display:inline-flex;gap:6px;margin-top:8px"><div class="chip">' + I.shield + u.trustScore + '% confianza</div><div class="chip">' + I.star + ' Miembro desde ' + new Date(u.memberSince).getFullYear() + '</div></div></div>';
    html += '<div style="display:grid;grid-template-columns:1fr 1fr;gap:8px;margin-bottom:14px"><button class="btn btn-gst" onclick="go(\'scr-trust\')">' + I.shield + ' Trust Score</button><button class="btn btn-gst" onclick="go(\'scr-favorites\')">' + I.heart + ' Favoritos</button><button class="btn btn-gst" onclick="go(\'scr-payments\')">' + I.money + ' Pagos</button><button class="btn btn-gst" onclick="go(\'scr-settings\')">' + I.settings + ' Ajustes</button></div>';
    if (state.contracts.length > 0) {
      html += '<div class="stl" style="padding-left:0">Mis contratos</div>';
      state.contracts.forEach(ct => { html += '<div class="card"><div style="display:flex;justify-content:space-between;align-items:center"><div><div style="font-size:13px;font-weight:700">' + ct.roomTitle + '</div><div style="font-size:11px;color:var(--txt3)">' + new Date(ct.date).toLocaleDateString() + '</div></div><div class="chip" style="background:var(--suc-bg);color:var(--suc);border-color:var(--suc)">' + I.check + ' Activo</div></div></div>'; });
    }
    html += '<button class="btn btn-out btn-blk" style="margin-top:8px;color:var(--err);border-color:var(--err)" onclick="Auth.logout()">' + I.logout + ' Cerrar sesión</button>';
    document.getElementById('profile-content').innerHTML = html;
  }
};
