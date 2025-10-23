<?php
require_once 'config.php';

// Procesar nueva venta
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['accion'])) {
    if ($_POST['accion'] === 'crear_venta') {
        $cliente_id = intval($_POST['cliente_id']);
        $metodo_pago = limpiar_entrada($_POST['metodo_pago']);
        $productos = json_decode($_POST['productos'], true);
        $total = floatval($_POST['total']);
        
        // Iniciar transacción
        $conn->begin_transaction();
        
        try {
            // Insertar venta
            $sql_venta = "INSERT INTO ventas (cliente_id, usuario_id, total, metodo_pago) VALUES (?, 1, ?, ?)";
            $stmt_venta = $conn->prepare($sql_venta);
            $stmt_venta->bind_param("ids", $cliente_id, $total, $metodo_pago);
            $stmt_venta->execute();
            $venta_id = $conn->insert_id;
            
            // Insertar detalles y actualizar stock
            foreach ($productos as $prod) {
                $producto_id = intval($prod['id']);
                $cantidad = intval($prod['cantidad']);
                $precio = floatval($prod['precio']);
                $subtotal = $cantidad * $precio;
                
                // Insertar detalle
                $sql_detalle = "INSERT INTO detalle_ventas (venta_id, producto_id, cantidad, precio_unitario, subtotal) VALUES (?, ?, ?, ?, ?)";
                $stmt_detalle = $conn->prepare($sql_detalle);
                $stmt_detalle->bind_param("iiidd", $venta_id, $producto_id, $cantidad, $precio, $subtotal);
                $stmt_detalle->execute();
                
                // Actualizar stock
                $sql_stock = "UPDATE productos SET stock = stock - ? WHERE id = ?";
                $stmt_stock = $conn->prepare($sql_stock);
                $stmt_stock->bind_param("ii", $cantidad, $producto_id);
                $stmt_stock->execute();
            }
            
            $conn->commit();
            $mensaje = "Venta registrada exitosamente";
            $tipo_mensaje = "success";
        } catch (Exception $e) {
            $conn->rollback();
            $mensaje = "Error al registrar venta: " . $e->getMessage();
            $tipo_mensaje = "danger";
        }
    }
}

// Obtener ventas
$sql_ventas = "SELECT v.*, c.nombre as cliente_nombre, c.apellido as cliente_apellido 
               FROM ventas v 
               INNER JOIN clientes c ON v.cliente_id = c.id 
               ORDER BY v.id DESC";
$result_ventas = $conn->query($sql_ventas);

// Obtener clientes activos
$sql_clientes = "SELECT * FROM clientes WHERE estado=1 ORDER BY nombre";
$result_clientes = $conn->query($sql_clientes);

