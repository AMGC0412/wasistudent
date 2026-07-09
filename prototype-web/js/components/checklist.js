/* ============================================================
   WasiStudent — Componente: Verification Checklist
   ============================================================ */

const Checklist = (function() {

  function render(room) {
    const items = Seed.VERIFICATION_ITEMS;
    // Simular que esta habitación tiene todos los items verificados
    const verifiedCount = room.verificationItems || items.length;
    const pct = Math.round((verifiedCount / items.length) * 100);

    return `
      <div class="card card-pad-lg">
        <div class="row between mb-4">
          <div>
            <h3 style="margin-bottom:4px;">Verificación del inmueble</h3>
            <p class="text-2 fs-sm">${verifiedCount} de ${items.length} puntos verificados</p>
          </div>
          <div class="text-center">
            <div style="font-family:var(--font-display);font-size:var(--fs-2xl);font-weight:var(--fw-extrabold);color:var(--c-success);">${pct}%</div>
            <div class="text-3 fs-xs">Completado</div>
          </div>
        </div>

        <div class="progress success" style="margin-bottom:var(--sp-5);">
          <div class="bar" style="width:${pct}%"></div>
        </div>

        <div>
          ${items.map((item, i) => {
            const checked = i < verifiedCount;
            return `
              <div class="checklist-item">
                <div class="check-icon ${checked ? '' : 'unchecked'}">
                  ${checked ? Icons.check : Icons.x}
                </div>
                <div class="grow">
                  <div class="ci-title">${item.name} ${item.required ? '<span class="chip chip-primary" style="margin-left:4px;padding:1px 6px;font-size:9px;">Obligatorio</span>' : ''}</div>
                  <div class="ci-desc">${item.desc}</div>
                </div>
              </div>
            `;
          }).join('')}
        </div>

        <div class="card" style="background:var(--c-success-50);padding:var(--sp-4);margin-top:var(--sp-4);border-color:transparent;">
          <div class="row gap-3" style="align-items:flex-start;">
            <div style="color:var(--c-success);">${Icons.shieldCheck}</div>
            <div>
              <div class="fw-bold" style="color:var(--c-success-600);">Verificado por WasiStudent</div>
              <p class="fs-sm text-2 mt-1">Nuestro equipo visitó este inmueble y validó estos puntos en persona. No son solo fotos.</p>
            </div>
          </div>
        </div>
      </div>
    `;
  }

  function renderOwnerForm() {
    return `
      <div class="card card-pad-lg">
        <h3 style="margin-bottom:var(--sp-2);">Checklist de verificación</h3>
        <p class="text-2 fs-sm" style="margin-bottom:var(--sp-5);">Sube los documentos para cada punto. Mientras más verifiques, mayor tu Trust Score.</p>

        ${Seed.VERIFICATION_ITEMS.map((item, i) => `
          <div class="checklist-item" style="border-bottom:1px solid var(--c-outline-soft);padding:var(--sp-4) 0;">
            <div class="check-icon unchecked">
              ${Icons.clock}
            </div>
            <div class="grow">
              <div class="ci-title">${item.name} ${item.required ? '<span class="chip chip-primary" style="padding:1px 6px;font-size:9px;">Obligatorio</span>' : ''}</div>
              <div class="ci-desc">${item.desc}</div>
              <button class="btn btn-soft btn-sm mt-2" onclick="Checklist.upload('${item.id}')">
                ${Icons.camera} Subir documento
              </button>
            </div>
          </div>
        `).join('')}
      </div>
    `;
  }

  function upload(itemId) {
    UI.toast({ title: 'Documento subido', desc: 'En revisión (24-48h)', type: 'success' });
  }

  return { render, renderOwnerForm, upload };
})();

window.Checklist = Checklist;
