-- Intercambios Sin Fronteras

-- WARNING: Drops existing database if present
DROP DATABASE IF EXISTS universidad_intercambios;
CREATE DATABASE IF NOT EXISTS universidad_intercambios;
USE universidad_intercambios;

-- ==========================
-- GEOGRAPHICAL CHARTS
-- ==========================
CREATE TABLE IF NOT EXISTS estados (
    id_estado INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS municipios (
    id_municipio INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    id_estado INT NOT NULL,
    FOREIGN KEY (id_estado) REFERENCES estados(id_estado)
);

CREATE TABLE IF NOT EXISTS colonias (
    id_colonia INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    CP VARCHAR(10) NOT NULL,
    id_municipio INT NOT NULL,
    FOREIGN KEY (id_municipio) REFERENCES municipios(id_municipio)
);

CREATE TABLE IF NOT EXISTS direcciones (
    id_direccion INT AUTO_INCREMENT PRIMARY KEY,
    calle VARCHAR(100) NOT NULL,
    num_ext VARCHAR(10) NOT NULL,
    num_int VARCHAR(10),
    id_colonia INT NOT NULL,
    FOREIGN KEY (id_colonia) REFERENCES colonias(id_colonia)
);

-- ==========================
-- MAIN TABLES
-- ==========================
CREATE TABLE IF NOT EXISTS nacionalidades (
    id_nacionalidad INT AUTO_INCREMENT PRIMARY KEY,
    nacionalidad VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS idiomas (
    id_idioma INT AUTO_INCREMENT PRIMARY KEY,
    idioma VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS alumnos (
    id_alumno INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido_paterno VARCHAR(100) NOT NULL,
    apellido_materno VARCHAR(100) NOT NULL,
    fecha_nacimiento DATE NOT NULL,
    sexo ENUM('M','F','Otro') NOT NULL,
    telefono VARCHAR(20) NOT NULL,
    nivel_idioma VARCHAR(10) NOT NULL,
    correo VARCHAR(100) NOT NULL UNIQUE,
    id_direccion INT NOT NULL,
    promedio DECIMAL(3,2) NOT NULL CHECK (promedio BETWEEN 0 AND 10),
    id_nacionalidad INT NOT NULL,
    tipo ENUM('local', 'intercambio') NOT NULL, 
    FOREIGN KEY (id_direccion) REFERENCES direcciones(id_direccion),
    FOREIGN KEY (id_nacionalidad) REFERENCES nacionalidades(id_nacionalidad),
    UNIQUE(nombre, apellido_paterno, apellido_materno, fecha_nacimiento)
);

CREATE TABLE IF NOT EXISTS usuarios (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    nombre_usuario VARCHAR(50) NOT NULL UNIQUE,
    contrasena VARCHAR(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS universidades (
    id_universidad INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(150) NOT NULL UNIQUE,
    pais VARCHAR(100) NOT NULL,
    idioma VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS solicitud (
    id_solicitud INT AUTO_INCREMENT PRIMARY KEY,
    id_alumno INT NOT NULL,
    estatus VARCHAR(50) NOT NULL,
    fecha_solicitud DATE NOT NULL,
    FOREIGN KEY (id_alumno) REFERENCES alumnos(id_alumno)
);

CREATE TABLE IF NOT EXISTS intercambio (
    id_intercambio INT AUTO_INCREMENT PRIMARY KEY,
    id_solicitud INT NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NOT NULL,
    id_universidad INT NOT NULL,
    alumno_recibido VARCHAR(100) NOT NULL,
    FOREIGN KEY (id_solicitud) REFERENCES solicitud(id_solicitud),
    FOREIGN KEY (id_universidad) REFERENCES universidades(id_universidad),
    CHECK (TIMESTAMPDIFF(MONTH, fecha_inicio, fecha_fin) BETWEEN 6 AND 12)
);



CREATE TABLE IF NOT EXISTS alumno_idioma (
    id_alumno INT NOT NULL,
    id_idioma INT NOT NULL,
    PRIMARY KEY (id_alumno, id_idioma),
    FOREIGN KEY (id_alumno) REFERENCES alumnos(id_alumno),
    FOREIGN KEY (id_idioma) REFERENCES idiomas(id_idioma)
);
