/* ============================================================
   WasiStudent — Datos semilla (mock realista basado en Cusco)
   ============================================================ */

const Seed = (function() {

  const UNIVERSITIES = [
    { id: 'UNSAAC', name: 'Universidad Nacional de San Antonio Abad del Cusco', short: 'UNSAAC' },
    { id: 'UAC', name: 'Universidad Andina del Cusco', short: 'UAC' },
    { id: 'CONTINENTAL', name: 'Universidad Continental', short: 'Continental' },
    { id: 'TECSUP', name: 'TECSUP Cusco', short: 'TECSUP' },
  ];

  const DISTRICTS = [
    { id: 'cusco', name: 'Cusco Centro', lat: -13.5220, lng: -71.9670 },
    { id: 'wanchaq', name: 'Wanchaq', lat: -13.5290, lng: -71.9480 },
    { id: 'sanseb', name: 'San Sebastián', lat: -13.5160, lng: -71.9160 },
    { id: 'sant', name: 'Santiago', lat: -13.5290, lng: -71.9390 },
    { id: 'sanjer', name: 'San Jerónimo', lat: -13.5030, lng: -71.9070 },
    { id: 'ccor', name: 'Ccorca', lat: -13.5410, lng: -72.0200 },
  ];

  const ROOMS = [
    {
      id: 'r1',
      title: 'Habitación luminosa cerca de UNSAAC',
      description: 'Habitación amplia con ventana panorámica a la ciudad. Ideal para estudiantes universitarios, incluye escritorio amplio y closet empotrado. Edificio con seguridad 24h y zonas comunes limpias.',
      district: 'wanchaq',
      address: 'Av. De la Cultura 1240, Wanchaq',
      lat: -13.5290, lng: -71.9480,
      price: 850,
      currency: 'PEN',
      period: 'mes',
      type: 'single',
      roomType: 'Habitación individual',
      area: 16,
      floor: 2,
      maxOccupancy: 1,
      genderPreference: 'any',
      university: 'UNSAAC',
      walkMinutes: 12,
      busMinutes: 5,
      photos: [
        'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?w=900',
        'https://images.unsplash.com/photo-1554995207-c18c203602cb?w=900',
        'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?w=900',
        'https://images.unsplash.com/photo-1505693416388-ac5ce068fe85?w=900',
      ],
      amenities: ['wifi', 'bathroom', 'kitchen', 'desk', 'closet', 'security'],
      includedServices: ['Agua', 'Luz', 'Internet 100Mbps'],
      extraServices: [],
      ownerId: 'o1',
      ownerName: 'María Quispe',
      ownerRating: 4.8,
      ownerReviews: 23,
      trustScore: 92,
      verified: true,
      verificationItems: 12,
      contractActive: true,
      available: true,
      availableFrom: '2026-08-01',
      minStay: 6,
      deposit: 1700,
      createdAt: '2026-06-15T10:00:00Z',
      reviews: [
        { id: 'rv1', user: 'Carla M.', rating: 5, date: '2026-06-10', text: 'Excelente trato de la propietaria, la habitación cumplió todo lo prometido. Sin cobros ocultos.', verified: true },
        { id: 'rv2', user: 'Diego R.', rating: 5, date: '2026-05-22', text: 'Muy cerca de la universidad, ambiente seguro y tranquilo. Volvería sin dudarlo.', verified: true },
        { id: 'rv3', user: 'Andrea S.', rating: 4, date: '2026-04-15', text: 'Buena habitación, solo faltó mejorar el WiFi pero lo solucionaron rápido.', verified: true },
      ],
      rating: 4.8,
      reviewCount: 23,
    },
    {
      id: 'r2',
      title: 'Cuarto amoblado en casa familiiar San Sebastián',
      description: 'Cuarto en casa de familia cusqueña, ambiente cálido y seguro. Incluye desayuno y acceso a cocina. Perfecto para estudiantes que buscan integrarse a la cultura local.',
      district: 'sanseb',
      address: 'Calle Túpac Amaru 450, San Sebastián',
      lat: -13.5160, lng: -71.9160,
      price: 650,
      currency: 'PEN',
      period: 'mes',
      type: 'family',
      roomType: 'Cuarto en casa de familia',
      area: 12,
      floor: 1,
      maxOccupancy: 1,
      genderPreference: 'female',
      university: 'UNSAAC',
      walkMinutes: 25,
      busMinutes: 10,
      photos: [
        'https://images.unsplash.com/photo-1505691938895-1758d7feb511?w=900',
        'https://images.unsplash.com/photo-1502672023488-70e25813eb80?w=900',
        'https://images.unsplash.com/photo-1505873242700-f289a29e1e0f?w=900',
      ],
      amenities: ['wifi', 'bathroom', 'kitchen', 'desk', 'closet', 'breakfast'],
      includedServices: ['Agua', 'Luz', 'Internet', 'Desayuno'],
      extraServices: [{ name: 'Lavandería', price: 30 }],
      ownerId: 'o2',
      ownerName: 'Familia Huamán',
      ownerRating: 4.9,
      ownerReviews: 31,
      trustScore: 95,
      verified: true,
      verificationItems: 12,
      contractActive: true,
      available: true,
      availableFrom: '2026-08-01',
      minStay: 6,
      deposit: 1300,
      createdAt: '2026-06-20T10:00:00Z',
      reviews: [
        { id: 'rv4', user: 'Lucía P.', rating: 5, date: '2026-06-05', text: 'La familia es un amor, me sentí como en casa. La comida buenísima.', verified: true },
        { id: 'rv5', user: 'Rosa T.', rating: 5, date: '2026-05-18', text: 'Recomendadísimo, son muy atentos y respetuosos.', verified: true },
      ],
      rating: 4.9,
      reviewCount: 31,
    },
    {
      id: 'r3',
      title: 'Departamento moderno para estudiantes Santiago',
      description: 'Mini departamento independiente con baño privado y kitchenette. Edificio nuevo con elevador, gym y área de estudio. Diseñado para estudiantes universitarios.',
      district: 'sant',
      address: 'Av. Tomasa Tito Condemayta 230, Santiago',
      lat: -13.5290, lng: -71.9390,
      price: 1200,
      currency: 'PEN',
      period: 'mes',
      type: 'apartment',
      roomType: 'Mini departamento',
      area: 28,
      floor: 5,
      maxOccupancy: 2,
      genderPreference: 'any',
      university: 'UAC',
      walkMinutes: 18,
      busMinutes: 7,
      photos: [
        'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?w=900',
        'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?w=900',
        'https://images.unsplash.com/photo-1505873242700-f289a29e1e0f?w=900',
        'https://images.unsplash.com/photo-1522444195799-478538b28823?w=900',
      ],
      amenities: ['wifi', 'bathroom', 'kitchen', 'desk', 'closet', 'gym', 'elevator', 'laundry'],
      includedServices: ['Agua', 'Luz', 'Internet 200Mbps', 'Gym'],
      extraServices: [{ name: 'Cochera', price: 80 }],
      ownerId: 'o3',
      ownerName: 'Inversiones Andinas SAC',
      ownerRating: 4.6,
      ownerReviews: 18,
      trustScore: 88,
      verified: true,
      verificationItems: 11,
      contractActive: true,
      available: true,
      availableFrom: '2026-07-15',
      minStay: 6,
      deposit: 2400,
      createdAt: '2026-06-25T10:00:00Z',
      reviews: [
        { id: 'rv6', user: 'Pedro L.', rating: 4, date: '2026-06-12', text: 'Moderno y bien ubicado. Algunos detalles de terminación pero nada grave.', verified: true },
        { id: 'rv7', user: 'Ana K.', rating: 5, date: '2026-05-30', text: 'Excelente edificio, el gym es un plus. Lo recomiendo.', verified: true },
      ],
      rating: 4.6,
      reviewCount: 18,
    },
    {
      id: 'r4',
      title: 'Habitación económica en residencia estudiantil',
      description: 'Habitación en residencia con 8 cuartos, baños compartidos limpios. Ambiente 100% estudiantil con sala de estudio y zona de lavandería. Súper económico.',
      district: 'cusco',
      address: 'Calle Saphi 780, Cusco',
      lat: -13.5220, lng: -71.9670,
      price: 450,
      currency: 'PEN',
      period: 'mes',
      type: 'residence',
      roomType: 'Residencia estudiantil',
      area: 10,
      floor: 3,
      maxOccupancy: 1,
      genderPreference: 'any',
      university: 'UNSAAC',
      walkMinutes: 5,
      busMinutes: 0,
      photos: [
        'https://images.unsplash.com/photo-1505873242700-f289a29e1e0f?w=900',
        'https://images.unsplash.com/photo-1555854877-bab0e6662c0c?w=900',
      ],
      amenities: ['wifi', 'kitchen', 'desk', 'laundry', 'study'],
      includedServices: ['Agua', 'Luz', 'Internet'],
      extraServices: [],
      ownerId: 'o4',
      ownerName: 'Residencia Estudiantil Cusco',
      ownerRating: 4.3,
      ownerReviews: 47,
      trustScore: 82,
      verified: true,
      verificationItems: 10,
      contractActive: true,
      available: true,
      availableFrom: '2026-08-01',
      minStay: 4,
      deposit: 900,
      createdAt: '2026-06-18T10:00:00Z',
      reviews: [
        { id: 'rv8', user: 'Marco V.', rating: 4, date: '2026-06-08', text: 'Económico y cumple. Los baños a veces se llenan pero están limpios.', verified: true },
        { id: 'rv9', user: 'Joss F.', rating: 5, date: '2026-05-25', text: 'Hice muchos amigos, ambiente buenísimo.', verified: true },
      ],
      rating: 4.3,
      reviewCount: 47,
    },
    {
      id: 'r5',
      title: 'Cuarto con vista a la ciudad San Jerónimo',
      description: 'Cuarto amplio en segunda planta con balcón y vista panorámica. Casa con patio andino y plantas. La dueña es docente universitaria jubilada.',
      district: 'sanjer',
      address: 'Av. Indoamérica 1450, San Jerónimo',
      lat: -13.5030, lng: -71.9070,
      price: 700,
      currency: 'PEN',
      period: 'mes',
      type: 'single',
      roomType: 'Habitación individual',
      area: 18,
      floor: 2,
      maxOccupancy: 1,
      genderPreference: 'any',
      university: 'CONTINENTAL',
      walkMinutes: 30,
      busMinutes: 12,
      photos: [
        'https://images.unsplash.com/photo-1505693416388-ac5ce068fe85?w=900',
        'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?w=900',
        'https://images.unsplash.com/photo-1554995207-c18c203602cb?w=900',
      ],
      amenities: ['wifi', 'bathroom', 'kitchen', 'desk', 'closet', 'balcony', 'garden'],
      includedServices: ['Agua', 'Luz', 'Internet'],
      extraServices: [],
      ownerId: 'o5',
      ownerName: 'Prof. Carmen Aparicio',
      ownerRating: 5.0,
      ownerReviews: 12,
      trustScore: 98,
      verified: true,
      verificationItems: 12,
      contractActive: true,
      available: true,
      availableFrom: '2026-09-01',
      minStay: 6,
      deposit: 1400,
      createdAt: '2026-06-22T10:00:00Z',
      reviews: [
        { id: 'rv10', user: 'Sofía R.', rating: 5, date: '2026-06-15', text: 'La profe Carmen es un amor, me ayudó mucho con mi tesis. La vista es increíble.', verified: true },
      ],
      rating: 5.0,
      reviewCount: 12,
    },
    {
      id: 'r6',
      title: 'Habitación con baño privado Wanchaq',
      description: 'Habitación moderna con baño privado en suite. Edificio con seguridad y recepción 24h. A 15 minutos caminando del centro histórico.',
      district: 'wanchaq',
      address: 'Calle Mariscal Gamarra 320, Wanchaq',
      lat: -13.5280, lng: -71.9470,
      price: 950,
      currency: 'PEN',
      period: 'mes',
      type: 'single',
      roomType: 'Habitación con baño privado',
      area: 20,
      floor: 4,
      maxOccupancy: 1,
      genderPreference: 'any',
      university: 'UAC',
      walkMinutes: 8,
      busMinutes: 3,
      photos: [
        'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?w=900',
        'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?w=900',
        'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?w=900',
      ],
      amenities: ['wifi', 'bathroom', 'kitchen', 'desk', 'closet', 'security', 'elevator'],
      includedServices: ['Agua', 'Luz', 'Internet', 'Recepción 24h'],
      extraServices: [],
      ownerId: 'o1',
      ownerName: 'María Quispe',
      ownerRating: 4.8,
      ownerReviews: 23,
      trustScore: 92,
      verified: true,
      verificationItems: 12,
      contractActive: true,
      available: true,
      availableFrom: '2026-08-15',
      minStay: 6,
      deposit: 1900,
      createdAt: '2026-06-28T10:00:00Z',
      reviews: [
        { id: 'rv11', user: 'Luis M.', rating: 5, date: '2026-06-18', text: 'Baño privado lo mejor, todo muy limpio. La dueña responde rapidísimo.', verified: true },
      ],
      rating: 4.8,
      reviewCount: 23,
    },
  ];

  // Items de verificación (12 puntos)
  const VERIFICATION_ITEMS = [
    { id: 'v1', name: 'Identidad del propietario', desc: 'DNI verificado contra RENIEC', required: true },
    { id: 'v2', name: 'Propiedad del inmueble', desc: 'Título de propiedad o contrato de alquiler vigente', required: true },
    { id: 'v3', name: 'Predio al día', desc: 'Pago de impuesto predial al día', required: true },
    { id: 'v4', name: 'Sistema eléctrico seguro', desc: 'Inspección visual de instalaciones', required: true },
    { id: 'v5', name: 'Agua potable', desc: 'Conexión a red pública o cisterna certificada', required: true },
    { id: 'v6', name: 'Saneamiento', desc: 'Desagüe conectado a red pública', required: true },
    { id: 'v7', name: 'Seguridad estructural', desc: 'Sin riesgo evidente de derrumbe', required: true },
    { id: 'v8', name: 'Salidas de emergencia', desc: 'Al menos 2 rutas de evacuación', required: false },
    { id: 'v9', name: 'Detector de humo', desc: 'En zonas comunes y habitaciones', required: false },
    { id: 'v10', name: 'Extintor', desc: 'Recargado en último año', required: false },
    { id: 'v11', name: 'Llaves de agua y gas', desc: 'Accesibles y operativas', required: true },
    { id: 'v12', name: 'Referencias verificadas', desc: 'Al menos 2 referencias de inquilinos anteriores', required: false },
  ];

  // Cláusulas contractuales (5 legales)
  const CONTRACT_CLAUSES = [
    {
      id: 'c1',
      num: 1,
      title: 'Precio fijo por todo el contrato',
      body: 'El monto de alquiler mensual quedará fijado en el presente contrato y no podrá ser incrementado unilateralmente durante su vigencia, salvo acuerdo expreso entre ambas partes.',
      legalRef: 'Art. 1680 Código Civil Peruano',
    },
    {
      id: 'c2',
      num: 2,
      title: 'Duración mínima de 6 meses',
      body: 'El presente contrato tendrá una duración mínima de 6 (seis) meses, garantizando estabilidad al inquilino estudiante y evitando desalojos intempestivos.',
      legalRef: 'Ley 30201 — Ley de Alquileres Urbanos',
    },
    {
      id: 'c3',
      num: 3,
      title: 'Devolución de depósito en 15 días',
      body: 'El deposito de garantía será devuelto en su totalidad dentro de los 15 días calendario siguientes a la desocupación del inmueble, salvo daños comprobables causados por el inquilino.',
      legalRef: 'Art. 1679 Código Civil Peruano',
    },
    {
      id: 'c4',
      num: 4,
      title: 'Transparencia en servicios',
      body: 'El propietario informará previamente todos los servicios incluidos y los cobros adicionales. No se podrán aplicar cobros ocultos ni conceptos no expresados en el contrato.',
      legalRef: 'Ley 29571 — Código de Protección y Defensa del Consumidor',
    },
    {
      id: 'c5',
      num: 5,
      title: 'Preaviso de 30 días para finalización',
      body: 'Cualquiera de las partes que desee finalizar el contrato deberá notificar a la otra con al menos 30 días calendario de anticipación, por escrito.',
      legalRef: 'Art. 1687 Código Civil Peruano',
    },
  ];

  // Factores del Trust Score
  const TRUST_FACTORS = [
    { id: 'f1', name: 'Verificación del inmueble', desc: '12 puntos de seguridad y legalidad', weight: 35, max: 12 },
    { id: 'f2', name: 'Contrato legal', desc: '5 cláusulas del Código Civil', weight: 25, max: 5 },
    { id: 'f3', name: 'Reseñas verificadas', desc: 'Inquilinos anteriores reales', weight: 25, max: 100 },
    { id: 'f4', name: 'Antigüedad y actividad', desc: 'Tiempo en plataforma', weight: 15, max: 100 },
  ];

  // Notificaciones de ejemplo
  const NOTIFICATIONS_SEED = [
    { id: 'n1', userId: 'u1', icon: 'check', type: 'success', title: 'Verificación completada', desc: 'Tu habitación ha sido verificada en 12/12 puntos', time: 'Hace 2 horas', read: false },
    { id: 'n2', userId: 'u1', icon: 'file', type: 'info', title: 'Contrato listo para firmar', desc: 'María Quispe ha enviado el contrato', time: 'Hace 5 horas', read: false },
    { id: 'n3', userId: 'u1', icon: 'bell', type: 'info', title: 'Nueva reseña', desc: 'Recibiste una reseña de 5 estrellas', time: 'Ayer', read: true },
  ];

  // Mensajes de chat
  const CHATS_SEED = [
    {
      id: 'ch1',
      userId: 'u1',
      ownerId: 'o1',
      ownerName: 'María Quispe',
      roomId: 'r1',
      roomTitle: 'Habitación luminosa cerca de UNSAAC',
      messages: [
        { id: 'm1', from: 'me', text: 'Hola María, ¿la habitación sigue disponible?', time: '10:30' },
        { id: 'm2', from: 'them', text: 'Hola! Sí, está disponible desde el 1 de agosto. ¿Quieres coordinar una visita?', time: '10:32' },
        { id: 'm3', from: 'me', text: 'Sí, perfecto. ¿Mañana a las 4pm?', time: '10:35' },
        { id: 'm4', from: 'them', text: 'Está bien, te espero en Av. De la Cultura 1240', time: '10:36' },
      ],
      lastTime: '10:36',
      unread: 1,
    },
    {
      id: 'ch2',
      userId: 'u1',
      ownerId: 'o5',
      ownerName: 'Prof. Carmen Aparicio',
      roomId: 'r5',
      roomTitle: 'Cuarto con vista a la ciudad San Jerónimo',
      messages: [
        { id: 'm5', from: 'them', text: 'Hola estudiante, vi tu interés en mi cuarto. ¿Eres de Continental?', time: 'Ayer 18:20' },
        { id: 'm6', from: 'me', text: 'Sí, estudio Ingeniería. ¿El cuarto tiene escritorio amplio?', time: 'Ayer 18:45' },
        { id: 'm7', from: 'them', text: 'Sí, y tiene vista al valle. Te va a encantar', time: 'Ayer 18:50' },
      ],
      lastTime: 'Ayer 18:50',
      unread: 0,
    },
  ];

  // Usuarios propietario (para que el panel de owner funcione)
  const OWNERS = [
    { id: 'o1', name: 'María Quispe', phone: '+51 984 123 456', email: 'maria.q@example.com', rooms: ['r1', 'r6'] },
    { id: 'o2', name: 'Familia Huamán', phone: '+51 984 234 567', email: 'familia.huaman@example.com', rooms: ['r2'] },
    { id: 'o3', name: 'Inversiones Andinas SAC', phone: '+51 084 232 345', email: 'contacto@inverandinas.com', rooms: ['r3'] },
    { id: 'o4', name: 'Residencia Estudiantil Cusco', phone: '+51 984 345 678', email: 'residencia@cusco.edu', rooms: ['r4'] },
    { id: 'o5', name: 'Prof. Carmen Aparicio', phone: '+51 984 456 789', email: 'carmen.aparicio@example.com', rooms: ['r5'] },
  ];

  // Requests (solicitudes de visita/alquiler)
  const REQUESTS_SEED = [
    { id: 'rq1', roomId: 'r1', roomTitle: 'Habitación luminosa cerca de UNSAAC', studentName: 'Estudiante Demo', studentId: 'u1', status: 'pending', date: '2026-07-09', type: 'visit', message: 'Hola, me gustaría visitar la habitación esta semana' },
    { id: 'rq2', roomId: 'r6', roomTitle: 'Habitación con baño privado Wanchaq', studentName: 'Carlos Vega', studentId: 'u9', status: 'pending', date: '2026-07-08', type: 'visit', message: 'Disponible para visitar mañana?' },
    { id: 'rq3', roomId: 'r1', roomTitle: 'Habitación luminosa cerca de UNSAAC', studentName: 'Lucía Pérez', studentId: 'u10', status: 'approved', date: '2026-07-06', type: 'rental', message: 'Quiero alquilar esta habitación' },
  ];

  function ensureSeed() {
    // Solo inicializar si no existe
    if (!Store.get(Store.KEYS.ROOMS)) {
      Store.set(Store.KEYS.ROOMS, ROOMS);
    }
    if (!Store.get('wasi_owners_seed')) {
      Store.set('wasi_owners_seed', OWNERS);
    }
    if (!Store.get('wasi_requests_seed')) {
      Store.set('wasi_requests_seed', REQUESTS_SEED);
    }
  }

  return {
    UNIVERSITIES, DISTRICTS, ROOMS, VERIFICATION_ITEMS, CONTRACT_CLAUSES, TRUST_FACTORS,
    NOTIFICATIONS_SEED, CHATS_SEED, OWNERS, REQUESTS_SEED,
    ensureSeed,
    getRooms: () => Store.get(Store.KEYS.ROOMS, ROOMS),
    getRoom: (id) => Store.get(Store.KEYS.ROOMS, ROOMS).find(r => r.id === id),
    saveRoom: (room) => {
      const rooms = Store.get(Store.KEYS.ROOMS, ROOMS);
      const idx = rooms.findIndex(r => r.id === room.id);
      if (idx >= 0) rooms[idx] = room;
      else rooms.unshift(room);
      Store.set(Store.KEYS.ROOMS, rooms);
    },
  };
})();

window.Seed = Seed;
