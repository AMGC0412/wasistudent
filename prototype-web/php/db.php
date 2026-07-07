<?php
// ═══ db.php — Conexión a base de datos WasiStudent ═══
// Configura tus credenciales de MySQL/MariaDB aquí.

define('DB_HOST', 'localhost');
define('DB_NAME', 'wasistudent');
define('DB_USER', 'root');
define('DB_PASS', '');

function db() {
    static $pdo = null;
    if ($pdo === null) {
        try {
            $pdo = new PDO(
                'mysql:host=' . DB_HOST . ';dbname=' . DB_NAME . ';charset=utf8mb4',
                DB_USER,
                DB_PASS,
                [PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION, PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC]
            );
        } catch (PDOException $e) {
            http_response_code(500);
            echo json_encode(['error' => 'Database connection failed: ' . $e->getMessage()]);
            exit;
        }
    }
    return $pdo;
}

// Helper functions
function getAll($table) {
    $stmt = db()->query("SELECT * FROM $table ORDER BY id DESC");
    return $stmt->fetchAll();
}

function getById($table, $id) {
    $stmt = db()->prepare("SELECT * FROM $table WHERE id = ?");
    $stmt->execute([$id]);
    return $stmt->fetch();
}

function create($table, $data) {
    $columns = implode(',', array_keys($data));
    $placeholders = implode(',', array_fill(0, count($data), '?'));
    $stmt = db()->prepare("INSERT INTO $table ($columns) VALUES ($placeholders)");
    $stmt->execute(array_values($data));
    return ['id' => db()->lastInsertId()];
}

function deleteById($table, $id) {
    $stmt = db()->prepare("DELETE FROM $table WHERE id = ?");
    $stmt->execute([$id]);
    return ['deleted' => $stmt->rowCount()];
}
