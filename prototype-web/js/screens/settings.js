const Settings = {
  render() {
    let html = '<div class="stl" style="padding-left:0">Rol de usuario</div>';
    if (!state.ownerEnabled) {
      html += '<div class="card" style="cursor:pointer" onclick="Settings.enableOwner()"><div style="display:flex;align-items:center;gap:10px"><div style="width:36px;height:36px;background:var(--pri-t);border-radius:10px;display:flex;align-items:center;justify-content:center;color:var(--pri)">' + I.home + '</div><div><div style="font-size:13px;font-weight:700">Convertirme en propietaria</div><div style="font-size:11px;color:var(--txt3)">Publica cuartos y recibe solicitudes</div></div></div></div>';
    } else {
      html += '<div class="card" style="cursor:pointer" onclick="go(\'scr-owner\')"><div style="display:flex;align-items:center;gap:10px"><div style="width:36px;height:36px;background:var(--pri-t);border-radius:10px;display:flex;align-items:center;justify-content:center;color:var(--pri)">' + I.home + '</div><div><div style="font-size:13px;font-weight:700">Panel de propietaria</div></div></div></div>';
      html += '<div class="toggle" onclick="Settings.switchRole()"><div class="tl"><div><div class="tt">Cambiar rol</div><div class="ts">Actual: ' + (state.role === 'owner' ? 'Propietaria' : 'Estudiante') + '</div></div></div><div class="sw ' + (state.role === 'owner' ? 'on' : '') + '"></div></div>';
      html += '<div class="card" style="cursor:pointer" onclick="Settings.disableOwner()"><div style="font-size:13px;color:var(--err)">Desactivar cuenta de propietaria</div></div>';
    }
    html += '<div class="stl" style="padding-left:0">Cuenta</div><div class="card" style="cursor:pointer" onclick="alert(\'Próximamente\')">Cambiar contraseña</div>';
    html += '<div class="stl" style="padding-left:0">Acerca de</div><div class="card"><div style="font-size:13px;color:var(--txt2)">Versión 13.0.0</div></div>';
    document.getElementById('settings-content').innerHTML = html;
  },
  enableOwner() { state.ownerEnabled = true; state.role = 'owner'; go('scr-owner'); },
  disableOwner() { state.ownerEnabled = false; state.role = 'student'; go('scr-settings'); },
  switchRole() { state.role = state.role === 'owner' ? 'student' : 'owner'; if (state.role === 'owner') go('scr-owner'); else Settings.render(); }
};
