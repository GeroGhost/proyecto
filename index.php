<?php
require_once 'config.php';

// Obtener métricas del mes actual
$mes_actual = date('Y-m');
$sql_ventas_mes = "SELECT SUM(total) as total FROM ventas WHERE DATE_FORMAT(fecha_venta, '%Y-%m') = ? AND estado='completada'";
$stmt = $conn->prepare($sql_ventas_mes);
$stmt->bind_param("s", $mes_actual);
$stmt->execute();
$ventas_mensuales = $stmt->get_result()->fetch_assoc()['total'] ?? 0;

// Ventas anuales
$anio_actual = date('Y');
$sql_ventas_anual = "SELECT SUM(total) as total FROM ventas WHERE YEAR(fecha_venta) = ? AND estado='completada'";
$stmt = $conn->prepare($sql_ventas_anual);
$stmt->bind_param("s", $anio_actual);
$stmt->execute();
$ventas_anuales = $stmt->get_result()->fetch_assoc()['total'] ?? 0;

// Total productos
$sql_productos = "SELECT COUNT(*) as total FROM productos WHERE estado=1";
$total_productos = $conn->query($sql_productos)->fetch_assoc()['total'];

// Total clientes
$sql_clientes = "SELECT COUNT(*) as total FROM clientes WHERE estado=1";
$total_clientes = $conn->query($sql_clientes)->fetch_assoc()['total'];

// Ventas de los últimos 12 meses
$sql_grafico_ventas = "SELECT DATE_FORMAT(fecha_venta, '%Y-%m') as mes, SUM(total) as total 
                       FROM ventas WHERE estado='completada' 
                       GROUP BY DATE_FORMAT(fecha_venta, '%Y-%m') 
                       ORDER BY mes ASC LIMIT 12";
$result_grafico = $conn->query($sql_grafico_ventas);
$datos_grafico = [];
while($row = $result_grafico->fetch_assoc()) {
    $datos_grafico[] = $row;
}

// Ventas por categoría
$sql_categorias = "SELECT c.nombre, SUM(dv.subtotal) as total
                   FROM detalle_ventas dv
                   INNER JOIN productos p ON dv.producto_id = p.id
                   INNER JOIN categorias c ON p.categoria_id = c.id
                   INNER JOIN ventas v ON dv.venta_id = v.id
                   WHERE v.estado='completada'
                   GROUP BY c.id, c.nombre
                   LIMIT 5";
