/* ============================================================
   WasiStudent — Screen: Settings
   ============================================================ */

const SettingsScreen = (function() {

  let settings = {
    notifMessages: true,
    notifRequests: true,
    notifPayments: true,
    notifMarketing: false,
    theme: 'light',
    language: 'es',
    privacy: 'verified-only',
  };

  function render() {
    UI.setTitle('Configuración');
    const user = Auth.current();

    UI.render(`
      <div class="mb-6">
        <h1 style="font-size:var(--fs-2xl);font-weight:var(--fw-extrabold);margin-bottom:var(--sp-2);">Configuración</h1>
        <p class="text-2">Personaliza tu experiencia en WasiStudent.</p>
      </div>

      <div class="detail-grid">
        <div class="detail-main">
          <!-- Notifications -->
          <div class="card card-pad-lg mb-4">
            <h3 style="margin-bottom:var(--sp-4);">Notificaciones</h3>
            <div class="row between mb-4">
              <div>
                <div class="fw-semibold">Mensajes</div>
                <div class="text-2 fs-sm">Recibir avisos cuando lleguen mensajes nuevos</div>
              </div>
              <label class="check"><input type="checkbox" ${settings.notifMessages ? 'checked' : ''} onchange="SettingsScreen.toggle('notifMessages', this.checked)"><span class="box"></span></label>
            </div>
            <div class="row between mb-4">
              <div>
                <div class="fw-semibold">Solicitudes</div>
                <div class="text-2 fs-sm">Avisos de solicitudes de visita o alquiler</div>
              </div>
              <label class="check"><input type="checkbox" ${settings.notifRequests ? 'checked' : ''} onchange="SettingsScreen.toggle('notifRequests', this.checked)"><span class="box"></span></label>
            </div>
            <div class="row between mb-4">
              <div>
                <div class="fw-semibold">Pagos</div>
                <div class="text-2 fs-sm">Recordatorios de pagos pendientes</div>
              </div>
              <label class="check"><input type="checkbox" ${settings.notifPayments ? 'checked' : ''} onchange="SettingsScreen.toggle('notifPayments', this.checked)"><span class="box"></span></label>
            </div>
            <div class="row between">
              <div>
                <div class="fw-semibold">Promociones</div>
                <div class="text-2 fs-sm">Ofertas y novedades de WasiStudent</div>
              </div>
              <label class="check"><input type="checkbox" ${settings.notifMarketing ? 'checked' : ''} onchange="SettingsScreen.toggle('notifMarketing', this.checked)"><span class="box"></span></label>
            </div>
          </div>

          <!-- Privacy -->
          <div class="card card-pad-lg mb-4">
            <h3 style="margin-bottom:var(--sp-4);">Privacidad</h3>
            <div class="field">
              <label>¿Quién puede ver tu perfil?</label>
              <select class="select" onchange="SettingsScreen.set('privacy', this.value)">
                <option value="public" ${settings.privacy === 'public' ? 'selected' : ''}>Todos</option>
                <option value="verified-only" ${settings.privacy === 'verified-only' ? 'selected' : ''}>Solo usuarios verificados</option>
                <option value="owners" ${settings.privacy === 'owners' ? 'selected' : ''}>Solo propietarios verificados</option>
              </select>
            </div>
            <div class="card" style="background:var(--c-info-bg);padding:var(--sp-4);border-color:transparent;">
              <div class="row gap-2" style="align-items:flex-start;">
                ${Icons.info}
                <div class="fs-sm text-2">Tu información de contacto nunca se muestra públicamente. Solo se comparte cuando inicias una conversación.</div>
              </div>
            </div>
          </div>

          <!-- About -->
          <div class="card card-pad-lg">
            <h3 style="margin-bottom:var(--sp-4);">Acerca de WasiStudent</h3>
            <div class="row between mb-3"><span class="text-2">Versión</span><span class="fw-semibold">5.0.0</span></div>
            <div class="row between mb-3"><span class="text-2">Última actualización</span><span class="fw-semibold">Julio 2026</span></div>
            <div class="row between mb-3"><span class="text-2">Términos legales</span><a class="link" style="color:var(--c-primary);" onclick="UI.toast({ title: 'Términos', desc: 'Documento completo disponible pronto' })">Ver</a></div>
            <div class="row between mb-3"><span class="text-2">Política de privacidad</span><a class="link" style="color:var(--c-primary);" onclick="UI.toast({ title: 'Privacidad', desc: 'Documento completo disponible pronto' })">Ver</a></div>
            <div class="row between"><span class="text-2">Soporte</span><a class="link" style="color:var(--c-primary);" onclick="UI.toast({ title: 'Soporte', desc: 'hola@wasistudent.pe' })">Contactar</a></div>
          </div>
        </div>

        <div class="detail-side">
          <!-- Quick actions -->
          <div class="card card-pad-lg">
            <h3 style="margin-bottom:var(--sp-3);font-size:var(--fs-md);">Acciones rápidas</h3>
            <button class="btn btn-ghost btn-block mb-2" onclick="OnboardingSvc.start()" style="justify-content:flex-start;">${Icons.refresh} Repetir onboarding</button>
            <button class="btn btn-ghost btn-block mb-2" onclick="UI.toast({ title: 'Datos descargados', type: 'success' })" style="justify-content:flex-start;">${Icons.file} Descargar mis datos</button>
            <button class="btn btn-ghost btn-block" style="justify-content:flex-start;color:var(--c-error);" onclick="UI.confirm({ title: 'Eliminar cuenta', message: 'Esta acción no se puede deshacer. Se perderán todos tus datos.', confirmText: 'Eliminar', danger: true, onConfirm: '() => Auth.logout()' })">${Icons.trash} Eliminar cuenta</button>
          </div>

          <div class="card card-pad-lg" style="background:var(--c-primary-50);border-color:transparent;">
            <div class="row gap-2 mb-2">
              ${Icons.sparkles}
              <div class="fw-bold" style="color:var(--c-primary-700);">¿Necesitas ayuda?</div>
            </div>
            <p class="fs-sm text-2 mb-3">Nuestro equipo está disponible 24/7 para resolver tus dudas.</p>
            <button class="btn btn-primary btn-block btn-sm">${Icons.chat} Contactar soporte</button>
          </div>
        </div>
      </div>
    `);
  }

  function toggle(key, value) {
    settings[key] = value;
    UI.toast({ title: value ? 'Activado' : 'Desactivado', type: 'info', duration: 1500 });
  }

  function set(key, value) {
    settings[key] = value;
  }

  return { render, toggle, set };
})();

window.SettingsScreen = SettingsScreen;
