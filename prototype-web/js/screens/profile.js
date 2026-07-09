/* ============================================================
   WasiStudent — Screen: Profile
   ============================================================ */

const ProfileScreen = (function() {

  function render() {
    UI.setTitle('Perfil');
    const user = Auth.current();

    UI.render(`
      <div class="mb-6">
        <h1 style="font-size:var(--fs-2xl);font-weight:var(--fw-extrabold);margin-bottom:var(--sp-2);">Mi perfil</h1>
        <p class="text-2">Tu información personal y de confianza en WasiStudent.</p>
      </div>

      <div class="detail-grid">
        <div class="detail-main">
          <!-- Profile header -->
          <div class="card card-pad-lg mb-4">
            <div class="row gap-4" style="align-items:flex-start;">
              <div class="avatar xl">${user.name.charAt(0)}</div>
              <div class="grow">
                <div class="row gap-2 between wrap">
                  <div>
                    <h2 style="font-size:var(--fs-xl);font-weight:var(--fw-extrabold);margin-bottom:4px;">${user.name}</h2>
                    <div class="text-2 fs-sm mb-2">${user.email}</div>
                    <div class="row gap-2 wrap">
                      <span class="chip chip-primary">${user.role === 'student' ? Icons.graduation : Icons.building} ${user.role === 'student' ? 'Estudiante' : 'Propietario'}</span>
                      <span class="verified">Verificado</span>
                      ${user.university ? `<span class="chip">${Seed.UNIVERSITIES.find(u => u.id === user.university)?.short || user.university}</span>` : ''}
                    </div>
                  </div>
                  <button class="btn btn-ghost btn-sm" onclick="ProfileScreen.edit()">${Icons.edit} Editar perfil</button>
                </div>
              </div>
            </div>
          </div>

          <!-- Personal info -->
          <div class="card card-pad-lg mb-4">
            <h3 style="margin-bottom:var(--sp-4);">Información personal</h3>
            <div class="row gap-4 wrap">
              <div class="grow">
                <div class="text-2 fs-sm">Nombre completo</div>
                <div class="fw-semibold">${user.name}</div>
              </div>
              <div class="grow">
                <div class="text-2 fs-sm">Correo</div>
                <div class="fw-semibold">${user.email}</div>
              </div>
              <div class="grow">
                <div class="text-2 fs-sm">Teléfono</div>
                <div class="fw-semibold">${user.phone || '—'}</div>
              </div>
              <div class="grow">
                <div class="text-2 fs-sm">Universidad</div>
                <div class="fw-semibold">${Seed.UNIVERSITIES.find(u => u.id === user.university)?.short || '—'}</div>
              </div>
              <div class="grow">
                <div class="text-2 fs-sm">Rol</div>
                <div class="fw-semibold">${user.role === 'student' ? 'Estudiante' : 'Propietario'}</div>
              </div>
              <div class="grow">
                <div class="text-2 fs-sm">Miembro desde</div>
                <div class="fw-semibold">${new Date(user.createdAt || Date.now()).toLocaleDateString('es-PE')}</div>
              </div>
            </div>
          </div>

          ${user.preferences ? `
            <div class="card card-pad-lg mb-4">
              <div class="row between mb-4">
                <h3 style="margin:0;">Tus preferencias</h3>
                <button class="btn btn-text btn-sm" onclick="OnboardingSvc.start()">${Icons.edit} Actualizar</button>
              </div>
              <div class="row gap-4 wrap">
                <div><div class="text-2 fs-sm">Presupuesto</div><div class="fw-semibold">S/ ${user.preferences.budgetMin} – S/ ${user.preferences.budgetMax}</div></div>
                <div><div class="text-2 fs-sm">Tipo preferido</div><div class="fw-semibold">${user.preferences.roomType}</div></div>
                <div><div class="text-2 fs-sm">Servicios</div><div class="fw-semibold">${user.preferences.amenities.length} seleccionados</div></div>
              </div>
            </div>
          ` : ''}

          <!-- Activity -->
          <div class="card card-pad-lg">
            <h3 style="margin-bottom:var(--sp-4);">Actividad reciente</h3>
            <div class="notif-row" style="border:1px solid var(--c-outline-soft);border-radius:var(--r-sm);margin-bottom:8px;">
              <div class="icon" style="background:var(--c-success-50);color:var(--c-success);">${Icons.checkCircle}</div>
              <div class="grow">
                <div class="title">Completaste tu perfil</div>
                <div class="desc">Onboarding finalizado</div>
              </div>
              <div class="time">Hoy</div>
            </div>
            <div class="notif-row" style="border:1px solid var(--c-outline-soft);border-radius:var(--r-sm);margin-bottom:8px;">
              <div class="icon" style="background:var(--c-info-bg);color:var(--c-info);">${Icons.file}</div>
              <div class="grow">
                <div class="title">Contrato firmado</div>
                <div class="desc">Habitación luminosa cerca de UNSAAC</div>
              </div>
              <div class="time">Ayer</div>
            </div>
            <div class="notif-row" style="border:1px solid var(--c-outline-soft);border-radius:var(--r-sm);">
              <div class="icon" style="background:var(--c-accent-soft);color:#8B6914;">${Icons.heart}</div>
              <div class="grow">
                <div class="title">Agregaste a favoritos</div>
                <div class="desc">3 habitaciones</div>
              </div>
              <div class="time">Hace 3 días</div>
            </div>
          </div>
        </div>

        <div class="detail-side">
          <div class="card card-pad-lg text-center">
            <div class="text-2 fs-sm mb-3">Tu Trust Score</div>
            ${TrustRing.render(user.trustScore || 65, { size: 120, stroke: 10 })}
            <p class="text-2 fs-sm mt-3">${(user.trustScore || 65) >= 75 ? 'Confianza alta' : 'Sigue mejorando'}</p>
            <button class="btn btn-soft btn-block mt-4" onclick="UI.nav('trust')">${Icons.shieldCheck} Ver detalles</button>
          </div>

          <div class="card card-pad-lg">
            <h3 style="margin-bottom:var(--sp-3);font-size:var(--fs-md);">Verificación</h3>
            <div class="checklist-item" style="border:none;padding:6px 0;">
              <div class="check-icon">${Icons.check}</div>
              <div><div class="ci-title">Correo verificado</div></div>
            </div>
            <div class="checklist-item" style="border:none;padding:6px 0;">
              <div class="check-icon">${Icons.check}</div>
              <div><div class="ci-title">Teléfono verificado</div></div>
            </div>
            <div class="checklist-item" style="border:none;padding:6px 0;">
              <div class="check-icon">${Icons.check}</div>
              <div><div class="ci-title">Identidad verificada</div></div>
            </div>
            <div class="checklist-item" style="border:none;padding:6px 0;">
              <div class="check-icon unchecked">${Icons.clock}</div>
              <div><div class="ci-title text-3">Ingreso universitario</div></div>
            </div>
            <div class="checklist-item" style="border:none;padding:6px 0;">
              <div class="check-icon unchecked">${Icons.clock}</div>
              <div><div class="ci-title text-3">Referencia de propietario</div></div>
            </div>
          </div>

          <button class="btn btn-ghost btn-block" style="color:var(--c-error);" onclick="ProfileScreen.logout()">${Icons.logout} Cerrar sesión</button>
        </div>
      </div>
    `);
  }

  function edit() {
    const user = Auth.current();
    UI.modal({
      title: 'Editar perfil',
      body: `
        ${Forms.text('edit-name', 'Tu nombre', user.name, { label: 'Nombre' })}
        ${Forms.email('edit-email', 'correo@ejemplo.com', user.email, { label: 'Correo' })}
        ${Forms.text('edit-phone', '+51 984 000 000', user.phone || '', { label: 'Teléfono' })}
        ${Forms.select('edit-uni', Seed.UNIVERSITIES.map(u => ({ value: u.id, label: u.short })), user.university, { label: 'Universidad' })}
      `,
      footer: `
        <button class="btn btn-ghost" onclick="UI.closeModal()">Cancelar</button>
        <button class="btn btn-primary" onclick="ProfileScreen.save()">${Icons.check} Guardar cambios</button>
      `
    });
  }

  function save() {
    const updates = {
      name: Forms.val('edit-name'),
      email: Forms.val('edit-email'),
      phone: Forms.val('edit-phone'),
      university: Forms.val('edit-uni'),
    };
    Auth.updateProfile(updates);
    UI.closeModal();
    UI.toast({ title: 'Perfil actualizado', type: 'success' });
    render();
  }

  function logout() {
    UI.confirm({
      title: 'Cerrar sesión',
      message: '¿Seguro que quieres salir?',
      confirmText: 'Cerrar sesión',
      onConfirm: () => Auth.logout()
    });
  }

  return { render, edit, save, logout };
})();

window.ProfileScreen = ProfileScreen;
