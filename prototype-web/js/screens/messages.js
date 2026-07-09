/* ============================================================
   WasiStudent — Screen: Messages (chat)
   ============================================================ */

const MessagesScreen = (function() {

  let activeChatId = null;

  function render(params = {}) {
    UI.setTitle('Mensajes');
    const user = Auth.current();
    const chats = Store.get(Store.KEYS.CHATS, Seed.CHATS_SEED).filter(c => c.userId === user.id);

    if (params.roomId) {
      // Crear o encontrar chat para esta habitación
      let chat = chats.find(c => c.roomId === params.roomId);
      if (!chat) {
        const room = Seed.getRoom(params.roomId);
        chat = {
          id: 'ch' + Date.now(),
          userId: user.id,
          ownerId: room.ownerId,
          ownerName: room.ownerName,
          roomId: room.id,
          roomTitle: room.title,
          messages: [
            { id: 'm' + Date.now(), from: 'them', text: `Hola! Gracias por tu interés en "${room.title}". ¿En qué puedo ayudarte?`, time: new Date().toLocaleTimeString('es-PE', { hour: '2-digit', minute: '2-digit' }) },
          ],
          lastTime: new Date().toLocaleTimeString('es-PE', { hour: '2-digit', minute: '2-digit' }),
          unread: 0,
        };
        chats.push(chat);
        Store.set(Store.KEYS.CHATS, chats);
      }
      activeChatId = chat.id;
    } else if (chats.length > 0 && !activeChatId) {
      activeChatId = chats[0].id;
    }

    UI.render(`
      <div class="chat-layout">
        <div class="chat-list">
          <div class="chat-list-head">
            <h3 style="font-size:var(--fs-lg);">Conversaciones</h3>
          </div>
          ${chats.length === 0 ? `
            <div class="text-center text-2 fs-sm" style="padding:var(--sp-6);">
              ${Icons.chat}
              <p class="mt-2">No tienes conversaciones aún</p>
            </div>
          ` : chats.map(c => `
            <div class="chat-item ${c.id === activeChatId ? 'active' : ''}" onclick="MessagesScreen.openChat('${c.id}')">
              <div class="avatar">${c.ownerName.charAt(0)}</div>
              <div class="grow">
                <div class="row between">
                  <div class="fw-semibold fs-sm truncate">${c.ownerName}</div>
                  <div class="time">${c.lastTime}</div>
                </div>
                <div class="last-msg truncate">${c.messages[c.messages.length - 1]?.text || ''}</div>
              </div>
              ${c.unread ? `<span class="badge-num" style="background:var(--c-primary);color:white;font-size:10px;padding:2px 6px;border-radius:50%;">${c.unread}</span>` : ''}
            </div>
          `).join('')}
        </div>

        <div class="chat-thread" id="chat-thread">
          ${renderThread(chats.find(c => c.id === activeChatId))}
        </div>
      </div>
    `);
  }

  function renderThread(chat) {
    if (!chat) {
      return `
        <div class="empty-state" style="margin:auto;">
          <div class="icon-circle">${Icons.chat}</div>
          <h3>Selecciona una conversación</h3>
          <p>O inicia una nueva desde el detalle de una habitación</p>
        </div>
      `;
    }

    return `
      <div class="chat-thread-head">
        <div class="avatar">${chat.ownerName.charAt(0)}</div>
        <div class="grow">
          <div class="fw-semibold">${chat.ownerName}</div>
          <div class="text-3 fs-xs">${chat.roomTitle}</div>
        </div>
        <button class="btn-icon" onclick="UI.nav('detail', { roomId: '${chat.roomId}' })" data-tooltip="Ver habitación">${Icons.building}</button>
      </div>
      <div class="chat-messages" id="chat-messages">
        ${chat.messages.map(m => `
          <div class="chat-bubble ${m.from}">
            ${m.text}
            <span class="time">${m.time}</span>
          </div>
        `).join('')}
      </div>
      <div class="chat-input">
        <button class="btn-icon">${Icons.image}</button>
        <input type="text" class="input" id="msg-input" placeholder="Escribe un mensaje..." onkeypress="if(event.key==='Enter') MessagesScreen.send('${chat.id}')">
        <button class="btn btn-primary" onclick="MessagesScreen.send('${chat.id}')">${Icons.send}</button>
      </div>
    `;
  }

  function openChat(chatId) {
    activeChatId = chatId;
    // Marcar como leído
    const user = Auth.current();
    const chats = Store.get(Store.KEYS.CHATS, Seed.CHATS_SEED);
    const chat = chats.find(c => c.id === chatId);
    if (chat) chat.unread = 0;
    Store.set(Store.KEYS.CHATS, chats);
    // Re-render thread only
    const thread = document.getElementById('chat-thread');
    if (thread) thread.innerHTML = renderThread(chat);
    // Update active
    document.querySelectorAll('.chat-item').forEach(el => el.classList.remove('active'));
    event?.currentTarget?.classList?.add('active');
  }

  function send(chatId) {
    const input = document.getElementById('msg-input');
    const text = input.value.trim();
    if (!text) return;

    const chats = Store.get(Store.KEYS.CHATS, Seed.CHATS_SEED);
    const chat = chats.find(c => c.id === chatId);
    if (!chat) return;

    const now = new Date().toLocaleTimeString('es-PE', { hour: '2-digit', minute: '2-digit' });
    chat.messages.push({ id: 'm' + Date.now(), from: 'me', text, time: now });
    chat.lastTime = now;
    Store.set(Store.KEYS.CHATS, chats);

    input.value = '';
    render({});

    // Auto-respuesta simulada
    setTimeout(() => {
      const updatedChats = Store.get(Store.KEYS.CHATS, Seed.CHATS_SEED);
      const c = updatedChats.find(ch => ch.id === chatId);
      if (c) {
        c.messages.push({ id: 'm' + Date.now() + 1, from: 'them', text: 'Gracias por tu mensaje. Te respondo en un momento.', time: new Date().toLocaleTimeString('es-PE', { hour: '2-digit', minute: '2-digit' }) });
        c.lastTime = new Date().toLocaleTimeString('es-PE', { hour: '2-digit', minute: '2-digit' });
        Store.set(Store.KEYS.CHATS, updatedChats);
        // Solo actualizar si seguimos en el mismo chat
        if (activeChatId === chatId) {
          const thread = document.getElementById('chat-thread');
          if (thread) thread.innerHTML = renderThread(c);
        }
      }
    }, 1500);
  }

  return { render, openChat, send };
})();

window.MessagesScreen = MessagesScreen;
