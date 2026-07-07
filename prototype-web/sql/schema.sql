-- ═══ WasiStudent Database Schema ═══
-- Ejecutar en MySQL/MariaDB para crear la base de datos.

CREATE DATABASE IF NOT EXISTS wasistudent CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE wasistudent;

-- Users
CREATE TABLE IF NOT EXISTS users (
    id VARCHAR(36) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    phone VARCHAR(20),
    university VARCHAR(50),
    trust_score INT DEFAULT 25,
    avatar VARCHAR(4),
    member_since DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Rooms
CREATE TABLE IF NOT EXISTS rooms (
    id VARCHAR(36) PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL,
    district VARCHAR(50),
    lat DECIMAL(10,6),
    lng DECIMAL(10,6),
    walk_time_min INT,
    size_sqm DECIMAL(5,1),
    room_type ENUM('private','shared','studio') DEFAULT 'private',
    amenities JSON,
    image_urls JSON,
    verification_level INT DEFAULT 0,
    trust_score INT DEFAULT 0,
    owner_id VARCHAR(36),
    owner_name VARCHAR(100),
    owner_avatar VARCHAR(4),
    owner_rating DECIMAL(2,1) DEFAULT 0,
    accepts_couples BOOLEAN DEFAULT FALSE,
    accepts_pets BOOLEAN DEFAULT FALSE,
    accepts_foreigners BOOLEAN DEFAULT TRUE,
    is_furnished BOOLEAN DEFAULT FALSE,
    is_active BOOLEAN DEFAULT TRUE,
    is_featured BOOLEAN DEFAULT FALSE,
    is_urgent BOOLEAN DEFAULT FALSE,
    deposit_amount DECIMAL(10,2),
    utilities_cost DECIMAL(10,2) DEFAULT 0,
    min_contract_months INT DEFAULT 6,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (owner_id) REFERENCES users(id)
);

-- Contracts
CREATE TABLE IF NOT EXISTS contracts (
    id VARCHAR(36) PRIMARY KEY,
    room_id VARCHAR(36),
    room_title VARCHAR(200),
    tenant_id VARCHAR(36),
    tenant_name VARCHAR(100),
    tenant_dni VARCHAR(8),
    tenant_email VARCHAR(100),
    tenant_phone VARCHAR(20),
    owner_id VARCHAR(36),
    owner_name VARCHAR(100),
    monthly_rent DECIMAL(10,2),
    start_date DATE,
    end_date DATE,
    status ENUM('active','completed','cancelled') DEFAULT 'active',
    signed_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (room_id) REFERENCES rooms(id),
    FOREIGN KEY (tenant_id) REFERENCES users(id)
);

-- Reviews
CREATE TABLE IF NOT EXISTS reviews (
    id VARCHAR(36) PRIMARY KEY,
    room_id VARCHAR(36),
    reviewer_id VARCHAR(36),
    reviewer_name VARCHAR(100),
    rating INT NOT NULL,
    title VARCHAR(200),
    body TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (room_id) REFERENCES rooms(id),
    FOREIGN KEY (reviewer_id) REFERENCES users(id)
);

-- Favorites
CREATE TABLE IF NOT EXISTS favorites (
    id VARCHAR(36) PRIMARY KEY,
    user_id VARCHAR(36),
    room_id VARCHAR(36),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY unique_fav (user_id, room_id),
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (room_id) REFERENCES rooms(id)
);

-- Requests (solicitudes a cuartos)
CREATE TABLE IF NOT EXISTS requests (
    id VARCHAR(36) PRIMARY KEY,
    room_id VARCHAR(36),
    student_id VARCHAR(36),
    student_name VARCHAR(100),
    university VARCHAR(100),
    trust_score INT,
    message TEXT,
    status ENUM('pending','accepted','rejected') DEFAULT 'pending',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (room_id) REFERENCES rooms(id),
    FOREIGN KEY (student_id) REFERENCES users(id)
);
