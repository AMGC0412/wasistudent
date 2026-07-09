/* ============================================================
   WasiStudent — Router (SPA simple por hash)
   ============================================================ */

const Router = (function() {
  const routes = {};
  let current = null;
  const beforeHooks = [];

  function register(name, handler) {
    routes[name] = handler;
  }

  function before(hook) {
    beforeHooks.push(hook);
  }

  function go(name, params = {}) {
    if (!routes[name]) {
      console.warn('Ruta no encontrada:', name);
      return;
    }

    // Ejecutar hooks antes
    for (const hook of beforeHooks) {
      const result = hook(name, params);
      if (result === false) return;
    }

    current = { name, params };
    // Actualizar URL hash sin recargar
    if (window.history && window.history.replaceState) {
      window.history.replaceState(null, '', '#' + name);
    }

    // Actualizar nav activa
    document.querySelectorAll('[data-nav]').forEach(el => {
      el.classList.toggle('active', el.dataset.nav === name);
    });

    routes[name](params);
  }

  function current_() { return current; }

  return { register, go, before, current: current_ };
})();

window.Router = Router;
