-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 22-10-2025 a las 21:27:38
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
(10, 5, 10, 3, 250000.00, 750000.00);

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
(3, '0001-00000003', 'B', 'presupuesto', 3, '2025-10-22', NULL, 15000.00, 3150.00, 18150.00, 'pendiente', NULL, 1, '2025-10-22 19:02:42');

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
(5, 'egreso', 'Pago de servicio', 'gasto', 350000.00, 'efectivo', '', '2025-10-22', NULL, NULL, NULL, 'xd', 1, '2025-10-22 19:24:45');

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
(10, 'Celular', 'Moto E6 plus', 250000.00, 2, 1, NULL, 1, '2025-10-22 18:37:32');

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
(5, 5, 1, 750000.00, 'tarjeta', 'completada', '2025-10-22 18:39:30');

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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT de la tabla `facturas`
--
ALTER TABLE `facturas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `gastos`
--
ALTER TABLE `gastos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `movimientos_caja`
--
ALTER TABLE `movimientos_caja`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

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
