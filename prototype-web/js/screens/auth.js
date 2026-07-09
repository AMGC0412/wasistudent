/* ============================================================
   WasiStudent — Screen: Auth (login / register)
   ============================================================ */

const AuthScreen = (function() {

  let mode = 'login';

  function render() {
    const root = document.getElementById('app-root');
    root.innerHTML = `
      <div class="auth-layout">
        <aside class="auth-aside">
          <div class="logo-row">
            <div class="logo">W</div>
            <div class="brand">WasiStudent</div>
          </div>
          <div>
            <div class="quote">Tu wasi te espera.<br>Sin engaños, sin sorpresas.</div>
            <p style="opacity:0.85;margin-top:var(--sp-4);max-width:380px;">La primera plataforma de alojamiento estudiantil en Cusco con verificación real y contrato legal basado en el Código Civil peruano.</p>
          </div>
          <div class="stats">
            <div class="stat">
              <div class="num">12</div>
              <div class="lbl">Puntos de verificación</div>
            </div>
            <div class="stat">
              <div class="num">5</div>
              <div class="lbl">Cláusulas legales</div>
            </div>
            <div class="stat">
              <div class="num">100%</div>
              <div class="lbl">Confianza</div>
            </div>
          </div>
        </aside>
        <main class="auth-main">
          <div class="auth-form anim-up" id="auth-form">
            <h1>${mode === 'login' ? 'Bienvenido de nuevo' : 'Crea tu cuenta'}</h1>
            <p class="subtitle">${mode === 'login' ? 'Ingresa para encontrar tu wasi en Cusco' : 'Únete y encuentra tu wasi confiable'}</p>

            ${mode === 'register' ? Forms.text('reg-name', 'Tu nombre completo', '', { label: 'Nombre completo', required: true }) : ''}
            ${Forms.email('auth-email', 'correo@ejemplo.com', '', { label: 'Correo electrónico', required: true })}
            ${Forms.password('auth-pass', 'Mínimo 6 caracteres', { label: 'Contraseña', required: true })}

            ${mode === 'register' ? `
              ${Forms.text('reg-phone', '+51 984 123 456', '', { label: 'Teléfono', required: true })}
              ${Forms.select('reg-uni', Seed.UNIVERSITIES.map(u => ({ value: u.id, label: u.short })), 'UNSAAC', { label: 'Universidad' })}
              ${Forms.select('reg-role', [{ value: 'student', label: 'Soy estudiante' }, { value: 'owner', label: 'Soy propietario' }], 'student', { label: 'Voy a' })}
            ` : ''}

            <div id="auth-err" class="auth-err" style="display:none;color:var(--c-error);font-size:var(--fs-sm);margin-bottom:var(--sp-3);padding:var(--sp-3);background:var(--c-error-soft);border-radius:var(--r-sm);"></div>

            <button class="btn btn-primary btn-lg btn-block" onclick="AuthScreen.submit()">
              ${mode === 'login' ? 'Iniciar sesión' : 'Crear cuenta'}
            </button>

            <div class="divider-text">o continúa con</div>

            <div class="row gap-3">
              <button class="btn btn-ghost grow" onclick="AuthScreen.demo('student')" style="padding:14px 16px;">
                <span style="display:inline-flex;width:24px;height:24px;align-items:center;justify-content:center;">${Icons.graduation}</span>
                <span>Demo estudiante</span>
              </button>
              <button class="btn btn-ghost grow" onclick="AuthScreen.demo('owner')" style="padding:14px 16px;">
                <span style="display:inline-flex;width:24px;height:24px;align-items:center;justify-content:center;">${Icons.building}</span>
                <span>Demo propietario</span>
              </button>
            </div>

            <p class="text-center text-2 fs-sm" style="margin-top:var(--sp-6);">
              ${mode === 'login' ? '¿No tienes cuenta?' : '¿Ya tienes cuenta?'}
              <a class="toggle-link" onclick="AuthScreen.toggle()">${mode === 'login' ? 'Regístrate gratis' : 'Inicia sesión'}</a>
            </p>
          </div>
        </main>
      </div>
    `;
  }

  function toggle() {
    mode = mode === 'login' ? 'register' : 'login';
    render();
  }

  function showError(msg) {
    const el = document.getElementById('auth-err');
    if (el) {
      el.textContent = msg;
      el.style.display = 'block';
    }
  }

  function submit() {
    const email = Forms.val('auth-email');
    const pass = Forms.val('auth-pass');

    if (!Forms.validateEmail(email)) {
      showError('Ingresa un correo electrónico válido');
      return;
    }
    if (pass.length < 6) {
      showError('La contraseña debe tener al menos 6 caracteres');
      return;
    }

    if (mode === 'login') {
      const result = Auth.login(email, pass);
      if (!result.ok) {
        // Si no existe, ofrecer demo
        showError('Usuario no encontrado. Prueba con un usuario demo.');
        return;
      }
      afterLogin(result.user);
    } else {
      const name = Forms.val('reg-name');
      const phone = Forms.val('reg-phone');
      const uni = Forms.val('reg-uni');
      const role = Forms.val('reg-role');
      if (!name) { showError('Ingresa tu nombre'); return; }
      if (!phone) { showError('Ingresa tu teléfono'); return; }

      const result = Auth.register(name, email, pass, phone, uni, role);
      if (!result.ok) {
        showError(result.error);
        return;
      }
      afterLogin(result.user);
    }
  }

  function demo(role) {
    // Crear usuario demo si no existe
    const email = role === 'student' ? 'estudiante@demo.com' : 'propietario@demo.com';
    const pass = 'demo123';
    const name = role === 'student' ? 'Estudiante Demo' : 'Propietario Demo';

    let result = Auth.login(email, pass);
    if (!result.ok) {
      result = Auth.register(name, email, pass, '+51 984 000 000', 'UNSAAC', role);
    }
    if (result.ok) {
      // Si es estudiante demo, marcar onboarding como completo
      if (role === 'student') {
        const user = result.user;
        user.onboarding = true;
        user.preferences = {
          role: 'student', university: 'UNSAAC',
          budgetMin: 400, budgetMax: 1000,
          roomType: 'single', genderPreference: 'any',
          amenities: ['wifi', 'security'], social: 60, cleanliness: 70,
          sleepSchedule: 'flexible', smoke: false, pets: false
        };
        Store.set(Store.KEYS.AUTH, user);
      }
      afterLogin(result.user);
    }
  }

  function afterLogin(user) {
    UI.toast({ title: '¡Bienvenido!', desc: `Hola ${user.name.split(' ')[0]}`, type: 'success' });
    if (!user.onboarding) {
      OnboardingSvc.start();
    } else {
      App.start();
    }
  }

  return { render, toggle, submit, demo };
})();

window.AuthScreen = AuthScreen;
