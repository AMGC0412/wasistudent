// ═══ APP ENTRY POINT ═══
function initApp() {
  // Set icons in static elements
  document.getElementById('loading-icon').innerHTML = '<svg viewBox="0 0 24 24" fill="none" stroke="#C44536" stroke-width="2"><path d="M3 12l9-9 9 9M5 10v10h14V10"/></svg>';
  document.getElementById('auth-logo').innerHTML = '<svg viewBox="0 0 24 24" fill="none" stroke="#fff" stroke-width="2" style="width:32px;height:32px"><path d="M3 12l9-9 9 9M5 10v10h14V10"/></svg>';
  document.getElementById('search-icon-slot').innerHTML = I.search + '<input type="text" id="explore-search" placeholder="Buscar por barrio, título..." oninput="Explore.search()">';
  
  // Nav icons
  document.querySelector('#nav-home .ni-icon').innerHTML = I.home;
  document.querySelector('#nav-explore .ni-icon').innerHTML = I.explore;
  document.querySelector('#nav-discover .ni-icon').innerHTML = I.star;
  document.querySelector('#nav-messages .ni-icon').innerHTML = I.chat;
  document.querySelector('#nav-profile .ni-icon').innerHTML = I.person;

  // Nav clicks
  document.getElementById('nav-home').onclick = () => navTo('scr-home');
  document.getElementById('nav-explore').onclick = () => navTo('scr-explore');
  document.getElementById('nav-discover').onclick = () => navTo('scr-discover');
  document.getElementById('nav-messages').onclick = () => navTo('scr-messages');
  document.getElementById('nav-profile').onclick = () => navTo('scr-profile');

  // Back buttons
  const backBtns = {
    'detail-back-btn': () => goBack(),
    'c1-back-btn': () => go('scr-detail'),
    'c2-back-btn': () => go('scr-c1'),
    'c3-back-btn': () => go('scr-c2'),
    'c1-cancel-btn': () => go('scr-detail'),
    'c2-cancel-btn': () => go('scr-c1'),
    'c3-cancel-btn': () => go('scr-c2'),
    'results-back-btn': () => go('scr-home'),
    'publish-back-btn': () => go('scr-owner'),
    'or-back-btn': () => go('scr-owner'),
    'oreq-back-btn': () => go('scr-owner'),
    'oc-back-btn': () => go('scr-owner'),
    'op-back-btn': () => go('scr-owner'),
    'settings-back-btn': () => go('scr-profile'),
    'trust-back-btn': () => go('scr-profile'),
    'rev-back-btn': () => goBack(),
    'ar-back-btn': () => go('scr-reviews'),
    'fav-back-btn': () => go('scr-profile'),
    'pay-back-btn': () => go('scr-profile'),
  };
  Object.entries(backBtns).forEach(([id, fn]) => {
    const el = document.getElementById(id);
    if (el) { el.innerHTML = I.back; el.onclick = fn; }
  });

  // Detail actions
  document.getElementById('detail-fav-btn').onclick = () => Favorites.toggle(state.currentRoom);
  document.getElementById('detail-compare-btn').onclick = () => alert('Comparación disponible próximamente');
  document.getElementById('detail-contract-btn').onclick = () => Contract.start();
  
  // Map
  document.getElementById('map-list-btn').innerHTML = I.list;
  document.getElementById('map-list-btn').onclick = () => go('scr-explore');

  // Owner quick access
  document.getElementById('qa-rooms-btn').onclick = () => go('scr-owner-rooms');
  document.getElementById('qa-reqs-btn').onclick = () => go('scr-owner-requests');
  document.getElementById('qa-contracts-btn').onclick = () => go('scr-owner-contracts');
  document.getElementById('qa-payments-btn').onclick = () => go('scr-owner-payments');
  document.getElementById('qa-rooms-btn').querySelector('.qa-icon').innerHTML = I.home;
  document.getElementById('qa-reqs-btn').querySelector('.qa-icon').innerHTML = I.chat;
  document.getElementById('qa-contracts-btn').querySelector('.qa-icon').innerHTML = I.doc;
  document.getElementById('qa-payments-btn').querySelector('.qa-icon').innerHTML = I.money;
  
  // Publish
  document.getElementById('publish-btn').onclick = () => go('scr-publish');
  document.getElementById('publish-form').innerHTML = `
    <div class="fld"><label>Título</label><input type="text" id="pub-title" placeholder="Cuarto individual luminoso"></div>
    <div class="fld"><label>Descripción</label><textarea id="pub-desc" placeholder="Describe tu cuarto..."></textarea></div>
    <div style="display:flex;gap:10px"><div class="fld" style="flex:1"><label>Precio (S/)</label><input type="number" id="pub-price" placeholder="280"></div><div class="fld" style="flex:1"><label>Tamaño (m²)</label><input type="number" id="pub-size" placeholder="12"></div></div>
    <div class="fld"><label>Distrito</label><select id="pub-district"><option>San Jerónimo</option><option>San Sebastián</option><option>Santiago</option><option>Wanchaq</option><option>Cusco Centro</option><option>San Blas</option><option>Poroy</option></select></div>
    <div class="fld"><label>Minutos caminando a la universidad</label><input type="number" id="pub-walk" placeholder="8"></div>
    <div class="fld"><label>Tipo de cuarto</label><select id="pub-type"><option value="private">Privado</option><option value="shared">Compartido</option><option value="studio">Estudio</option></select></div>
    <div class="fld"><label>Servicios (separa con comas)</label><input type="text" id="pub-amen" placeholder="Wi-Fi, Agua caliente, Cocina"></div>
    <div style="display:flex;gap:10px;margin-bottom:10px">
      <div class="toggle" style="flex:1" onclick="this.querySelector('.sw').classList.toggle('on')"><div class="tl">${I.person}<div><div class="tt">Parejas</div><div class="ts">Acepta parejas</div></div></div><div class="sw" id="sw-couples"></div></div>
      <div class="toggle" style="flex:1" onclick="this.querySelector('.sw').classList.toggle('on')"><div class="tl">${I.shield}<div><div class="tt">Mascotas</div><div class="ts">Acepta mascotas</div></div></div><div class="sw" id="sw-pets"></div></div>
    </div>
    <button class="btn btn-pri btn-blk" onclick="Owner.publish()">Publicar</button>
  `;

  // Reviews
  document.getElementById('rev-add-btn').onclick = () => go('scr-add-review');
  document.getElementById('add-review-form').innerHTML = `
    <div class="fld"><label>Calificación</label><div id="star-input" style="display:flex;gap:4px">${[1,2,3,4,5].map(n => '<div onclick="Reviews.selStars(' + n + ')" style="cursor:pointer;padding:4px" id="star-' + n + '">' + I.star + '</div>').join('')}</div></div>
    <div class="fld"><label>Título</label><input type="text" id="rev-title" placeholder="Resumen de tu experiencia"></div>
    <div class="fld"><label>Comentario</label><textarea id="rev-body" placeholder="Cuéntanos tu experiencia..."></textarea></div>
    <button class="btn btn-pri btn-blk" onclick="Reviews.submit()">Publicar reseña</button>
  `;

  // Success button
  document.getElementById('success-btn').onclick = () => go('scr-home');

  // Load state
  state.user = API.getUser();
  state.rooms = DB.get('rooms', seedRooms());
  state.contracts = DB.get('contracts', []);
  state.reviews = DB.get('reviews', []);
  state.favorites = API.getFavorites();
  state.requests = DB.get('requests', seedRequests());
  state.role = DB.get('role', 'student');
  state.ownerEnabled = DB.get('ownerEnabled', false);

  // If rooms empty, seed
  if (state.rooms.length === 0) { state.rooms = seedRooms(); DB.set('rooms', state.rooms); }

  // Start
  setTimeout(() => {
    if (state.user) go('scr-home'); else go('scr-auth');
  }, 2500);
}

// Star rating for reviews
Reviews.selStars = function(n) {
  state.selectedStars = n;
  for (let i = 1; i <= 5; i++) {
    const el = document.getElementById('star-' + i);
    if (el) { el.querySelector('svg').style.color = i <= n ? 'var(--acc)' : 'var(--txt3)'; el.querySelector('svg').setAttribute('fill', i <= n ? 'var(--acc)' : 'none'); }
  }
};

// Start app
initApp();
