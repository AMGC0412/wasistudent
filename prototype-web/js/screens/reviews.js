/* ============================================================
   WasiStudent — Screen: Reviews
   ============================================================ */

const ReviewsScreen = (function() {

  function render() {
    UI.setTitle('Reseñas');
    const rooms = Seed.getRooms();
    const myReviews = [
      { id: 'my1', roomTitle: 'Habitación luminosa cerca de UNSAAC', roomId: 'r1', rating: 5, date: '2026-06-15', text: 'Excelente experiencia. La habitación cumplió todo lo prometido y María fue muy atenta. Sin cobros ocultos, todo transparente.', status: 'published' },
      { id: 'my2', roomTitle: 'Cuarto en casa familiiar San Sebastián', roomId: 'r2', rating: 5, date: '2026-05-10', text: 'La familia Huamán es increíble. Me sentí como en casa. La comida deliciosa y el ambiente muy respetuoso.', status: 'published' },
    ];

    UI.render(`
      <div class="mb-6">
        <h1 style="font-size:var(--fs-2xl);font-weight:var(--fw-extrabold);margin-bottom:var(--sp-2);">Mis reseñas</h1>
        <p class="text-2">Las reseñas que has escrito. Solo puedes reseñar habitaciones que alquilaste (verificadas).</p>
      </div>

      <div class="card card-pad-lg mb-6" style="background:linear-gradient(135deg,var(--c-accent-soft),var(--c-surface));border-color:transparent;">
        <div class="row gap-6" style="align-items:center;">
          <div style="text-align:center;">
            <div style="font-family:var(--font-display);font-size:var(--fs-3xl);font-weight:var(--fw-extrabold);color:var(--c-text);">5.0</div>
            ${UI.stars(5, 20)}
            <div class="text-2 fs-xs mt-1">${myReviews.length} reseñas</div>
          </div>
          <div class="grow">
            <h3 style="margin-bottom:var(--sp-2);">Tu contribución a la comunidad</h3>
            <p class="text-2 mb-4">Tus reseñas ayudan a otros estudiantes a tomar decisiones informadas. Cada reseña verificada suma a tu Trust Score.</p>
            <button class="btn btn-primary" onclick="ReviewsScreen.write()">${Icons.plus} Escribir nueva reseña</button>
          </div>
        </div>
      </div>

      <h3 style="margin-bottom:var(--sp-4);">Reseñas publicadas</h3>
      ${myReviews.map(r => `
        <div class="review-card">
          <div class="head">
            <div class="avatar sm">${r.roomTitle.charAt(0)}</div>
            <div class="grow">
              <div class="row between">
                <div>
                  <div class="fw-semibold">${r.roomTitle}</div>
                  <div class="text-3 fs-xs">${new Date(r.date).toLocaleDateString('es-PE')}</div>
                </div>
                <div class="row gap-2">
                  ${UI.stars(r.rating, 16)}
                  <span class="chip chip-success">${Icons.check} Verificada</span>
                </div>
              </div>
            </div>
          </div>
          <div class="body">${r.text}</div>
          <div class="row gap-2 mt-3">
            <button class="btn btn-text btn-sm" onclick="UI.nav('detail', { roomId: '${r.roomId}' })">${Icons.building} Ver habitación</button>
            <button class="btn btn-text btn-sm" onclick="UI.toast({ title: 'Editando reseña', desc: 'Función disponible pronto', type: 'info' })">${Icons.edit} Editar</button>
          </div>
        </div>
      `).join('')}
    `);
  }

  function write() {
    UI.modal({
      title: 'Escribir reseña',
      body: `
        <div class="field">
          <label>Selecciona la habitación</label>
          <select class="select" id="review-room">
            ${Seed.getRooms().map(r => `<option value="${r.id}">${r.title}</option>`).join('')}
          </select>
        </div>
        <div class="field">
          <label>Calificación</label>
          <div class="rating-input" id="rating-input" style="font-size:32px;">
            ${[1,2,3,4,5].map(i => `<span class="star" data-value="${i}" onclick="ReviewsScreen.rate(${i})" style="cursor:pointer;display:inline-block;width:40px;height:40px;">${Icons.starOutline}</span>`).join('')}
          </div>
        </div>
        <div class="field">
          <label>Tu reseña</label>
          <textarea class="textarea" id="review-text" placeholder="Comparte tu experiencia. ¿Cumplió lo prometido? ¿Lo recomiendas?" rows="5"></textarea>
        </div>
      `,
      footer: `
        <button class="btn btn-ghost" onclick="UI.closeModal()">Cancelar</button>
        <button class="btn btn-primary" onclick="ReviewsScreen.publish()">${Icons.check} Publicar reseña</button>
      `
    });
  }

  let currentRating = 0;
  function rate(value) {
    currentRating = value;
    document.querySelectorAll('#rating-input .star').forEach((s, i) => {
      s.innerHTML = i < value ? Icons.star : Icons.starOutline;
      s.classList.toggle('active', i < value);
    });
  }

  function publish() {
    UI.closeModal();
    UI.toast({ title: 'Reseña publicada', desc: 'Gracias por tu feedback', type: 'success' });
    setTimeout(() => render(), 800);
  }

  return { render, write, rate, publish };
})();

window.ReviewsScreen = ReviewsScreen;
