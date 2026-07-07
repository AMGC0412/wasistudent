const Detail = {
  open(id) {
    state.currentRoom = id;
    state.history.push('scr-detail');
    const r = state.rooms.find(x => x.id === id);
    if (!r) return;
    const isFav = state.favorites.includes(id);
    const favIcon = document.getElementById('detail-fav-btn');
    favIcon.innerHTML = I.heart;
    favIcon.querySelector('svg').style.color = isFav ? 'var(--pri)' : 'var(--txt3)';
    favIcon.querySelector('svg').setAttribute('fill', isFav ? 'var(--pri)' : 'none');

    let html = '<div class="hero">' + I.home + '<div class="pills"><div class="p-pr">S/' + r.price + '<small>/mes</small></div><div class="p-mt">' + I.check + ' ' + r.match + '% match</div></div></div><div class="body"><h2>' + r.title + '</h2><div class="loc">' + I.loc + r.district + ', Cusco</div><div class="vtag">' + I.check + ' Verificado en persona</div><div class="stats"><div class="st">' + I.walk + '<div class="v">' + r.walk + ' min</div><div class="l">caminando</div></div><div class="st">' + I.size + '<div class="v">' + r.size + ' m²</div><div class="l">tamaño</div></div><div class="st">' + I.person + '<div class="v">1</div><div class="l">ocupante</div></div><div class="st">' + I.bed + '<div class="v">' + (r.type === 'private' ? 'Privado' : r.type === 'shared' ? 'Comp.' : 'Estudio') + '</div><div class="l">tipo</div></div></div>';
    html += '<div class="sec"><h3>Descripción</h3><p>' + r.desc + '</p><div class="chips"><div class="chip">' + I.money + 'Depósito S/' + r.deposit + '</div><div class="chip">' + I.bolt + 'Servicios ' + (r.services > 0 ? 'S/' + r.services : 'Incluidos') + '</div></div></div>';
    html += '<div class="sec"><h3>Servicios</h3><div class="chips">' + r.amen.map(a => '<div class="chip">' + a + '</div>').join('') + '</div></div>';
    html += '<div class="sec"><h3>Verificación en persona</h3><div class="vcard"><div class="vhead" onclick="Detail.togV()"><div class="ic2">' + I.check + '</div><div class="tx"><h4>12 puntos verificados</h4><p>Verificado por WasiStudent · ' + r.trustScore + '/100</p></div><div class="ar" id="va">' + I.back + '</div></div><div class="vbody" id="vb">' + Detail.checklist() + '</div></div></div>';
    html += '<div class="sec"><div class="gban"><div class="gh">' + I.shield + '<h4>Garantía WasiStudent</h4><div class="tg">OPCIONAL</div></div><p>Si el cuarto no coincide, te devolvemos los gastos. Asistencia legal gratuita.</p></div></div>';
    html += '<div class="sec"><h3>Propietaria</h3><div class="ocard"><div class="av">' + r.ownerAvatar + '<div class="dot">' + I.check + '</div></div><div class="oi"><h4>' + r.owner + '</h4><div class="m"><span class="s">' + I.star + ' ' + r.ownerRating + '</span><span class="t">' + I.shield + ' ' + r.trustScore + '% confianza</span></div><div class="sn">Miembro desde ' + r.memberSince + '</div></div><button class="cb" onclick="alert(\'Chat disponible próximamente\')">' + I.chat + '</button></div></div>';
    document.getElementById('detail-content').innerHTML = html;
    document.getElementById('bnav').style.display = 'none';
    document.getElementById('scr-detail').classList.add('on');
    window.scrollTo(0, 0);
  },
  togV() { document.getElementById('vb').classList.toggle('open'); document.getElementById('va').classList.toggle('open'); },
  checklist() {
    const req = [{l:'Agua potable',d:'Suministro continuo'},{l:'Electricidad segura',d:'Sin cables expuestos'},{l:'Baño funcional',d:'Puerta, inodoro, ducha'},{l:'Cocina accesible',d:'Estufa operativa'},{l:'Cerradura en puerta',d:'Llave entregada'},{l:'Estructura sin daños',d:'Techo, paredes, piso OK'},{l:'Ventilación natural',d:'Ventana al exterior'}];
    const opt = [{l:'Wi-Fi',d:'Velocidad medida'},{l:'Agua caliente',d:'Disponible para ducha',nt:'6am-9am y 6pm-10pm'},{l:'Baño propio',d:'Compartido con 1 persona',no:true},{l:'Escritorio',d:'Superficie para estudiar'},{l:'Iluminación natural',d:'Luz solar diurna'}];
    let h = '<div class="vbanner">' + I.check + '<div class="bt"><h5>Cuarto verificado y apto</h5><p>Un verificador visitó este cuarto en persona.</p></div><div class="sc">92/100</div></div>';
    h += '<div class="vst req">' + I.gavel + 'Indispensables</div>';
    req.forEach(i => h += '<div class="vi"><div class="vi-ic ok">' + I.check + '</div><div class="vi-tx"><div class="l">' + i.l + '</div><div class="d">' + i.d + '</div></div></div>');
    h += '<div style="height:10px"></div><div class="vst opt">' + I.bell + 'Complementarios</div>';
    opt.forEach(i => h += '<div class="vi"><div class="vi-ic ' + (i.no ? 'no' : 'ok') + '">' + (i.no ? I.cross : I.check) + '</div><div class="vi-tx"><div class="l">' + i.l + '</div><div class="d">' + i.d + '</div>' + (i.nt ? '<div style="display:inline-block;background:rgba(212,165,116,.15);color:#A67C3B;padding:2px 6px;border-radius:4px;font-size:9px;font-style:italic;margin-top:2px">' + i.nt + '</div>' : '') + '</div></div>');
    return h;
  }
};
