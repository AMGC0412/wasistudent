const Contract = {
  start() {
    const r = state.rooms.find(x => x.id === state.currentRoom);
    if (!r) return;
    document.getElementById('c-name').value = state.user?.name || '';
    document.getElementById('c-email').value = state.user?.email || '';
    document.getElementById('c-phone').value = state.user?.phone || '';
    Contract.checkStep1();
    go('scr-c1');
  },
  checkStep1() {
    const n = document.getElementById('c-name').value.trim();
    const d = document.getElementById('c-dni').value.trim();
    const e = document.getElementById('c-email').value.trim();
    const p = document.getElementById('c-phone').value.trim();
    const a = document.getElementById('c-addr').value.trim();
    document.getElementById('c1-btn').disabled = !(n && d.length === 8 && e && p && a);
  },
  next1() {
    if (!/^\d{8}$/.test(document.getElementById('c-dni').value.trim())) { alert('DNI: 8 dígitos'); return; }
    document.getElementById('clauses-list').innerHTML = CLAUSES.map(c => '<div class="cc" id="cl' + c.n + '"><div class="ch"><div class="cn">' + c.n + '</div><div class="ct">' + c.t + '</div></div><div class="lb">' + I.gavel + '<span>' + c.lb + '</span></div><div class="ctx">' + c.tx + '</div><label class="ack"><input type="checkbox" id="ck' + c.n + '" onchange="Contract.checkStep2()"> He leído y acepto</label></div>').join('');
    go('scr-c2');
  },
  checkStep2() {
    const ok = [1,2,3,4,5].every(i => document.getElementById('ck' + i).checked);
    document.getElementById('c2-btn').disabled = !ok;
    [1,2,3,4,5].forEach(i => { const c = document.getElementById('cl' + i); if (document.getElementById('ck' + i).checked) c.classList.add('acc'); else c.classList.remove('acc'); });
  },
  next2() {
    document.getElementById('c3-summary').innerHTML = '<h4>Resumen</h4><div class="r"><div class="lb2">Arrendatario</div><div class="vl">' + document.getElementById('c-name').value + '</div></div><div class="r"><div class="lb2">DNI</div><div class="vl">' + document.getElementById('c-dni').value + '</div></div><div class="r"><div class="lb2">Correo</div><div class="vl">' + document.getElementById('c-email').value + '</div></div><div class="r"><div class="lb2">Teléfono</div><div class="vl">' + document.getElementById('c-phone').value + '</div></div><div class="r"><div class="lb2">Cuarto</div><div class="vl">' + (state.rooms.find(x => x.id === state.currentRoom)?.title || '') + '</div></div><div class="r"><div class="lb2">Cláusulas</div><div class="vl">5/5 aceptadas</div></div>';
    document.getElementById('c3-sign-area').innerHTML = I.edit + '<p>Área de firma digital</p>';
    go('scr-c3');
  },
  checkStep3() { document.getElementById('c3-btn').disabled = !document.getElementById('c-confirm').checked; },
  async sign() {
    const b = document.getElementById('c3-btn');
    b.disabled = true; b.textContent = 'Firmando...';
    setTimeout(async () => {
      const r = state.rooms.find(x => x.id === state.currentRoom);
      const contract = { roomId: state.currentRoom, roomTitle: r?.title || '', price: r?.price || 0, tenant: document.getElementById('c-name').value, dni: document.getElementById('c-dni').value, email: document.getElementById('c-email').value, phone: document.getElementById('c-phone').value, owner: r?.owner || '', date: new Date().toISOString(), status: 'active' };
      const result = await API.createContract(contract);
      state.contracts.push(result.contract || contract);
      document.getElementById('success-msg').textContent = 'Tu contrato fue guardado. Ahora necesitamos tu opinión.';
      document.getElementById('success-icon-slot').className = 'suc';
      document.getElementById('success-icon-slot').innerHTML = '<div class="si">' + I.check + '</div><h2 style="font-size:20px;font-weight:800;margin-bottom:6px;text-align:center">Contrato firmado</h2><p id="success-msg" style="font-size:13px;color:var(--txt2);text-align:center;max-width:280px;margin:0 auto">' + ('Tu contrato fue guardado. Ahora necesitamos tu opinión.') + '</p><button class="nx" style="margin:20px auto 0;display:block;width:auto;padding:12px 28px" id="success-btn">Volver al inicio</button>';
      go('scr-success');
      setTimeout(() => { if (confirm('¿Quieres responder una breve encuesta?')) { Survey.render(); go('scr-survey'); } }, 1500);
    }, 1800);
  }
};
