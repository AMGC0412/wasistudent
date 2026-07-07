const Payments = {
  render() {
    if (state.contracts.length === 0) { document.getElementById('payments-content').innerHTML = '<div class="empty">' + I.money + '<h3>Sin pagos</h3></div>'; return; }
    let html = '<div class="card" style="background:linear-gradient(135deg,var(--pri),var(--pri-d));color:#fff"><div style="font-size:13px;opacity:.8">Próximo pago</div><div style="font-size:28px;font-weight:900">S/' + state.contracts[0].price + '</div><div style="font-size:12px;opacity:.7">' + state.contracts[0].roomTitle + '</div></div>';
    html += '<div class="stl" style="padding-left:0">Historial</div>';
    state.contracts.forEach(ct => { html += '<div class="card"><div style="display:flex;align-items:center;gap:10px"><div style="width:36px;height:36px;background:var(--suc-bg);border-radius:8px;display:flex;align-items:center;justify-content:center;color:var(--suc)">' + I.check + '</div><div style="flex:1"><div style="font-size:13px;font-weight:600">' + ct.roomTitle + '</div><div style="font-size:11px;color:var(--txt3)">' + new Date(ct.date).toLocaleDateString() + '</div></div><div style="font-size:14px;font-weight:800;color:var(--pri)">S/' + ct.price + '</div></div></div>'; });
    document.getElementById('payments-content').innerHTML = html;
  }
};
