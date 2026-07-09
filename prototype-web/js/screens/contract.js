/* ============================================================
   WasiStudent — Screen: Contract Flow (5 cláusulas + firma)
   ============================================================ */

const ContractScreen = (function() {

  let step = 1; // 1: review, 2: terms, 3: sign, 4: done
  let roomId = null;

  function render(params = {}) {
    UI.setTitle('Contrato legal');
    if (params.roomId) roomId = params.roomId;
    if (!step) step = 1;

    const room = roomId ? Seed.getRoom(roomId) : Seed.getRooms()[0];
    if (!room) {
      UI.render(`<div class="empty-state"><h3>No hay habitación seleccionada</h3></div>`);
      return;
    }

    const user = Auth.current();

    UI.render(`
      <button class="btn btn-ghost mb-4" onclick="UI.nav('detail', { roomId: '${room.id}' })">
        ${Icons.arrowLeft} Volver a la habitación
      </button>

      <div class="row between mb-4 wrap gap-3">
        <div>
          <h1 style="font-size:var(--fs-2xl);font-weight:var(--fw-extrabold);margin-bottom:4px;">Contrato de alquiler</h1>
          <p class="text-2">Basado en el Código Civil peruano · Generado automáticamente</p>
        </div>
        ${stepper()}
      </div>

      <div id="contract-content">
        ${renderStep(room, user)}
      </div>
    `);
  }

  function stepper() {
    return `
      <div class="stepper" style="min-width:340px;">
        <div class="step ${step >= 1 ? 'active' : ''} ${step > 1 ? 'done' : ''}">
          <div class="dot">${step > 1 ? Icons.check : '1'}</div>
          <div class="label">Revisión</div>
        </div>
        <div class="line"></div>
        <div class="step ${step >= 2 ? 'active' : ''} ${step > 2 ? 'done' : ''}">
          <div class="dot">${step > 2 ? Icons.check : '2'}</div>
          <div class="label">Cláusulas</div>
        </div>
        <div class="line"></div>
        <div class="step ${step >= 3 ? 'active' : ''} ${step > 3 ? 'done' : ''}">
          <div class="dot">${step > 3 ? Icons.check : '3'}</div>
          <div class="label">Firma</div>
        </div>
        <div class="line"></div>
        <div class="step ${step >= 4 ? 'active' : ''} ${step > 4 ? 'done' : ''}">
          <div class="dot">${step > 4 ? Icons.check : '4'}</div>
          <div class="label">Listo</div>
        </div>
      </div>
    `;
  }

  function renderStep(room, user) {
    switch (step) {
      case 1: return renderReview(room, user);
      case 2: return renderClauses(room, user);
      case 3: return renderSign(room, user);
      case 4: return renderDone(room, user);
    }
  }

  function renderReview(room, user) {
    return `
      <div class="detail-grid">
        <div class="detail-main">
          <div class="contract-paper">
            <h2>Resumen del contrato</h2>
            <p class="subtitle">Revisa los datos antes de continuar con las cláusulas legales.</p>

            <div class="row gap-4 wrap mb-4">
              <div class="grow">
                <div class="text-2 fs-sm">Inquilino</div>
                <div class="fw-bold">${user.name}</div>
                <div class="text-3 fs-xs">${user.email}</div>
              </div>
              <div class="grow">
                <div class="text-2 fs-sm">Propietario</div>
                <div class="fw-bold">${room.ownerName}</div>
                <div class="text-3 fs-xs">Verificado</div>
              </div>
            </div>

            <div class="divider"></div>

            <div class="row gap-4 wrap">
              <div class="grow">
                <div class="text-2 fs-sm">Inmueble</div>
                <div class="fw-semibold">${room.title}</div>
                <div class="text-3 fs-xs">${room.address}</div>
              </div>
              <div>
                <div class="text-2 fs-sm">Precio mensual</div>
                <div class="fw-bold" style="font-family:var(--font-display);font-size:var(--fs-lg);color:var(--c-primary);">${UI.formatPrice(room.price)}</div>
              </div>
            </div>

            <div class="divider"></div>

            <div class="row gap-4 wrap">
              <div><div class="text-2 fs-sm">Depósito</div><div class="fw-semibold">S/ ${room.deposit}</div></div>
              <div><div class="text-2 fs-sm">Duración mínima</div><div class="fw-semibold">${room.minStay} meses</div></div>
              <div><div class="text-2 fs-sm">Disponible desde</div><div class="fw-semibold">${new Date(room.availableFrom).toLocaleDateString('es-PE')}</div></div>
            </div>

            <div class="card" style="background:var(--c-info-bg);padding:var(--sp-4);margin-top:var(--sp-4);border-color:transparent;">
              <div class="row gap-2" style="align-items:flex-start;">
                ${Icons.info}
                <div>
                  <div class="fw-semibold" style="color:var(--c-info);">¿Sabías que?</div>
                  <p class="text-2 fs-sm mt-1">Este contrato incluye 5 cláusulas basadas en el Código Civil peruano que te protegen contra: aumentos sorpresivos, desalojos intempestivos, retención indebida del depósito, cobros ocultos y falta de preaviso.</p>
                </div>
              </div>
            </div>

            <div class="row gap-3 mt-6">
              <button class="btn btn-primary btn-lg grow" onclick="ContractScreen.next()">
                Revisar cláusulas ${Icons.arrowRight}
              </button>
            </div>
          </div>
        </div>

        <div class="detail-side">
          <div class="card card-pad" style="background:var(--c-success-50);border-color:transparent;">
            <div class="row gap-2 mb-2">
              ${Icons.shieldCheck}
              <div class="fw-bold" style="color:var(--c-success-600);">Contrato inteligente</div>
            </div>
            <p class="fs-sm text-2 mb-4">WasiStudent genera contratos basados en leyes peruanas vigentes. No necesitas abogado.</p>
            <div class="fs-xs text-2" style="line-height:1.6;">
              <div class="fw-semibold text-2" style="margin-bottom:4px;">Referencias legales:</div>
              ${Seed.CONTRACT_CLAUSES.map(c => `<div style="margin-bottom:2px;">${c.legalRef}</div>`).join('')}
            </div>
          </div>
        </div>
      </div>
    `;
  }

  function renderClauses(room, user) {
    return `
      <div class="contract-paper">
        <div class="row between wrap gap-3 mb-4">
          <div class="grow">
            <h2>Cláusulas contractuales</h2>
            <p class="subtitle">5 cláusulas que te protegen. Cada una está basada en una ley específica del Código Civil peruano.</p>
          </div>
          <div class="row gap-2">
            <button class="btn btn-ghost btn-sm" onclick="ContractScreen.glossary()" data-tooltip="Glosario legal">
              ${Icons.bookOpen} Glosario
            </button>
            <button class="btn btn-ghost btn-sm" onclick="ContractScreen.downloadPDF()" data-tooltip="Descargar PDF">
              ${Icons.file} Descargar PDF
            </button>
          </div>
        </div>

        <!-- Banner hipótesis: ANTES vs DESPUÉS -->
        <div class="card card-pad" style="background:linear-gradient(135deg,var(--c-surface-2),var(--c-surface));border:1.5px solid var(--c-outline);margin-bottom:var(--sp-5);">
          <div class="row gap-6 wrap" style="align-items:stretch;">
            <div class="grow" style="border-right:1px dashed var(--c-outline);">
              <div class="row gap-2 mb-2">
                <span class="badge" style="background:var(--c-error);color:white;">ANTES</span>
                <span class="text-2 fs-sm">Sin WasiStudent</span>
              </div>
              <ul class="check-list" style="list-style:none;padding:0;margin:0;font-size:var(--fs-sm);color:var(--c-text-2);line-height:1.8;">
                <li><span class="li-icon" style="color:var(--c-error);">${Icons.x}</span><span>Engaño en fotos y precios</span></li>
                <li><span class="li-icon" style="color:var(--c-error);">${Icons.x}</span><span>Sin contrato legal, solo palabra</span></li>
                <li><span class="li-icon" style="color:var(--c-error);">${Icons.x}</span><span>Depósito retenido injustificadamente</span></li>
                <li><span class="li-icon" style="color:var(--c-error);">${Icons.x}</span><span>Cobros ocultos de servicios</span></li>
                <li><span class="li-icon" style="color:var(--c-error);">${Icons.x}</span><span>Desalojo sin preaviso</span></li>
              </ul>
            </div>
            <div class="grow">
              <div class="row gap-2 mb-2">
                <span class="badge" style="background:var(--c-success);color:white;">DESPUÉS</span>
                <span class="text-2 fs-sm">Con WasiStudent</span>
              </div>
              <ul class="check-list" style="list-style:none;padding:0;margin:0;font-size:var(--fs-sm);color:var(--c-text);line-height:1.8;">
                <li><span class="li-icon" style="color:var(--c-success);">${Icons.check}</span><span>Verificación en 12 puntos (antes)</span></li>
                <li><span class="li-icon" style="color:var(--c-success);">${Icons.check}</span><span>Contrato legal con 5 cláusulas (después)</span></li>
                <li><span class="li-icon" style="color:var(--c-success);">${Icons.check}</span><span>Depósito devuelto en 15 días</span></li>
                <li><span class="li-icon" style="color:var(--c-success);">${Icons.check}</span><span>Transparencia total de servicios</span></li>
                <li><span class="li-icon" style="color:var(--c-success);">${Icons.check}</span><span>Preaviso de 30 días garantizado</span></li>
              </ul>
            </div>
          </div>
        </div>

        <!-- Cláusulas -->
        ${Seed.CONTRACT_CLAUSES.map(c => {
          const critical = c.id === 'c3' || c.id === 'c4'; // Depósito y transparencia son las más críticas
          return `
            <div class="clause ${critical ? 'critical' : ''}" style="${critical ? 'border-left-color:var(--c-warning);background:var(--c-warning-soft);' : ''}">
              <div class="row between wrap">
                <div>
                  <span class="num">${c.num}</span>
                  <span class="title">${c.title}</span>
                  ${critical ? `<span class="chip chip-warning" style="margin-left:8px;">${Icons.shield} Cláusula crítica</span>` : ''}
                </div>
                <button class="btn btn-text btn-sm" onclick="ContractScreen.explainClause('${c.id}')" data-tooltip="¿Qué significa esto?">
                  ${Icons.info} Explicar
                </button>
              </div>
              <div class="body">${highlightKeywords(c.body)}</div>
              <span class="legal-ref">${Icons.bookOpen} ${c.legalRef}</span>
            </div>
          `;
        }).join('')}

        <label class="check" style="margin-top:var(--sp-6);align-items:flex-start;padding:var(--sp-4);background:var(--c-surface-2);border-radius:var(--r-md);">
          <input type="checkbox" id="accept-terms" onchange="ContractScreen.toggleAccept(this)">
          <span class="box" style="margin-top:2px;"></span>
          <span>He leído y acepto las 5 cláusulas del contrato. Entiendo que este documento tiene validez legal según el Código Civil peruano y que las <strong>cláusulas críticas</strong> protegen mi depósito y mi derecho a transparencia.</span>
        </label>

        <div class="row gap-3 mt-6">
          <button class="btn btn-ghost btn-lg" onclick="ContractScreen.prev()">${Icons.arrowLeft} Atrás</button>
          <button class="btn btn-primary btn-lg grow" id="continue-sign-btn" disabled onclick="ContractScreen.goSign()" style="opacity:0.5;">
            Continuar a firma ${Icons.arrowRight}
          </button>
        </div>
      </div>
    `;
  }

  // Resaltar términos legales clave en el texto
  function highlightKeywords(text) {
    const keywords = [
      { word: 'Código Civil', cls: 'kw-legal' },
      { word: 'depósito', cls: 'kw-critical' },
      { word: 'deposito', cls: 'kw-critical' },
      { word: 'garantía', cls: 'kw-critical' },
      { word: 'garantia', cls: 'kw-critical' },
      { word: '15 días', cls: 'kw-critical' },
      { word: '15 (quince) días', cls: 'kw-critical' },
      { word: '6 (seis) meses', cls: 'kw-critical' },
      { word: '30 días', cls: 'kw-critical' },
      { word: '30 (treinta) días', cls: 'kw-critical' },
      { word: 'cobros ocultos', cls: 'kw-warning' },
      { word: 'incrementado', cls: 'kw-warning' },
      { word: 'desocupación', cls: 'kw-critical' },
    ];
    let result = text;
    keywords.forEach(k => {
      const re = new RegExp(k.word.replace(/[.*+?^${}()|[\]\\]/g, '\\$&'), 'gi');
      result = result.replace(re, `<span class="${k.cls}">$&</span>`);
    });
    return result;
  }

  function toggleAccept(checkbox) {
    const btn = document.getElementById('continue-sign-btn');
    if (checkbox.checked) {
      btn.disabled = false;
      btn.style.opacity = '1';
      // Feedback visual del checkbox
      checkbox.parentElement.style.background = 'var(--c-success-50)';
    } else {
      btn.disabled = true;
      btn.style.opacity = '0.5';
      checkbox.parentElement.style.background = 'var(--c-surface-2)';
    }
  }

  function glossary() {
    UI.modal({
      title: 'Glosario legal',
      size: 'lg',
      body: `
        <p class="text-2 mb-4">Términos legales clave que aparecen en tu contrato. Si tienes dudas, consulta con un abogado de confianza.</p>
        <div class="clause" style="border-left-color:var(--c-primary);">
          <div class="title">Depósito de garantía</div>
          <div class="body">Cantidad de dinero (generalmente 1-2 meses de alquiler) que el inquilino entrega al propietario como garantía. <strong>Debe devolverse en 15 días</strong> tras la desocupación, salvo daños comprobables.</div>
        </div>
        <div class="clause" style="border-left-color:var(--c-primary);">
          <div class="title">Preaviso</div>
          <div class="body">Notificación anticipada que una parte debe dar a la otra antes de finalizar el contrato. En WasiStudent: <strong>30 días calendario</strong>.</div>
        </div>
        <div class="clause" style="border-left-color:var(--c-primary);">
          <div class="title">Cobros ocultos</div>
          <div class="body">Cualquier cobro no expresado en el contrato. Están <strong>prohibidos por el Código de Protección y Defensa del Consumidor</strong> (Ley 29571).</div>
        </div>
        <div class="clause" style="border-left-color:var(--c-primary);">
          <div class="title">Vigencia mínima</div>
          <div class="body">Período mínimo durante el cual el contrato no puede ser rescindido unilateralmente. En WasiStudent: <strong>6 meses</strong> según Ley 30201.</div>
        </div>
        <div class="clause" style="border-left-color:var(--c-primary);">
          <div class="title">Precio fijo</div>
          <div class="body">Monto de alquiler que no puede ser incrementado durante la vigencia del contrato. Protege al inquilino de aumentos sorpresivos.</div>
        </div>
      `,
      footer: `<button class="btn btn-primary" onclick="UI.closeModal()">Entendido</button>`
    });
  }

  function explainClause(clauseId) {
    const clause = Seed.CONTRACT_CLAUSES.find(c => c.id === clauseId);
    if (!clause) return;
    const explanations = {
      c1: 'Esta cláusula evita que el propietario te suba el alquiler a mitad del contrato. Sin esto, podrías recibir aumentos mensuales injustificados.',
      c2: 'Garantiza que tendrás estabilidad mínima de 6 meses. Sin esto, el propietario podría desalojarte en cualquier momento.',
      c3: 'Protege tu dinero. Sin esta cláusula, muchos propietarios retienen el depósito injustificadamente. El Código Civil te respalda.',
      c4: 'Evita sorpresas. Sin esto, podrías recibir cobros extra por servicios que no acordaste (agua, luz, internet, mantenimiento).',
      c5: 'Te da tiempo para organizarte. Sin esto, podrías recibir un desalojo de un día para otro sin posibilidad de buscar nueva vivienda.',
    };
    UI.modal({
      title: `Cláusula ${clause.num}: ${clause.title}`,
      size: 'sm',
      body: `
        <div class="card card-pad" style="background:var(--c-primary-50);border-color:transparent;margin-bottom:var(--sp-4);">
          <div class="row gap-2 mb-2">
            ${Icons.info}
            <div class="fw-bold" style="color:var(--c-primary-700);">¿Qué significa para ti?</div>
          </div>
          <p class="text-2 fs-sm">${explanations[clauseId]}</p>
        </div>
        <p class="text-2 fs-sm mb-2"><strong>Texto legal:</strong></p>
        <p class="text-2 fs-sm" style="font-style:italic;">${clause.body}</p>
        <p class="text-3 fs-xs mt-3">${Icons.bookOpen} ${clause.legalRef}</p>
      `,
      footer: `<button class="btn btn-primary" onclick="UI.closeModal()">Cerrar</button>`
    });
  }

  function downloadPDF() {
    UI.toast({
      title: 'Generando PDF del contrato',
      desc: 'Se descargará en unos segundos',
      type: 'info'
    });
    // En una implementación real, aquí se llamaría al backend para generar el PDF
    setTimeout(() => {
      UI.toast({
        title: 'Contrato PDF generado',
        desc: 'Documento listo para descarga',
        type: 'success'
      });
    }, 1500);
  }

  function renderSign(room, user) {
    return `
      <div class="contract-paper">
        <h2>Firma del contrato</h2>
        <p class="subtitle">Tu firma se aplicará digitalmente y tendrá validez legal.</p>

        <div class="row gap-6 mb-6 wrap">
          <div class="grow">
            <div class="text-2 fs-sm mb-1">Firma del inquilino</div>
            <div class="signature-pad" id="signature-pad">
              <div class="text-center">
                ${Icons.edit}
                <p class="text-3 fs-sm mt-2">Firma aquí con el mouse o tu dedo</p>
              </div>
            </div>
          </div>
          <div class="grow">
            <div class="text-2 fs-sm mb-1">Firma del propietario</div>
            <div class="signature-pad" style="background:var(--c-surface-2);cursor:default;">
              <div class="text-center">
                <div class="avatar lg" style="margin:0 auto 8px;">${room.ownerName.charAt(0)}</div>
                <div class="fw-bold">${room.ownerName}</div>
                <p class="text-3 fs-xs mt-1">Firmado digitalmente · ${new Date().toLocaleDateString('es-PE')}</p>
              </div>
            </div>
          </div>
        </div>

        <div class="card" style="background:var(--c-warning-soft);padding:var(--sp-4);border-color:transparent;margin-bottom:var(--sp-4);">
          <div class="row gap-2" style="align-items:flex-start;">
            ${Icons.alert}
            <div>
              <div class="fw-semibold" style="color:var(--c-warning);">Antes de firmar</div>
              <p class="fs-sm text-2 mt-1">Asegúrate de haber visitado la habitación en persona. WasiStudent recomienda no firmar sin visita previa.</p>
            </div>
          </div>
        </div>

        <div class="row gap-3">
          <button class="btn btn-ghost" onclick="ContractScreen.prev()">${Icons.arrowLeft} Atrás</button>
          <button class="btn btn-success btn-lg grow" onclick="ContractScreen.finish()">
            ${Icons.fileCheck} Firmar y finalizar contrato
          </button>
        </div>
      </div>
    `;
  }

  function renderDone(room, user) {
    return `
      <div class="card card-pad-lg text-center" style="max-width:600px;margin:0 auto;">
        <div style="width:96px;height:96px;background:var(--c-success-50);color:var(--c-success);border-radius:50%;display:inline-flex;align-items:center;justify-content:center;margin-bottom:var(--sp-4);">
          <div style="width:48px;height:48px;">${Icons.checkCircle}</div>
        </div>
        <h1 style="font-size:var(--fs-2xl);font-weight:var(--fw-extrabold);margin-bottom:var(--sp-2);">¡Contrato firmado!</h1>
        <p class="text-2 mb-6">Tu contrato está listo. Se ha enviado una copia a tu correo. Ahora puedes coordinar la mudanza.</p>

        <div class="card card-pad" style="background:var(--c-surface-2);text-align:left;margin-bottom:var(--sp-6);">
          <div class="row between mb-2"><span class="text-2 fs-sm">Contrato N°</span><span class="fw-semibold">WS-2026-${Math.floor(Math.random() * 9000 + 1000)}</span></div>
          <div class="row between mb-2"><span class="text-2 fs-sm">Fecha</span><span class="fw-semibold">${new Date().toLocaleDateString('es-PE')}</span></div>
          <div class="row between mb-2"><span class="text-2 fs-sm">Inmueble</span><span class="fw-semibold">${room.title}</span></div>
          <div class="row between mb-2"><span class="text-2 fs-sm">Monto mensual</span><span class="fw-semibold">${UI.formatPrice(room.price)}</span></div>
          <div class="row between"><span class="text-2 fs-sm">Vigencia mínima</span><span class="fw-semibold">${room.minStay} meses</span></div>
        </div>

        <div class="row gap-3">
          <button class="btn btn-ghost grow" onclick="UI.nav('home')">${Icons.home} Volver al inicio</button>
          <button class="btn btn-primary grow" onclick="UI.nav('payments')">${Icons.dollar} Ver pagos</button>
        </div>
      </div>
    `;
  }

  function next() { step++; rerender(); }
  function prev() { step--; rerender(); }
  function goSign() {
    if (!document.getElementById('accept-terms').checked) {
      UI.toast({ title: 'Debes aceptar las cláusulas', type: 'warning' });
      return;
    }
    step = 3;
    rerender();
  }
  function finish() {
    step = 4;
    rerender();
    UI.toast({ title: '¡Contrato firmado!', desc: 'Copia enviada a tu correo', type: 'success' });
    // Aumentar trust score
    const user = Auth.current();
    Auth.updateProfile({ trustScore: (user.trustScore || 60) + 15 });
  }

  function rerender() {
    render({ roomId });
  }

  return { render, next, prev, goSign, finish, glossary, explainClause, downloadPDF, toggleAccept };
})();

window.ContractScreen = ContractScreen;
