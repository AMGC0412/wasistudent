/* ============================================================
   WasiStudent — Screen: Discover (lista + filtros + mapa)
   ============================================================ */

const Discover = (function() {

  let view = 'grid'; // grid | map

  function render() {
    UI.setTitle('Descubrir');
    const rooms = Seed.getRooms().filter(Filters.apply);

    UI.render(`
      <div class="row between mb-4 wrap gap-3">
        <div>
          <h1 style="font-size:var(--fs-2xl);font-weight:var(--fw-extrabold);">Descubre tu wasi</h1>
          <p class="text-2">${rooms.length} habitaciones verificadas en Cusco</p>
        </div>
        <div class="row gap-2">
          <div class="tabs" style="border:1px solid var(--c-outline-soft);border-radius:var(--r-sm);padding:4px;">
            <button class="tab ${view === 'grid' ? 'active' : ''}" style="border:none;padding:8px 14px;margin:0;" onclick="Discover.setView('grid')">${Icons.search} Lista</button>
            <button class="tab ${view === 'map' ? 'active' : ''}" style="border:none;padding:8px 14px;margin:0;" onclick="Discover.setView('map')">${Icons.map} Mapa</button>
          </div>
        </div>
      </div>

      <div id="filters-container">${Filters.render()}</div>

      <div id="rooms-container">
        ${view === 'grid' ? renderGrid(rooms) : renderMap(rooms)}
      </div>
    `);
  }

  function renderGrid(rooms) {
    if (rooms.length === 0) {
      return `
        <div class="empty-state">
          <div class="icon-circle">${Icons.search}</div>
          <h3>No encontramos habitaciones</h3>
          <p>Prueba ajustando los filtros. También puedes explorar sin filtros para ver todas las opciones.</p>
          <button class="btn btn-primary mt-4" onclick="Filters.clear()">Limpiar filtros</button>
        </div>
      `;
    }

    return `
      <div class="rooms-grid">
        ${rooms.map(r => RoomCard.render(r, { matchScore: RoomCard.computeMatch(r) })).join('')}
      </div>
    `;
  }

  function renderMap(rooms) {
    // Mapa simple: SVG estilizado de Cusco + markers
    return `
      <div class="card" style="overflow:hidden;">
        <div style="position:relative;height:560px;background:linear-gradient(135deg,#E8F0E8,#F5EDE0);">
          <!-- Mapa decorativo SVG -->
          <svg width="100%" height="100%" viewBox="0 0 800 560" style="position:absolute;inset:0;">
            <!-- Ríos -->
            <path d="M 0 380 Q 200 360 400 400 T 800 380" stroke="#A8C5D8" stroke-width="20" fill="none" opacity="0.4"/>
            <!-- Calles principales -->
            <line x1="0" y1="200" x2="800" y2="220" stroke="#D5C8B5" stroke-width="3" opacity="0.6"/>
            <line x1="0" y1="320" x2="800" y2="340" stroke="#D5C8B5" stroke-width="3" opacity="0.6"/>
            <line x1="200" y1="0" x2="220" y2="560" stroke="#D5C8B5" stroke-width="3" opacity="0.6"/>
            <line x1="500" y1="0" x2="520" y2="560" stroke="#D5C8B5" stroke-width="3" opacity="0.6"/>
            <!-- Zonas verdes -->
            <ellipse cx="120" cy="120" rx="60" ry="40" fill="#C9E5D6" opacity="0.6"/>
            <ellipse cx="680" cy="450" rx="80" ry="50" fill="#C9E5D6" opacity="0.6"/>
          </svg>

          <!-- Markers -->
          ${rooms.map((r, i) => {
            const x = 100 + (i * 130) + (i % 2 === 0 ? 20 : 0);
            const y = 120 + (i % 3) * 120;
            return `
              <div onclick="UI.nav('detail', { roomId: '${r.id}' })"
                style="position:absolute;left:${x}px;top:${y}px;transform:translate(-50%,-100%);cursor:pointer;z-index:2;animation:fade-up 0.4s ${i * 60}ms both;">
                <div style="background:var(--c-primary);color:white;padding:6px 12px;border-radius:var(--r-full);font-weight:var(--fw-bold);font-size:var(--fs-sm);box-shadow:var(--sh-md);display:inline-flex;align-items:center;gap:4px;transition:transform 0.2s;">
                  ${UI.formatPrice(r.price)}
                </div>
                <div style="width:14px;height:14px;background:var(--c-primary);margin:0 auto;border-radius:50% 50% 50% 0;transform:rotate(-45deg);margin-top:-4px;border:2px solid white;"></div>
              </div>
            `;
          }).join('')}

          <!-- Tooltip info -->
          <div style="position:absolute;bottom:20px;left:20px;background:white;padding:var(--sp-4);border-radius:var(--r-md);box-shadow:var(--sh-md);max-width:280px;">
            <div class="fw-bold mb-1">${rooms.length} habitaciones en el mapa</div>
            <p class="text-2 fs-xs">Haz clic en un marcador para ver detalles. Los marcadores rojos están verificados.</p>
          </div>
        </div>
      </div>
    `;
  }

  function setView(v) {
    view = v;
    render();
  }

  function refresh() {
    const container = document.getElementById('filters-container');
    if (container) container.innerHTML = Filters.render();
    const roomsContainer = document.getElementById('rooms-container');
    if (roomsContainer) {
      const rooms = Seed.getRooms().filter(Filters.apply);
      roomsContainer.innerHTML = view === 'grid' ? renderGrid(rooms) : renderMap(rooms);
    }
  }

  return { render, setView, refresh };
})();

window.Discover = Discover;
