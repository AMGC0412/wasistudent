/* ============================================================
   WasiStudent — Componente: Filters
   ============================================================ */

const Filters = (function() {

  const DEFAULTS = {
    priceMin: 0,
    priceMax: 2500,
    roomTypes: [],
    districts: [],
    amenities: [],
    verifiedOnly: false,
    sort: 'relevance',
  };

  let state = { ...DEFAULTS };

  function render() {
    const types = [
      { id: 'single', name: 'Individual' },
      { id: 'family', name: 'Casa familia' },
      { id: 'apartment', name: 'Departamento' },
      { id: 'residence', name: 'Residencia' },
    ];

    return `
      <div class="filters-bar">
        <div class="row gap-2">
          <span style="color:var(--c-text-3);">${Icons.filter}</span>
          <span class="fw-semibold fs-sm">Filtros:</span>
        </div>

        ${types.map(t => `
          <div class="filter-chip ${state.roomTypes.includes(t.id) ? 'active' : ''}" onclick="Filters.toggle('roomTypes', '${t.id}')">${t.name}</div>
        `).join('')}

        <div class="filter-chip ${state.verifiedOnly ? 'active' : ''}" onclick="Filters.toggleVerified()">
          ${Icons.shieldCheck} Solo verificados
        </div>

        <button class="btn btn-text btn-sm" onclick="Filters.openAdvanced()">
          ${Icons.settings} Más filtros
        </button>

        ${(state.roomTypes.length > 0 || state.verifiedOnly) ? `<button class="btn btn-text btn-sm" onclick="Filters.clear()" style="color:var(--c-error);">Limpiar</button>` : ''}
      </div>
    `;
  }

  function toggle(arr, val) {
    const list = state[arr];
    const idx = list.indexOf(val);
    if (idx >= 0) list.splice(idx, 1);
    else list.push(val);
    Discover.refresh();
  }

  function toggleVerified() {
    state.verifiedOnly = !state.verifiedOnly;
    Discover.refresh();
  }

  function clear() {
    state = { ...DEFAULTS };
    Discover.refresh();
  }

  function apply(room) {
    if (state.roomTypes.length > 0 && !state.roomTypes.includes(room.type)) return false;
    if (state.verifiedOnly && !room.verified) return false;
    if (room.price < state.priceMin || room.price > state.priceMax) return false;
    if (state.amenities.length > 0 && !state.amenities.some(a => room.amenities.includes(a))) return false;
    return true;
  }

  function openAdvanced() {
    UI.modal({
      title: 'Filtros avanzados',
      body: `
        <div class="field">
          <label>Rango de precio (S/)</label>
          <div class="row gap-3">
            <input type="number" class="input" id="f-priceMin" value="${state.priceMin}" placeholder="Mín">
            <input type="number" class="input" id="f-priceMax" value="${state.priceMax}" placeholder="Máx">
          </div>
        </div>
        <div class="field">
          <label>Distritos</label>
          <div class="row wrap gap-2">
            ${Seed.DISTRICTS.map(d => `
              <div class="chip ${state.districts.includes(d.id) ? 'chip-primary' : ''}" style="cursor:pointer;padding:8px 14px;" onclick="this.classList.toggle('chip-primary')">${d.name}</div>
            `).join('')}
          </div>
        </div>
      `,
      footer: `
        <button class="btn btn-ghost" onclick="UI.closeModal()">Cancelar</button>
        <button class="btn btn-primary" onclick="Filters.applyAdvanced()">Aplicar</button>
      `
    });
  }

  function applyAdvanced() {
    state.priceMin = parseInt(document.getElementById('f-priceMin').value) || 0;
    state.priceMax = parseInt(document.getElementById('f-priceMax').value) || 2500;
    UI.closeModal();
    Discover.refresh();
  }

  return { render, toggle, toggleVerified, clear, apply, openAdvanced, applyAdvanced, state: () => state };
})();

window.Filters = Filters;