$result_categorias = $conn->query($sql_categorias);
$datos_categorias = [];
while($row = $result_categorias->fetch_assoc()) {
    $datos_categorias[] = $row;
}
?>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - Sistema de Ventas</title>
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
        .chart-container {
            position: relative;
            height: 300px;
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
                <form class="d-none d-sm-inline-block form-inline mr-auto ml-md-3 my-2 my-md-0 mw-100">
                    <div class="input-group">
                        <input type="text" class="form-control bg-light border-0 small" placeholder="Buscar..." style="border-radius: 10rem;">
                    </div>
                </form>
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
                    <h1 class="h3 mb-0 text-gray-800">Dashboard</h1>
                    <a href="reportes.php" class="btn btn-primary btn-sm">
                        <i class="fas fa-download fa-sm text-white-50"></i> Generar Reporte
                    </a>
                </div>
                
                <!-- Cards de Métricas -->
                <div class="row">
                    <div class="col-xl-3 col-md-6 mb-4">
                        <div class="card border-left-primary shadow h-100 py-2">
                            <div class="card-body">
                                <div class="row no-gutters align-items-center">
                                    <div class="col mr-2">
                                        <div class="text-xs font-weight-bold text-primary text-uppercase mb-1">Ventas (Mensual)</div>
                                        <div class="h5 mb-0 font-weight-bold text-gray-800">
                                            <?php echo formatear_precio($ventas_mensuales); ?>
                                        </div>
                                    </div>
                                    <div class="col-auto">
                                        <i class="fas fa-calendar fa-2x text-gray-300"></i>
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
                                        <div class="text-xs font-weight-bold text-success text-uppercase mb-1">Ventas (Anual)</div>
                                        <div class="h5 mb-0 font-weight-bold text-gray-800">
                                            <?php echo formatear_precio($ventas_anuales); ?>
                                        </div>
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
                                        <i class="fas fa-clipboard-list fa-2x text-gray-300"></i>
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
                    <div class="col-xl-8 col-lg-7">
                        <div class="card shadow mb-4">
                            <div class="card-header py-3">
                                <h6 class="m-0 font-weight-bold" style="color: var(--primary);">Resumen de Ventas</h6>
                            </div>
                            <div class="card-body">
                                <div class="chart-container">
                                    <canvas id="ventasChart"></canvas>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="col-xl-4 col-lg-5">
                        <div class="card shadow mb-4">
                            <div class="card-header py-3">
                                <h6 class="m-0 font-weight-bold" style="color: var(--primary);">Ventas por Categoría</h6>
                            </div>
                            <div class="card-body">
                                <div class="chart-container">
                                    <canvas id="categoriasChart"></canvas>
                                </div>
                                <div class="mt-4 text-center small">
                                    <?php 
                                    $colores = ['#4e73df', '#1cc88a', '#36b9cc', '#f6c23e', '#e74a3b'];
                                    foreach($datos_categorias as $index => $cat): 
                                    ?>
                                        <span class="mr-2">
                                            <i class="fas fa-circle" style="color: <?php echo $colores[$index % 5]; ?>;"></i> 
                                            <?php echo $cat['nombre']; ?>
                                        </span>
                                    <?php endforeach; ?>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Footer -->
            <footer class="bg-white py-4">
                <div class="container my-auto">
                    <div class="copyright text-center my-auto">
                        <span>Copyright &copy; Sistema de Ventas 2025</span>
                    </div>
                </div>
            </footer>
        </div>
    </div>
    
    <script>
        console.log('Inicializando gráficos...');
        
        // Datos desde PHP
        const datosVentas = <?php echo json_encode($datos_grafico); ?>;
        const datosCategorias = <?php echo json_encode($datos_categorias); ?>;
        
        console.log('Datos de ventas:', datosVentas);
        console.log('Datos de categorías:', datosCategorias);
        
        // Gráfico de Ventas
        if (datosVentas && datosVentas.length > 0) {
            const ctxVentas = document.getElementById('ventasChart');
            if (ctxVentas) {
                new Chart(ctxVentas, {
                    type: 'line',
                    data: {
                        labels: datosVentas.map(item => item.mes),
                        datasets: [{
                            label: 'Ventas',
                            data: datosVentas.map(item => parseFloat(item.total)),
                            borderColor: '#4e73df',
                            backgroundColor: 'rgba(78, 115, 223, 0.05)',
                            tension: 0.4,
                            fill: true,
                            borderWidth: 2
                        }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        plugins: {
                            legend: { display: false },
                            tooltip: {
                                callbacks: {
                                    label: function(context) {
                                        return '$' + context.parsed.y.toLocaleString('es-AR', {minimumFractionDigits: 2, maximumFractionDigits: 2});
                                    }
                                }
                            }
                        },
                        scales: {
                            y: {
                                beginAtZero: true,
                                ticks: {
                                    callback: function(value) {
                                        return '$' + value.toLocaleString('es-AR');
                                    }
                                }
                            }
                        }
                    }
                });
                console.log('Gráfico de ventas creado exitosamente');
            } else {
                console.error('No se encontró el canvas ventasChart');
            }
        } else {
            console.warn('No hay datos de ventas para mostrar');
            document.getElementById('ventasChart').parentElement.innerHTML = '<p class="text-center text-muted p-5">No hay datos de ventas disponibles</p>';
        }
        
        // Gráfico de Categorías
        if (datosCategorias && datosCategorias.length > 0) {
            const ctxCategorias = document.getElementById('categoriasChart');
            if (ctxCategorias) {
                new Chart(ctxCategorias, {
                    type: 'doughnut',
                    data: {
                        labels: datosCategorias.map(item => item.nombre),
                        datasets: [{
                            data: datosCategorias.map(item => parseFloat(item.total)),
                            backgroundColor: ['#4e73df', '#1cc88a', '#36b9cc', '#f6c23e', '#e74a3b'],
                            hoverBackgroundColor: ['#2e59d9', '#17a673', '#2c9faf', '#dda20a', '#be2617'],
                            borderWidth: 2,
                            borderColor: '#fff'
                        }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        plugins: {
                            legend: { display: false },
                            tooltip: {
                                callbacks: {
                                    label: function(context) {
                                        const label = context.label || '';
                                        const value = context.parsed || 0;
                                        const total = context.dataset.data.reduce((a, b) => a + b, 0);
                                        const percentage = ((value / total) * 100).toFixed(1);
                                        return label + ': $' + value.toLocaleString('es-AR', {minimumFractionDigits: 2}) + ' (' + percentage + '%)';
                                    }
                                }
                            }
                        }
                    }
                });
                console.log('Gráfico de categorías creado exitosamente');
            } else {
                console.error('No se encontró el canvas categoriasChart');
            }
        } else {
            console.warn('No hay datos de categorías para mostrar');
            document.getElementById('categoriasChart').parentElement.innerHTML = '<p class="text-center text-muted p-5">No hay datos de categorías disponibles</p>';
        }
    </script>
</body>
</html>