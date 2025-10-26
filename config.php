<?php
// Configuración de la base de datos
define('DB_HOST', 'localhost');
define('DB_USER', 'root');
define('DB_PASS', '');
define('DB_NAME', 'sistema_ventas');

// Crear conexión
try {
    $conn = new mysqli(DB_HOST, DB_USER, DB_PASS, DB_NAME);

    // Verificar conexión
    if ($conn->connect_error) {
        throw new Exception("Error de conexión: " . $conn->connect_error);
    }

    // Establecer charset UTF-8
    $conn->set_charset("utf8");
} catch (Exception $e) {
    die("Error: " . $e->getMessage());
}

// Función para prevenir SQL Injection
function limpiar_entrada($data)
{
    global $conn;
    $data = trim($data);
    $data = stripslashes($data);
    $data = htmlspecialchars($data);
    return $conn->real_escape_string($data);
}

// Función para formatear precio
function formatear_precio($precio)
{
    return '$' . number_format($precio, 2, ',', '.');
}

// Función para formatear fecha
function formatear_fecha($fecha)
{
    return date('d/m/Y H:i', strtotime($fecha));
}

// Iniciar sesión
session_start();

// Función para verificar si el usuario está logueado
function esta_logueado()
{
    return isset($_SESSION['usuario_id']);
}

// Función para verificar si es admin
function es_admin()
{
    return isset($_SESSION['rol']) && $_SESSION['rol'] === 'admin';
}

// Función para redirigir
function redirigir($url)
{
    header("Location: " . $url);
    exit();
}
