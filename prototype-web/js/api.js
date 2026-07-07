// ═══ API LAYER ═══
// Si USE_LOCAL = true, usa localStorage. Si false, usa PHP API.

const API = {
  async login(email, pass) {
    if (CONFIG.USE_LOCAL) {
      const users = DB.get('users', []);
      const u = users.find(x => x.email === email && x.pass === pass);
      if (!u) return { error: 'Correo o contraseña incorrectos' };
      return { user: { id: u.id, name: u.name, email: u.email, phone: u.phone, uni: u.uni, trustScore: u.trustScore || 25, memberSince: u.memberSince || new Date().toISOString(), avatar: u.name.substring(0, 2).toUpperCase() } };
    }
    const r = await fetch(CONFIG.API_URL + 'auth.php', { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({ action: 'login', email, pass }) });
    return await r.json();
  },

  async register(name, email, pass, phone, uni) {
    if (CONFIG.USE_LOCAL) {
      const users = DB.get('users', []);
      if (users.find(x => x.email === email)) return { error: 'Ya existe una cuenta con este correo' };
      const u = { id: 'u' + Date.now(), name, email, pass, phone, uni, trustScore: 25, memberSince: new Date().toISOString() };
      users.push(u); DB.set('users', users);
      return { user: { id: u.id, name: u.name, email: u.email, phone: u.phone, uni: u.uni, trustScore: 25, memberSince: u.memberSince, avatar: name.substring(0, 2).toUpperCase() } };
    }
    const r = await fetch(CONFIG.API_URL + 'auth.php', { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({ action: 'register', name, email, pass, phone, uni }) });
    return await r.json();
  },

  async getRooms() {
    if (CONFIG.USE_LOCAL) return DB.get('rooms', seedRooms());
    const r = await fetch(CONFIG.API_URL + 'rooms.php?action=list');
    return await r.json();
  },

  async createRoom(room) {
    if (CONFIG.USE_LOCAL) {
      const rooms = DB.get('rooms', []);
      room.id = 'room' + Date.now();
      rooms.push(room); DB.set('rooms', rooms);
      return { success: true, room };
    }
    const r = await fetch(CONFIG.API_URL + 'rooms.php', { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify(room) });
    return await r.json();
  },

  async deleteRoom(id) {
    if (CONFIG.USE_LOCAL) {
      let rooms = DB.get('rooms', []);
      rooms = rooms.filter(r => r.id !== id); DB.set('rooms', rooms);
      return { success: true };
    }
    const r = await fetch(CONFIG.API_URL + 'rooms.php?action=delete&id=' + id, { method: 'DELETE' });
    return await r.json();
  },

  async getContracts() {
    if (CONFIG.USE_LOCAL) return DB.get('contracts', []);
    const r = await fetch(CONFIG.API_URL + 'contracts.php?action=list');
    return await r.json();
  },

  async createContract(contract) {
    if (CONFIG.USE_LOCAL) {
      const contracts = DB.get('contracts', []);
      contract.id = 'ct' + Date.now();
      contracts.push(contract); DB.set('contracts', contracts);
      return { success: true, contract };
    }
    const r = await fetch(CONFIG.API_URL + 'contracts.php', { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify(contract) });
    return await r.json();
  },

  async getReviews(roomId) {
    if (CONFIG.USE_LOCAL) {
      const reviews = DB.get('reviews', []);
      return reviews.filter(r => r.roomId === roomId);
    }
    const r = await fetch(CONFIG.API_URL + 'reviews.php?action=list&roomId=' + roomId);
    return await r.json();
  },

  async createReview(review) {
    if (CONFIG.USE_LOCAL) {
      const reviews = DB.get('reviews', []);
      review.id = 'rev' + Date.now();
      reviews.push(review); DB.set('reviews', reviews);
      return { success: true, review };
    }
    const r = await fetch(CONFIG.API_URL + 'reviews.php', { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify(review) });
    return await r.json();
  },

  async getRequests() {
    if (CONFIG.USE_LOCAL) return DB.get('requests', seedRequests());
    const r = await fetch(CONFIG.API_URL + 'requests.php?action=list');
    return await r.json();
  },

  async updateRequest(id, action) {
    if (CONFIG.USE_LOCAL) {
      let requests = DB.get('requests', []);
      requests = requests.filter(r => r.id !== id); DB.set('requests', requests);
      return { success: true };
    }
    const r = await fetch(CONFIG.API_URL + 'requests.php', { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({ id, action }) });
    return await r.json();
  },

  getFavorites() { return DB.get('favorites', []); },
  toggleFavorite(id) {
    let favs = DB.get('favorites', []);
    const idx = favs.indexOf(id);
    if (idx > -1) favs.splice(idx, 1); else favs.push(id);
    DB.set('favorites', favs);
    return favs;
  },

  saveUser(user) { DB.set('user', user); },
  getUser() { return DB.get('user', null); },
  clearUser() { DB.del('user'); },
};
