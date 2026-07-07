const Explore = {
  filter: '',
  render() {
    const districts = ['Todos','San Jerónimo','San Sebastián','Santiago','Wanchaq','Cusco Centro','San Blas','Poroy'];
    document.getElementById('explore-filters').innerHTML = districts.map(d => '<div class="fc' + (Explore.filter === d ? ' act' : '') + '" onclick="Explore.setFilter(\'' + d + '\')">' + d + '</div>').join('');
    Explore.renderRooms();
  },
  setFilter(d) { Explore.filter = d; Explore.render(); },
  renderRooms() {
    let rooms = state.rooms.filter(r => r.active);
    if (Explore.filter && Explore.filter !== 'Todos') rooms = rooms.filter(r => r.district === Explore.filter);
    const c = document.getElementById('explore-content');
    c.innerHTML = rooms.length === 0 ? '<div class="empty">' + I.home + '<h3>Sin resultados</h3><p>No hay cuartos con ese filtro.</p></div>' : rooms.map(r => Components.roomCard(r)).join('');
  },
  search() {
    const q = document.getElementById('explore-search').value.toLowerCase();
    let rooms = state.rooms.filter(r => r.active);
    if (Explore.filter && Explore.filter !== 'Todos') rooms = rooms.filter(r => r.district === Explore.filter);
    if (q) rooms = rooms.filter(r => r.title.toLowerCase().includes(q) || r.district.toLowerCase().includes(q) || r.desc.toLowerCase().includes(q));
    document.getElementById('explore-content').innerHTML = rooms.length === 0 ? '<div class="empty"><h3>Sin resultados</h3></div>' : rooms.map(r => Components.roomCard(r)).join('');
  }
};