// Obtener productos activos
$sql_productos = "SELECT * FROM productos WHERE estado=1 AND stock > 0 ORDER BY nombre";
$result_productos = $conn->query($sql_productos);
?>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ventas - Sistema de Ventas</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        :root {
            --primary: #4e73df;
            --success: #1cc88a;
            --info: #36b9cc;
            --warning: #f6c23e;
            --danger: #e74a3b;
        }
        body {
            font-family: 'Nunito', sans-serif;
            background-color: #f8f9fc;
        }
        #wrapper { display: flex; }
        #sidebar-wrapper {
            min-height: 100vh;
            width: 224px;
            background: linear-gradient(180deg, #4e73df 10%, #224abe 100%);
        }
        .sidebar-brand {
            height: 4.375rem;
            text-decoration: none;
            font-size: 1rem;
            font-weight: 800;
            padding: 1.5rem 1rem;
            text-align: center;
            color: #fff;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .nav-link {
            display: flex;
            align-items: center;
            padding: 1rem;
            color: rgba(255,255,255,.8);
            text-decoration: none;
            transition: all 0.3s;
        }
        .nav-link:hover, .nav-link.active {
            color: #fff;
            background-color: rgba(255,255,255,.1);
        }
        .nav-link i { width: 2rem; font-size: 0.85rem; }
        #content-wrapper { flex: 1; display: flex; flex-direction: column; }
        .topbar {
            height: 4.375rem;
            background-color: #fff;
            box-shadow: 0 0.15rem 1.75rem 0 rgba(58, 59, 69, 0.15);
        }
        .card {
            border: none;
            box-shadow: 0 0.15rem 1.75rem 0 rgba(58, 59, 69, 0.15);
            margin-bottom: 1.5rem;
        }
        .table-responsive { max-height: 600px; overflow-y: auto; }
        .btn-sm { padding: 0.25rem 0.5rem; font-size: 0.875rem; }
        .badge { padding: 0.5em 0.75em; }
        #carrito-productos { max-height: 300px; overflow-y: auto; }
        .producto-item { border-bottom: 1px solid #e3e6f0; padding: 10px 0; }
        .total-venta {
            font-size: 1.5rem;
            font-weight: bold;
            color: var(--success);
        }
    </style>
</head>
<body>
    <div id="wrapper">
        <!-- Sidebar -->
        <ul class="navbar-nav" id="sidebar-wrapper">
            <a class="sidebar-brand" href="index.php">
                <div class="sidebar-brand-icon"><i class="fas fa-shopping-cart"></i></div>
                <div class="sidebar-brand-text mx-3">VENTAS</div>
            </a>
            <hr class="sidebar-divider my-0" style="border-color: rgba(255,255,255,.2)">
            <li class="nav-item">
                <a class="nav-link active" href="index.php">
                    <i class="fas fa-fw fa-tachometer-alt"></i><span>Dashboard</span>
                </a>
            </li>
            <hr class="sidebar-divider" style="border-color: rgba(255,255,255,.2)">
            <div class="sidebar-heading" style="color: rgba(255,255,255,.5); padding: 0 1rem; font-size: 0.65rem; text-transform: uppercase; margin-top: 0.5rem;">Gestión</div>
            <li class="nav-item">
                <a class="nav-link" href="productos.php">
                    <i class="fas fa-fw fa-box"></i><span>Productos</span>
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="clientes.php">
                    <i class="fas fa-fw fa-users"></i><span>Clientes</span>
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="proveedores.php">
                    <i class="fas fa-fw fa-truck"></i><span>Proveedores</span>
                </a>
            </li>
            <hr class="sidebar-divider" style="border-color: rgba(255,255,255,.2)">
            <div class="sidebar-heading" style="color: rgba(255,255,255,.5); padding: 0 1rem; font-size: 0.65rem; text-transform: uppercase; margin-top: 0.5rem;">Operaciones</div>
            <li class="nav-item">
                <a class="nav-link" href="ventas.php">
                    <i class="fas fa-fw fa-cash-register"></i><span>Ventas</span>
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="facturas.php">
                    <i class="fas fa-fw fa-file-invoice"></i><span>Facturas</span>
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="caja.php">
                    <i class="fas fa-fw fa-money-bill-wave"></i><span>Caja</span>
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="cuentas_corrientes.php">
                    <i class="fas fa-fw fa-file-invoice-dollar"></i><span>Cuentas Corrientes</span>
                </a>
            </li>
            <hr class="sidebar-divider" style="border-color: rgba(255,255,255,.2)">
            <li class="nav-item">
                <a class="nav-link" href="reportes.php">
                    <i class="fas fa-fw fa-chart-area"></i><span>Reportes</span>
                </a>
            </li>
            <hr class="sidebar-divider" style="border-color: rgba(255,255,255,.2)">
            <li class="nav-item">
                <a class="nav-link" href="cerrar_sesion.php">
                    <i class="fas fa-fw fa-sign-out-alt"></i><span>Cerrar Sesión</span>
                </a>
            </li>
        </ul>
        
        <!-- Content -->
        <div id="content-wrapper">
            <nav class="navbar navbar-expand topbar mb-4 static-top">
                <ul class="navbar-nav ml-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="#">
                            <i class="fas fa-user-circle fa-2x" style="color: #858796;"></i>
                        </a>
                    </li>
                </ul>
            </nav>
            
            <div class="container-fluid">
                <?php if (isset($mensaje)): ?>
                    <div class="alert alert-<?php echo $tipo_mensaje; ?> alert-dismissible fade show">
                        <?php echo $mensaje; ?>
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                <?php endif; ?>
                
                <div class="d-sm-flex align-items-center justify-content-between mb-4">
                    <h1 class="h3 mb-0 text-gray-800">Gestión de Ventas</h1>
                    <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#modalVenta">
                        <i class="fas fa-plus"></i> Nueva Venta
                    </button>
                </div>
                
                <div class="card">
                    <div class="card-header py-3">
                        <h6 class="m-0 font-weight-bold" style="color: var(--primary);">Historial de Ventas</h6>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-hover">
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Cliente</th>
                                        <th>Total</th>
                                        <th>Método de Pago</th>
                                        <th>Estado</th>
                                        <th>Fecha</th>
                                        <th>Acciones</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <?php while($row = $result_ventas->fetch_assoc()): ?>
                                    <tr>
                                        <td>#<?php echo $row['id']; ?></td>
                                        <td><?php echo $row['cliente_nombre'] . ' ' . $row['cliente_apellido']; ?></td>
                                        <td class="text-success fw-bold"><?php echo formatear_precio($row['total']); ?></td>
                                        <td>
                                            <span class="badge bg-info">
                                                <?php echo ucfirst($row['metodo_pago']); ?>
                                            </span>
                                        </td>
                                        <td>
                                            <span class="badge bg-success">
                                                <?php echo ucfirst($row['estado']); ?>
                                            </span>
                                        </td>
                                        <td><?php echo formatear_fecha($row['fecha_venta']); ?></td>
                                        <td>
                                            <button class="btn btn-info btn-sm" onclick="verDetalle(<?php echo $row['id']; ?>)">
                                                <i class="fas fa-eye"></i> Ver
                                            </button>
                                        </td>
                                    </tr>
                                    <?php endwhile; ?>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Modal Nueva Venta -->
    <div class="modal fade" id="modalVenta" tabindex="-1">
        <div class="modal-dialog modal-xl">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Nueva Venta</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form method="POST" id="formVenta">
                    <div class="modal-body">
                        <input type="hidden" name="accion" value="crear_venta">
                        <input type="hidden" name="productos" id="productos_json">
                        <input type="hidden" name="total" id="total_venta">
                        
                        <div class="row">
                            <div class="col-md-8">
                                <h6 class="mb-3">Seleccionar Productos</h6>
                                <div class="mb-3">
                                    <select class="form-select" id="producto_select">
                                        <option value="">Seleccionar producto...</option>
                                        <?php 
                                        while($prod = $result_productos->fetch_assoc()): 
                                        ?>
                                            <option value='<?php echo json_encode($prod); ?>'>
                                                <?php echo $prod['nombre'] . ' - ' . formatear_precio($prod['precio']) . ' (Stock: ' . $prod['stock'] . ')'; ?>
                                            </option>
                                        <?php endwhile; ?>
                                    </select>
                                </div>
                                
                                <div id="carrito-productos">
                                    <p class="text-muted">No hay productos agregados</p>
                                </div>
                            </div>
                            
                            <div class="col-md-4">
                                <h6 class="mb-3">Información de Venta</h6>
                                
                                <div class="mb-3">
                                    <label class="form-label">Cliente</label>
                                    <select class="form-select" name="cliente_id" required>
                                        <option value="">Seleccionar...</option>
                                        <?php 
                                        while($cli = $result_clientes->fetch_assoc()): 
                                        ?>
                                            <option value="<?php echo $cli['id']; ?>">
                                                <?php echo $cli['nombre'] . ' ' . $cli['apellido']; ?>
                                            </option>
                                        <?php endwhile; ?>
                                    </select>
                                </div>
                                
                                <div class="mb-3">
                                    <label class="form-label">Método de Pago</label>
                                    <select class="form-select" name="metodo_pago" required>
                                        <option value="efectivo">Efectivo</option>
                                        <option value="tarjeta">Tarjeta</option>
                                        <option value="transferencia">Transferencia</option>
                                    </select>
                                </div>
                                
                                <hr>
                                
                                <div class="text-center">
                                    <h6>Total a Pagar</h6>
                                    <div class="total-venta" id="total_display">$0.00</div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                        <button type="submit" class="btn btn-success" id="btnGuardarVenta">
                            <i class="fas fa-check"></i> Procesar Venta
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
    <script>
        let carrito = [];
        
        document.getElementById('producto_select').addEventListener('change', function() {
            if (this.value) {
                const producto = JSON.parse(this.value);
                agregarAlCarrito(producto);
                this.value = '';
            }
        });
        
        function agregarAlCarrito(producto) {
            const existe = carrito.find(p => p.id === producto.id);
            
            if (existe) {
                if (existe.cantidad < producto.stock) {
                    existe.cantidad++;
                } else {
                    alert('Stock insuficiente');
                    return;
                }
            } else {
                carrito.push({
                    id: producto.id,
                    nombre: producto.nombre,
                    precio: parseFloat(producto.precio),
                    cantidad: 1,
                    stock: parseInt(producto.stock)
                });
            }
            
            actualizarCarrito();
        }
        
        function actualizarCarrito() {
            const container = document.getElementById('carrito-productos');
            
            if (carrito.length === 0) {
                container.innerHTML = '<p class="text-muted">No hay productos agregados</p>';
                document.getElementById('total_display').innerText = '$0.00';
                document.getElementById('btnGuardarVenta').disabled = true;
                return;
            }
            
            let html = '';
            let total = 0;
            
            carrito.forEach((prod, index) => {
                const subtotal = prod.precio * prod.cantidad;
                total += subtotal;
                
                html += `
                    <div class="producto-item">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <strong>${prod.nombre}</strong><br>
                                <small>$${prod.precio.toFixed(2)} x ${prod.cantidad} = $${subtotal.toFixed(2)}</small>
                            </div>
                            <div class="btn-group">
                                <button type="button" class="btn btn-sm btn-outline-secondary" onclick="cambiarCantidad(${index}, -1)">-</button>
                                <button type="button" class="btn btn-sm btn-outline-secondary" disabled>${prod.cantidad}</button>
                                <button type="button" class="btn btn-sm btn-outline-secondary" onclick="cambiarCantidad(${index}, 1)">+</button>
                                <button type="button" class="btn btn-sm btn-danger" onclick="eliminarDelCarrito(${index})">
                                    <i class="fas fa-trash"></i>
                                </button>
                            </div>
                        </div>
                    </div>
                `;
            });
            
            container.innerHTML = html;
            document.getElementById('total_display').innerText = '$' + total.toFixed(2);
            document.getElementById('total_venta').value = total.toFixed(2);
            document.getElementById('productos_json').value = JSON.stringify(carrito);
            document.getElementById('btnGuardarVenta').disabled = false;
        }
        
        function cambiarCantidad(index, cambio) {
            const producto = carrito[index];
            const nuevaCantidad = producto.cantidad + cambio;
            
            if (nuevaCantidad <= 0) {
                eliminarDelCarrito(index);
                return;
            }
            
            if (nuevaCantidad > producto.stock) {
                alert('Stock insuficiente');
                return;
            }
            
            producto.cantidad = nuevaCantidad;
            actualizarCarrito();
        }
        
        function eliminarDelCarrito(index) {
            carrito.splice(index, 1);
            actualizarCarrito();
        }
        
        function verDetalle(id) {
            window.location.href = 'detalle_venta.php?id=' + id;
        }
        
        document.getElementById('modalVenta').addEventListener('hidden.bs.modal', function () {
            carrito = [];
            actualizarCarrito();
            document.getElementById('formVenta').reset();
        });
    </script>
</body>
</html>