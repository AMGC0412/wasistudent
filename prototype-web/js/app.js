/* ============================================================
   WasiStudent — App Bootstrap
   ============================================================ */

const App = (function() {

  function init() {
    // Inicializar datos seed
    Seed.ensureSeed();

    // Ocultar loading screen
    setTimeout(() => {
      const ls = document.getElementById('loading-screen');
      if (ls) ls.classList.add('hidden');

      // Decidir pantalla inicial
      const user = Auth.current();
      if (!user) {
        AuthScreen.render();
      } else if (!user.onboarding) {
        OnboardingSvc.start();
      } else {
        start();
      }
    }, 1200);
  }

  function start() {
    const user = Auth.current();
    if (!user) {
      AuthScreen.render();
      return;
    }

    // Renderizar shell
    const root = document.getElementById('app-root');
    root.innerHTML = UI.renderShell(user);

    // Registrar rutas
    registerRoutes();

    // Ir a pantalla inicial según rol
    if (user.role === 'owner') {
      Router.go('ownerDashboard');
    } else {
      Router.go('home');
    }
  }

  function registerRoutes() {
    // Estudiante
    Router.register('home', () => HomeScreen.render());
    Router.register('discover', () => Discover.render());
    Router.register('detail', (p) => DetailScreen.render(p));
    Router.register('trust', () => TrustScreen.render());
    Router.register('contract', (p) => ContractScreen.render(p));
    Router.register('favorites', () => FavoritesScreen.render());
    Router.register('messages', (p) => MessagesScreen.render(p));
    Router.register('payments', () => PaymentsScreen.render());
    Router.register('reviews', () => ReviewsScreen.render());
    Router.register('profile', () => ProfileScreen.render());
    Router.register('settings', () => SettingsScreen.render());
    Router.register('notifications', () => {
      UI.setTitle('Notificaciones');
      const user = Auth.current();
      const notifs = Store.get('wasi_notifs', Seed.NOTIFICATIONS_SEED).filter(n => n.userId === user.id || !n.userId);
      UI.render(`
        <div class="mb-6">
          <h1 style="font-size:var(--fs-2xl);font-weight:var(--fw-extrabold);margin-bottom:var(--sp-2);">Notificaciones</h1>
          <p class="text-2">${notifs.filter(n => !n.read).length} sin leer</p>
        </div>
        <div class="card card-pad-lg">
          ${notifs.length === 0 ? `
            <div class="empty-state"><div class="icon-circle">${Icons.bell}</div><h3>Sin notificaciones</h3></div>
          ` : notifs.map(n => {
            const iconMap = { check: Icons.checkCircle, file: Icons.file, bell: Icons.bell };
            const colorMap = { success: 'var(--c-success)', info: 'var(--c-info)', warning: 'var(--c-warning)' };
            return `
              <div class="notif-row ${n.read ? '' : 'unread'}" onclick="this.classList.remove('unread')">
                <div class="icon" style="background:${n.type === 'success' ? 'var(--c-success-50)' : 'var(--c-info-bg)'};color:${colorMap[n.type] || 'var(--c-info)'};">${iconMap[n.icon] || Icons.bell}</div>
                <div class="grow">
                  <div class="title">${n.title}</div>
                  <div class="desc">${n.desc}</div>
                </div>
                <div class="time">${n.time}</div>
              </div>
            `;
          }).join('')}
        </div>
      `);
    });

    // Propietario
    Router.register('ownerDashboard', () => OwnerDashboard.render());
    Router.register('ownerRooms', () => OwnerRooms.render());
    Router.register('ownerRequests', () => OwnerRequests.render());
    Router.register('ownerContracts', () => OwnerContracts.render());
    Router.register('ownerPayments', () => OwnerPayments.render());
  }

  return { init, start };
})();

window.App = App;

// Auto-inicializar al cargar
document.addEventListener('DOMContentLoaded', App.init);
