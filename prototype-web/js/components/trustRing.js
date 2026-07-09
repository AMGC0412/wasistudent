/* ============================================================
   WasiStudent — Componente: Trust Ring (anillo animado)
   ============================================================ */

const TrustRing = (function() {

  function render(score, opts = {}) {
    const size = opts.size || 88;
    const stroke = opts.stroke || 8;
    const radius = (size - stroke) / 2;
    const circumference = 2 * Math.PI * radius;
    const offset = circumference - (score / 100) * circumference;

    let colorClass = 'success';
    if (score < 50) colorClass = 'danger';
    else if (score < 75) colorClass = 'warning';

    return `
      <div class="trust-ring ${colorClass}" style="width:${size}px;height:${size}px;">
        <svg width="${size}" height="${size}">
          <circle class="ring-bg" cx="${size/2}" cy="${size/2}" r="${radius}" stroke-width="${stroke}" fill="none"></circle>
          <circle class="ring-fg" cx="${size/2}" cy="${size/2}" r="${radius}" stroke-width="${stroke}" fill="none"
            stroke-dasharray="${circumference}"
            stroke-dashoffset="${offset}"
            style="transition: stroke-dashoffset 1.2s cubic-bezier(0.34,1.56,0.64,1);"></circle>
        </svg>
        <div class="ring-val">${score}</div>
      </div>
    `;
  }

  function renderWithLabel(score, opts = {}) {
    const label = opts.label || 'Trust Score';
    return `
      <div class="col center gap-2">
        ${render(score, opts)}
        <div class="text-center">
          <div class="fw-bold">${label}</div>
          ${opts.subtitle ? `<div class="text-3 fs-xs">${opts.subtitle}</div>` : ''}
        </div>
      </div>
    `;
  }

  return { render, renderWithLabel };
})();

window.TrustRing = TrustRing;
