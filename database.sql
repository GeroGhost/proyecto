-- ACTUALIZACIÓN BASE DE DATOS - MÓDULOS FINANCIEROS
-- Ejecutar estas tablas adicionales en la base de datos sistema_ventas

USE sistema_ventas;

-- Tabla de proveedores
CREATE TABLE IF NOT EXISTS proveedores (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    razon_social VARCHAR(200),
    cuit VARCHAR(20) UNIQUE,
    email VARCHAR(100),
    telefono VARCHAR(20),
    direccion TEXT,
    ciudad VARCHAR(100),
    provincia VARCHAR(100),
    codigo_postal VARCHAR(10),
    contacto_nombre VARCHAR(100),
    contacto_telefono VARCHAR(20),
    estado TINYINT(1) DEFAULT 1,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de facturas
CREATE TABLE IF NOT EXISTS facturas (
    id INT PRIMARY KEY AUTO_INCREMENT,
    numero_factura VARCHAR(50) UNIQUE NOT NULL,
    tipo ENUM('A', 'B', 'C') NOT NULL,
    tipo_comprobante ENUM('factura', 'nota_credito', 'nota_debito', 'recibo', 'presupuesto') NOT NULL,
    cliente_id INT NOT NULL,
    fecha_emision DATE NOT NULL,
    fecha_vencimiento DATE,
    subtotal DECIMAL(10,2) NOT NULL,
    iva DECIMAL(10,2) DEFAULT 0,
    total DECIMAL(10,2) NOT NULL,
    estado ENUM('pendiente', 'pagada', 'vencida', 'anulada') DEFAULT 'pendiente',
    observaciones TEXT,
    usuario_id INT NOT NULL,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (cliente_id) REFERENCES clientes(id) ON DELETE RESTRICT,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE RESTRICT
);

-- Tabla de detalle de facturas
CREATE TABLE IF NOT EXISTS detalle_facturas (
    id INT PRIMARY KEY AUTO_INCREMENT,
    factura_id INT NOT NULL,
    producto_id INT,
    descripcion VARCHAR(255) NOT NULL,
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL,
    subtotal DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (factura_id) REFERENCES facturas(id) ON DELETE CASCADE,
    FOREIGN KEY (producto_id) REFERENCES productos(id) ON DELETE SET NULL
);

-- Tabla de cuentas corrientes (estado de cuenta por cliente)
CREATE TABLE IF NOT EXISTS cuentas_corrientes (
    id INT PRIMARY KEY AUTO_INCREMENT,
    cliente_id INT NOT NULL,
    tipo_movimiento ENUM('debe', 'haber') NOT NULL,
    concepto VARCHAR(255) NOT NULL,
    factura_id INT,
    importe DECIMAL(10,2) NOT NULL,
    saldo DECIMAL(10,2) NOT NULL,
    fecha_movimiento DATE NOT NULL,
    observaciones TEXT,
    usuario_id INT NOT NULL,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (cliente_id) REFERENCES clientes(id) ON DELETE RESTRICT,
    FOREIGN KEY (factura_id) REFERENCES facturas(id) ON DELETE SET NULL,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE RESTRICT
);

-- Tabla de caja (movimientos de efectivo)
CREATE TABLE IF NOT EXISTS movimientos_caja (
    id INT PRIMARY KEY AUTO_INCREMENT,
    tipo ENUM('ingreso', 'egreso') NOT NULL,
    concepto VARCHAR(255) NOT NULL,
    categoria ENUM('venta', 'compra', 'gasto', 'pago_proveedor', 'cobro_cliente', 'otro') NOT NULL,
    importe DECIMAL(10,2) NOT NULL,
    metodo_pago ENUM('efectivo', 'tarjeta', 'transferencia', 'cheque') NOT NULL,
    referencia VARCHAR(100),
    fecha_movimiento DATE NOT NULL,
    cliente_id INT,
    proveedor_id INT,
    factura_id INT,
    observaciones TEXT,
    usuario_id INT NOT NULL,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (cliente_id) REFERENCES clientes(id) ON DELETE SET NULL,
    FOREIGN KEY (proveedor_id) REFERENCES proveedores(id) ON DELETE SET NULL,
    FOREIGN KEY (factura_id) REFERENCES facturas(id) ON DELETE SET NULL,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE RESTRICT
);

-- Tabla de compras a proveedores
CREATE TABLE IF NOT EXISTS compras (
    id INT PRIMARY KEY AUTO_INCREMENT,
    proveedor_id INT NOT NULL,
    numero_comprobante VARCHAR(50),
    fecha_compra DATE NOT NULL,
    fecha_vencimiento DATE,
    subtotal DECIMAL(10,2) NOT NULL,
    iva DECIMAL(10,2) DEFAULT 0,
    total DECIMAL(10,2) NOT NULL,
    estado ENUM('pendiente', 'pagada', 'vencida', 'anulada') DEFAULT 'pendiente',
    observaciones TEXT,
    usuario_id INT NOT NULL,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (proveedor_id) REFERENCES proveedores(id) ON DELETE RESTRICT,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE RESTRICT
);

-- Tabla de detalle de compras
CREATE TABLE IF NOT EXISTS detalle_compras (
    id INT PRIMARY KEY AUTO_INCREMENT,
    compra_id INT NOT NULL,
    producto_id INT,
    descripcion VARCHAR(255) NOT NULL,
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL,
    subtotal DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (compra_id) REFERENCES compras(id) ON DELETE CASCADE,
    FOREIGN KEY (producto_id) REFERENCES productos(id) ON DELETE SET NULL
);

-- Tabla de pagos (para registrar pagos parciales o totales)
CREATE TABLE IF NOT EXISTS pagos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    tipo_comprobante ENUM('factura', 'compra') NOT NULL,
    comprobante_id INT NOT NULL,
    fecha_pago DATE NOT NULL,
    importe DECIMAL(10,2) NOT NULL,
    metodo_pago ENUM('efectivo', 'tarjeta', 'transferencia', 'cheque') NOT NULL,
    numero_referencia VARCHAR(100),
    observaciones TEXT,
    usuario_id INT NOT NULL,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE RESTRICT
);

