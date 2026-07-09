/* ============================================================
   WasiStudent — Onboarding Service
   ============================================================ */

const OnboardingSvc = (function() {

  const STEPS = [
    { id: 'welcome', title: 'Bienvenido a WasiStudent', desc: 'Tu wasi confiable te espera en Cusco. Vamos a configurar tu experiencia.' },
    { id: 'role', title: '¿Eres estudiante o propietario?', desc: 'Personalizaremos tu experiencia según tu rol.' },
    { id: 'university', title: '¿En qué universidad estudias?', desc: 'Buscaremos habitaciones cerca de tu campus.' },
    { id: 'budget', title: '¿Cuál es tu presupuesto mensual?', desc: 'Filtramos opciones que se ajusten a ti.' },
    { id: 'preferences', title: 'Tus preferencias de vivienda', desc: 'Cuéntanos qué es importante para ti.' },
    { id: 'lifestyle', title: 'Tu estilo de vida', desc: 'Para encontrarte compañeros compatibles.' },
    { id: 'done', title: '¡Listo! Tu perfil está completo', desc: 'Ya puedes empezar a buscar tu wasi.' },
  ];

  let state = {
    step: 0,
    data: {
      role: 'student',
      university: 'UNSAAC',
      budgetMin: 400,
      budgetMax: 900,
      roomType: 'single',
      genderPreference: 'any',
      amenities: ['wifi', 'security'],
      quiet: 50,
      social: 50,
      cleanliness: 70,
      sleepSchedule: 'flexible',
      smoke: false,
      pets: false,
    }
  };

  function start() {
    state.step = 0;
    render();
  }

  function next() {
    if (state.step < STEPS.length - 1) {
      state.step++;
      // Saltar "lifestyle" (paso 5) para propietarios — no aplica
      if (state.data.role === 'owner' && state.step === 5) {
        state.step = 6; // saltar a "done"
      }
      render();
    } else {
      complete();
    }
  }

  function prev() {
    if (state.step > 0) {
      state.step--;
      // Saltar "lifestyle" (paso 5) para propietarios al retroceder
      if (state.data.role === 'owner' && state.step === 5) {
        state.step = 4; // saltar a "preferences/ownerVerification"
      }
      render();
    }
  }

  function set(field, value) {
    state.data[field] = value;
  }

  function complete() {
    Auth.completeOnboarding(state.data);
    // Redirigir a app principal
    App.start();
  }

  function render() {
    const root = document.getElementById('app-root');
    if (!root) return;

    const step = STEPS[state.step];
    const total = STEPS.length;
    const current = state.step + 1;

    root.innerHTML = `
      <div class="onboard-layout">
        <aside class="onboard-aside">
          <div class="step-counter">
            Paso <span class="current">${String(current).padStart(2, '0')}</span>
            <span class="total">/ ${String(total).padStart(2, '0')}</span>
          </div>
          <div>
            <div class="step-title">${step.title}</div>
            <div class="step-desc">${step.desc}</div>
          </div>
          <div class="illustration">${getIllustration(state.step)}</div>
          <div class="progress-dots">
            ${STEPS.map((_, i) => `<div class="dot ${i === state.step ? 'active' : i < state.step ? 'done' : ''}"></div>`).join('')}
          </div>
        </aside>
        <main class="onboard-main">
          <div class="onboard-form anim-up" id="onboard-form">
            ${renderStep(state.step)}
          </div>
        </main>
      </div>
    `;
  }

  // Re-render manteniendo el mismo paso (para inputs interactivos)
  function rerender() {
    render();
  }

  function getIllustration(step) {
    const icons = ['heart', 'users', 'graduation', 'dollar', 'building', 'smile', 'checkCircle'];
    return `<div style="width:140px;height:140px;background:rgba(255,255,255,0.1);border-radius:32px;display:flex;align-items:center;justify-content:center;margin:0 auto;">${Icons[icons[step]] || Icons.sparkles}</div>`;
  }

  function renderStep(step) {
    switch (step) {
      case 0: return renderWelcome();
      case 1: return renderRole();
      case 2: return renderUniversity();
      case 3: return renderBudget();
      case 4: return renderPreferences();
      case 5: return renderLifestyle();
      case 6: return renderDone();
      default: return '';
    }
  }

  function renderWelcome() {
    return `
      <h2>¡Hola! Bienvenido a WasiStudent</h2>
      <p class="hint">Vamos a crear tu perfil en menos de 2 minutos. Esto nos ayudará a encontrar tu wasi ideal en Cusco, con verificación real y contrato legal.</p>

      <div class="card card-pad-lg" style="background:var(--c-primary-50);border-color:transparent;margin-bottom:var(--sp-5);">
        <div class="row gap-3" style="align-items:flex-start;">
          <div style="width:40px;height:40px;background:var(--c-primary);color:white;border-radius:10px;display:flex;align-items:center;justify-content:center;flex-shrink:0;">${Icons.shieldCheck}</div>
          <div>
            <div class="fw-bold" style="margin-bottom:4px;">¿Por qué WasiStudent?</div>
            <p class="text-2 fs-sm">Verificamos cada habitación en 12 puntos de seguridad. Cada alquiler incluye contrato con 5 cláusulas legales. Sin engaños, sin cobros ocultos.</p>
          </div>
        </div>
      </div>

      <div class="row gap-3 mb-4">
        <div class="grow">
          <div class="stat-card">
            <div class="stat-icon success">${Icons.checkCircle}</div>
            <div>
              <div class="stat-num">12</div>
              <div class="stat-lbl">Puntos de verificación</div>
            </div>
          </div>
        </div>
        <div class="grow">
          <div class="stat-card">
            <div class="stat-icon accent">${Icons.fileCheck}</div>
            <div>
              <div class="stat-num">5</div>
              <div class="stat-lbl">Cláusulas legales</div>
            </div>
          </div>
        </div>
      </div>

      <button class="btn btn-primary btn-lg btn-block" onclick="OnboardingSvc.next()">
        Comenzar
        ${Icons.arrowRight}
      </button>
    `;
  }

  function renderRole() {
    return `
      <h2>¿Cómo vas a usar WasiStudent?</h2>
      <p class="hint">Esto personaliza toda tu experiencia en la plataforma.</p>

      <div class="choice-grid">
        <div class="choice-card ${state.data.role === 'student' ? 'selected' : ''}" onclick="OnboardingSel.role('student')">
          <div style="font-size:48px;margin-bottom:8px;">${Icons.graduation}</div>
          <div class="name">Soy estudiante</div>
          <div class="text-3 fs-xs mt-1">Busco habitación</div>
        </div>
        <div class="choice-card ${state.data.role === 'owner' ? 'selected' : ''}" onclick="OnboardingSel.role('owner')">
          <div style="font-size:48px;margin-bottom:8px;">${Icons.building}</div>
          <div class="name">Soy propietario</div>
          <div class="text-3 fs-xs mt-1">Publico habitaciones</div>
        </div>
      </div>

      ${navButtons()}
    `;
  }

  function renderUniversity() {
    if (state.data.role === 'owner') {
      // Saltar este paso para owner — mostrar info sobre legalidad
      return `
        <h2>Verificación legal</h2>
        <p class="hint">Como propietario, deberás verificar tu propiedad. Esto protege a los estudiantes y te diferencia de los avisos informales.</p>

        <div class="card card-pad" style="border-left:3px solid var(--c-primary);margin-bottom:var(--sp-4);">
          <div class="fw-bold mb-2">12 puntos de verificación</div>
          <p class="text-2 fs-sm">Desde identidad del propietario hasta seguridad eléctrica. Verificamos en persona, no con fotos.</p>
        </div>

        <div class="card card-pad" style="border-left:3px solid var(--c-success);margin-bottom:var(--sp-4);">
          <div class="fw-bold mb-2">Contrato legal estándar</div>
          <p class="text-2 fs-sm">Basado en el Código Civil peruano. Protege tanto al inquilino como al propietario.</p>
        </div>

        ${navButtons()}
      `;
    }

    return `
      <h2>¿En qué universidad estudias?</h2>
      <p class="hint">Buscaremos habitaciones cerca de tu campus.</p>

      <div class="choice-grid cols-1">
        ${Seed.UNIVERSITIES.map(u => `
          <div class="radio-card ${state.data.university === u.id ? 'selected' : ''}" onclick="OnboardingSel.uni('${u.id}')">
            <div class="icon-circle">${Icons.graduation}</div>
            <div class="grow">
              <div class="fw-semibold">${u.short}</div>
              <div class="text-3 fs-xs">${u.name}</div>
            </div>
          </div>
        `).join('')}
      </div>

      ${navButtons()}
    `;
  }

  function renderBudget() {
    if (state.data.role === 'owner') {
      return renderOwnerPricing();
    }

    return `
      <h2>¿Cuál es tu presupuesto?</h2>
      <p class="hint">Rango mensual en soles (S/) que estás dispuesto a pagar.</p>

      <div class="card card-pad-lg mb-4">
        <div class="between mb-3">
          <span class="text-2 fs-sm">Mínimo</span>
          <span class="fw-bold" style="font-family:var(--font-display);font-size:var(--fs-xl);color:var(--c-primary);">S/ ${state.data.budgetMin}</span>
        </div>
        <input type="range" min="200" max="2000" step="50" value="${state.data.budgetMin}" class="range-slider" oninput="OnboardingSel.budget('min', this.value)">

        <div class="divider"></div>

        <div class="between mb-3">
          <span class="text-2 fs-sm">Máximo</span>
          <span class="fw-bold" style="font-family:var(--font-display);font-size:var(--fs-xl);color:var(--c-primary);">S/ ${state.data.budgetMax}</span>
        </div>
        <input type="range" min="200" max="2500" step="50" value="${state.data.budgetMax}" class="range-slider" oninput="OnboardingSel.budget('max', this.value)">
      </div>

      <div class="row gap-3">
        <div class="grow card card-pad text-center">
          <div class="text-2 fs-sm">Promedio en Cusco</div>
          <div class="fw-bold fs-lg">S/ 720</div>
        </div>
        <div class="grow card card-pad text-center">
          <div class="text-2 fs-sm">En tu rango</div>
          <div class="fw-bold fs-lg" style="color:var(--c-success);">~24 opciones</div>
        </div>
      </div>

      ${navButtons()}
    `;
  }

  function renderOwnerPricing() {
    return `
      <h2>Tu experiencia como propietario</h2>
      <p class="hint">Esto nos ayuda a darte las herramientas correctas.</p>

      <div class="field">
        <label>¿Cuántas habitaciones planeas publicar?</label>
        <select class="select" onchange="OnboardingSel.set('roomCount', this.value)">
          <option value="1">1 habitación</option>
          <option value="2-5" selected>2 a 5 habitaciones</option>
          <option value="6-10">6 a 10 habitaciones</option>
          <option value="10+">Más de 10 (residencia)</option>
        </select>
      </div>

      <div class="field">
        <label>¿Ya tienes contratos de alquiler?</label>
        <select class="select" onchange="OnboardingSel.set('hasContracts', this.value)">
          <option value="no">No, necesito ayuda legal</option>
          <option value="yes" selected>Sí, pero quiero mejorarlos</option>
          <option value="lawyer">Tengo abogado</option>
        </select>
      </div>

      ${navButtons()}
    `;
  }

  function renderPreferences() {
    if (state.data.role === 'owner') {
      return renderOwnerVerification();
    }

    const amenities = [
      { id: 'wifi', name: 'WiFi', icon: 'wifi' },
      { id: 'bathroom', name: 'Baño privado', icon: 'bath' },
      { id: 'kitchen', name: 'Cocina', icon: 'bath' },
      { id: 'security', name: 'Seguridad 24h', icon: 'shield' },
      { id: 'desk', name: 'Escritorio', icon: 'bookOpen' },
      { id: 'laundry', name: 'Lavandería', icon: 'refresh' },
      { id: 'gym', name: 'Gym', icon: 'zap' },
      { id: 'elevator', name: 'Ascensor', icon: 'building' },
    ];

    return `
      <h2>Tus preferencias de vivienda</h2>
      <p class="hint">Selecciona lo que es importante para ti.</p>

      <div class="field">
        <label>Tipo de habitación</label>
        <div class="choice-grid cols-3">
          ${[
            { id: 'single', name: 'Individual' },
            { id: 'family', name: 'Casa familia' },
            { id: 'apartment', name: 'Departamento' },
            { id: 'residence', name: 'Residencia' },
          ].map(t => `
            <div class="choice-card ${state.data.roomType === t.id ? 'selected' : ''}" onclick="OnboardingSel.set('roomType', '${t.id}')">
              <div class="name">${t.name}</div>
            </div>
          `).join('')}
        </div>
      </div>

      <div class="field">
        <label>Servicios importantes</label>
        <div class="row wrap gap-2">
          ${amenities.map(a => `
            <div class="chip ${state.data.amenities.includes(a.id) ? 'chip-primary' : ''}" style="cursor:pointer;padding:8px 14px;font-size:14px;" onclick="OnboardingSel.toggleAmenity('${a.id}')">
              ${Icons[a.icon] ? `<span style="width:16px;height:16px;display:inline-flex">${Icons[a.icon]}</span>` : ''}
              ${a.name}
              ${state.data.amenities.includes(a.id) ? Icons.check : ''}
            </div>
          `).join('')}
        </div>
      </div>

      <div class="field">
        <label>Preferencia de género</label>
        <div class="choice-grid cols-3">
          ${[
            { id: 'any', name: 'Cualquiera' },
            { id: 'female', name: 'Solo mujeres' },
            { id: 'male', name: 'Solo hombres' },
          ].map(g => `
            <div class="choice-card ${state.data.genderPreference === g.id ? 'selected' : ''}" onclick="OnboardingSel.set('genderPreference', '${g.id}')">
              <div class="name">${g.name}</div>
            </div>
          `).join('')}
        </div>
      </div>

      ${navButtons()}
    `;
  }

  function renderOwnerVerification() {
    return `
      <h2>Documentos que necesitarás</h2>
      <p class="hint">Para verificar tu propiedad y aumentar tu Trust Score.</p>

      <div class="card card-pad mb-4">
        <div class="fw-bold mb-3">Documentos obligatorios</div>
        ${['DNI del propietario', 'Título de propiedad o contrato vigente', 'Comprobante de predio al día', 'Fotos del inmueble (mínimo 4)'].map(d => `
          <div class="checklist-item">
            <div class="check-icon">${Icons.check}</div>
            <div>
              <div class="ci-title">${d}</div>
            </div>
          </div>
        `).join('')}
      </div>

      <div class="card card-pad" style="background:var(--c-success-50);border-color:transparent;">
        <div class="row gap-3" style="align-items:flex-start;">
          <div style="color:var(--c-success);">${Icons.sparkles}</div>
          <div>
            <div class="fw-bold" style="color:var(--c-success-600);">Beneficios de la verificación</div>
            <p class="fs-sm text-2 mt-1">Propiedades verificadas reciben 3x más solicitudes y pueden cobrar hasta 18% más.</p>
          </div>
        </div>
      </div>

      ${navButtons()}
    `;
  }

  function renderLifestyle() {
    return `
      <h2>Tu estilo de vida</h2>
      <p class="hint">Para matchear con compañeros compatibles.</p>

      <div class="card card-pad-lg mb-4">
        <div class="between mb-2">
          <span class="fw-semibold">Soy una persona tranquila</span>
          <span class="fw-semibold">Soy muy social</span>
        </div>
        <input type="range" min="0" max="100" value="${state.data.social}" class="range-slider" oninput="OnboardingSel.set('social', this.value)">
      </div>

      <div class="card card-pad-lg mb-4">
        <div class="between mb-2">
          <span class="fw-semibold">Relajado con limpieza</span>
          <span class="fw-semibold">Muy ordenado</span>
        </div>
        <input type="range" min="0" max="100" value="${state.data.cleanliness}" class="range-slider" oninput="OnboardingSel.set('cleanliness', this.value)">
      </div>

      <div class="field">
        <label>Horario de sueño</label>
        <div class="choice-grid cols-3">
          ${[
            { id: 'early', name: 'Temprano (10pm)' },
            { id: 'flexible', name: 'Flexible' },
            { id: 'late', name: 'Tarde (1am+)' },
          ].map(s => `
            <div class="choice-card ${state.data.sleepSchedule === s.id ? 'selected' : ''}" onclick="OnboardingSel.set('sleepSchedule', '${s.id}')">
              <div class="name">${s.name}</div>
            </div>
          `).join('')}
        </div>
      </div>

      <div class="row gap-4 mt-4">
        <label class="check">
          <input type="checkbox" ${state.data.smoke ? 'checked' : ''} onchange="OnboardingSel.set('smoke', this.checked)">
          <span class="box"></span>
          <span>Fumo ocasionalmente</span>
        </label>
        <label class="check">
          <input type="checkbox" ${state.data.pets ? 'checked' : ''} onchange="OnboardingSel.set('pets', this.checked)">
          <span class="box"></span>
          <span>Tengo mascota</span>
        </label>
      </div>

      ${navButtons()}
    `;
  }

  function renderDone() {
    return `
      <div class="text-center">
        <div style="width:96px;height:96px;background:var(--c-success-50);color:var(--c-success);border-radius:50%;display:inline-flex;align-items:center;justify-content:center;margin-bottom:var(--sp-4);animation:scale-in 0.6s cubic-bezier(0.34,1.56,0.64,1) both;">
          <div style="width:48px;height:48px;">${Icons.checkCircle}</div>
        </div>
        <h2 style="font-size:var(--fs-3xl);margin-bottom:var(--sp-2);">¡Todo listo!</h2>
        <p class="text-2" style="max-width:380px;margin:0 auto var(--sp-6);">Tu perfil está completo. Ahora puedes buscar tu wasi ideal con toda la confianza.</p>

        <div class="card card-pad-lg text-left" style="background:var(--c-surface-2);">
          <div class="fw-bold mb-3">Tu resumen</div>
          <div class="row between mb-2"><span class="text-2 fs-sm">Rol</span><span class="fw-semibold">${state.data.role === 'student' ? 'Estudiante' : 'Propietario'}</span></div>
          ${state.data.role === 'student' ? `
            <div class="row between mb-2"><span class="text-2 fs-sm">Universidad</span><span class="fw-semibold">${Seed.UNIVERSITIES.find(u => u.id === state.data.university)?.short || '—'}</span></div>
            <div class="row between mb-2"><span class="text-2 fs-sm">Presupuesto</span><span class="fw-semibold">S/ ${state.data.budgetMin} – S/ ${state.data.budgetMax}</span></div>
            <div class="row between"><span class="text-2 fs-sm">Tipo</span><span class="fw-semibold">${state.data.roomType}</span></div>
          ` : `
            <div class="row between"><span class="text-2 fs-sm">Acción</span><span class="fw-semibold">Publicar y verificar</span></div>
          `}
        </div>

        <button class="btn btn-primary btn-lg btn-block mt-6" onclick="OnboardingSvc.next()">
          ${state.data.role === 'student' ? 'Explorar habitaciones' : 'Ir a mi panel'}
          ${Icons.arrowRight}
        </button>
      </div>
    `;
  }

  function navButtons() {
    return `
      <div class="row gap-3 mt-6">
        ${state.step > 0 ? `<button class="btn btn-ghost" onclick="OnboardingSvc.prev()">${Icons.arrowLeft} Atrás</button>` : ''}
        <button class="btn btn-primary grow" onclick="OnboardingSvc.next()">
          ${state.step === STEPS.length - 1 ? 'Finalizar' : 'Continuar'}
          ${Icons.arrowRight}
        </button>
      </div>
    `;
  }

  function attachHandlers() {
    // Animación de entrada
    const form = document.getElementById('onboard-form');
    if (form) {
      form.classList.remove('anim-up');
      void form.offsetWidth;
      form.classList.add('anim-up');
    }
  }

  return { start, next, prev, set, rerender, state: () => state };
})();

window.OnboardingSvc = OnboardingSvc;

// Handlers globales para selects del onboarding
window.OnboardingSel = {
  role: (v) => {
    OnboardingSvc.set('role', v);
    OnboardingSvc.rerender();
    // Avanzar automáticamente al siguiente paso tras 300ms (dar feedback visual)
    setTimeout(() => OnboardingSvc.next(), 400);
  },
  uni: (v) => { OnboardingSvc.set('university', v); OnboardingSvc.rerender(); },
  budget: (type, v) => {
    if (type === 'min') OnboardingSvc.set('budgetMin', parseInt(v));
    else OnboardingSvc.set('budgetMax', parseInt(v));
    OnboardingSvc.rerender();
  },
  set: (field, value) => {
    OnboardingSvc.set(field, value);
    OnboardingSvc.rerender();
  },
  toggleAmenity: (id) => {
    const arr = OnboardingSvc.state().data.amenities;
    const idx = arr.indexOf(id);
    if (idx >= 0) arr.splice(idx, 1);
    else arr.push(id);
    OnboardingSvc.rerender();
  },
};
