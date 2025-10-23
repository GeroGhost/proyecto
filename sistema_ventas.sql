-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 23-10-2025 a las 10:12:43
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `sistema_ventas`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `categorias`
--

CREATE TABLE `categorias` (
  `id` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `estado` tinyint(1) DEFAULT 1,
  `fecha_creacion` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `categorias`
--

INSERT INTO `categorias` (`id`, `nombre`, `descripcion`, `estado`, `fecha_creacion`) VALUES
(1, 'Electrónica', 'Productos electrónicos y tecnología', 1, '2025-10-22 18:36:14'),
(2, 'Ropa', 'Prendas de vestir y accesorios', 1, '2025-10-22 18:36:14'),
(3, 'Alimentos', 'Productos alimenticios', 1, '2025-10-22 18:36:14'),
(4, 'Hogar', 'Artículos para el hogar', 1, '2025-10-22 18:36:14'),
(5, 'Deportes', 'Artículos deportivos', 1, '2025-10-22 18:36:14');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `clientes`
--

CREATE TABLE `clientes` (
  `id` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `apellido` varchar(100) NOT NULL,
  `email` varchar(100) DEFAULT NULL,
  `telefono` varchar(20) DEFAULT NULL,
  `direccion` text DEFAULT NULL,
  `dni` varchar(20) DEFAULT NULL,
  `estado` tinyint(1) DEFAULT 1,
  `fecha_creacion` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `clientes`
--

INSERT INTO `clientes` (`id`, `nombre`, `apellido`, `email`, `telefono`, `direccion`, `dni`, `estado`, `fecha_creacion`) VALUES
(1, 'Juan', 'Pérez', 'juan@email.com', '3875551234', 'Av. Belgrano 123', '12345678', 1, '2025-10-22 18:36:14'),
(2, 'María', 'González', 'maria@email.com', '3875555678', 'Calle Alvarado 456', '23456789', 1, '2025-10-22 18:36:14'),
(3, 'Carlos', 'López', 'carlos@email.com', '3875559012', 'Av. Sarmiento 789', '34567890', 1, '2025-10-22 18:36:14'),
(4, 'Ana', 'Martínez', 'ana@email.com', '3875553456', 'Calle Mitre 321', '45678901', 1, '2025-10-22 18:36:14'),
(5, 'Jose', 'Saravia', 'josesaravia303@gmail.com', '3871235353', 'Coronel Moldes', '46787907', 0, '2025-10-22 18:38:17');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `compras`
--

CREATE TABLE `compras` (
  `id` int(11) NOT NULL,
  `proveedor_id` int(11) NOT NULL,
  `numero_comprobante` varchar(50) DEFAULT NULL,
  `fecha_compra` date NOT NULL,
  `fecha_vencimiento` date DEFAULT NULL,
  `subtotal` decimal(10,2) NOT NULL,
  `iva` decimal(10,2) DEFAULT 0.00,
  `total` decimal(10,2) NOT NULL,
  `estado` enum('pendiente','pagada','vencida','anulada') DEFAULT 'pendiente',
  `observaciones` text DEFAULT NULL,
  `usuario_id` int(11) NOT NULL,
  `fecha_creacion` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cuentas_corrientes`
--

CREATE TABLE `cuentas_corrientes` (
  `id` int(11) NOT NULL,
  `cliente_id` int(11) NOT NULL,
  `tipo_movimiento` enum('debe','haber') NOT NULL,
  `concepto` varchar(255) NOT NULL,
  `factura_id` int(11) DEFAULT NULL,
  `importe` decimal(10,2) NOT NULL,
  `saldo` decimal(10,2) NOT NULL,
  `fecha_movimiento` date NOT NULL,
  `observaciones` text DEFAULT NULL,
  `usuario_id` int(11) NOT NULL,
  `fecha_creacion` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `cuentas_corrientes`
--

INSERT INTO `cuentas_corrientes` (`id`, `cliente_id`, `tipo_movimiento`, `concepto`, `factura_id`, `importe`, `saldo`, `fecha_movimiento`, `observaciones`, `usuario_id`, `fecha_creacion`) VALUES
(1, 1, 'debe', 'Factura 0001-00000004', 4, 60500.00, 60500.00, '2025-10-01', 'Venta a crédito', 1, '2025-10-23 06:57:38'),
(2, 1, 'haber', 'Pago parcial', 4, 20000.00, 40500.00, '2025-10-10', 'Pago en efectivo', 1, '2025-10-23 06:57:38'),
(3, 2, 'debe', 'Factura 0001-00000005', 5, 42350.00, 42350.00, '2025-10-05', 'Pago en 3 cuotas', 1, '2025-10-23 06:57:38'),
(4, 2, 'haber', 'Primera cuota', 5, 14116.67, 28233.33, '2025-10-12', 'Cuota 1/3', 1, '2025-10-23 06:57:38'),
(5, 3, 'debe', 'Factura 0001-00000006', 6, 33880.00, 33880.00, '2025-10-10', 'Crédito 30 días', 1, '2025-10-23 06:57:38'),
(6, 3, 'haber', 'Pago parcial', 6, 10000.00, 23880.00, '2025-10-15', 'Transferencia', 1, '2025-10-23 06:57:38'),
(7, 4, 'debe', 'Factura 0001-00000007', 7, 54450.00, 54450.00, '2025-10-15', 'Factura pendiente', 1, '2025-10-23 06:57:38');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detalle_compras`
--

CREATE TABLE `detalle_compras` (
  `id` int(11) NOT NULL,
  `compra_id` int(11) NOT NULL,
  `producto_id` int(11) DEFAULT NULL,
  `descripcion` varchar(255) NOT NULL,
  `cantidad` int(11) NOT NULL,
  `precio_unitario` decimal(10,2) NOT NULL,
  `subtotal` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detalle_facturas`
--

CREATE TABLE `detalle_facturas` (
  `id` int(11) NOT NULL,
  `factura_id` int(11) NOT NULL,
  `producto_id` int(11) DEFAULT NULL,
  `descripcion` varchar(255) NOT NULL,
  `cantidad` int(11) NOT NULL,
  `precio_unitario` decimal(10,2) NOT NULL,
  `subtotal` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detalle_ventas`
--

CREATE TABLE `detalle_ventas` (
  `id` int(11) NOT NULL,
  `venta_id` int(11) NOT NULL,
  `producto_id` int(11) NOT NULL,
  `cantidad` int(11) NOT NULL,
  `precio_unitario` decimal(10,2) NOT NULL,
  `subtotal` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `detalle_ventas`
--

INSERT INTO `detalle_ventas` (`id`, `venta_id`, `producto_id`, `cantidad`, `precio_unitario`, `subtotal`) VALUES
(1, 1, 1, 1, 45000.00, 45000.00),
(2, 1, 2, 1, 1500.00, 1500.00),
(3, 1, 3, 1, 3500.00, 3500.00),
(4, 2, 4, 2, 2500.00, 5000.00),
(5, 2, 6, 1, 500.00, 500.00),
(6, 3, 8, 1, 15000.00, 15000.00),
(7, 3, 7, 1, 800.00, 800.00),
(8, 4, 9, 1, 5000.00, 5000.00),
(9, 4, 5, 1, 3000.00, 3000.00),
(10, 5, 10, 3, 250000.00, 750000.00),
(11, 6, 2, 1, 1500.00, 1500.00),
(12, 6, 2, 2, 1500.00, 3000.00),
(13, 7, 5, 2, 3000.00, 6000.00),
(14, 7, 8, 3, 15000.00, 45000.00),
(15, 7, 5, 2, 3000.00, 6000.00),
(16, 8, 1, 1, 45000.00, 45000.00),
(17, 9, 4, 2, 2500.00, 5000.00),
(18, 9, 5, 2, 3000.00, 6000.00),
(19, 9, 9, 1, 5000.00, 5000.00),
(20, 10, 8, 1, 15000.00, 15000.00),
(21, 10, 1, 3, 45000.00, 135000.00),
(22, 11, 4, 1, 2500.00, 2500.00),
(23, 11, 1, 3, 45000.00, 135000.00),
(24, 11, 9, 2, 5000.00, 10000.00),
(25, 12, 6, 3, 500.00, 1500.00),
(26, 13, 5, 3, 3000.00, 9000.00),
(27, 14, 6, 3, 500.00, 1500.00),
(28, 14, 7, 1, 800.00, 800.00),
(29, 15, 9, 2, 5000.00, 10000.00),
(30, 16, 4, 3, 2500.00, 7500.00),
(31, 16, 7, 3, 800.00, 2400.00),
(32, 16, 6, 1, 500.00, 500.00),
(33, 17, 7, 2, 800.00, 1600.00),
(34, 17, 1, 1, 45000.00, 45000.00),
(35, 17, 1, 3, 45000.00, 135000.00),
(36, 18, 9, 3, 5000.00, 15000.00),
(37, 18, 4, 1, 2500.00, 2500.00),
(38, 19, 6, 3, 500.00, 1500.00),
(39, 20, 7, 1, 800.00, 800.00),
(40, 21, 3, 1, 3500.00, 3500.00),
(41, 21, 7, 2, 800.00, 1600.00),
(42, 21, 9, 1, 5000.00, 5000.00),
(43, 22, 2, 1, 1500.00, 1500.00),
(44, 22, 4, 2, 2500.00, 5000.00),
(45, 22, 6, 3, 500.00, 1500.00),
(46, 23, 4, 2, 2500.00, 5000.00),
(47, 24, 5, 1, 3000.00, 3000.00),
(48, 24, 7, 1, 800.00, 800.00),
(49, 24, 5, 1, 3000.00, 3000.00),
(50, 25, 8, 3, 15000.00, 45000.00),
(51, 25, 3, 1, 3500.00, 3500.00),
(52, 26, 5, 2, 3000.00, 6000.00),
(53, 26, 1, 1, 45000.00, 45000.00),
(54, 27, 3, 1, 3500.00, 3500.00),
(55, 28, 5, 1, 3000.00, 3000.00),
(56, 29, 5, 2, 3000.00, 6000.00),
(57, 30, 2, 2, 1500.00, 3000.00),
(58, 30, 7, 1, 800.00, 800.00),
(59, 31, 2, 3, 1500.00, 4500.00),
(60, 32, 2, 3, 1500.00, 4500.00),
(61, 32, 1, 3, 45000.00, 135000.00),
(62, 33, 6, 3, 500.00, 1500.00),
(63, 33, 5, 3, 3000.00, 9000.00),
(64, 33, 7, 2, 800.00, 1600.00),
(65, 34, 5, 2, 3000.00, 6000.00),
(66, 34, 9, 1, 5000.00, 5000.00),
(67, 35, 1, 2, 45000.00, 90000.00),
(68, 35, 3, 3, 3500.00, 10500.00),
(69, 35, 5, 2, 3000.00, 6000.00),
(70, 36, 9, 2, 5000.00, 10000.00),
(71, 36, 2, 1, 1500.00, 1500.00),
(72, 37, 7, 2, 800.00, 1600.00),
(73, 37, 7, 2, 800.00, 1600.00),
(74, 37, 5, 3, 3000.00, 9000.00),
(75, 38, 1, 1, 45000.00, 45000.00),
(76, 38, 1, 3, 45000.00, 135000.00),
(77, 38, 5, 3, 3000.00, 9000.00),
(78, 39, 5, 2, 3000.00, 6000.00),
(79, 39, 3, 2, 3500.00, 7000.00),
(80, 39, 2, 3, 1500.00, 4500.00),
(81, 40, 8, 1, 15000.00, 15000.00),
(82, 41, 2, 3, 1500.00, 4500.00),
(83, 41, 9, 2, 5000.00, 10000.00),
(84, 42, 6, 1, 500.00, 500.00),
(85, 42, 3, 3, 3500.00, 10500.00),
(86, 43, 9, 2, 5000.00, 10000.00),
(87, 44, 1, 1, 45000.00, 45000.00),
(88, 44, 1, 2, 45000.00, 90000.00),
(89, 44, 2, 2, 1500.00, 3000.00),
(90, 45, 1, 2, 45000.00, 90000.00),
(91, 45, 7, 2, 800.00, 1600.00),
(92, 46, 5, 3, 3000.00, 9000.00),
(93, 47, 9, 2, 5000.00, 10000.00),
(94, 47, 1, 1, 45000.00, 45000.00),
(95, 47, 3, 1, 3500.00, 3500.00),
(96, 48, 7, 2, 800.00, 1600.00),
(97, 49, 5, 1, 3000.00, 3000.00),
(98, 50, 2, 2, 1500.00, 3000.00),
(99, 50, 9, 3, 5000.00, 15000.00),
(100, 50, 9, 3, 5000.00, 15000.00),
(101, 51, 3, 3, 3500.00, 10500.00),
(102, 52, 7, 2, 800.00, 1600.00);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `facturas`
--

CREATE TABLE `facturas` (
  `id` int(11) NOT NULL,
  `numero_factura` varchar(50) NOT NULL,
  `tipo` enum('A','B','C') NOT NULL,
  `tipo_comprobante` enum('factura','nota_credito','nota_debito','recibo','presupuesto') NOT NULL,
  `cliente_id` int(11) NOT NULL,
  `fecha_emision` date NOT NULL,
  `fecha_vencimiento` date DEFAULT NULL,
  `subtotal` decimal(10,2) NOT NULL,
  `iva` decimal(10,2) DEFAULT 0.00,
  `total` decimal(10,2) NOT NULL,
  `estado` enum('pendiente','pagada','vencida','anulada') DEFAULT 'pendiente',
  `observaciones` text DEFAULT NULL,
  `usuario_id` int(11) NOT NULL,
  `fecha_creacion` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `facturas`
--

INSERT INTO `facturas` (`id`, `numero_factura`, `tipo`, `tipo_comprobante`, `cliente_id`, `fecha_emision`, `fecha_vencimiento`, `subtotal`, `iva`, `total`, `estado`, `observaciones`, `usuario_id`, `fecha_creacion`) VALUES
(1, '0001-00000001', 'B', 'factura', 1, '2025-10-22', '2025-11-21', 10000.00, 2100.00, 12100.00, 'pendiente', NULL, 1, '2025-10-22 19:02:42'),
(2, '0001-00000002', 'B', 'factura', 2, '2025-10-22', '2025-11-21', 5000.00, 1050.00, 6050.00, 'pagada', NULL, 1, '2025-10-22 19:02:42'),
(3, '0001-00000003', 'B', 'presupuesto', 3, '2025-10-22', NULL, 15000.00, 3150.00, 18150.00, 'pendiente', NULL, 1, '2025-10-22 19:02:42'),
(4, '0001-00000004', 'B', 'factura', 1, '2025-10-01', '2025-10-31', 50000.00, 10500.00, 60500.00, 'pendiente', 'Factura a crédito', 1, '2025-10-23 06:57:38'),
(5, '0001-00000005', 'B', 'factura', 2, '2025-10-01', '2025-10-31', 35000.00, 7350.00, 42350.00, 'pendiente', 'Factura a crédito', 1, '2025-10-23 06:57:38'),
(6, '0001-00000006', 'B', 'factura', 3, '2025-10-01', '2025-10-31', 28000.00, 5880.00, 33880.00, 'pendiente', 'Factura a crédito', 1, '2025-10-23 06:57:38'),
(7, '0001-00000007', 'B', 'factura', 4, '2025-10-01', '2025-10-31', 45000.00, 9450.00, 54450.00, 'pendiente', 'Factura a crédito', 1, '2025-10-23 06:57:38');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `gastos`
--

CREATE TABLE `gastos` (
  `id` int(11) NOT NULL,
  `concepto` varchar(255) NOT NULL,
  `categoria` enum('servicios','alquiler','sueldos','impuestos','mantenimiento','otros') NOT NULL,
  `importe` decimal(10,2) NOT NULL,
  `fecha_gasto` date NOT NULL,
  `metodo_pago` enum('efectivo','tarjeta','transferencia','cheque') NOT NULL,
  `numero_comprobante` varchar(100) DEFAULT NULL,
  `proveedor_id` int(11) DEFAULT NULL,
  `observaciones` text DEFAULT NULL,
  `usuario_id` int(11) NOT NULL,
  `fecha_creacion` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `gastos`
--

INSERT INTO `gastos` (`id`, `concepto`, `categoria`, `importe`, `fecha_gasto`, `metodo_pago`, `numero_comprobante`, `proveedor_id`, `observaciones`, `usuario_id`, `fecha_creacion`) VALUES
(1, 'Luz y gas', 'servicios', 5000.00, '2025-10-22', 'transferencia', NULL, NULL, NULL, 1, '2025-10-22 19:02:42'),
(2, 'Alquiler local', 'alquiler', 25000.00, '2025-10-22', 'transferencia', NULL, NULL, NULL, 1, '2025-10-22 19:02:42'),
(3, 'Mantenimiento PC', 'mantenimiento', 3000.00, '2025-10-22', 'efectivo', NULL, NULL, NULL, 1, '2025-10-22 19:02:42');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `movimientos_caja`
--

CREATE TABLE `movimientos_caja` (
  `id` int(11) NOT NULL,
  `tipo` enum('ingreso','egreso') NOT NULL,
  `concepto` varchar(255) NOT NULL,
  `categoria` enum('venta','compra','gasto','pago_proveedor','cobro_cliente','otro') NOT NULL,
  `importe` decimal(10,2) NOT NULL,
  `metodo_pago` enum('efectivo','tarjeta','transferencia','cheque') NOT NULL,
  `referencia` varchar(100) DEFAULT NULL,
  `fecha_movimiento` date NOT NULL,
  `cliente_id` int(11) DEFAULT NULL,
  `proveedor_id` int(11) DEFAULT NULL,
  `factura_id` int(11) DEFAULT NULL,
  `observaciones` text DEFAULT NULL,
  `usuario_id` int(11) NOT NULL,
  `fecha_creacion` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `movimientos_caja`
--

INSERT INTO `movimientos_caja` (`id`, `tipo`, `concepto`, `categoria`, `importe`, `metodo_pago`, `referencia`, `fecha_movimiento`, `cliente_id`, `proveedor_id`, `factura_id`, `observaciones`, `usuario_id`, `fecha_creacion`) VALUES
(1, 'ingreso', 'Venta del día', 'venta', 50000.00, 'efectivo', NULL, '2025-10-22', NULL, NULL, NULL, NULL, 1, '2025-10-22 19:02:42'),
(2, 'egreso', 'Pago luz', 'gasto', 5000.00, 'transferencia', NULL, '2025-10-22', NULL, NULL, NULL, NULL, 1, '2025-10-22 19:02:42'),
(3, 'ingreso', 'Cobro cliente', 'cobro_cliente', 12000.00, 'transferencia', NULL, '2025-10-22', NULL, NULL, NULL, NULL, 1, '2025-10-22 19:02:42'),
(4, 'ingreso', 'Cobro cliente', 'cobro_cliente', 280000.00, 'efectivo', '', '2025-10-22', NULL, NULL, NULL, 'Un Crack', 1, '2025-10-22 19:23:45'),
(5, 'egreso', 'Pago de servicio', 'gasto', 350000.00, 'efectivo', '', '2025-10-22', NULL, NULL, NULL, 'xd', 1, '2025-10-22 19:24:45'),
(6, 'ingreso', 'Electronica', 'venta', 10000.00, 'efectivo', '', '2025-10-23', NULL, NULL, NULL, '', 1, '2025-10-23 07:19:27');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `pagos`
--

CREATE TABLE `pagos` (
  `id` int(11) NOT NULL,
  `tipo_comprobante` enum('factura','compra') NOT NULL,
  `comprobante_id` int(11) NOT NULL,
  `fecha_pago` date NOT NULL,
  `importe` decimal(10,2) NOT NULL,
  `metodo_pago` enum('efectivo','tarjeta','transferencia','cheque') NOT NULL,
  `numero_referencia` varchar(100) DEFAULT NULL,
  `observaciones` text DEFAULT NULL,
  `usuario_id` int(11) NOT NULL,
  `fecha_creacion` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `productos`
--

CREATE TABLE `productos` (
  `id` int(11) NOT NULL,
  `nombre` varchar(200) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `precio` decimal(10,2) NOT NULL,
  `stock` int(11) NOT NULL DEFAULT 0,
  `categoria_id` int(11) DEFAULT NULL,
  `imagen` varchar(255) DEFAULT NULL,
  `estado` tinyint(1) DEFAULT 1,
  `fecha_creacion` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `productos`
--

INSERT INTO `productos` (`id`, `nombre`, `descripcion`, `precio`, `stock`, `categoria_id`, `imagen`, `estado`, `fecha_creacion`) VALUES
(1, 'Laptop HP', 'Laptop HP Intel Core i5, 8GB RAM, 256GB SSD', 45000.00, 10, 1, NULL, 1, '2025-10-22 18:36:14'),
(2, 'Mouse Logitech', 'Mouse inalámbrico Logitech', 1500.00, 50, 1, NULL, 1, '2025-10-22 18:36:14'),
(3, 'Teclado Mecánico', 'Teclado mecánico RGB', 3500.00, 25, 1, NULL, 1, '2025-10-22 18:36:14'),
(4, 'Remera Nike', 'Remera deportiva Nike', 2500.00, 100, 2, NULL, 1, '2025-10-22 18:36:14'),
(5, 'Pantalón Jean', 'Pantalón jean azul', 3000.00, 75, 2, NULL, 1, '2025-10-22 18:36:14'),
(6, 'Arroz 1kg', 'Arroz blanco 1kg', 500.00, 200, 3, NULL, 1, '2025-10-22 18:36:14'),
(7, 'Aceite 900ml', 'Aceite de girasol', 800.00, 150, 3, NULL, 1, '2025-10-22 18:36:14'),
(8, 'Silla de Oficina', 'Silla ergonómica', 15000.00, 20, 4, NULL, 1, '2025-10-22 18:36:14'),
(9, 'Pelota de Fútbol', 'Pelota oficial', 5000.00, 30, 5, NULL, 1, '2025-10-22 18:36:14'),
(10, 'Celular', 'Moto E6 plus', 250000.00, 3, 1, NULL, 1, '2025-10-22 18:37:32');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `proveedores`
--

CREATE TABLE `proveedores` (
  `id` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `razon_social` varchar(200) DEFAULT NULL,
  `cuit` varchar(20) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `telefono` varchar(20) DEFAULT NULL,
  `direccion` text DEFAULT NULL,
  `ciudad` varchar(100) DEFAULT NULL,
  `provincia` varchar(100) DEFAULT NULL,
  `codigo_postal` varchar(10) DEFAULT NULL,
  `contacto_nombre` varchar(100) DEFAULT NULL,
  `contacto_telefono` varchar(20) DEFAULT NULL,
  `estado` tinyint(1) DEFAULT 1,
  `fecha_creacion` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `proveedores`
--

INSERT INTO `proveedores` (`id`, `nombre`, `razon_social`, `cuit`, `email`, `telefono`, `direccion`, `ciudad`, `provincia`, `codigo_postal`, `contacto_nombre`, `contacto_telefono`, `estado`, `fecha_creacion`) VALUES
(1, 'Distribuidora Tech SA', 'Distribuidora Tech SA', '20-12345678-9', 'ventas@distritech.com', '3875551111', 'Av. Circunvalación 100', NULL, NULL, NULL, 'Juan Pérez', '3875552222', 1, '2025-10-22 19:02:42'),
(2, 'Mayorista Textil SRL', 'Mayorista Textil SRL', '30-23456789-0', 'info@mayotextil.com', '3875553333', 'Calle Comercio 250', NULL, NULL, NULL, 'María López', '3875554444', 1, '2025-10-22 19:02:42'),
(3, 'Alimentos del Norte', 'Alimentos del Norte SA', '20-34567890-1', 'compras@alinorte.com', '3875555555', 'Ruta 9 Km 15', NULL, NULL, NULL, 'Carlos Gómez', '3875556666', 1, '2025-10-22 19:02:42');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

CREATE TABLE `usuarios` (
  `id` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `rol` enum('admin','vendedor') DEFAULT 'vendedor',
  `fecha_creacion` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `usuarios`
--

INSERT INTO `usuarios` (`id`, `nombre`, `email`, `password`, `rol`, `fecha_creacion`) VALUES
(1, 'Administrador', 'admin@sistema.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'admin', '2025-10-22 18:36:14');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ventas`
--

CREATE TABLE `ventas` (
  `id` int(11) NOT NULL,
  `cliente_id` int(11) NOT NULL,
  `usuario_id` int(11) NOT NULL,
  `total` decimal(10,2) NOT NULL,
  `metodo_pago` enum('efectivo','tarjeta','transferencia') NOT NULL,
  `estado` enum('pendiente','completada','cancelada') DEFAULT 'completada',
  `fecha_venta` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `ventas`
--

INSERT INTO `ventas` (`id`, `cliente_id`, `usuario_id`, `total`, `metodo_pago`, `estado`, `fecha_venta`) VALUES
(1, 1, 1, 48500.00, 'tarjeta', 'completada', '2025-10-22 18:36:14'),
(2, 2, 1, 5500.00, 'efectivo', 'completada', '2025-10-22 18:36:14'),
(3, 3, 1, 15800.00, 'transferencia', 'completada', '2025-10-22 18:36:14'),
(4, 4, 1, 8000.00, 'efectivo', 'completada', '2025-10-22 18:36:14'),
(5, 5, 1, 750000.00, 'tarjeta', 'completada', '2025-10-22 18:39:30'),
(6, 4, 1, 4500.00, 'efectivo', 'completada', '2025-10-21 15:50:00'),
(7, 2, 1, 57000.00, 'efectivo', 'completada', '2025-10-10 17:26:00'),
(8, 4, 1, 45000.00, 'transferencia', 'completada', '2025-10-21 14:22:00'),
(9, 2, 1, 16000.00, 'efectivo', 'completada', '2025-10-01 13:36:00'),
(10, 2, 1, 150000.00, 'transferencia', 'completada', '2025-09-09 14:39:00'),
(11, 2, 1, 147500.00, 'tarjeta', 'completada', '2025-09-02 13:33:00'),
(12, 2, 1, 1500.00, 'tarjeta', 'completada', '2025-09-02 19:21:00'),
(13, 2, 1, 9000.00, 'efectivo', 'completada', '2025-08-08 13:48:00'),
(14, 1, 1, 2300.00, 'tarjeta', 'completada', '2025-08-14 14:45:00'),
(15, 2, 1, 10000.00, 'transferencia', 'completada', '2025-08-02 15:20:00'),
(16, 3, 1, 10400.00, 'transferencia', 'completada', '2025-08-09 15:31:00'),
(17, 1, 1, 181600.00, 'transferencia', 'completada', '2025-08-22 16:20:00'),
(18, 3, 1, 17500.00, 'tarjeta', 'completada', '2025-07-21 21:03:00'),
(19, 2, 1, 1500.00, 'efectivo', 'completada', '2025-07-21 15:57:00'),
(20, 4, 1, 800.00, 'efectivo', 'completada', '2025-07-13 13:00:00'),
(21, 4, 1, 10100.00, 'tarjeta', 'completada', '2025-06-26 17:08:00'),
(22, 2, 1, 8000.00, 'efectivo', 'completada', '2025-06-05 19:49:00'),
(23, 4, 1, 5000.00, 'transferencia', 'completada', '2025-06-15 16:55:00'),
(24, 2, 1, 6800.00, 'tarjeta', 'completada', '2025-06-05 15:38:00'),
(25, 3, 1, 48500.00, 'transferencia', 'completada', '2025-05-15 17:30:00'),
(26, 2, 1, 51000.00, 'tarjeta', 'completada', '2025-05-14 18:15:00'),
(27, 2, 1, 3500.00, 'tarjeta', 'completada', '2025-05-22 16:23:00'),
(28, 2, 1, 3000.00, 'tarjeta', 'completada', '2025-05-02 14:52:00'),
(29, 1, 1, 6000.00, 'efectivo', 'completada', '2025-05-04 14:05:00'),
(30, 1, 1, 3800.00, 'efectivo', 'completada', '2025-10-07 20:29:00'),
(31, 3, 1, 4500.00, 'transferencia', 'completada', '2025-10-20 14:06:00'),
(32, 4, 1, 139500.00, 'tarjeta', 'completada', '2025-10-26 18:06:00'),
(33, 2, 1, 12100.00, 'transferencia', 'completada', '2025-10-14 14:31:00'),
(34, 2, 1, 11000.00, 'efectivo', 'completada', '2025-09-27 12:08:00'),
(35, 1, 1, 106500.00, 'transferencia', 'completada', '2025-09-23 20:11:00'),
(36, 2, 1, 11500.00, 'transferencia', 'completada', '2025-09-28 17:47:00'),
(37, 1, 1, 12200.00, 'tarjeta', 'completada', '2025-08-14 15:37:00'),
(38, 1, 1, 189000.00, 'tarjeta', 'completada', '2025-08-23 13:49:00'),
(39, 4, 1, 17500.00, 'transferencia', 'completada', '2025-08-17 20:24:00'),
(40, 3, 1, 15000.00, 'efectivo', 'completada', '2025-08-04 20:33:00'),
(41, 4, 1, 14500.00, 'tarjeta', 'completada', '2025-07-09 19:18:00'),
(42, 1, 1, 11000.00, 'efectivo', 'completada', '2025-07-05 20:43:00'),
(43, 3, 1, 10000.00, 'efectivo', 'completada', '2025-07-18 15:53:00'),
(44, 2, 1, 138000.00, 'transferencia', 'completada', '2025-06-10 21:34:00'),
(45, 4, 1, 91600.00, 'transferencia', 'completada', '2025-06-08 14:12:00'),
(46, 3, 1, 9000.00, 'tarjeta', 'completada', '2025-06-02 18:17:00'),
(47, 3, 1, 58500.00, 'transferencia', 'completada', '2025-06-24 18:09:00'),
(48, 1, 1, 1600.00, 'efectivo', 'completada', '2025-06-21 15:23:00'),
(49, 4, 1, 3000.00, 'tarjeta', 'completada', '2025-05-20 21:06:00'),
(50, 4, 1, 33000.00, 'tarjeta', 'completada', '2025-05-07 18:01:00'),
(51, 2, 1, 10500.00, 'efectivo', 'completada', '2025-05-06 12:24:00'),
(52, 1, 1, 1600.00, 'efectivo', 'completada', '2025-05-10 21:39:00');

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vista_caja_diaria`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vista_caja_diaria` (
`fecha_movimiento` date
,`total_ingresos` decimal(32,2)
,`total_egresos` decimal(32,2)
,`saldo_diario` decimal(32,2)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vista_saldos_clientes`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vista_saldos_clientes` (
`id` int(11)
,`nombre` varchar(100)
,`apellido` varchar(100)
,`total_debe` decimal(32,2)
,`total_haber` decimal(32,2)
,`saldo_actual` decimal(32,2)
);

-- --------------------------------------------------------

--
-- Estructura para la vista `vista_caja_diaria`
--
DROP TABLE IF EXISTS `vista_caja_diaria`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vista_caja_diaria`  AS SELECT `movimientos_caja`.`fecha_movimiento` AS `fecha_movimiento`, sum(case when `movimientos_caja`.`tipo` = 'ingreso' then `movimientos_caja`.`importe` else 0 end) AS `total_ingresos`, sum(case when `movimientos_caja`.`tipo` = 'egreso' then `movimientos_caja`.`importe` else 0 end) AS `total_egresos`, sum(case when `movimientos_caja`.`tipo` = 'ingreso' then `movimientos_caja`.`importe` else -`movimientos_caja`.`importe` end) AS `saldo_diario` FROM `movimientos_caja` GROUP BY `movimientos_caja`.`fecha_movimiento` ORDER BY `movimientos_caja`.`fecha_movimiento` DESC ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vista_saldos_clientes`
--
DROP TABLE IF EXISTS `vista_saldos_clientes`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vista_saldos_clientes`  AS SELECT `c`.`id` AS `id`, `c`.`nombre` AS `nombre`, `c`.`apellido` AS `apellido`, coalesce(sum(case when `cc`.`tipo_movimiento` = 'debe' then `cc`.`importe` else 0 end),0) AS `total_debe`, coalesce(sum(case when `cc`.`tipo_movimiento` = 'haber' then `cc`.`importe` else 0 end),0) AS `total_haber`, coalesce(sum(case when `cc`.`tipo_movimiento` = 'debe' then `cc`.`importe` else -`cc`.`importe` end),0) AS `saldo_actual` FROM (`clientes` `c` left join `cuentas_corrientes` `cc` on(`c`.`id` = `cc`.`cliente_id`)) GROUP BY `c`.`id`, `c`.`nombre`, `c`.`apellido` ;

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `categorias`
--
ALTER TABLE `categorias`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `clientes`
--
ALTER TABLE `clientes`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `dni` (`dni`);

--
-- Indices de la tabla `compras`
--
ALTER TABLE `compras`
  ADD PRIMARY KEY (`id`),
  ADD KEY `usuario_id` (`usuario_id`),
  ADD KEY `idx_compras_proveedor` (`proveedor_id`);

--
-- Indices de la tabla `cuentas_corrientes`
--
ALTER TABLE `cuentas_corrientes`
  ADD PRIMARY KEY (`id`),
  ADD KEY `factura_id` (`factura_id`),
  ADD KEY `usuario_id` (`usuario_id`),
  ADD KEY `idx_cuentas_cliente` (`cliente_id`);

--
-- Indices de la tabla `detalle_compras`
--
ALTER TABLE `detalle_compras`
  ADD PRIMARY KEY (`id`),
  ADD KEY `compra_id` (`compra_id`),
  ADD KEY `producto_id` (`producto_id`);

--
-- Indices de la tabla `detalle_facturas`
--
ALTER TABLE `detalle_facturas`
  ADD PRIMARY KEY (`id`),
  ADD KEY `factura_id` (`factura_id`),
  ADD KEY `producto_id` (`producto_id`);

--
-- Indices de la tabla `detalle_ventas`
--
ALTER TABLE `detalle_ventas`
  ADD PRIMARY KEY (`id`),
  ADD KEY `venta_id` (`venta_id`),
  ADD KEY `producto_id` (`producto_id`);

--
-- Indices de la tabla `facturas`
--
ALTER TABLE `facturas`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `numero_factura` (`numero_factura`),
  ADD KEY `usuario_id` (`usuario_id`),
  ADD KEY `idx_facturas_cliente` (`cliente_id`),
  ADD KEY `idx_facturas_estado` (`estado`),
  ADD KEY `idx_facturas_fecha` (`fecha_emision`);

--
-- Indices de la tabla `gastos`
--
ALTER TABLE `gastos`
  ADD PRIMARY KEY (`id`),
  ADD KEY `proveedor_id` (`proveedor_id`),
  ADD KEY `usuario_id` (`usuario_id`);

--
-- Indices de la tabla `movimientos_caja`
--
ALTER TABLE `movimientos_caja`
  ADD PRIMARY KEY (`id`),
  ADD KEY `cliente_id` (`cliente_id`),
  ADD KEY `proveedor_id` (`proveedor_id`),
  ADD KEY `factura_id` (`factura_id`),
  ADD KEY `usuario_id` (`usuario_id`),
  ADD KEY `idx_movimientos_fecha` (`fecha_movimiento`);

--
-- Indices de la tabla `pagos`
--
ALTER TABLE `pagos`
  ADD PRIMARY KEY (`id`),
  ADD KEY `usuario_id` (`usuario_id`);

--
-- Indices de la tabla `productos`
--
ALTER TABLE `productos`
  ADD PRIMARY KEY (`id`),
  ADD KEY `categoria_id` (`categoria_id`);

--
-- Indices de la tabla `proveedores`
--
ALTER TABLE `proveedores`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `cuit` (`cuit`);

--
-- Indices de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indices de la tabla `ventas`
--
ALTER TABLE `ventas`
  ADD PRIMARY KEY (`id`),
  ADD KEY `cliente_id` (`cliente_id`),
  ADD KEY `usuario_id` (`usuario_id`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `categorias`
--
ALTER TABLE `categorias`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `clientes`
--
ALTER TABLE `clientes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `compras`
--
ALTER TABLE `compras`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `cuentas_corrientes`
--
ALTER TABLE `cuentas_corrientes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de la tabla `detalle_compras`
--
ALTER TABLE `detalle_compras`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `detalle_facturas`
--
ALTER TABLE `detalle_facturas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `detalle_ventas`
--
ALTER TABLE `detalle_ventas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=103;

--
-- AUTO_INCREMENT de la tabla `facturas`
--
ALTER TABLE `facturas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de la tabla `gastos`
--
ALTER TABLE `gastos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `movimientos_caja`
--
ALTER TABLE `movimientos_caja`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT de la tabla `pagos`
--
ALTER TABLE `pagos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `productos`
--
ALTER TABLE `productos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT de la tabla `proveedores`
--
ALTER TABLE `proveedores`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `ventas`
--
ALTER TABLE `ventas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=53;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `compras`
--
ALTER TABLE `compras`
  ADD CONSTRAINT `compras_ibfk_1` FOREIGN KEY (`proveedor_id`) REFERENCES `proveedores` (`id`),
  ADD CONSTRAINT `compras_ibfk_2` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`);

--
-- Filtros para la tabla `cuentas_corrientes`
--
ALTER TABLE `cuentas_corrientes`
  ADD CONSTRAINT `cuentas_corrientes_ibfk_1` FOREIGN KEY (`cliente_id`) REFERENCES `clientes` (`id`),
  ADD CONSTRAINT `cuentas_corrientes_ibfk_2` FOREIGN KEY (`factura_id`) REFERENCES `facturas` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `cuentas_corrientes_ibfk_3` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`);

--
-- Filtros para la tabla `detalle_compras`
--
ALTER TABLE `detalle_compras`
  ADD CONSTRAINT `detalle_compras_ibfk_1` FOREIGN KEY (`compra_id`) REFERENCES `compras` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `detalle_compras_ibfk_2` FOREIGN KEY (`producto_id`) REFERENCES `productos` (`id`) ON DELETE SET NULL;

--
-- Filtros para la tabla `detalle_facturas`
--
ALTER TABLE `detalle_facturas`
  ADD CONSTRAINT `detalle_facturas_ibfk_1` FOREIGN KEY (`factura_id`) REFERENCES `facturas` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `detalle_facturas_ibfk_2` FOREIGN KEY (`producto_id`) REFERENCES `productos` (`id`) ON DELETE SET NULL;

--
-- Filtros para la tabla `detalle_ventas`
--
ALTER TABLE `detalle_ventas`
  ADD CONSTRAINT `detalle_ventas_ibfk_1` FOREIGN KEY (`venta_id`) REFERENCES `ventas` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `detalle_ventas_ibfk_2` FOREIGN KEY (`producto_id`) REFERENCES `productos` (`id`);

--
-- Filtros para la tabla `facturas`
--
ALTER TABLE `facturas`
  ADD CONSTRAINT `facturas_ibfk_1` FOREIGN KEY (`cliente_id`) REFERENCES `clientes` (`id`),
  ADD CONSTRAINT `facturas_ibfk_2` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`);

--
-- Filtros para la tabla `gastos`
--
ALTER TABLE `gastos`
  ADD CONSTRAINT `gastos_ibfk_1` FOREIGN KEY (`proveedor_id`) REFERENCES `proveedores` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `gastos_ibfk_2` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`);

--
-- Filtros para la tabla `movimientos_caja`
--
ALTER TABLE `movimientos_caja`
  ADD CONSTRAINT `movimientos_caja_ibfk_1` FOREIGN KEY (`cliente_id`) REFERENCES `clientes` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `movimientos_caja_ibfk_2` FOREIGN KEY (`proveedor_id`) REFERENCES `proveedores` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `movimientos_caja_ibfk_3` FOREIGN KEY (`factura_id`) REFERENCES `facturas` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `movimientos_caja_ibfk_4` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`);

--
-- Filtros para la tabla `pagos`
--
ALTER TABLE `pagos`
  ADD CONSTRAINT `pagos_ibfk_1` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`);

--
-- Filtros para la tabla `productos`
--
ALTER TABLE `productos`
  ADD CONSTRAINT `productos_ibfk_1` FOREIGN KEY (`categoria_id`) REFERENCES `categorias` (`id`) ON DELETE SET NULL;

--
-- Filtros para la tabla `ventas`
--
ALTER TABLE `ventas`
  ADD CONSTRAINT `ventas_ibfk_1` FOREIGN KEY (`cliente_id`) REFERENCES `clientes` (`id`),
  ADD CONSTRAINT `ventas_ibfk_2` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
