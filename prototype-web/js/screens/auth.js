const Auth = {
  toggle() {
    state.isLogin = !state.isLogin;
    document.getElementById('auth-title').textContent = state.isLogin ? 'Bienvenido' : 'Crea tu cuenta';
    document.getElementById('auth-sub').textContent = state.isLogin ? 'Ingresa para encontrar tu wasi en Cusco' : 'Únete a WasiStudent';
    document.getElementById('auth-btn').textContent = state.isLogin ? 'Iniciar sesión' : 'Crear cuenta';
    document.getElementById('auth-toggle').textContent = state.isLogin ? 'No tengo cuenta' : 'Ya tengo cuenta';
    document.getElementById('auth-name-field').style.display = state.isLogin ? 'none' : 'block';
    document.getElementById('auth-phone-field').style.display = state.isLogin ? 'none' : 'block';
    document.getElementById('auth-err').style.display = 'none';
  },

  async doAuth() {
    const email = document.getElementById('auth-email').value.trim();
    const pass = document.getElementById('auth-pass').value;
    if (!email || !pass) { Auth.err('Completa todos los campos'); return; }
    if (pass.length < 6) { Auth.err('La contraseña debe tener al menos 6 caracteres'); return; }

    let result;
    if (state.isLogin) {
      result = await API.login(email, pass);
    } else {
      const name = document.getElementById('reg-name').value.trim();
      const phone = document.getElementById('reg-phone').value.trim();
      const uni = document.getElementById('reg-uni').value;
      if (!name) { Auth.err('Ingresa tu nombre'); return; }
      if (!phone) { Auth.err('Ingresa tu teléfono'); return; }
      result = await API.register(name, email, pass, phone, uni);
    }

    if (result.error) { Auth.err(result.error); return; }
    state.user = result.user;
    API.saveUser(state.user);
    go('scr-home');
  },

  err(msg) {
    const e = document.getElementById('auth-err');
    e.textContent = msg;
    e.style.display = 'block';
  },

  logout() {
    API.clearUser();
    state.user = null;
    state.history = [];
    go('scr-auth');
  }
};
