// ═══ NAVIGATION ═══
const navScreens = ['scr-home', 'scr-explore', 'scr-discover', 'scr-messages', 'scr-profile'];

function go(id) {
  document.querySelectorAll('.scr').forEach(s => s.classList.remove('on'));
  const el = document.getElementById(id);
  if (el) el.classList.add('on');
  state.history.push(id);

  const showNav = navScreens.includes(id) || id === 'scr-home';
  document.getElementById('bnav').style.display = showNav ? 'flex' : 'none';

  document.querySelectorAll('.ni').forEach(n => n.classList.remove('act'));
  if (id === 'scr-home') document.getElementById('nav-home')?.classList.add('act');
  else if (id === 'scr-explore') document.getElementById('nav-explore')?.classList.add('act');
  else if (id === 'scr-discover') document.getElementById('nav-discover')?.classList.add('act');
  else if (id === 'scr-messages') document.getElementById('nav-messages')?.classList.add('act');
  else if (id === 'scr-profile') document.getElementById('nav-profile')?.classList.add('act');

  if (id === 'scr-home') Home.render();
  if (id === 'scr-explore') Explore.render();
  if (id === 'scr-discover') Discover.render();
  if (id === 'scr-messages') Messages.render();
  if (id === 'scr-profile') Profile.render();
  if (id === 'scr-owner') Owner.render();
  if (id === 'scr-owner-rooms') Owner.renderRooms();
  if (id === 'scr-owner-requests') Owner.renderRequests();
  if (id === 'scr-owner-contracts') Owner.renderContracts();
  if (id === 'scr-owner-payments') Owner.renderPayments();
  if (id === 'scr-settings') Settings.render();
  if (id === 'scr-trust') Trust.render();
  if (id === 'scr-favorites') Favorites.render();
  if (id === 'scr-payments') Payments.render();
  if (id === 'scr-map') MapScreen.render();
  if (id === 'scr-reviews') Reviews.render();

  window.scrollTo(0, 0);
}

function goBack() {
  state.history.pop();
  const prev = state.history[state.history.length - 1] || 'scr-home';
  state.history.pop();
  go(prev);
}

function navTo(id) { state.history = [id]; go(id); }
