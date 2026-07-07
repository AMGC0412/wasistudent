const Discover = {
  render() {
    const rooms = state.rooms.filter(r => r.active);
    const c = document.getElementById('discover-content');
    c.innerHTML = rooms.length === 0 ? '<div class="empty">' + I.home + '<h3>Nada que descubrir</h3></div>' : '<div style="text-align:center;padding:20px 0;color:var(--txt2);font-size:13px">Desliza las tarjetas para descubrir tu match</div>' + rooms.slice(0, 3).map(r => '<div style="margin-bottom:16px">' + Components.roomCard(r) + '</div>').join('');
  }
};
