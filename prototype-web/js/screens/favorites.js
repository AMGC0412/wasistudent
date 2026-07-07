const Favorites = {
  render() {
    const favRooms = state.rooms.filter(r => state.favorites.includes(r.id) && r.active);
    document.getElementById('fav-content').innerHTML = favRooms.length === 0 ? '<div class="empty">' + I.heart + '<h3>Sin favoritos</h3><p>Toca el corazón en un cuarto.</p></div>' : favRooms.map(r => Components.roomCard(r)).join('');
  },
  toggle(id) {
    state.favorites = API.toggleFavorite(id);
    if (document.getElementById('scr-detail').classList.contains('on')) {
      const isFav = state.favorites.includes(id);
      const svg = document.getElementById('detail-fav-btn').querySelector('svg');
      svg.style.color = isFav ? 'var(--pri)' : 'var(--txt3)';
      svg.setAttribute('fill', isFav ? 'var(--pri)' : 'none');
    }
  }
};
