/* ============================================================
   WasiStudent — Screen: Owner Dashboard
   ============================================================ */

const OwnerDashboard = (function() {

  function render() {
    UI.setTitle('Dashboard');
    const user = Auth.current();

    // Habitaciones del owner
    const rooms = Seed.getRooms().slice(0, 3);
    const requests = Store.get('wasi_requests_seed', []);
    const pendingReq = requests.filter(r => r.status === 'pending');
    const contracts = 3;
    const totalIncome = 4250;
    const occupancyRate = 87;

    UI.render(`
      <div class="mb-6">
        <h1 style="font-size:var(--fs-2xl);font-weight:var(--fw-extrabold);margin-bottom:var(--sp-2);">Hola ${user.name.split(' ')[0]}, bienvenido</h1>
        <p class="text-2">Aquí tienes el resumen de tu actividad como propietario en WasiStudent.</p>
      </div>

      <!-- KPIs -->
      <div class="stats-grid mb-6">
        <div class="kpi-card">
          <div class="icon-circle">${Icons.building}</div>
          <div class="num">${rooms.length}</div>
          <div class="lbl">Habitaciones publicadas</div>
          <div class="trend up">${Icons.trending} +2 este mes</div>
        </div>
        <div class="kpi-card">
          <div class="icon-circle" style="background:var(--c-warning-soft);color:var(--c-warning);">${Icons.bell}</div>
          <div class="num">${pendingReq.length}</div>
          <div class="lbl">Solicitudes pendientes</div>
          <div class="trend up">${Icons.trending} ${pendingReq.length > 0 ? 'Revisar ahora' : 'Sin pendientes'}</div>
        </div>
        <div class="kpi-card">
          <div class="icon-circle" style="background:var(--c-success-50);color:var(--c-success);">${Icons.fileCheck}</div>
          <div class="num">${contracts}</div>
          <div class="lbl">Contratos activos</div>
          <div class="trend up">${Icons.trending} 100% al día</div>
        </div>
        <div class="kpi-card">
          <div class="icon-circle" style="background:var(--c-accent-soft);color:#8B6914;">${Icons.dollar}</div>
          <div class="num">S/ ${totalIncome.toLocaleString('es-PE')}</div>
          <div class="lbl">Ingresos del mes</div>
          <div class="trend up">${Icons.trending} +12% vs mes anterior</div>
        </div>
      </div>

      <div class="detail-grid">
        <div class="detail-main">
          <!-- Ocupación -->
          <div class="card card-pad-lg mb-4">
            <div class="row between mb-4">
              <h3 style="margin:0;">Ocupación de tus habitaciones</h3>
              <span class="chip chip-success">${occupancyRate}% promedio</span>
            </div>
            ${rooms.map(r => {
              const occ = Math.floor(70 + Math.random() * 30);
              return `
                <div class="row gap-3 mb-3" style="align-items:center;">
                  <div class="grow">
                    <div class="row between mb-1">
                      <div class="fw-semibold fs-sm truncate">${r.title}</div>
                      <div class="fw-bold fs-sm">${occ}%</div>
                    </div>
                    <div class="progress ${occ >= 80 ? 'success' : 'warning'}"><div class="bar" style="width:${occ}%"></div></div>
                  </div>
                </div>
              `;
            }).join('')}
          </div>

          <!-- Recent requests -->
          <div class="card card-pad-lg">
            <div class="row between mb-4">
              <h3 style="margin:0;">Solicitudes recientes</h3>
              <a class="link" style="color:var(--c-primary);" onclick="UI.nav('ownerRequests')">Ver todas ${Icons.chevronRight}</a>
            </div>
            ${requests.slice(0, 4).map(r => `
              <div class="request-row" style="margin-bottom:8px;">
                <div class="avatar sm">${r.studentName.charAt(0)}</div>
                <div class="grow">
                  <div class="row between">
                    <div>
                      <div class="fw-semibold fs-sm">${r.studentName}</div>
                      <div class="text-2 fs-xs truncate" style="max-width:300px;">${r.message}</div>
                    </div>
                    <div class="text-right">
                      <div class="text-3 fs-xs">${new Date(r.date).toLocaleDateString('es-PE')}</div>
                      <span class="chip ${r.status === 'pending' ? 'chip-warning' : r.status === 'approved' ? 'chip-success' : ''}">${r.status === 'pending' ? 'Pendiente' : r.status === 'approved' ? 'Aprobado' : 'Rechazado'}</span>
                    </div>
                  </div>
                </div>
                ${r.status === 'pending' ? `<button class="btn btn-primary btn-sm" onclick="UI.nav('ownerRequests')">Revisar</button>` : ''}
              </div>
            `).join('')}
          </div>
        </div>

        <div class="detail-side">
          <!-- Trust Score -->
          <div class="card card-pad-lg text-center">
            <div class="text-2 fs-sm mb-3">Tu Trust Score</div>
            ${TrustRing.render(user.trustScore || 78, { size: 120, stroke: 10 })}
            <p class="text-2 fs-sm mt-3">Los propietarios con score 80+ reciben 3x más solicitudes</p>
            <button class="btn btn-soft btn-block mt-3" onclick="UI.nav('trust')">${Icons.shieldCheck} Ver detalles</button>
          </div>

          <!-- Quick action -->
          <div class="card card-pad-lg" style="background:linear-gradient(135deg,var(--c-primary-700),var(--c-primary));color:white;border-color:transparent;">
            <h3 style="color:white;margin-bottom:var(--sp-2);">¿Publicar nueva habitación?</h3>
            <p style="opacity:0.9;font-size:var(--fs-sm);margin-bottom:var(--sp-4);">Agrega una nueva habitación y empieza a recibir solicitudes verificadas.</p>
            <button class="btn btn-block" style="background:white;color:var(--c-primary);" onclick="UI.nav('ownerRooms')">
              ${Icons.plus} Publicar habitación
            </button>
          </div>

          <!-- Tips -->
          <div class="card card-pad-lg">
            <h3 style="margin-bottom:var(--sp-3);font-size:var(--fs-md);">Tips para propietarios</h3>
            <div class="fs-sm text-2 mb-3" style="line-height:1.6;">
              <div class="row gap-2 mb-2"><span style="color:var(--c-success);">${Icons.check}</span><span>Responde en menos de 2 horas</span></div>
              <div class="row gap-2 mb-2"><span style="color:var(--c-success);">${Icons.check}</span><span>Sube fotos bien iluminadas</span></div>
              <div class="row gap-2 mb-2"><span style="color:var(--c-success);">${Icons.check}</span><span>Completa los 12 puntos de verificación</span></div>
              <div class="row gap-2"><span style="color:var(--c-success);">${Icons.check}</span><span>Precios competitivos según zona</span></div>
            </div>
          </div>
        </div>
      </div>
    `);
  }

  return { render };
})();

window.OwnerDashboard = OwnerDashboard;
