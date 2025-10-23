<?php
require_once 'config.php';

// Obtener estadísticas generales
$sql_total_ventas = "SELECT COUNT(*) as total FROM ventas WHERE estado='completada'";
$total_ventas = $conn->query($sql_total_ventas)->fetch_assoc()['total'];

$sql_total_ingresos = "SELECT SUM(total) as ingresos FROM ventas WHERE estado='completada'";
$total_ingresos = $conn->query($sql_total_ingresos)->fetch_assoc()['ingresos'] ?? 0;

$sql_total_productos = "SELECT COUNT(*) as total FROM productos WHERE estado=1";
$total_productos = $conn->query($sql_total_productos)->fetch_assoc()['total'];

$sql_total_clientes = "SELECT COUNT(*) as total FROM clientes WHERE estado=1";
$total_clientes = $conn->query($sql_total_clientes)->fetch_assoc()['total'];

// Ventas por mes (últimos 12 meses)
$sql_ventas_mes = "SELECT DATE_FORMAT(fecha_venta, '%Y-%m') as mes, SUM(total) as total 
                   FROM ventas WHERE estado='completada' 
                   GROUP BY DATE_FORMAT(fecha_venta, '%Y-%m') 
                   ORDER BY mes DESC LIMIT 12";
$result_ventas_mes = $conn->query($sql_ventas_mes);
$ventas_mes = [];
while($row = $result_ventas_mes->fetch_assoc()) {
    $ventas_mes[] = $row;
}
$ventas_mes = array_reverse($ventas_mes);

// Productos más vendidos
$sql_productos_top = "SELECT p.nombre, SUM(dv.cantidad) as vendido, SUM(dv.subtotal) as ingresos
                      FROM detalle_ventas dv
                      INNER JOIN productos p ON dv.producto_id = p.id
                      INNER JOIN ventas v ON dv.venta_id = v.id
                      WHERE v.estado='completada'
                      GROUP BY p.id
                      ORDER BY vendido DESC
                      LIMIT 10";
$result_productos_top = $conn->query($sql_productos_top);

// Ventas por categoría
$sql_ventas_categoria = "SELECT c.nombre, SUM(dv.subtotal) as total
                         FROM detalle_ventas dv
                         INNER JOIN productos p ON dv.producto_id = p.id
                         INNER JOIN categorias c ON p.categoria_id = c.id
                         INNER JOIN ventas v ON dv.venta_id = v.id
                         WHERE v.estado='completada'
                         GROUP BY c.id
                         ORDER BY total DESC";
$result_ventas_categoria = $conn->query($sql_ventas_categoria);
$ventas_categoria = [];
while($row = $result_ventas_categoria->fetch_assoc()) {
    $ventas_categoria[] = $row;
}

// Métodos de pago
$sql_metodos_pago = "SELECT metodo_pago, COUNT(*) as cantidad, SUM(total) as monto
                     FROM ventas WHERE estado='completada'
                     GROUP BY metodo_pago";
