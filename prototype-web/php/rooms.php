<?php
// ═══ rooms.php — WasiStudent API ═══
// Este archivo maneja las operaciones CRUD para rooms.
// Requiere php/db.php para conexión a base de datos.

header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, DELETE, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') exit(0);

require_once 'db.php';

$method = $_SERVER['REQUEST_METHOD'];
$input = json_decode(file_get_contents('php://input'), true) ?? [];

// TODO: Implementar endpoints específicos de rooms
// Ejemplo:
// if ($method === 'GET') { echo json_encode(getAll('rooms')); }
// if ($method === 'POST') { echo json_encode(create('rooms', $input)); }

echo json_encode(['status' => 'ok', 'message' => 'rooms endpoint ready', 'method' => $method]);
