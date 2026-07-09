/* ============================================================
   WasiStudent — Screen: Payments
   ============================================================ */

const PaymentsScreen = (function() {

  function render() {
    UI.setTitle('Pagos');
    const user = Auth.current();

    // Generar pagos de ejemplo
    const payments = [
      { id: 'p1', month: 'Agosto 2026', amount: 850, status: 'pending', due: '2026-08-05', room: 'Habitación luminosa cerca de UNSAAC' },
      { id: 'p2', month: 'Julio 2026', amount: 850, status: 'paid', due: '2026-07-05', paid: '2026-07-03', room: 'Habitación luminosa cerca de UNSAAC' },
      { id: 'p3', month: 'Junio 2026', amount: 850, status: 'paid', due: '2026-06-05', paid: '2026-06-02', room: 'Habitación luminosa cerca de UNSAAC' },
      { id: 'p4', month: 'Mayo 2026', amount: 800, status: 'paid', due: '2026-05-05', paid: '2026-05-04', room: 'Habitación luminosa cerca de UNSAAC' },
    ];

    const totalPaid = payments.filter(p => p.status === 'paid').reduce((s, p) => s + p.amount, 0);
    const pending = payments.filter(p => p.status === 'pending');

    UI.render(`
      <div class="mb-6">
        <h1 style="font-size:var(--fs-2xl);font-weight:var(--fw-extrabold);margin-bottom:var(--sp-2);">Pagos</h1>
        <p class="text-2">Gestiona tus pagos de alquiler. Todos quedan registrados como respaldo legal.</p>
      </div>

      <div class="stats-grid mb-6">
        <div class="stat-card">
          <div class="stat-icon success">${Icons.checkCircle}</div>
          <div>
            <div class="stat-num">${UI.formatPrice(totalPaid)}</div>
            <div class="stat-lbl">Total pagado</div>
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
          <div class="stat-icon info">${Icons.calendar}</div>
          <div>
            <div class="stat-num">4</div>
            <div class="stat-lbl">Meses pagados</div>
          </div>
        </div>
      </div>

      ${pending.length > 0 ? `
        <div class="card card-pad-lg mb-6" style="background:var(--c-warning-soft);border-color:transparent;">
          <div class="row gap-4" style="align-items:center;">
            <div style="color:var(--c-warning);">${Icons.alert}</div>
            <div class="grow">
              <div class="fw-bold" style="color:var(--c-warning);">Tienes ${pending.length} pago(s) pendiente(s)</div>
              <p class="text-2 fs-sm">El pago vence el ${new Date(pending[0].due).toLocaleDateString('es-PE')}. Evita recargos.</p>
            </div>
            <button class="btn btn-primary" onclick="PaymentsScreen.pay('${pending[0].id}')">${Icons.dollar} Pagar S/ ${pending[0].amount}</button>
          </div>
        </div>
      ` : ''}

      <h3 style="margin-bottom:var(--sp-4);">Historial de pagos</h3>
      <div class="card card-pad-lg">
        ${payments.map(p => `
          <div class="payment-row ${p.status}">
            <div class="icon">
              ${p.status === 'paid' ? Icons.checkCircle : Icons.clock}
            </div>
            <div class="grow">
              <div class="fw-semibold">${p.month}</div>
              <div class="text-2 fs-xs">${p.room}</div>
              <div class="text-3 fs-xs mt-1">${p.status === 'paid' ? `Pagado el ${new Date(p.paid).toLocaleDateString('es-PE')}` : `Vence el ${new Date(p.due).toLocaleDateString('es-PE')}`}</div>
            </div>
            <div class="text-right">
              <div class="amount">${UI.formatPrice(p.amount)}</div>
              <span class="chip ${p.status === 'paid' ? 'chip-success' : 'chip-warning'}">${p.status === 'paid' ? 'Pagado' : 'Pendiente'}</span>
            </div>
            ${p.status === 'pending' ? `<button class="btn btn-primary btn-sm" onclick="PaymentsScreen.pay('${p.id}')">Pagar</button>` : `<button class="btn btn-ghost btn-sm" onclick="UI.toast({ title: 'Recibo generado', type: 'success' })">${Icons.file} Recibo</button>`}
          </div>
        `).join('')}
      </div>
    `);
  }

  function pay(paymentId) {
    UI.modal({
      title: 'Confirmar pago',
      size: 'sm',
      body: `
        <p class="text-2 mb-4">Estás por realizar un pago. Será procesado de forma segura.</p>
        <div class="card card-pad" style="background:var(--c-surface-2);margin-bottom:var(--sp-4);">
          <div class="row between mb-2"><span class="text-2 fs-sm">Monto</span><span class="fw-bold">S/ 850.00</span></div>
          <div class="row between mb-2"><span class="text-2 fs-sm">Comisión</span><span class="text-2">S/ 0.00</span></div>
          <div class="divider" style="margin:8px 0;"></div>
          <div class="row between"><span class="fw-bold">Total</span><span class="fw-bold" style="color:var(--c-primary);">S/ 850.00</span></div>
        </div>
        <div class="field">
          <label>Método de pago</label>
          <select class="select">
            <option>Yape / Plin</option>
            <option>Tarjeta de débito/crédito</option>
            <option>Transferencia bancaria</option>
            <option>Efectivo (agente)</option>
          </select>
        </div>
      `,
      footer: `
        <button class="btn btn-ghost" onclick="UI.closeModal()">Cancelar</button>
        <button class="btn btn-success" onclick="PaymentsScreen.confirmPay('${paymentId}')">${Icons.check} Confirmar pago</button>
      `
    });
  }

  function confirmPay(paymentId) {
    UI.closeModal();
    UI.toast({ title: '¡Pago realizado!', desc: 'Se generó tu recibo', type: 'success' });
    setTimeout(() => render(), 800);
  }

  return { render, pay, confirmPay };
})();

window.PaymentsScreen = PaymentsScreen;
