/* ============================================================
   WasiStudent — Componente: RoomCard
   ============================================================ */

const RoomCard = (function() {

  function render(room, opts = {}) {
    const favorites = Store.get(Store.KEYS.FAVORITES, []);
    const isFav = favorites.includes(room.id);

    const matchScore = opts.matchScore ?? computeMatch(room);
    const matchClass = matchScore >= 75 ? 'high' : matchScore >= 50 ? 'medium' : 'low';

    const photo = room.photos && room.photos[0] ? room.photos[0] : '';
    const district = Seed.DISTRICTS.find(d => d.id === room.district);

    return `
      <div class="room-card anim-up" onclick="UI.nav('detail', { roomId: '${room.id}' })">
        <div class="photo">
          ${photo ? `<img src="${photo}" alt="${room.title}" loading="lazy" onerror="this.style.display='none'">` : `<div style="width:100%;height:100%;display:flex;align-items:center;justify-content:center;color:var(--c-text-3);">${Icons.image}</div>`}
          <div class="badges-top">
            ${room.verified ? `<span class="badge" style="background:var(--c-success);color:white;">${Icons.shieldCheck} Verificado</span>` : ''}
            ${room.contractActive ? `<span class="badge" style="background:var(--c-info);color:white;">Contrato legal</span>` : ''}
          </div>
          <button class="fav-btn ${isFav ? 'active' : ''}" onclick="event.stopPropagation(); RoomCard.toggleFav('${room.id}', this)">
            ${isFav ? Icons.heartFill : Icons.heart}
          </button>
          <div class="price-tag">
            ${UI.formatPrice(room.price)} <span class="period">/${room.period}</span>
          </div>
        </div>
        <div class="body">
          <div class="title clamp-2">${room.title}</div>
          <div class="location">
            ${Icons.pin}
            ${district ? district.name : ''} · ${room.walkMinutes} min a pie
          </div>
          <div class="features">
            <span class="feat">${Icons.bed} ${room.area}m²</span>
            ${room.amenities.includes('wifi') ? `<span class="feat">${Icons.wifi} WiFi</span>` : ''}
            ${room.amenities.includes('bathroom') ? `<span class="feat">${Icons.bath} Baño</span>` : ''}
            <span class="feat">${Icons.users} ${room.maxOccupancy}</span>
          </div>
          <div class="footer">
            <div class="match-badge ${matchClass}">
              ${Icons.zap} ${matchScore}% match
            </div>
            <div class="row gap-1" style="color:var(--c-accent);">
              ${Icons.star}
              <span style="font-size:13px;font-weight:600;color:var(--c-text);">${room.rating || '—'}</span>
              <span class="text-3 fs-xs">(${room.reviewCount || 0})</span>
            </div>
          </div>
        </div>
      </div>
    `;
  }

  function computeMatch(room) {
    const user = Auth.current();
    if (!user || !user.preferences) return Math.floor(60 + Math.random() * 30);

    const prefs = user.preferences;
    let score = 50;
    const reasons = [];

    if (room.price >= prefs.budgetMin && room.price <= prefs.budgetMax) { score += 20; reasons.push('Precio'); }
    if (room.type === prefs.roomType) { score += 15; reasons.push('Tipo'); }
    if (room.amenities.some(a => prefs.amenities.includes(a))) { score += 10; reasons.push('Servicios'); }
    if (room.university === prefs.university) { score += 5; }

    return Math.min(99, score);
  }

  function toggleFav(roomId, btn) {
    const favs = Store.get(Store.KEYS.FAVORITES, []);
    const idx = favs.indexOf(roomId);
    if (idx >= 0) {
      favs.splice(idx, 1);
      btn.classList.remove('active');
      btn.innerHTML = Icons.heart;
      UI.toast({ title: 'Quitado de favoritos', type: 'info' });
    } else {
      favs.push(roomId);
      btn.classList.add('active');
      btn.innerHTML = Icons.heartFill;
      UI.toast({ title: 'Agregado a favoritos', desc: 'Puedes verlo en tu lista de favoritos', type: 'success' });
    }
    Store.set(Store.KEYS.FAVORITES, favs);
  }

  return { render, toggleFav, computeMatch };
})();

window.RoomCard = RoomCard;
