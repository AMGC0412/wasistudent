<?php
// ═══ contracts.php — WasiStudent API ═══
// Este archivo maneja las operaciones CRUD para contracts.
// Requiere php/db.php para conexión a base de datos.

header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, DELETE, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') exit(0);

require_once 'db.php';

$method = $_SERVER['REQUEST_METHOD'];
$input = json_decode(file_get_contents('php://input'), true) ?? [];

// TODO: Implementar endpoints específicos de contracts
// Ejemplo:
// if ($method === 'GET') { echo json_encode(getAll('contracts')); }
// if ($method === 'POST') { echo json_encode(create('contracts', $input)); }

echo json_encode(['status' => 'ok', 'message' => 'contracts endpoint ready', 'method' => $method]);
