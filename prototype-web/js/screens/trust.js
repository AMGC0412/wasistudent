/* ============================================================
   WasiStudent — Screen: Trust Score
   ============================================================ */

const TrustScreen = (function() {

  function render() {
    UI.setTitle('Trust Score');
    const user = Auth.current();
    // Calcular trust score del usuario (en base a actividad)
    const score = user.trustScore || 65;
    const factors = Seed.TRUST_FACTORS;

    UI.render(`
      <div class="mb-6">
        <h1 style="font-size:var(--fs-2xl);font-weight:var(--fw-extrabold);margin-bottom:var(--sp-2);">Tu Trust Score</h1>
        <p class="text-2">Medimos tu confianza en la plataforma. A mayor score, más oportunidades y mejor reputación.</p>
      </div>

      <div class="trust-overview mb-6">
        ${TrustRing.render(score, { size: 140, stroke: 12 })}
        <div>
          <h2 style="font-size:var(--fs-xl);margin-bottom:var(--sp-2);">${score >= 75 ? '¡Excelente confianza!' : score >= 50 ? 'Vas por buen camino' : 'Aumenta tu confianza'}</h2>
          <p class="text-2 mb-4" style="max-width:480px;">Tu Trust Score se calcula con 4 factores: verificación, contratos, reseñas y antigüedad. Cada acción que completas suma puntos.</p>
          <div class="row gap-3 wrap">
            ${score < 75 ? `<button class="btn btn-primary" onclick="UI.nav('contract')">${Icons.fileCheck} Aumentar score</button>` : ''}
            <button class="btn btn-ghost" onclick="UI.toast({ title: 'Detalles del cálculo', desc: 'Cada factor tiene un peso específico' })">${Icons.info} ¿Cómo se calcula?</button>
          </div>
        </div>
      </div>

      <h2 style="margin-bottom:var(--sp-4);">Factores que componen tu score</h2>
      <div class="trust-factors mb-6">
        ${factors.map(f => {
          const value = f.id === 'f1' ? 8 : f.id === 'f2' ? 3 : f.id === 'f3' ? 60 : 40;
          const pct = f.id === 'f1' || f.id === 'f2' ? Math.round((value / f.max) * 100) : value;
          return `
            <div class="trust-factor">
              <div class="head">
                <div class="icon-circle">${f.id === 'f1' ? Icons.shieldCheck : f.id === 'f2' ? Icons.fileCheck : f.id === 'f3' ? Icons.star : Icons.clock}</div>
                <div class="pct">${pct}%</div>
              </div>
              <div class="name">${f.name}</div>
              <div class="desc">${f.desc}</div>
              <div class="progress"><div class="bar" style="width:${pct}%"></div></div>
              <div class="text-3 fs-xs mt-2">Peso: ${f.weight}% del score total</div>
            </div>
          `;
        }).join('')}
      </div>

      <div class="card card-pad-lg mb-6" style="background:linear-gradient(135deg,var(--c-primary-50),var(--c-surface));border-color:transparent;">
        <div class="row gap-6" style="align-items:center;">
          <div class="grow">
            <h3 style="margin-bottom:var(--sp-2);">¿Cómo funciona el Trust Score?</h3>
            <p class="text-2 mb-4">Es el sistema que hace WasiStudent diferente. No es solo una calificación: es una garantía de confianza mutua entre estudiantes y propietarios.</p>
            <div class="row gap-3 mb-3">
              <div style="width:28px;height:28px;background:var(--c-primary);color:white;border-radius:50%;display:inline-flex;align-items:center;justify-content:center;font-weight:var(--fw-bold);font-size:14px;flex-shrink:0;">1</div>
              <div class="text-2 fs-sm">Verificamos identidad del propietario y del inmueble en persona</div>
            </div>
            <div class="row gap-3 mb-3">
              <div style="width:28px;height:28px;background:var(--c-primary);color:white;border-radius:50%;display:inline-flex;align-items:center;justify-content:center;font-weight:var(--fw-bold);font-size:14px;flex-shrink:0;">2</div>
              <div class="text-2 fs-sm">Cada alquiler genera un contrato con 5 cláusulas del Código Civil</div>
            </div>
            <div class="row gap-3 mb-3">
              <div style="width:28px;height:28px;background:var(--c-primary);color:white;border-radius:50%;display:inline-flex;align-items:center;justify-content:center;font-weight:var(--fw-bold);font-size:14px;flex-shrink:0;">3</div>
              <div class="text-2 fs-sm">Las reseñas solo las escriben inquilinos verificados</div>
            </div>
            <div class="row gap-3">
              <div style="width:28px;height:28px;background:var(--c-primary);color:white;border-radius:50%;display:inline-flex;align-items:center;justify-content:center;font-weight:var(--fw-bold);font-size:14px;flex-shrink:0;">4</div>
              <div class="text-2 fs-sm">El algoritmo pondera los 4 factores y se actualiza en tiempo real</div>
            </div>
          </div>
        </div>
      </div>

      <h2 style="margin-bottom:var(--sp-4);">Beneficios de tener alto Trust Score</h2>
      <div class="stats-grid">
        <div class="card card-pad">
          <div style="width:40px;height:40px;background:var(--c-success-50);color:var(--c-success);border-radius:10px;display:inline-flex;align-items:center;justify-content:center;margin-bottom:var(--sp-3);">${Icons.zap}</div>
          <h3 style="font-size:var(--fs-md);margin-bottom:var(--sp-1);">Prioridad en búsquedas</h3>
          <p class="text-2 fs-sm">Apareces primero en los resultados para estudiantes</p>
        </div>
        <div class="card card-pad">
          <div style="width:40px;height:40px;background:var(--c-success-50);color:var(--c-success);border-radius:10px;display:inline-flex;align-items:center;justify-content:center;margin-bottom:var(--sp-3);">${Icons.dollar}</div>
          <h3 style="font-size:var(--fs-md);margin-bottom:var(--sp-1);">Mejores precios</h3>
          <p class="text-2 fs-sm">Los propietarios confían en ti y aceptan mejores ofertas</p>
        </div>
        <div class="card card-pad">
          <div style="width:40px;height:40px;background:var(--c-success-50);color:var(--c-success);border-radius:10px;display:inline-flex;align-items:center;justify-content:center;margin-bottom:var(--sp-3);">${Icons.shieldCheck}</div>
          <h3 style="font-size:var(--fs-md);margin-bottom:var(--sp-1);">Sello verificado</h3>
          <p class="text-2 fs-sm">Tu perfil muestra el badge de confianza WasiStudent</p>
        </div>
      </div>
    `);
  }

  return { render };
})();

window.TrustScreen = TrustScreen;
