/* ============================================================
   WasiStudent — UI helpers (toast, modal, render, etc)
   ============================================================ */

const UI = (function() {

  // ── Renderizar layout principal con sidebar + bottom nav ──
  function renderShell(user) {
    const isOwner = user.role === 'owner';
    const navItems = isOwner ? ownerNavItems() : studentNavItems();

    return `
      <div class="app-shell">
        <!-- Backdrop mobile -->
        <div class="sidebar-backdrop" id="sidebar-backdrop" onclick="UI.toggleSidebar(false)"></div>

        <!-- Sidebar -->
        <aside class="sidebar" id="sidebar">
          <div class="sidebar-head">
            <div class="logo">W</div>
            <div class="brand">WasiStudent<span class="sub">${isOwner ? 'Propietario' : 'Estudiante'}</span></div>
          </div>
          <nav class="sidebar-nav">
            ${navItems.map(section => `
              <div class="sidebar-section">
                ${section.label ? `<div class="label">${section.label}</div>` : ''}
                ${section.items.map(item => `
                  <div class="nav-item ${item.active ? 'active' : ''}" data-nav="${item.route}" onclick="UI.nav('${item.route}')">
                    ${Icons[item.icon] || ''}
                    <span>${item.label}</span>
                    ${item.badge ? `<span class="badge-num">${item.badge}</span>` : ''}
                  </div>
                `).join('')}
              </div>
            `).join('')}
          </nav>
          <div class="sidebar-foot">
            <div class="sidebar-user" onclick="UI.nav('profile')">
              <div class="avatar sm">${(user.name || 'U').charAt(0).toUpperCase()}</div>
              <div class="grow">
                <div class="name truncate">${user.name || 'Usuario'}</div>
                <div class="role">${user.email || ''}</div>
              </div>
              ${Icons.chevronRight}
            </div>
          </div>
        </aside>

        <!-- Main -->
        <div class="main">
          <!-- Mobile header -->
          <header class="mobile-header">
            <button class="btn-icon" onclick="UI.toggleSidebar(true)">${Icons.menu}</button>
            <div class="row gap-2">
              <div class="logo" style="width:28px;height:28px;font-size:14px;border-radius:8px;">W</div>
              <span class="brand">WasiStudent</span>
            </div>
            <button class="btn-icon" onclick="UI.nav('notifications')">${Icons.bell}</button>
          </header>

          <!-- Topbar desktop -->
          <header class="topbar">
            <div class="page-title" id="page-title">Inicio</div>
            <div class="search-mini">
              <div class="input-group">
                <span class="prefix">${Icons.search}</span>
                <input type="text" class="input" placeholder="Buscar habitaciones, propietarios..." id="topbar-search">
              </div>
            </div>
            <div class="topbar-actions">
              <button class="btn-icon" onclick="UI.nav('notifications')" data-tooltip="Notificaciones">${Icons.bell}</button>
              <button class="btn btn-soft btn-sm" onclick="UI.nav('profile')">
                <div class="avatar sm" style="width:24px;height:24px;font-size:11px;">${(user.name || 'U').charAt(0).toUpperCase()}</div>
                <span>${(user.name || 'Usuario').split(' ')[0]}</span>
              </button>
            </div>
          </header>

          <main class="content-area" id="content-area"></main>
        </div>
      </div>

      <!-- Bottom nav (mobile) -->
      <nav class="bottom-nav">
        <div class="bottom-nav-items">
          ${navItems[0].items.slice(0, 5).map(item => `
            <div class="bn-item ${item.active ? 'active' : ''}" data-nav="${item.route}" onclick="UI.nav('${item.route}')">
              ${Icons[item.icon] || ''}
              <span>${item.label.split(' ')[0]}</span>
              ${item.badge ? `<span class="badge-num">${item.badge}</span>` : ''}
            </div>
          `).join('')}
        </div>
      </nav>
    `;
  }

  function studentNavItems() {
    const favCount = Store.get(Store.KEYS.FAVORITES, []).length;
    return [
      { label: '', items: [
        { route: 'home', label: 'Inicio', icon: 'home' },
        { route: 'discover', label: 'Descubrir', icon: 'search' },
        { route: 'favorites', label: 'Favoritos', icon: 'heart', badge: favCount > 0 ? favCount : '' },
        { route: 'messages', label: 'Mensajes', icon: 'chat', badge: 1 },
      ]},
      { label: 'Confianza', items: [
        { route: 'trust', label: 'Trust Score', icon: 'shieldCheck' },
        { route: 'contract', label: 'Contrato', icon: 'fileCheck' },
        { route: 'payments', label: 'Pagos', icon: 'dollar' },
      ]},
      { label: 'Cuenta', items: [
        { route: 'reviews', label: 'Reseñas', icon: 'star' },
        { route: 'profile', label: 'Perfil', icon: 'user' },
        { route: 'settings', label: 'Configuración', icon: 'settings' },
      ]},
    ];
  }

  function ownerNavItems() {
    const reqCount = Store.get('wasi_requests_seed', []).filter(r => r.status === 'pending').length;
    return [
      { label: '', items: [
        { route: 'ownerDashboard', label: 'Dashboard', icon: 'home' },
        { route: 'ownerRooms', label: 'Mis habitaciones', icon: 'building' },
        { route: 'ownerRequests', label: 'Solicitudes', icon: 'bell', badge: reqCount > 0 ? reqCount : '' },
        { route: 'ownerContracts', label: 'Contratos', icon: 'fileCheck' },
      ]},
      { label: 'Gestión', items: [
        { route: 'ownerPayments', label: 'Pagos', icon: 'dollar' },
        { route: 'messages', label: 'Mensajes', icon: 'chat' },
      ]},
      { label: 'Cuenta', items: [
        { route: 'profile', label: 'Perfil', icon: 'user' },
        { route: 'settings', label: 'Configuración', icon: 'settings' },
      ]},
    ];
  }

  // ── Navegación ─────────────────────────────────────────────
  function nav(route, params) {
    // Cerrar sidebar en mobile
    toggleSidebar(false);
    // Scroll top
    document.getElementById('content-area')?.scrollTo({ top: 0, behavior: 'smooth' });
    Router.go(route, params);
  }

  // ── Sidebar toggle (mobile) ────────────────────────────────
  function toggleSidebar(open) {
    const sb = document.getElementById('sidebar');
    const bd = document.getElementById('sidebar-backdrop');
    if (open) { sb.classList.add('open'); bd.classList.add('show'); }
    else { sb.classList.remove('open'); bd.classList.remove('show'); }
  }

  // ── Set page title ─────────────────────────────────────────
  function setTitle(title) {
    const el = document.getElementById('page-title');
    if (el) el.textContent = title;
    document.title = title + ' · WasiStudent';
  }

  // ── Render screen content ──────────────────────────────────
  function render(html) {
    const area = document.getElementById('content-area');
    if (area) {
      area.innerHTML = html;
      // Reiniciar animación de pantallas
      area.classList.remove('anim-fade');
      void area.offsetWidth;
      area.classList.add('anim-fade');
    }
  }

  // ── Toast ──────────────────────────────────────────────────
  function toast(opts) {
    const { title = '', desc = '', type = 'info', duration = 3500 } = typeof opts === 'string' ? { title: opts } : opts;
    const container = document.getElementById('toast-container');
    if (!container) return;

    const iconMap = { success: Icons.checkCircle, error: Icons.alert, warning: Icons.alert, info: Icons.info };
    const colorMap = { success: 'var(--c-success)', error: 'var(--c-error)', warning: 'var(--c-warning)', info: 'var(--c-info)' };

    const toast = document.createElement('div');
    toast.className = 'toast ' + type;
    toast.innerHTML = `
      <div class="icon" style="color:${colorMap[type]}">${iconMap[type] || Icons.info}</div>
      <div class="body">
        ${title ? `<div class="title">${title}</div>` : ''}
        ${desc ? `<div class="desc">${desc}</div>` : ''}
      </div>
    `;
    container.appendChild(toast);

    setTimeout(() => {
      toast.classList.add('removing');
      setTimeout(() => toast.remove(), 300);
    }, duration);
  }

  // ── Modal ──────────────────────────────────────────────────
  function modal(opts) {
    const { title = '', body = '', footer = '', size = 'md', onClose } = opts;
    const mount = document.getElementById('modal-mount');
    if (!mount) return;

    const overlay = document.createElement('div');
    overlay.className = 'modal-overlay';
    overlay.innerHTML = `
      <div class="modal" style="${size === 'lg' ? 'max-width:720px;' : size === 'sm' ? 'max-width:400px;' : ''}">
        <div class="modal-head">
          <h3>${title}</h3>
          <button class="btn-icon" onclick="this.closest('.modal-overlay').remove()">${Icons.x}</button>
        </div>
        <div class="modal-body">${body}</div>
        ${footer ? `<div class="modal-foot">${footer}</div>` : ''}
      </div>
    `;
    overlay.addEventListener('click', e => {
      if (e.target === overlay) {
        overlay.remove();
        if (onClose) onClose();
      }
    });
    mount.appendChild(overlay);
    return overlay;
  }

  function closeModal() {
    const overlay = document.querySelector('.modal-overlay');
    if (overlay) overlay.remove();
  }

  // ── Confirm ────────────────────────────────────────────────
  function confirm(opts) {
    const { title = 'Confirmar', message = '¿Estás seguro?', confirmText = 'Confirmar', cancelText = 'Cancelar', onConfirm, danger = false } = opts;
    return modal({
      title,
      size: 'sm',
      body: `<p style="color:var(--c-text-2)">${message}</p>`,
      footer: `
        <button class="btn btn-ghost" onclick="UI.closeModal()">${cancelText}</button>
        <button class="btn ${danger ? 'btn-primary' : 'btn-primary'}" onclick="(${onConfirm})(); UI.closeModal()">${confirmText}</button>
      `
    });
  }

  // ── Skeleton helpers ───────────────────────────────────────
  function skeletonRooms(count = 6) {
    return Array.from({ length: count }).map(() => `
      <div class="room-card">
        <div class="skeleton skeleton-block" style="height:200px;border-radius:0;"></div>
        <div class="body" style="padding:16px;">
          <div class="skeleton skeleton-text lg" style="width:80%"></div>
          <div class="skeleton skeleton-text sm" style="width:50%"></div>
          <div class="skeleton skeleton-text" style="width:60%;margin-top:12px"></div>
        </div>
      </div>
    `).join('');
  }

  // ── Format helpers ─────────────────────────────────────────
  function formatPrice(amount, currency = 'PEN') {
    const symbol = currency === 'PEN' ? 'S/' : currency === 'USD' ? '$' : currency;
    return `${symbol} ${amount.toLocaleString('es-PE')}`;
  }

  function timeAgo(date) {
    const diff = Date.now() - new Date(date).getTime();
    const mins = Math.floor(diff / 60000);
    if (mins < 1) return 'Ahora';
    if (mins < 60) return `Hace ${mins} min`;
    const hours = Math.floor(mins / 60);
    if (hours < 24) return `Hace ${hours} h`;
    const days = Math.floor(hours / 24);
    if (days < 7) return `Hace ${days} d`;
    return new Date(date).toLocaleDateString('es-PE');
  }

  // ── Stars renderer ─────────────────────────────────────────
  function stars(rating, size = 16) {
    let html = '<div class="stars" style="font-size:'+size+'px">';
    for (let i = 1; i <= 5; i++) {
      if (rating >= i) html += `<span style="display:inline-block;width:${size}px;height:${size}px">${Icons.star}</span>`;
      else if (rating >= i - 0.5) html += `<span style="display:inline-block;width:${size}px;height:${size}px;opacity:0.5">${Icons.star}</span>`;
      else html += `<span style="display:inline-block;width:${size}px;height:${size}px;color:var(--c-outline)">${Icons.starOutline}</span>`;
    }
    return html + '</div>';
  }

  // ── Ripple effect ──────────────────────────────────────────
  function attachRipple(el) {
    el.addEventListener('click', function(e) {
      const ripple = document.createElement('span');
      ripple.className = 'ripple';
      const rect = this.getBoundingClientRect();
      const size = Math.max(rect.width, rect.height);
      ripple.style.width = ripple.style.height = size + 'px';
      ripple.style.left = (e.clientX - rect.left - size / 2) + 'px';
      ripple.style.top = (e.clientY - rect.top - size / 2) + 'px';
      this.appendChild(ripple);
      setTimeout(() => ripple.remove(), 600);
    });
  }

  return {
    renderShell, nav, toggleSidebar, setTitle, render,
    toast, modal, closeModal, confirm,
    skeletonRooms, formatPrice, timeAgo, stars,
    attachRipple,
  };
})();

window.UI = UI;
