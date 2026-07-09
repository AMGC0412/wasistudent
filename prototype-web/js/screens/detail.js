/* ============================================================
   WasiStudent — Screen: Detail (detalle de habitación)
   ============================================================ */

const DetailScreen = (function() {

  let activePhoto = 0;
  let currentRoomId = null;

  function render(params) {
    UI.setTitle('Detalle');
    const room = Seed.getRoom(params.roomId);
    if (!room) {
      UI.render(`<div class="empty-state"><h3>Habitación no encontrada</h3></div>`);
      return;
    }

    currentRoomId = params.roomId;
    activePhoto = 0;
    const district = Seed.DISTRICTS.find(d => d.id === room.district);
    const match = RoomCard.computeMatch(room);
    const favorites = Store.get(Store.KEYS.FAVORITES, []);
    const isFav = favorites.includes(room.id);

    UI.render(`
      <button class="btn btn-ghost mb-4" onclick="history.back(); UI.nav('discover')">
        ${Icons.arrowLeft} Volver
      </button>

      <div class="detail-grid">
        <!-- Main column -->
        <div class="detail-main">
          <!-- Gallery -->
          <div class="gallery-main" id="gallery-main">
            <img src="${room.photos[activePhoto]}" alt="${room.title}" id="main-photo">
            <div style="position:absolute;top:var(--sp-3);left:var(--sp-3);display:flex;gap:var(--sp-2);">
              ${room.verified ? `<span class="badge" style="background:var(--c-success);color:white;">${Icons.shieldCheck} Verificado</span>` : ''}
              ${room.contractActive ? `<span class="badge" style="background:var(--c-info);color:white;">Contrato legal</span>` : ''}
            </div>
          </div>

          <div class="gallery-thumbs">
            ${room.photos.map((p, i) => `
              <div class="gallery-thumb ${i === activePhoto ? 'active' : ''}" onclick="DetailScreen.setPhoto(${i})">
                <img src="${p}" alt="Foto ${i+1}">
              </div>
            `).join('')}
          </div>

          <!-- Info card -->
          <div class="detail-card">
            <div class="row between wrap gap-3 mb-4">
              <div class="grow">
                <h1 style="font-size:var(--fs-2xl);font-weight:var(--fw-extrabold);line-height:1.2;margin-bottom:var(--sp-2);">${room.title}</h1>
                <div class="row gap-3 wrap text-2 fs-sm">
                  <span class="row gap-1"><span class="inline-icon">${Icons.pin}</span>${district?.name}, ${room.address}</span>
                  <span class="row gap-1"><span class="inline-icon">${Icons.clock}</span>${room.walkMinutes} min a pie · ${room.busMinutes} min bus</span>
                </div>
              </div>
              <button class="btn ${isFav ? 'btn-soft' : 'btn-ghost'}" onclick="DetailScreen.toggleFav('${room.id}', this)">
                ${isFav ? Icons.heartFill : Icons.heart} ${isFav ? 'En favoritos' : 'Favorito'}
              </button>
            </div>

            <div class="row gap-4 wrap mb-4">
              <div class="row gap-2"><span class="stat-mini-icon" style="color:var(--c-primary);">${Icons.bed}</span><div><div class="fw-semibold">${room.area} m²</div><div class="text-3 fs-xs">Área</div></div></div>
              <div class="row gap-2"><span class="stat-mini-icon" style="color:var(--c-primary);">${Icons.building}</span><div><div class="fw-semibold">Piso ${room.floor}</div><div class="text-3 fs-xs">Nivel</div></div></div>
              <div class="row gap-2"><span class="stat-mini-icon" style="color:var(--c-primary);">${Icons.users}</span><div><div class="fw-semibold">${room.maxOccupancy} persona(s)</div><div class="text-3 fs-xs">Capacidad</div></div></div>
              <div class="row gap-2"><span class="stat-mini-icon" style="color:var(--c-primary);">${Icons.calendar}</span><div><div class="fw-semibold">${new Date(room.availableFrom).toLocaleDateString('es-PE', { day: 'numeric', month: 'short' })}</div><div class="text-3 fs-xs">Disponible</div></div></div>
            </div>

            <div class="divider"></div>

            <h3 style="margin-bottom:var(--sp-3);">Descripción</h3>
            <p class="text-2" style="line-height:1.6;">${room.description}</p>

            <div class="divider"></div>

            <h3 style="margin-bottom:var(--sp-3);">Servicios</h3>
            <div class="row wrap gap-2">
              ${room.amenities.map(a => {
                const labels = { wifi: 'WiFi', bathroom: 'Baño privado', kitchen: 'Cocina', desk: 'Escritorio', closet: 'Closet', security: 'Seguridad 24h', gym: 'Gym', elevator: 'Ascensor', laundry: 'Lavandería', balcony: 'Balcón', garden: 'Jardín', breakfast: 'Desayuno', study: 'Sala de estudio' };
                return `<span class="chip chip-primary" style="padding:6px 12px;font-size:13px;"><span style="display:inline-flex;width:14px;height:14px;align-items:center;justify-content:center;flex-shrink:0;">${Icons[a] || Icons.check}</span>${labels[a] || a}</span>`;
              }).join('')}
            </div>

            <div class="row gap-4 mt-4">
              <div class="grow">
                <div class="fw-semibold fs-sm mb-2">Servicios incluidos</div>
                <div class="text-2 fs-sm">${room.includedServices.join(', ')}</div>
              </div>
              ${room.extraServices.length > 0 ? `
                <div class="grow">
                  <div class="fw-semibold fs-sm mb-2">Servicios extra</div>
                  <div class="text-2 fs-sm">${room.extraServices.map(s => `${s.name} (+S/ ${s.price})`).join(', ')}</div>
                </div>
              ` : ''}
            </div>
          </div>

          <!-- Verification checklist -->
          ${Checklist.render(room)}

          <!-- Reviews -->
          <div class="card card-pad-lg">
            <div class="row between mb-4">
              <h3 style="margin:0;">Reseñas verificadas</h3>
              <div class="row gap-2">
                ${UI.stars(room.rating, 20)}
                <span class="fw-bold">${room.rating}</span>
                <span class="text-2 fs-sm">(${room.reviewCount} reseñas)</span>
              </div>
            </div>
            ${room.reviews.map(r => `
              <div class="review-card" style="box-shadow:none;border:1px solid var(--c-outline-soft);">
                <div class="head">
                  <div class="avatar sm">${r.user.charAt(0)}</div>
                  <div class="grow">
                    <div class="row gap-2 between">
                      <div>
                        <div class="fw-semibold">${r.user} ${r.verified ? '<span class="verified" style="margin-left:4px;">Verificado</span>' : ''}</div>
                        <div class="text-3 fs-xs">${r.date}</div>
                      </div>
                      ${UI.stars(r.rating, 14)}
                    </div>
                  </div>
                </div>
                <div class="body">${r.text}</div>
              </div>
            `).join('')}
          </div>
        </div>

        <!-- Sidebar -->
        <div class="detail-side">
          <!-- Price card -->
          <div class="price-card">
            <div class="price">
              <span class="cur">S/</span>${room.price}
              <span class="period">/${room.period}</span>
            </div>
            <div class="text-2 fs-sm mt-1">${room.roomType} · ${room.area} m²</div>

            <div class="extras">
              <div class="row"><span>Depósito</span><span class="fw-semibold">S/ ${room.deposit}</span></div>
              <div class="row"><span>Mínimo estadía</span><span class="fw-semibold">${room.minStay} meses</span></div>
              <div class="row"><span>Servicios incluidos</span><span class="fw-semibold">${room.includedServices.length} items</span></div>
              <div class="row"><span>Trust Score</span><span class="fw-semibold" style="color:var(--c-success);">${room.trustScore}%</span></div>
            </div>

            <button class="btn btn-primary btn-lg btn-block" style="margin-bottom:10px;" onclick="DetailScreen.requestVisit('${room.id}')">
              ${Icons.calendar} Solicitar visita
            </button>
            <button class="btn btn-success btn-lg btn-block" style="margin-bottom:10px;" onclick="DetailScreen.startContract('${room.id}')">
              ${Icons.fileCheck} Iniciar contrato legal
            </button>
            <button class="btn btn-ghost btn-block" onclick="DetailScreen.contact('${room.id}')">
              ${Icons.chat} Mensajear propietario
            </button>

            <div class="divider"></div>

            <div class="row gap-3">
              <div class="avatar">${room.ownerName.charAt(0)}</div>
              <div class="grow">
                <div class="fw-semibold">${room.ownerName}</div>
                <div class="row gap-1 text-2 fs-xs">
                  ${Icons.star} ${room.ownerRating} · ${room.ownerReviews} reseñas
                </div>
              </div>
              <span class="verified">Verificado</span>
            </div>
          </div>

          <!-- Match card -->
          <div class="card card-pad">
            <div class="row between mb-3">
              <h3 style="margin:0;font-size:var(--fs-md);">Tu compatibilidad</h3>
              <span class="chip ${match >= 75 ? 'chip-success' : match >= 50 ? 'chip-accent' : ''}">${match}%</span>
            </div>
            <div class="progress ${match >= 75 ? 'success' : ''} mb-3">
              <div class="bar" style="width:${match}%"></div>
            </div>
            <p class="text-2 fs-sm">Basado en tu presupuesto, preferencias de habitación y servicios. A mayor compatibilidad, mejor experiencia.</p>
          </div>

          <!-- Trust card -->
          <div class="card card-pad" style="background:var(--c-success-50);border-color:transparent;">
            <div class="row gap-2 mb-2">
              ${Icons.shieldCheck}
              <div class="fw-bold" style="color:var(--c-success-600);">Esta habitación está protegida</div>
            </div>
            <p class="fs-sm text-2">Verificada en 12 puntos. Contrato con 5 cláusulas del Código Civil. Sin engaños posibles.</p>
          </div>
        </div>
      </div>
    `);
  }

  function setPhoto(idx) {
    activePhoto = idx;
    const room = Seed.getRoom(currentRoomId);
    if (!room) return;
    const main = document.getElementById('main-photo');
    if (main) main.src = room.photos[idx];
    document.querySelectorAll('.gallery-thumb').forEach((t, i) => t.classList.toggle('active', i === idx));
  }

  function toggleFav(roomId, btn) {
    RoomCard.toggleFav(roomId, btn);
    // Re-render the button label
    const isFav = Store.get(Store.KEYS.FAVORITES, []).includes(roomId);
    btn.className = `btn ${isFav ? 'btn-soft' : 'btn-ghost'}`;
    btn.innerHTML = `${isFav ? Icons.heartFill : Icons.heart} ${isFav ? 'En favoritos' : 'Favorito'}`;
  }

  function requestVisit(roomId) {
    UI.modal({
      title: 'Solicitar visita',
      body: `
        <p class="text-2 mb-4">Coordina con el propietario una visita presencial. WasiStudent recomienda siempre visitar antes de firmar.</p>
        ${Forms.select('visit-date', [
          { value: 'today', label: 'Hoy' },
          { value: 'tomorrow', label: 'Mañana' },
          { value: 'week', label: 'Esta semana' },
        ], 'tomorrow', { label: '¿Cuándo prefieres?' })}
        ${Forms.select('visit-time', [
          { value: 'morning', label: 'Mañana (9am-12pm)' },
          { value: 'afternoon', label: 'Tarde (12pm-5pm)' },
          { value: 'evening', label: 'Noche (5pm-7pm)' },
        ], 'afternoon', { label: 'Horario' })}
        ${Forms.textarea('visit-msg', 'Hola, me gustaría visitar la habitación...', '', { label: 'Mensaje (opcional)', rows: 3 })}
      `,
      footer: `
        <button class="btn btn-ghost" onclick="UI.closeModal()">Cancelar</button>
        <button class="btn btn-primary" onclick="DetailScreen.sendVisitRequest('${roomId}')">Enviar solicitud</button>
      `
    });
  }

  function sendVisitRequest(roomId) {
    const room = Seed.getRoom(roomId);
    UI.closeModal();
    UI.toast({ title: 'Solicitud enviada', desc: `${room.ownerName} te responderá pronto`, type: 'success' });
    setTimeout(() => UI.nav('messages'), 1500);
  }

  function startContract(roomId) {
    UI.nav('contract', { roomId });
  }

  function contact(roomId) {
    UI.nav('messages', { roomId });
  }

  return { render, setPhoto, toggleFav, requestVisit, sendVisitRequest, startContract, contact };
})();

window.DetailScreen = DetailScreen;