$result_metodos_pago = $conn->query($sql_metodos_pago);
$metodos_pago = [];
while($row = $result_metodos_pago->fetch_assoc()) {
    $metodos_pago[] = $row;
}
?>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reportes - Sistema de Ventas</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/4.3.0/chart.umd.min.js"></script>
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
        .border-left-primary { border-left: 0.25rem solid var(--primary) !important; }
        .border-left-success { border-left: 0.25rem solid var(--success) !important; }
        .border-left-info { border-left: 0.25rem solid var(--info) !important; }
        .border-left-warning { border-left: 0.25rem solid var(--warning) !important; }
        .text-xs {
            font-size: 0.7rem;
            font-weight: 700;
            text-transform: uppercase;
        }
        .h5 { font-size: 1.25rem; font-weight: 700; }
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
                <a class="nav-link" href="index.php">
                    <i class="fas fa-fw fa-tachometer-alt"></i><span>Dashboard</span>
                </a>
            </li>
            <hr class="sidebar-divider" style="border-color: rgba(255,255,255,.2)">
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
                <a class="nav-link" href="ventas.php">
                    <i class="fas fa-fw fa-cash-register"></i><span>Ventas</span>
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link active" href="reportes.php">
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
                <div class="d-sm-flex align-items-center justify-content-between mb-4">
                    <h1 class="h3 mb-0 text-gray-800">Reportes y Estadísticas</h1>
                    <button class="btn btn-primary" onclick="window.print()">
                        <i class="fas fa-download"></i> Exportar Reporte
                    </button>
                </div>
                
                <!-- Cards de Métricas -->
                <div class="row">
                    <div class="col-xl-3 col-md-6 mb-4">
                        <div class="card border-left-primary shadow h-100 py-2">
                            <div class="card-body">
                                <div class="row no-gutters align-items-center">
                                    <div class="col mr-2">
                                        <div class="text-xs font-weight-bold text-primary text-uppercase mb-1">Total Ventas</div>
                                        <div class="h5 mb-0 font-weight-bold text-gray-800"><?php echo $total_ventas; ?></div>
                                    </div>
                                    <div class="col-auto">
                                        <i class="fas fa-shopping-cart fa-2x text-gray-300"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="col-xl-3 col-md-6 mb-4">
                        <div class="card border-left-success shadow h-100 py-2">
                            <div class="card-body">
                                <div class="row no-gutters align-items-center">
                                    <div class="col mr-2">
                                        <div class="text-xs font-weight-bold text-success text-uppercase mb-1">Ingresos Totales</div>
                                        <div class="h5 mb-0 font-weight-bold text-gray-800"><?php echo formatear_precio($total_ingresos); ?></div>
                                    </div>
                                    <div class="col-auto">
                                        <i class="fas fa-dollar-sign fa-2x text-gray-300"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="col-xl-3 col-md-6 mb-4">
                        <div class="card border-left-info shadow h-100 py-2">
                            <div class="card-body">
                                <div class="row no-gutters align-items-center">
                                    <div class="col mr-2">
                                        <div class="text-xs font-weight-bold text-info text-uppercase mb-1">Productos</div>
                                        <div class="h5 mb-0 font-weight-bold text-gray-800"><?php echo $total_productos; ?></div>
                                    </div>
                                    <div class="col-auto">
                                        <i class="fas fa-box fa-2x text-gray-300"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="col-xl-3 col-md-6 mb-4">
                        <div class="card border-left-warning shadow h-100 py-2">
                            <div class="card-body">
                                <div class="row no-gutters align-items-center">
                                    <div class="col mr-2">
                                        <div class="text-xs font-weight-bold text-warning text-uppercase mb-1">Clientes</div>
                                        <div class="h5 mb-0 font-weight-bold text-gray-800"><?php echo $total_clientes; ?></div>
                                    </div>
                                    <div class="col-auto">
                                        <i class="fas fa-users fa-2x text-gray-300"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Gráficos -->
                <div class="row">
                    <div class="col-xl-8">
                        <div class="card shadow mb-4">
                            <div class="card-header py-3">
                                <h6 class="m-0 font-weight-bold" style="color: var(--primary);">Ventas por Mes</h6>
                            </div>
                            <div class="card-body">
                                <canvas id="ventasMesChart" height="100"></canvas>
                            </div>
                        </div>
                    </div>
                    
                    <div class="col-xl-4">
                        <div class="card shadow mb-4">
                            <div class="card-header py-3">
                                <h6 class="m-0 font-weight-bold" style="color: var(--primary);">Ventas por Categoría</h6>
                            </div>
                            <div class="card-body">
                                <canvas id="categoriasChart"></canvas>
                            </div>
                        </div>
                    </div>
                </div>
                
                <div class="row">
                    <div class="col-xl-6">
                        <div class="card shadow mb-4">
                            <div class="card-header py-3">
                                <h6 class="m-0 font-weight-bold" style="color: var(--primary);">Productos Más Vendidos</h6>
                            </div>
                            <div class="card-body">
                                <div class="table-responsive">
                                    <table class="table table-sm">
                                        <thead>
                                            <tr>
                                                <th>Producto</th>
                                                <th>Cantidad</th>
                                                <th>Ingresos</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <?php while($row = $result_productos_top->fetch_assoc()): ?>
                                            <tr>
                                                <td><?php echo $row['nombre']; ?></td>
                                                <td><span class="badge bg-primary"><?php echo $row['vendido']; ?></span></td>
                                                <td class="text-success fw-bold"><?php echo formatear_precio($row['ingresos']); ?></td>
                                            </tr>
                                            <?php endwhile; ?>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="col-xl-6">
                        <div class="card shadow mb-4">
                            <div class="card-header py-3">
                                <h6 class="m-0 font-weight-bold" style="color: var(--primary);">Métodos de Pago</h6>
                            </div>
                            <div class="card-body">
                                <canvas id="metodosPagoChart"></canvas>
                                <div class="mt-4">
                                    <?php foreach($metodos_pago as $metodo): ?>
                                    <div class="mb-3">
                                        <div class="d-flex justify-content-between">
                                            <span class="text-capitalize"><?php echo $metodo['metodo_pago']; ?></span>
                                            <span class="fw-bold"><?php echo formatear_precio($metodo['monto']); ?></span>
                                        </div>
                                        <small class="text-muted"><?php echo $metodo['cantidad']; ?> transacciones</small>
                                    </div>
                                    <?php endforeach; ?>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <script>
        // Gráfico de Ventas por Mes
        const ctxVentasMes = document.getElementById('ventasMesChart').getContext('2d');
        new Chart(ctxVentasMes, {
            type: 'line',
            data: {
                labels: <?php echo json_encode(array_column($ventas_mes, 'mes')); ?>,
                datasets: [{
                    label: 'Ventas',
                    data: <?php echo json_encode(array_column($ventas_mes, 'total')); ?>,
                    borderColor: '#4e73df',
                    backgroundColor: 'rgba(78, 115, 223, 0.05)',
                    tension: 0.4,
                    fill: true
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: { legend: { display: false } },
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: {
                            callback: function(value) {
                                return ' + value.toLocaleString();
                            }
                        }
                    }
                }
            }
        });
        
        // Gráfico de Categorías
        const ctxCategorias = document.getElementById('categoriasChart').getContext('2d');
        new Chart(ctxCategorias, {
            type: 'doughnut',
            data: {
                labels: <?php echo json_encode(array_column($ventas_categoria, 'nombre')); ?>,
                datasets: [{
                    data: <?php echo json_encode(array_column($ventas_categoria, 'total')); ?>,
                    backgroundColor: ['#4e73df', '#1cc88a', '#36b9cc', '#f6c23e', '#e74a3b'],
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: true,
                plugins: { legend: { position: 'bottom' } }
            }
        });
        
        // Gráfico de Métodos de Pago
        const ctxMetodos = document.getElementById('metodosPagoChart').getContext('2d');
        new Chart(ctxMetodos, {
            type: 'bar',
            data: {
                labels: <?php echo json_encode(array_map('ucfirst', array_column($metodos_pago, 'metodo_pago'))); ?>,
                datasets: [{
                    label: 'Monto',
                    data: <?php echo json_encode(array_column($metodos_pago, 'monto')); ?>,
                    backgroundColor: ['#4e73df', '#1cc88a', '#36b9cc'],
                }]
            },
            options: {
                responsive: true,
                plugins: { legend: { display: false } },
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: {
                            callback: function(value) {
                                return ' + value.toLocaleString();
                            }
                        }
                    }
                }
            }
        });
    </script>
</body>
</html>