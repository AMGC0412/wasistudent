/* ============================================================
   WasiStudent — Screen: Favorites
   ============================================================ */

const FavoritesScreen = (function() {

  function render() {
    UI.setTitle('Favoritos');
    const favIds = Store.get(Store.KEYS.FAVORITES, []);
    const allRooms = Seed.getRooms();
    const favRooms = allRooms.filter(r => favIds.includes(r.id));

    if (favRooms.length === 0) {
      UI.render(`
        <div class="empty-state">
          <div class="icon-circle">${Icons.heart}</div>
          <h3>Aún no tienes favoritos</h3>
          <p>Marca habitaciones con el corazón para guardarlas aquí. Así podrás compararlas fácilmente.</p>
          <button class="btn btn-primary mt-4" onclick="UI.nav('discover')">${Icons.search} Explorar habitaciones</button>
        </div>
      `);
      return;
    }

    UI.render(`
      <div class="mb-6">
        <h1 style="font-size:var(--fs-2xl);font-weight:var(--fw-extrabold);margin-bottom:var(--sp-2);">Tus favoritos</h1>
        <p class="text-2">${favRooms.length} habitación(es) guardada(s). Compara y decide cuál es tu favorita.</p>
      </div>

      <div class="rooms-grid">
        ${favRooms.map(r => RoomCard.render(r, { matchScore: RoomCard.computeMatch(r) })).join('')}
      </div>
    `);
  }

  return { render };
})();

window.FavoritesScreen = FavoritesScreen;
