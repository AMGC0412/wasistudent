/* ============================================================
   WasiStudent — Screen: Owner Payments
   ============================================================ */

const OwnerPayments = (function() {

  function render() {
    UI.setTitle('Pagos recibidos');
    const payments = [
      { id: 'op1', student: 'Estudiante Demo', month: 'Julio 2026', amount: 850, status: 'received', date: '2026-07-03', method: 'Yape' },
      { id: 'op2', student: 'Carlos Vega', month: 'Julio 2026', amount: 950, status: 'received', date: '2026-07-05', method: 'Plin' },
      { id: 'op3', student: 'Estudiante Demo', month: 'Agosto 2026', amount: 850, status: 'pending', due: '2026-08-05', method: '—' },
      { id: 'op4', student: 'Carlos Vega', month: 'Agosto 2026', amount: 950, status: 'pending', due: '2026-08-05', method: '—' },
      { id: 'op5', student: 'Andrea Soto', month: 'Junio 2026', amount: 700, status: 'received', date: '2026-06-04', method: 'Banco' },
    ];

    const total = payments.filter(p => p.status === 'received').reduce((s, p) => s + p.amount, 0);
    const pending = payments.filter(p => p.status === 'pending');

    UI.render(`
      <div class="mb-6">
        <h1 style="font-size:var(--fs-2xl);font-weight:var(--fw-extrabold);margin-bottom:var(--sp-2);">Pagos recibidos</h1>
        <p class="text-2">Historial completo de pagos de tus inquilinos.</p>
      </div>

      <div class="stats-grid mb-6">
        <div class="stat-card">
          <div class="stat-icon success">${Icons.dollar}</div>
          <div>
            <div class="stat-num">S/ ${total.toLocaleString('es-PE')}</div>
            <div class="stat-lbl">Total recibido</div>
          </div>
        </div>
        <div class="stat-card">
          <div class="stat-icon accent">${Icons.clock}</div>
          <div>
            <div class="stat-num">${pending.length}</div>
            <div class="stat-lbl">Pendientes</div>
          </div>
        </div>
        <div class="stat-card">
          <div class="stat-icon info">${Icons.checkCircle}</div>
          <div>
            <div class="stat-num">${payments.filter(p => p.status === 'received').length}</div>
            <div class="stat-lbl">Recibidos</div>
          </div>
        </div>
      </div>

      <h3 style="margin-bottom:var(--sp-4);">Historial de pagos</h3>
      <div class="card card-pad-lg">
        ${payments.map(p => `
          <div class="payment-row ${p.status === 'pending' ? 'pending' : ''}">
            <div class="icon">${p.status === 'received' ? Icons.checkCircle : Icons.clock}</div>
            <div class="grow">
              <div class="fw-semibold">${p.student}</div>
              <div class="text-2 fs-xs">${p.month} · ${p.method}</div>
              <div class="text-3 fs-xs mt-1">${p.status === 'received' ? `Recibido el ${new Date(p.date).toLocaleDateString('es-PE')}` : `Vence el ${new Date(p.due).toLocaleDateString('es-PE')}`}</div>
            </div>
            <div class="text-right">
              <div class="amount">${UI.formatPrice(p.amount)}</div>
              <span class="chip ${p.status === 'received' ? 'chip-success' : 'chip-warning'}">${p.status === 'received' ? 'Recibido' : 'Pendiente'}</span>
            </div>
            ${p.status === 'received' ? `<button class="btn btn-ghost btn-sm" onclick="UI.toast({ title: 'Recibo generado', type: 'success' })">${Icons.file} Recibo</button>` : `<button class="btn btn-ghost btn-sm" onclick="UI.nav('messages')">${Icons.chat} Recordar</button>`}
          </div>
        `).join('')}
      </div>
    `);
  }

  return { render };
})();

window.OwnerPayments = OwnerPayments;
