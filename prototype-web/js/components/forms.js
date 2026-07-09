/* ============================================================
   WasiStudent — Componente: Forms helpers
   ============================================================ */

const Forms = (function() {

  function field(label, input, opts = {}) {
    return `
      <div class="field">
        <label>${label} ${opts.required ? '<span style="color:var(--c-error);">*</span>' : ''}</label>
        ${input}
        ${opts.hint ? `<div class="hint">${opts.hint}</div>` : ''}
        ${opts.error ? `<div class="error-msg">${opts.error}</div>` : ''}
      </div>
    `;
  }

  function text(id, placeholder, value = '', opts = {}) {
    return field(opts.label || '', `<input type="text" class="input ${opts.error ? 'input-error' : ''}" id="${id}" placeholder="${placeholder}" value="${value}">`, opts);
  }

  function email(id, placeholder, value = '', opts = {}) {
    return field(opts.label || '', `<input type="email" class="input ${opts.error ? 'input-error' : ''}" id="${id}" placeholder="${placeholder}" value="${value}">`, opts);
  }

  function password(id, placeholder, opts = {}) {
    return field(opts.label || '', `<input type="password" class="input ${opts.error ? 'input-error' : ''}" id="${id}" placeholder="${placeholder}">`, opts);
  }

  function select(id, options, value = '', opts = {}) {
    return field(opts.label || '', `<select class="select" id="${id}">${options.map(o => `<option value="${o.value}" ${o.value === value ? 'selected' : ''}>${o.label}</option>`).join('')}</select>`, opts);
  }

  function textarea(id, placeholder, value = '', opts = {}) {
    return field(opts.label || '', `<textarea class="textarea" id="${id}" placeholder="${placeholder}" rows="${opts.rows || 4}">${value}</textarea>`, opts);
  }

  function number(id, placeholder, value = '', opts = {}) {
    return field(opts.label || '', `<input type="number" class="input" id="${id}" placeholder="${placeholder}" value="${value}" min="${opts.min || ''}" max="${opts.max || ''}" step="${opts.step || ''}">`, opts);
  }

  function val(id) {
    const el = document.getElementById(id);
    return el ? el.value.trim() : '';
  }

  function validateEmail(email) {
    return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email);
  }

  return { field, text, email, password, select, textarea, number, val, validateEmail };
})();

window.Forms = Forms;
