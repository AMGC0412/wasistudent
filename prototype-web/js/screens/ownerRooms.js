/* ============================================================
   WasiStudent — Screen: Owner Rooms (lista + form)
   ============================================================ */

const OwnerRooms = (function() {

  function render() {
    UI.setTitle('Mis habitaciones');
    const rooms = Seed.getRooms().slice(0, 4); // Owner's rooms (mock)

    UI.render(`
      <div class="row between mb-6 wrap gap-3">
        <div>
          <h1 style="font-size:var(--fs-2xl);font-weight:var(--fw-extrabold);margin-bottom:var(--sp-2);">Mis habitaciones</h1>
          <p class="text-2">${rooms.length} habitaciones publicadas · ${rooms.filter(r => r.verified).length} verificadas</p>
        </div>
        <button class="btn btn-primary" onclick="OwnerRooms.showForm()">${Icons.plus} Publicar nueva</button>
      </div>

      <div class="rooms-grid">
        ${rooms.map(r => `
          <div class="room-card">
            <div class="photo">
              <img src="${r.photos[0]}" alt="${r.title}">
              <div class="badges-top">
                ${r.verified ? `<span class="badge" style="background:var(--c-success);color:white;">Verificado</span>` : `<span class="badge" style="background:var(--c-warning);color:white;">En revisión</span>`}
              </div>
              <div class="price-tag">${UI.formatPrice(r.price)} <span class="period">/mes</span></div>
            </div>
            <div class="body">
              <div class="title clamp-2">${r.title}</div>
              <div class="location">${Icons.pin} ${Seed.DISTRICTS.find(d => d.id === r.district)?.name}</div>
              <div class="row gap-2 mt-2 mb-3">
                <span class="chip chip-success">${Icons.eye} ${Math.floor(Math.random() * 200 + 50)} vistas</span>
                <span class="chip chip-info">${Icons.heart} ${Math.floor(Math.random() * 30 + 5)} favoritos</span>
              </div>
              <div class="footer">
                <button class="btn btn-ghost btn-sm" onclick="UI.nav('detail', { roomId: '${r.id}' })">${Icons.eye} Ver</button>
                <button class="btn btn-soft btn-sm" onclick="OwnerRooms.edit('${r.id}')">${Icons.edit} Editar</button>
              </div>
            </div>
          </div>
        `).join('')}
      </div>
    `);
  }

  function showForm(roomId = null) {
    const room = roomId ? Seed.getRoom(roomId) : null;
    UI.modal({
      title: room ? 'Editar habitación' : 'Publicar nueva habitación',
      size: 'lg',
      body: `
        ${Forms.text('room-title', 'Título atractivo', room?.title || '', { label: 'Título', required: true })}
        ${Forms.textarea('room-desc', 'Describe tu habitación...', room?.description || '', { label: 'Descripción', rows: 4 })}

        <div class="row gap-3">
          <div class="grow">
            ${Forms.select('room-district', Seed.DISTRICTS.map(d => ({ value: d.id, label: d.name })), room?.district || 'wanchaq', { label: 'Distrito' })}
          </div>
          <div class="grow">
            ${Forms.text('room-address', 'Dirección completa', room?.address || '', { label: 'Dirección' })}
          </div>
        </div>

        <div class="row gap-3">
          <div class="grow">
            ${Forms.number('room-price', '850', room?.price || '', { label: 'Precio mensual (S/)', min: 100 })}
          </div>
          <div class="grow">
            ${Forms.number('room-deposit', '1700', room?.deposit || '', { label: 'Depósito (S/)' })}
          </div>
          <div class="grow">
            ${Forms.number('room-area', '16', room?.area || '', { label: 'Área (m²)' })}
          </div>
        </div>

        <div class="row gap-3">
          <div class="grow">
            ${Forms.select('room-type', [
              { value: 'single', label: 'Habitación individual' },
              { value: 'family', label: 'Casa de familia' },
              { value: 'apartment', label: 'Departamento' },
              { value: 'residence', label: 'Residencia' },
            ], room?.type || 'single', { label: 'Tipo' })}
          </div>
          <div class="grow">
            ${Forms.select('room-uni', Seed.UNIVERSITIES.map(u => ({ value: u.id, label: u.short })), room?.university || 'UNSAAC', { label: 'Universidad cercana' })}
          </div>
        </div>

        <div class="row gap-3">
          <div class="grow">
            ${Forms.number('room-walk', '12', room?.walkMinutes || '', { label: 'Minutos a pie a la universidad' })}
          </div>
          <div class="grow">
            ${Forms.number('room-floor', '2', room?.floor || '', { label: 'Piso' })}
          </div>
          <div class="grow">
            ${Forms.number('room-minstay', '6', room?.minStay || '', { label: 'Estadía mínima (meses)' })}
          </div>
        </div>

        <div class="field">
          <label>Servicios incluidos</label>
          <div class="row wrap gap-2">
            ${['wifi', 'bathroom', 'kitchen', 'desk', 'closet', 'security', 'gym', 'elevator', 'laundry', 'breakfast'].map(a => {
              const labels = { wifi: 'WiFi', bathroom: 'Baño privado', kitchen: 'Cocina', desk: 'Escritorio', closet: 'Closet', security: 'Seguridad 24h', gym: 'Gym', elevator: 'Ascensor', laundry: 'Lavandería', breakfast: 'Desayuno' };
              const checked = room?.amenities.includes(a);
              return `<label class="check" style="background:var(--c-surface-2);padding:6px 12px;border-radius:var(--r-full);"><input type="checkbox" ${checked ? 'checked' : ''} data-amen="${a}"><span class="box"></span><span class="fs-sm">${labels[a]}</span></label>`;
            }).join('')}
          </div>
        </div>

        <div class="field">
          <label>Fotos</label>
          <div class="card" style="border:2px dashed var(--c-outline);padding:var(--sp-8);text-align:center;cursor:pointer;" onclick="OwnerRooms.uploadPhoto()">
            ${Icons.camera}
            <div class="fw-semibold mt-2">Sube al menos 4 fotos</div>
            <div class="text-3 fs-xs">Arrastra o haz clic para seleccionar</div>
          </div>
        </div>

        <div class="card" style="background:var(--c-success-50);padding:var(--sp-4);border-color:transparent;">
          <div class="row gap-2" style="align-items:flex-start;">
            ${Icons.shieldCheck}
            <div>
              <div class="fw-bold" style="color:var(--c-success-600);">Verificación automática</div>
              <p class="fs-sm text-2 mt-1">Al publicar, nuestro equipo revisará tu propiedad en persona en 12 puntos. Esto aumenta tu Trust Score.</p>
            </div>
          </div>
        </div>
      `,
      footer: `
        <button class="btn btn-ghost" onclick="UI.closeModal()">Cancelar</button>
        <button class="btn btn-primary" onclick="OwnerRooms.save('${roomId || ''}')">${Icons.check} ${room ? 'Guardar cambios' : 'Publicar habitación'}</button>
      `
    });
  }

  function edit(roomId) {
    showForm(roomId);
  }

  function save(roomId) {
    UI.closeModal();
    UI.toast({ title: roomId ? 'Habitación actualizada' : 'Habitación publicada', desc: 'En verificación (24-48h)', type: 'success' });
    setTimeout(() => render(), 800);
  }

  function uploadPhoto() {
    UI.toast({ title: 'Foto subida', type: 'success', duration: 1500 });
  }

  return { render, showForm, edit, save, uploadPhoto };
})();

window.OwnerRooms = OwnerRooms;
