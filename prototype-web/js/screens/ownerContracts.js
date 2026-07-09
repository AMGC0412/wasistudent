/* ============================================================
   WasiStudent — Screen: Owner Contracts
   ============================================================ */

const OwnerContracts = (function() {

  function render() {
    UI.setTitle('Contratos');
    const contracts = [
      { id: 'oc1', student: 'Estudiante Demo', room: 'Habitación luminosa cerca de UNSAAC', start: '2026-06-01', end: '2026-12-01', amount: 850, status: 'active', contractNum: 'WS-2026-1024' },
      { id: 'oc2', student: 'Carlos Vega', room: 'Habitación con baño privado Wanchaq', start: '2026-05-15', end: '2026-11-15', amount: 950, status: 'active', contractNum: 'WS-2026-1018' },
      { id: 'oc3', student: 'Lucía Pérez', room: 'Habitación luminosa cerca de UNSAAC', start: '2026-07-01', end: '2027-01-01', amount: 850, status: 'pending', contractNum: 'WS-2026-1042' },
      { id: 'oc4', student: 'Andrea Soto', room: 'Cuarto con vista a la ciudad San Jerónimo', start: '2026-01-15', end: '2026-07-15', amount: 700, status: 'ended', contractNum: 'WS-2026-0987' },
    ];

    UI.render(`
      <div class="row between mb-6 wrap gap-3">
        <div>
          <h1 style="font-size:var(--fs-2xl);font-weight:var(--fw-extrabold);margin-bottom:var(--sp-2);">Contratos</h1>
          <p class="text-2">${contracts.filter(c => c.status === 'active').length} activos · ${contracts.filter(c => c.status === 'pending').length} por firmar</p>
        </div>
        <button class="btn btn-primary" onclick="UI.nav('ownerRooms')">${Icons.plus} Nuevo contrato</button>
      </div>

      <div class="stats-grid mb-6">
        <div class="stat-card">
          <div class="stat-icon success">${Icons.fileCheck}</div>
          <div><div class="stat-num">${contracts.filter(c => c.status === 'active').length}</div><div class="stat-lbl">Activos</div></div>
        </div>
        <div class="stat-card">
          <div class="stat-icon accent">${Icons.clock}</div>
          <div><div class="stat-num">${contracts.filter(c => c.status === 'pending').length}</div><div class="stat-lbl">Por firmar</div></div>
        </div>
        <div class="stat-card">
          <div class="stat-icon info">${Icons.checkCircle}</div>
          <div><div class="stat-num">${contracts.filter(c => c.status === 'ended').length}</div><div class="stat-lbl">Finalizados</div></div>
        </div>
        <div class="stat-card">
          <div class="stat-icon" style="background:var(--c-primary-50);color:var(--c-primary);">${Icons.dollar}</div>
          <div><div class="stat-num">S/ ${contracts.filter(c => c.status === 'active').reduce((s, c) => s + c.amount, 0).toLocaleString('es-PE')}</div><div class="stat-lbl">Ingreso mensual</div></div>
        </div>
      </div>

      <h3 style="margin-bottom:var(--sp-4);">Todos los contratos</h3>
      ${contracts.map(c => `
        <div class="card card-pad-lg mb-3">
          <div class="row gap-4 wrap" style="align-items:flex-start;">
            <div style="width:48px;height:48px;background:var(--c-primary-50);color:var(--c-primary);border-radius:var(--r-sm);display:flex;align-items:center;justify-content:center;flex-shrink:0;">
              ${Icons.fileCheck}
            </div>
            <div class="grow">
              <div class="row between wrap mb-2">
                <div>
                  <div class="fw-bold">${c.student}</div>
                  <div class="text-2 fs-sm">${c.room}</div>
                </div>
                <span class="chip ${c.status === 'active' ? 'chip-success' : c.status === 'pending' ? 'chip-warning' : 'chip-info'}">
                  ${c.status === 'active' ? 'Activo' : c.status === 'pending' ? 'Por firmar' : 'Finalizado'}
                </span>
              </div>
              <div class="row gap-4 wrap text-2 fs-sm mb-3">
                <span>${Icons.calendar} ${new Date(c.start).toLocaleDateString('es-PE')} → ${new Date(c.end).toLocaleDateString('es-PE')}</span>
                <span>${Icons.dollar} S/ ${c.amount}/mes</span>
                <span>${Icons.file} ${c.contractNum}</span>
              </div>
              <div class="row gap-2">
                <button class="btn btn-ghost btn-sm" onclick="UI.toast({ title: 'Descargando PDF', desc: 'Contrato ' + '${c.contractNum}', type: 'success' })">${Icons.file} Descargar PDF</button>
                ${c.status === 'pending' ? `<button class="btn btn-primary btn-sm" onclick="UI.nav('contract')">${Icons.edit} Revisar</button>` : ''}
                ${c.status === 'active' ? `<button class="btn btn-ghost btn-sm" onclick="UI.nav('messages')">${Icons.chat} Contactar</button>` : ''}
              </div>
            </div>
          </div>
        </div>
      `).join('')}
    `);
  }

  return { render };
})();

window.OwnerContracts = OwnerContracts;
