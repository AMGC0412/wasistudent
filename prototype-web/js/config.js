// ═══ CONFIG ═══
const CONFIG = {
  API_URL: 'php/',
  USE_LOCAL: true, // true = localStorage, false = PHP API
};

// ═══ STATE ═══
const state = {
  user: null,
  rooms: [],
  contracts: [],
  reviews: [],
  favorites: [],
  requests: [],
  isLogin: true,
  currentRoom: null,
  surveyAns: {},
  selectedStars: 0,
  history: [],
  role: 'student',
  ownerEnabled: false,
};

// ═══ SEED DATA ═══
function seedRooms() {
  return [
    {id:'room1',title:'Cuarto individual en Urb. Ttiobamba',desc:'Cuarto acogedor en Ttiobamba, 8 min de la UNSAAC. Doña Rosa lleva 12 años alquilando.',price:280,district:'San Jerónimo',lat:-13.530,lng:-71.948,walk:8,size:12,type:'private',amen:['Wi-Fi','Agua caliente','Cocina','Lavandería','Escritorio'],owner:'Rosa Mamani Quispe',ownerAvatar:'RM',ownerRating:4.8,trustScore:92,memberSince:2014,verified:2,match:94,featured:true,urgent:false,active:true,createdAt:Date.now()-86400000,couples:false,pets:false,foreigners:true,gender:'any',deposit:280,services:0,minMonths:6},
    {id:'room2',title:'Cuarto individual en San Jerónimo',desc:'Casa de Don Eusebio, 12 años alquilando. Precios estables, trato justo.',price:250,district:'San Jerónimo',lat:-13.533,lng:-71.945,walk:12,size:11,type:'private',amen:['Wi-Fi','Agua caliente','Cocina','Patio'],owner:'Eusebio Huamán',ownerAvatar:'EH',ownerRating:4.5,trustScore:80,memberSince:2013,verified:2,match:88,featured:false,urgent:false,active:true,createdAt:Date.now()-172800000,couples:false,pets:false,foreigners:true,gender:'any',deposit:250,services:30,minMonths:6},
    {id:'room3',title:'Cuarto económico en Santiago',desc:'Pequeño pero funcional, ideal para presupuesto ajustado.',price:200,district:'Santiago',lat:-13.527,lng:-71.952,walk:20,size:8,type:'private',amen:['Agua caliente','Cocina','Escritorio'],owner:'Luzmila Pérez',ownerAvatar:'LP',ownerRating:4.1,trustScore:70,memberSince:2020,verified:1,match:65,featured:false,urgent:true,active:true,createdAt:Date.now()-259200000,couples:false,pets:false,foreigners:false,gender:'female',deposit:200,services:20,minMonths:3},
    {id:'room4',title:'Cuarto con baño propio en San Sebastián',desc:'Amplio con baño privado, agua caliente 24h, cocina compartida.',price:400,district:'San Sebastián',lat:-13.518,lng:-71.930,walk:18,size:16,type:'private',amen:['Wi-Fi','Agua caliente','Baño privado','Cocina','Calefacción','Escritorio'],owner:'Patricia Ríos',ownerAvatar:'PR',ownerRating:4.9,trustScore:90,memberSince:2018,verified:2,match:80,featured:true,urgent:false,active:true,createdAt:Date.now()-345600000,couples:true,pets:true,foreigners:true,gender:'any',deposit:400,services:60,minMonths:6}
  ];
}

function seedRequests() {
  return [
    {id:'r1',student:'María Quispe',uni:'UNSAAC - Enfermería',trust:78,msg:'Hola, vi tu cuarto y me interesa. Vengo de Quillabamba.',date:'Hace 2h',room:'room1'},
    {id:'r2',student:'José Cáceres',uni:'UAC - Derecho',trust:85,msg:'Buenas, ¿aún está disponible?',date:'Hace 5h',room:'room2'},
    {id:'r3',student:'Ana Romero',uni:'Continental - Psicología',trust:65,msg:'¿El precio incluye servicios?',date:'Ayer',room:'room3'}
  ];
}

// ═══ DB LAYER (localStorage) ═══
const DB = {
  get: (k, d) => { try { return JSON.parse(localStorage.getItem('ws_' + k)) || d } catch { return d } },
  set: (k, v) => localStorage.setItem('ws_' + k, JSON.stringify(v)),
  del: (k) => localStorage.removeItem('ws_' + k)
};

// ═══ CLAUSES ═══
const CLAUSES = [
  {n:1,t:'Precio fijo durante toda la vigencia',lb:'Código Civil Art. 1680',tx:'El arrendamiento es INMODIFICABLE durante toda la vigencia. El 67% de estudiantes reporta alzas de hasta 52% al inicio de clases.'},
  {n:2,t:'Duración mínima de 6 meses',lb:'Ley N° 30201 Art. 4',tx:'El arrendador no podrá resolver el contrato ni solicitar desalojo, salvo causales del Art. 1704. Resolución anticipada sin causal = indemnización de 1 mes.'},
  {n:3,t:'Devolución del depósito en 15 días',lb:'Código Civil Art. 1679',tx:'Depósito devuelto íntegro en 15 días. Si no se devuelve, WasiStudent registra infracción y puntaje de confianza cae 30 puntos.'},
  {n:4,t:'Transparencia total de servicios',lb:'Ley N° 29571 Art. 18',tx:'Servicios declarados exhaustivamente. Sin cobros adicionales. Interrupción >24h = descuento 5%/día.'},
  {n:5,t:'Preaviso de 30 días para cualquier cambio',lb:'Código Civil Art. 1687',tx:'Cualquier cambio requiere 30 días de preaviso. Incumplimiento = indemnización de 1 mes.'}
];
