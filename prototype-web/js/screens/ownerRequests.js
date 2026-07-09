/* ============================================================
   WasiStudent — Screen: Owner Requests
   ============================================================ */

const OwnerRequests = (function() {

  let activeFilter = 'all';

  function render() {
    UI.setTitle('Solicitudes');
    const requests = Store.get('wasi_requests_seed', []);
    const filtered = activeFilter === 'all' ? requests : requests.filter(r => r.status === activeFilter);

    UI.render(`
      <div class="mb-6">
        <h1 style="font-size:var(--fs-2xl);font-weight:var(--fw-extrabold);margin-bottom:var(--sp-2);">Solicitudes recibidas</h1>
        <p class="text-2">${requests.filter(r => r.status === 'pending').length} pendientes de revisión</p>
      </div>

      <div class="tabs mb-6" style="border-bottom:none;">
        <div class="tab ${activeFilter === 'all' ? 'active' : ''}" onclick="OwnerRequests.setFilter('all')">Todas (${requests.length})</div>
        <div class="tab ${activeFilter === 'pending' ? 'active' : ''}" onclick="OwnerRequests.setFilter('pending')">Pendientes (${requests.filter(r => r.status === 'pending').length})</div>
        <div class="tab ${activeFilter === 'approved' ? 'active' : ''}" onclick="OwnerRequests.setFilter('approved')">Aprobadas (${requests.filter(r => r.status === 'approved').length})</div>
        <div class="tab ${activeFilter === 'rejected' ? 'active' : ''}" onclick="OwnerRequests.setFilter('rejected')">Rechazadas (${requests.filter(r => r.status === 'rejected').length})</div>
      </div>

      ${filtered.length === 0 ? `
        <div class="empty-state">
          <div class="icon-circle">${Icons.bell}</div>
          <h3>No hay solicitudes en esta categoría</h3>
          <p>Cuando recibas solicitudes de estudiantes, aparecerán aquí.</p>
        </div>
      ` : filtered.map(r => `
        <div class="card card-pad-lg mb-3">
          <div class="row gap-4 wrap" style="align-items:flex-start;">
            <div class="avatar lg">${r.studentName.charAt(0)}</div>
            <div class="grow">
              <div class="row between wrap mb-2">
                <div>
                  <div class="fw-bold fs-md">${r.studentName}</div>
                  <div class="text-2 fs-xs">${new Date(r.date).toLocaleDateString('es-PE', { weekday: 'long', day: 'numeric', month: 'long' })}</div>
                </div>
                <span class="chip ${r.status === 'pending' ? 'chip-warning' : r.status === 'approved' ? 'chip-success' : 'chip-error'}">
                  ${r.status === 'pending' ? 'Pendiente' : r.status === 'approved' ? 'Aprobada' : 'Rechazada'}
                </span>
              </div>
              <div class="card" style="background:var(--c-surface-2);padding:var(--sp-3);margin-bottom:var(--sp-3);border-color:transparent;">
                <div class="row gap-2" style="align-items:center;">
                  ${Icons.building}
                  <div>
                    <div class="fw-semibold fs-sm">${r.roomTitle}</div>
                    <div class="text-3 fs-xs">Solicitud de ${r.type === 'visit' ? 'visita' : 'alquiler'}</div>
                  </div>
                </div>
              </div>
              <div class="row gap-2 mb-3" style="align-items:flex-start;">
                ${Icons.chat}
                <div class="text-2 fs-sm" style="font-style:italic;">"${r.message}"</div>
              </div>
              ${r.status === 'pending' ? `
                <div class="row gap-2">
                  <button class="btn btn-success btn-sm" onclick="OwnerRequests.respond('${r.id}', 'approved')">${Icons.check} Aprobar</button>
                  <button class="btn btn-ghost btn-sm" style="color:var(--c-error);" onclick="OwnerRequests.respond('${r.id}', 'rejected')">${Icons.x} Rechazar</button>
                  <button class="btn btn-ghost btn-sm" onclick="UI.nav('messages')">${Icons.chat} Mensaje</button>
                </div>
              ` : `
                <div class="row gap-2">
                  <button class="btn btn-ghost btn-sm" onclick="UI.nav('messages')">${Icons.chat} Ver conversación</button>
                  ${r.status === 'approved' && r.type === 'rental' ? `<button class="btn btn-primary btn-sm" onclick="UI.nav('ownerContracts')">${Icons.fileCheck} Ver contrato</button>` : ''}
                </div>
              `}
            </div>
          </div>
        </div>
      `).join('')}
    `);
  }

  function setFilter(filter) {
    activeFilter = filter;
    render();
  }

  function respond(reqId, status) {
    const requests = Store.get('wasi_requests_seed', []);
    const req = requests.find(r => r.id === reqId);
    if (req) req.status = status;
    Store.set('wasi_requests_seed', requests);
    UI.toast({
      title: status === 'approved' ? 'Solicitud aprobada' : 'Solicitud rechazada',
      desc: status === 'approved' ? 'El estudiante será notificado' : 'El estudiante será notificado',
      type: status === 'approved' ? 'success' : 'info'
    });
    setTimeout(() => render(), 800);
  }

  return { render, setFilter, respond };
})();

window.OwnerRequests = OwnerRequests;
