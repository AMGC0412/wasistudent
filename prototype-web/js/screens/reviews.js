const Reviews = {
  render() {
    const roomReviews = state.reviews.filter(r => r.roomId === state.currentRoom);
    let html = roomReviews.length === 0 ? '<div class="empty">' + I.star + '<h3>Sin reseñas</h3></div>' : '<div class="card" style="text-align:center"><div style="font-size:36px;font-weight:900;color:var(--pri)">' + (roomReviews.reduce((s,r) => s + r.rating, 0) / roomReviews.length).toFixed(1) + '</div><div style="font-size:12px;color:var(--txt3)">' + roomReviews.length + ' reseñas</div></div>';
    roomReviews.forEach(r => { html += '<div class="card"><div style="display:flex;align-items:center;gap:10px;margin-bottom:8px"><div style="width:36px;height:36px;background:var(--pri-t);border-radius:50%;display:flex;align-items:center;justify-content:center;font-size:11px;font-weight:700;color:var(--pri)">' + r.reviewer.substring(0, 2) + '</div><div style="flex:1"><div style="font-size:13px;font-weight:700">' + r.reviewer + '</div><div style="font-size:11px;color:var(--txt3)">' + r.date + '</div></div><div style="display:flex;align-items:center;gap:2px">' + I.star + '<span style="font-size:13px;font-weight:700">' + r.rating + '</span></div></div><div style="font-size:13px;font-weight:600;margin-bottom:4px">' + r.title + '</div><div style="font-size:12px;color:var(--txt2)">' + r.body + '</div></div>'; });
    document.getElementById('reviews-content').innerHTML = html;
  },
  submit() {
    const rating = state.selectedStars, title = document.getElementById('rev-title').value.trim(), body = document.getElementById('rev-body').value.trim();
    if (rating === 0 || !title || !body) { alert('Completa todo'); return; }
    const review = { roomId: state.currentRoom, reviewer: state.user.name, rating, title, body, date: new Date().toLocaleDateString() };
    API.createReview(review).then(() => { state.reviews.push(review); state.selectedStars = 0; go('scr-reviews'); });
  }
};
