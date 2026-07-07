const Survey = {
  render() {
    document.getElementById('survey-content').innerHTML = [
      {q:'¿Qué tan confiado te sentiste de que el cuarto era real?',k:'tb',min:'Nada confiado',max:'Muy confiado',vals:[1,2,3,4,5,6,7,8,9,10]},
      {q:'¿Qué tan protegido te sentiste al firmar?',k:'ta',min:'Nada protegido',max:'Muy protegido',vals:[1,2,3,4,5,6,7,8,9,10]},
      {q:'¿Entendiste las 5 cláusulas?',k:'und',type:'yn',opts:['Sí, todas','Parcialmente','No']},
      {q:'¿Recomendarías WasiStudent?',k:'nps',min:'No',max:'Muy probable',vals:[0,1,2,3,4,5,6,7,8,9,10]},
      {q:'¿Qué te hizo sentir seguro?',k:'secure',type:'text'},
      {q:'¿Qué fue difícil o confuso?',k:'difficult',type:'text'}
    ].map(s => {
      if (s.type === 'text') return '<div class="sq"><div class="qt">' + s.q + '</div><textarea id="sq-' + s.k + '" placeholder="Tu respuesta..."></textarea></div>';
      if (s.type === 'yn') return '<div class="sq"><div class="qt">' + s.q + '</div><div class="yn" data-q="' + s.k + '">' + s.opts.map((o, i) => '<div onclick="Survey.sel(this,\'' + s.k + '\',\'' + ['yes','partial','no'][i] + '\')">' + o + '</div>').join('') + '</div></div>';
      return '<div class="sq"><div class="qt">' + s.q + '</div><div class="so" data-q="' + s.k + '">' + s.vals.map(v => '<div onclick="Survey.sel(this,\'' + s.k + '\',' + v + ')">' + v + '</div>').join('') + '</div><div class="sl2"><span>' + s.min + '</span><span>' + s.max + '</span></div></div>';
    }).join('');
    state.surveyAns = {};
  },
  sel(el, q, v) {
    state.surveyAns[q] = v;
    el.parentElement.querySelectorAll('div').forEach(d => d.classList.remove('sel'));
    el.classList.add('sel');
  },
  submit() {
    const tb = state.surveyAns.tb || 0, ta = state.surveyAns.ta || 0, np = state.surveyAns.nps || 0, u = state.surveyAns.und || '—';
    const s = document.getElementById('sq-secure')?.value || '', d = document.getElementById('sq-difficult')?.value || '';
    let h = '<div class="rc"><h4>Confianza ANTES</h4><div class="bn">' + tb + '/10</div><div class="lb3">Verificación</div><div class="rb"><div class="fl" style="width:' + (tb * 10) + '%"></div></div></div>';
    h += '<div class="rc"><h4>Confianza DESPUÉS</h4><div class="bn">' + ta + '/10</div><div class="lb3">Contrato</div><div class="rb"><div class="fl" style="width:' + (ta * 10) + '%"></div></div></div>';
    h += '<div class="rc"><h4>Recomendación</h4><div class="bn">' + np + '/10</div><div class="lb3">NPS</div><div class="rb"><div class="fl" style="width:' + (np * 10) + '%"></div></div></div>';
    h += '<div class="rc"><h4>Comprensión</h4><div style="font-size:16px;font-weight:700;color:var(--pri)">' + ({yes:'Sí, todas',partial:'Parcialmente',no:'No'}[u] || '—') + '</div></div>';
    if (s || d) h += '<div class="rc"><h4>Comentarios</h4><p style="font-size:12px;color:var(--txt2);margin-top:6px"><strong>Seguro:</strong></p><p style="font-size:12px;margin-top:2px">' + (s || '—') + '</p><p style="font-size:12px;color:var(--txt2);margin-top:10px"><strong>Difícil:</strong></p><p style="font-size:12px;margin-top:2px">' + (d || '—') + '</p></div>';
    const avg = (tb + ta) / 2;
    h += '<div class="rc" style="background:var(--suc-bg);border-color:var(--suc)"><h4 style="color:var(--suc)">Veredicto</h4><p style="font-size:12px;color:var(--suc);margin-top:6px">' + (avg >= 7 && np >= 7 ? 'HIPÓTESIS VALIDADA: El sistema de confianza funciona.' : avg >= 5 ? 'HIPÓTESIS PARCIAL: Funciona con margen de mejora.' : 'HIPÓTESIS NO VALIDADA: Requiere pivotar.') + '</p></div>';
    document.getElementById('results-content').innerHTML = h;
    go('scr-results');
  }
};
