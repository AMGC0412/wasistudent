/* ============================================================
   WasiStudent — Store (Persistencia local con fallback)
   ============================================================ */

const Store = (function() {
  const _mem = {};
  let _backend = 'memory';

  // Detectar backend disponible
  try {
    const test = '__wasi_test__';
    localStorage.setItem(test, test);
    localStorage.removeItem(test);
    _backend = 'localStorage';
  } catch (e) {
    _backend = 'memory';
  }

  function get(key, fallback = null) {
    try {
      if (_backend === 'localStorage') {
        const raw = localStorage.getItem(key);
        if (raw === null) return fallback;
        return JSON.parse(raw);
      }
      return key in _mem ? _mem[key] : fallback;
    } catch (e) {
      return fallback;
    }
  }

  function set(key, value) {
    try {
      if (_backend === 'localStorage') {
        localStorage.setItem(key, JSON.stringify(value));
      } else {
        _mem[key] = value;
      }
      return true;
    } catch (e) {
      _mem[key] = value;
      return false;
    }
  }

  function remove(key) {
    if (_backend === 'localStorage') localStorage.removeItem(key);
    else delete _mem[key];
  }

  function clear() {
    if (_backend === 'localStorage') localStorage.clear();
    else Object.keys(_mem).forEach(k => delete _mem[k]);
  }

  // Helpers específicos
  const KEYS = {
    AUTH: 'wasi_auth',
    USERS: 'wasi_users',
    ONBOARDING: 'wasi_onboarding',
    FAVORITES: 'wasi_favorites',
    REQUESTS: 'wasi_requests',
    CONTRACTS: 'wasi_contracts',
    CHATS: 'wasi_chats',
    MESSAGES: 'wasi_messages',
    NOTIFICATIONS: 'wasi_notifs',
    PAYMENTS: 'wasi_payments',
    REVIEWS: 'wasi_reviews',
    PREFERENCES: 'wasi_prefs',
    ROOMS: 'wasi_rooms_seed_v',
  };

  return {
    get, set, remove, clear, KEYS,
    backend: () => _backend,
  };
})();

window.Store = Store;
