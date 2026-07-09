/* ============================================================
   WasiStudent — Auth Service
   ============================================================ */

const Auth = (function() {

  function current() {
    return Store.get(Store.KEYS.AUTH, null);
  }

  function isLogged() {
    return current() !== null;
  }

  function getUsers() {
    return Store.get(Store.KEYS.USERS, []);
  }

  function saveUsers(users) {
    Store.set(Store.KEYS.USERS, users);
  }

  function login(email, password) {
    const users = getUsers();
    const user = users.find(u => u.email === email && u.password === password);
    if (!user) {
      return { ok: false, error: 'Correo o contraseña incorrectos' };
    }
    const session = { id: user.id, name: user.name, email: user.email, role: user.role, university: user.university, phone: user.phone, onboarding: user.onboarding || false };
    Store.set(Store.KEYS.AUTH, session);
    return { ok: true, user: session };
  }

  function register(name, email, password, phone, university, role = 'student') {
    const users = getUsers();
    if (users.find(u => u.email === email)) {
      return { ok: false, error: 'Ya existe una cuenta con este correo' };
    }
    const user = {
      id: 'u' + Date.now(),
      name, email, password, phone, university, role,
      onboarding: false,
      createdAt: new Date().toISOString(),
      trustScore: role === 'owner' ? 50 : 0,
    };
    users.push(user);
    saveUsers(users);
    const session = { id: user.id, name, email, role, university, phone, onboarding: false };
    Store.set(Store.KEYS.AUTH, session);
    return { ok: true, user: session };
  }

  function logout() {
    Store.remove(Store.KEYS.AUTH);
    location.reload();
  }

  function completeOnboarding(preferences) {
    const session = current();
    if (!session) return;
    session.onboarding = true;
    session.preferences = preferences;
    Store.set(Store.KEYS.AUTH, session);
    // Actualizar usuario en store
    const users = getUsers();
    const idx = users.findIndex(u => u.id === session.id);
    if (idx >= 0) {
      users[idx].onboarding = true;
      users[idx].preferences = preferences;
      saveUsers(users);
    }
  }

  function updateProfile(updates) {
    const session = current();
    if (!session) return;
    Object.assign(session, updates);
    Store.set(Store.KEYS.AUTH, session);
    const users = getUsers();
    const idx = users.findIndex(u => u.id === session.id);
    if (idx >= 0) {
      Object.assign(users[idx], updates);
      saveUsers(users);
    }
  }

  return { current, isLogged, login, register, logout, completeOnboarding, updateProfile };
})();

window.Auth = Auth;
