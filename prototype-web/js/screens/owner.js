const Owner = {
  render() {
    const myRooms = state.rooms.filter(r => r.owner === state.user?.name);
    const reqs = state.requests;
    const income = myRooms.reduce((s, r) => s + r.price, 0);
    document.getElementById('owner-greeting').textContent = 'Hola, ' + state.user.name.split(' ')[0];
    document.getElementById('owner-stats').innerHTML = '<div class="owner-stat"><div class="os">' + I.home + '<div class="v">' + myRooms.length + '</div><div class="l">Cuartos</div></div><div class="os">' + I.chat + '<div class="v">' + reqs.length + '</div><div class="l">Solicitudes</div></div><div class="os">' + I.money + '<div class="v">S/' + income + '</div><div class="l">Ingresos</div></div></div>';
    document.getElementById('qa-rooms').textContent = myRooms.length + ' publicados';
    document.getElementById('qa-reqs').textContent = reqs.length + ' pendientes';
    document.getElementById('owner-rooms-list').innerHTML = myRooms.length === 0 ? '<div class="empty"><h3>Sin cuartos</h3><p>Publica tu primer cuarto.</p></div>' : myRooms.map(r => '<div class="rcard" onclick="Detail.open(\'' + r.id + '\')"><div class="inf"><div class="r"><div><h3>' + r.title + '</h3><div class="m">' + I.loc + r.district + '</div></div><div class="pr">S/' + r.price + '</div></div></div></div>').join('');
  },
  renderRooms() {
    const myRooms = state.rooms.filter(r => r.owner === state.user?.name);
    document.getElementById('owner-rooms-full').innerHTML = myRooms.length === 0 ? '<div class="empty">' + I.home + '<h3>Sin cuartos</h3><button class="btn btn-pri" style="margin-top:16px" onclick="go(\'scr-publish\')">Publicar</button></div>' : myRooms.map(r => '<div class="rcard"><div class="inf"><div class="r"><div><h3>' + r.title + '</h3><div class="m">' + I.loc + r.district + ' · S/' + r.price + '</div></div><div style="display:flex;gap:6px"><button class="btn btn-gst" style="padding:6px 10px;font-size:11px" onclick="Detail.open(\'' + r.id + '\')">Ver</button><button class="btn btn-out" style="padding:6px 10px;font-size:11px;color:var(--err);border-color:var(--err)" onclick="Owner.del(\'' + r.id + '\')">Eliminar</button></div></div></div></div>').join('');
  },
  async del(id) { if (!confirm('¿Eliminar?')) return; await API.deleteRoom(id); state.rooms = state.rooms.filter(r => r.id !== id); Owner.renderRooms(); },
  renderRequests() {
    document.getElementById('owner-requests-list').innerHTML = state.requests.length === 0 ? '<div class="empty">' + I.chat + '<h3>Sin solicitudes</h3></div>' : state.requests.map(r => '<div class="card"><div style="display:flex;align-items:center;gap:12px;margin-bottom:10px"><div style="width:40px;height:40px;background:var(--pri-t);border-radius:50%;display:flex;align-items:center;justify-content:center;font-size:12px;font-weight:700;color:var(--pri)">' + r.student.substring(0, 2) + '</div><div style="flex:1"><div style="font-size:13px;font-weight:700">' + r.student + '</div><div style="font-size:11px;color:var(--txt3)">' + r.uni + '</div></div><div style="background:var(--suc-bg);color:var(--suc);padding:3px 8px;border-radius:6px;font-size:10px;font-weight:700">' + r.trust + '% trust</div></div><div style="background:var(--srf2);border-radius:8px;padding:8px;font-size:12px;color:var(--txt2);margin-bottom:10px;font-style:italic">"' + r.msg + '"</div><div style="display:flex;gap:8px"><button class="btn btn-out" style="flex:1;font-size:12px;padding:8px" onclick="Owner.reqAction(\'' + r.id + '\')">Rechazar</button><button class="btn btn-suc" style="flex:1;font-size:12px;padding:8px" onclick="Owner.reqAction(\'' + r.id + '\')">Aceptar</button></div></div>').join('');
  },
  async reqAction(id) { await API.updateRequest(id, 'accept'); state.requests = state.requests.filter(r => r.id !== id); Owner.renderRequests(); alert('Solicitud procesada.'); },
  renderContracts() {
    document.getElementById('owner-contracts-list').innerHTML = state.contracts.length === 0 ? '<div class="empty">' + I.doc + '<h3>Sin contratos</h3></div>' : state.contracts.map(ct => '<div class="card"><div style="display:flex;justify-content:space-between;align-items:center"><div><div style="font-size:13px;font-weight:700">' + ct.tenant + '</div><div style="font-size:11px;color:var(--txt3)">' + ct.roomTitle + '</div></div><div style="text-align:right"><div style="font-size:15px;font-weight:800;color:var(--pri)">S/' + ct.price + '</div><div class="chip" style="background:var(--suc-bg);color:var(--suc);border-color:var(--suc);margin-top:4px">' + I.check + ' Activo</div></div></div></div>').join('');
  },
  renderPayments() {
    const total = state.contracts.reduce((s, ct) => s + ct.price, 0);
    let html = '<div class="card" style="background:linear-gradient(135deg,var(--suc),#1B5E3F);color:#fff;text-align:center;padding:20px"><div style="font-size:13px;opacity:.8">Ingresos totales</div><div style="font-size:32px;font-weight:900">S/' + total + '</div><div style="font-size:12px;opacity:.7">' + state.contracts.length + ' contratos</div></div>';
    html += '<div class="stl" style="padding-left:0">Historial</div>';
    if (state.contracts.length === 0) html += '<div class="empty"><h3>Sin pagos</h3></div>';
    else state.contracts.forEach(ct => { html += '<div class="card"><div style="display:flex;align-items:center;gap:10px"><div style="width:36px;height:36px;background:var(--suc-bg);border-radius:8px;display:flex;align-items:center;justify-content:center;color:var(--suc)">' + I.check + '</div><div style="flex:1"><div style="font-size:13px;font-weight:600">' + ct.tenant + '</div><div style="font-size:11px;color:var(--txt3)">' + new Date(ct.date).toLocaleDateString() + '</div></div><div style="font-size:14px;font-weight:800;color:var(--suc)">S/' + ct.price + '</div></div></div>'; });
    document.getElementById('owner-payments-list').innerHTML = html;
  },
  publish() {
    const title = document.getElementById('pub-title').value.trim();
    const desc = document.getElementById('pub-desc').value.trim();
    const price = parseFloat(document.getElementById('pub-price').value);
    const size = parseInt(document.getElementById('pub-size').value);
    const district = document.getElementById('pub-district').value;
    const walk = parseInt(document.getElementById('pub-walk').value);
    const type = document.getElementById('pub-type').value;
    const amen = document.getElementById('pub-amen').value.split(',').map(s => s.trim()).filter(s => s);
    const couples = document.getElementById('sw-couples').classList.contains('on');
    const pets = document.getElementById('sw-pets').classList.contains('on');
    if (!title || !desc || !price) { alert('Completa título, descripción y precio'); return; }
    const room = { title, desc, price, district, lat: -13.5319, lng: -71.9675, walk: walk || 10, size: size || 12, type, amen, owner: state.user.name, ownerAvatar: state.user.avatar, ownerRating: 0, trustScore: state.user.trustScore, memberSince: new Date(state.user.memberSince).getFullYear(), verified: 1, match: 0, featured: false, urgent: false, active: true, createdAt: Date.now(), couples, pets, foreigners: true, gender: 'any', deposit: price, services: 0, minMonths: 6 };
    API.createRoom(room).then(result => { state.rooms.push(result.room || room); alert('Cuarto publicado.'); go('scr-owner'); });
  }
};
