/* ============================================================
   WasiStudent — Screen: Home (dashboard estudiante)
   ============================================================ */

const HomeScreen = (function() {

  function render() {
    UI.setTitle('Inicio');
    const user = Auth.current();
    const allRooms = Seed.getRooms();
    const favCount = Store.get(Store.KEYS.FAVORITES, []).length;
    const requests = Store.get('wasi_requests_seed', []).filter(r => r.studentId === user.id);

    // Top picks: ordenar por trust score + match
    const topPicks = [...allRooms]
      .sort((a, b) => (b.trustScore + RoomCard.computeMatch(b)) - (a.trustScore + RoomCard.computeMatch(a)))
      .slice(0, 4);

    // Recomendados cerca
    const nearYou = [...allRooms]
      .sort((a, b) => a.walkMinutes - b.walkMinutes)
      .slice(0, 4);

    UI.render(`
      <!-- Hero -->
      <div class="hero">
        <div class="hero-content">
          <h1>Hola ${user.name.split(' ')[0]}, tu wasi te espera</h1>
          <p>Explora habitaciones verificadas cerca de ${Seed.UNIVERSITIES.find(u => u.id === (user.preferences?.university || 'UNSAAC'))?.short || 'tu universidad'}. Cada una con verificación en 12 puntos y contrato legal.</p>
          <div class="row gap-3 wrap">
            <button class="btn btn-primary btn-lg" onclick="UI.nav('discover')">
              ${Icons.search} Explorar habitaciones
            </button>
            <button class="btn btn-ghost btn-lg" style="color:white;border-color:rgba(255,255,255,0.3);" onclick="UI.nav('trust')">
              ${Icons.shieldCheck} Ver mi Trust Score
            </button>
          </div>
        </div>
      </div>

      <!-- Stats -->
      <div class="stats-grid">
        <div class="stat-card">
          <div class="stat-icon">${Icons.building}</div>
          <div>
            <div class="stat-num">${allRooms.length}</div>
            <div class="stat-lbl">Habitaciones disponibles</div>
          </div>
        </div>
        <div class="stat-card">
          <div class="stat-icon success">${Icons.shieldCheck}</div>
          <div>
            <div class="stat-num">${allRooms.filter(r => r.verified).length}</div>
            <div class="stat-lbl">Verificadas (12 pts)</div>
          </div>
        </div>
        <div class="stat-card">
          <div class="stat-icon accent">${Icons.heart}</div>
          <div>
            <div class="stat-num">${favCount}</div>
            <div class="stat-lbl">Tus favoritos</div>
          </div>
        </div>
        <div class="stat-card">
          <div class="stat-icon info">${Icons.fileCheck}</div>
          <div>
            <div class="stat-num">${requests.length}</div>
            <div class="stat-lbl">Tus solicitudes</div>
          </div>
        </div>
      </div>

      <!-- Top picks -->
      <div class="section-header">
        <h2>Recomendados para ti</h2>
        <a class="link" onclick="UI.nav('discover')">Ver todas ${Icons.chevronRight}</a>
      </div>
      <div class="rooms-grid mb-6">
        ${topPicks.map(r => RoomCard.render(r, { matchScore: RoomCard.computeMatch(r) })).join('')}
      </div>

      <!-- Trust banner -->
      <div class="card card-pad-lg mb-6" style="background:linear-gradient(135deg,var(--c-success-50),var(--c-surface));border-color:transparent;">
        <div class="row gap-6" style="align-items:center;">
          <div class="grow">
            <div class="row gap-2 mb-2">
              <span class="chip chip-success">${Icons.shieldCheck} Confianza garantizada</span>
            </div>
            <h3 style="font-size:var(--fs-xl);margin-bottom:var(--sp-2);">¿Por qué WasiStudent es diferente?</h3>
            <p class="text-2" style="margin-bottom:var(--sp-4);max-width:560px;">No somos otro portal de avisos. Verificamos cada propiedad en 12 puntos, generamos contratos con 5 cláusulas del Código Civil peruano, y calculamos un Trust Score transparente.</p>
            <div class="row gap-4 wrap">
              <div class="row gap-2">
                <div style="width:32px;height:32px;background:var(--c-success);color:white;border-radius:8px;display:flex;align-items:center;justify-content:center;">${Icons.check}</div>
                <div><div class="fw-semibold">Verificación presencial</div><div class="text-3 fs-xs">No solo fotos</div></div>
              </div>
              <div class="row gap-2">
                <div style="width:32px;height:32px;background:var(--c-success);color:white;border-radius:8px;display:flex;align-items:center;justify-content:center;">${Icons.check}</div>
                <div><div class="fw-semibold">Contrato legal estándar</div><div class="text-3 fs-xs">Código Civil peruano</div></div>
              </div>
              <div class="row gap-2">
                <div style="width:32px;height:32px;background:var(--c-success);color:white;border-radius:8px;display:flex;align-items:center;justify-content:center;">${Icons.check}</div>
                <div><div class="fw-semibold">Sin cobros ocultos</div><div class="text-3 fs-xs">Transparencia total</div></div>
              </div>
            </div>
          </div>
          <div style="text-align:center;">
            ${TrustRing.render(94, { size: 120 })}
            <div class="text-2 fs-sm mt-2">Ejemplo: Trust Score alto</div>
          </div>
        </div>
      </div>

      <!-- Near you -->
      <div class="section-header">
        <h2>Cerca de tu universidad</h2>
        <a class="link" onclick="UI.nav('discover')">Ver mapa ${Icons.chevronRight}</a>
      </div>
      <div class="rooms-grid">
        ${nearYou.map(r => RoomCard.render(r, { matchScore: RoomCard.computeMatch(r) })).join('')}
      </div>
    `);
  }

  return { render };
})();

window.HomeScreen = HomeScreen;
