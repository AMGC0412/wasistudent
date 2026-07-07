const Components = {
  roomCard(r) {
    const isFav = state.favorites.includes(r.id);
    return '<div class="rcard" onclick="Detail.open(\'' + r.id + '\')"><div class="img">' + I.home + (r.verified >= 2 ? '<div class="b-v">' + I.check + ' Verificado</div>' : '<div class="b-v bs">Básico</div>') + '<div class="b-m">' + I.star + ' ' + r.match + '% match</div>' + (isFav ? '<button class="fav-btn act" onclick="event.stopPropagation();Favorites.toggle(\'' + r.id + '\')">' + I.heart + '</button>' : '') + '</div><div class="inf"><div class="r"><div><h3>' + r.title + '</h3><div class="m">' + I.loc + r.district + ' · ' + r.walk + ' min</div></div><div class="pr">S/' + r.price + '<small>/mes</small></div></div></div></div>';
  }
};