-- Tabla de gastos generales
CREATE TABLE IF NOT EXISTS gastos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    concepto VARCHAR(255) NOT NULL,
    categoria ENUM('servicios', 'alquiler', 'sueldos', 'impuestos', 'mantenimiento', 'otros') NOT NULL,
    importe DECIMAL(10,2) NOT NULL,
    fecha_gasto DATE NOT NULL,
    metodo_pago ENUM('efectivo', 'tarjeta', 'transferencia', 'cheque') NOT NULL,
    numero_comprobante VARCHAR(100),
    proveedor_id INT,
    observaciones TEXT,
    usuario_id INT NOT NULL,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (proveedor_id) REFERENCES proveedores(id) ON DELETE SET NULL,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE RESTRICT
);

-- Insertar proveedores de ejemplo
INSERT INTO proveedores (nombre, razon_social, cuit, email, telefono, direccion, contacto_nombre, contacto_telefono) VALUES 
('Distribuidora Tech SA', 'Distribuidora Tech SA', '20-12345678-9', 'ventas@distritech.com', '3875551111', 'Av. Circunvalación 100', 'Juan Pérez', '3875552222'),
('Mayorista Textil SRL', 'Mayorista Textil SRL', '30-23456789-0', 'info@mayotextil.com', '3875553333', 'Calle Comercio 250', 'María López', '3875554444'),
('Alimentos del Norte', 'Alimentos del Norte SA', '20-34567890-1', 'compras@alinorte.com', '3875555555', 'Ruta 9 Km 15', 'Carlos Gómez', '3875556666');

-- Insertar facturas de ejemplo
INSERT INTO facturas (numero_factura, tipo, tipo_comprobante, cliente_id, fecha_emision, fecha_vencimiento, subtotal, iva, total, estado, usuario_id) VALUES
('0001-00000001', 'B', 'factura', 1, CURDATE(), DATE_ADD(CURDATE(), INTERVAL 30 DAY), 10000.00, 2100.00, 12100.00, 'pendiente', 1),
('0001-00000002', 'B', 'factura', 2, CURDATE(), DATE_ADD(CURDATE(), INTERVAL 30 DAY), 5000.00, 1050.00, 6050.00, 'pagada', 1),
('0001-00000003', 'B', 'presupuesto', 3, CURDATE(), NULL, 15000.00, 3150.00, 18150.00, 'pendiente', 1);

-- Insertar movimientos de caja de ejemplo
INSERT INTO movimientos_caja (tipo, concepto, categoria, importe, metodo_pago, fecha_movimiento, usuario_id) VALUES
('ingreso', 'Venta del día', 'venta', 50000.00, 'efectivo', CURDATE(), 1),
('egreso', 'Pago luz', 'gasto', 5000.00, 'transferencia', CURDATE(), 1),
('ingreso', 'Cobro cliente', 'cobro_cliente', 12000.00, 'transferencia', CURDATE(), 1);

-- Insertar gastos de ejemplo
INSERT INTO gastos (concepto, categoria, importe, fecha_gasto, metodo_pago, usuario_id) VALUES
('Luz y gas', 'servicios', 5000.00, CURDATE(), 'transferencia', 1),
('Alquiler local', 'alquiler', 25000.00, CURDATE(), 'transferencia', 1),
('Mantenimiento PC', 'mantenimiento', 3000.00, CURDATE(), 'efectivo', 1);

-- Índices para mejorar rendimiento
CREATE INDEX idx_facturas_cliente ON facturas(cliente_id);
CREATE INDEX idx_facturas_estado ON facturas(estado);
CREATE INDEX idx_facturas_fecha ON facturas(fecha_emision);
CREATE INDEX idx_cuentas_cliente ON cuentas_corrientes(cliente_id);
CREATE INDEX idx_movimientos_fecha ON movimientos_caja(fecha_movimiento);
CREATE INDEX idx_compras_proveedor ON compras(proveedor_id);

-- Vista para resumen de cuenta corriente por cliente
CREATE OR REPLACE VIEW vista_saldos_clientes AS
SELECT 
    c.id,
    c.nombre,
    c.apellido,
    COALESCE(SUM(CASE WHEN cc.tipo_movimiento = 'debe' THEN cc.importe ELSE 0 END), 0) as total_debe,
    COALESCE(SUM(CASE WHEN cc.tipo_movimiento = 'haber' THEN cc.importe ELSE 0 END), 0) as total_haber,
    COALESCE(SUM(CASE WHEN cc.tipo_movimiento = 'debe' THEN cc.importe ELSE -cc.importe END), 0) as saldo_actual
FROM clientes c
LEFT JOIN cuentas_corrientes cc ON c.id = cc.cliente_id
GROUP BY c.id, c.nombre, c.apellido;

-- Vista para control de caja diario
CREATE OR REPLACE VIEW vista_caja_diaria AS
SELECT 
    fecha_movimiento,
    SUM(CASE WHEN tipo = 'ingreso' THEN importe ELSE 0 END) as total_ingresos,
    SUM(CASE WHEN tipo = 'egreso' THEN importe ELSE 0 END) as total_egresos,
    SUM(CASE WHEN tipo = 'ingreso' THEN importe ELSE -importe END) as saldo_diario
FROM movimientos_caja
GROUP BY fecha_movimiento
ORDER BY fecha_movimiento DESC;