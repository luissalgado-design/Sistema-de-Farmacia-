<%@page import="DAO.PagoDAO"%>
<%@page import="Modelo.Pago"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // Validar inicio de sesión
    HttpSession sesion = request.getSession(false);
    if (sesion == null || sesion.getAttribute("nombre") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String rol = (String) sesion.getAttribute("rol");
    String nombreUsuario = (String) sesion.getAttribute("nombre");
    boolean esVendedor = "Vendedor".equalsIgnoreCase(rol);

    // Restricción de acceso para vendedores
    if (esVendedor) {
        response.sendRedirect("ventas.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Pagos - Farmacia</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <link rel="stylesheet" href="css/estilos.css">

    <style>
        .bg-mint-custom { background-color: #419d78 !important; }
        .text-mint-custom { color: #2d6a4f !important; }
        .badge-rol { background-color: #d8f3dc !important; color: #1b4332 !important; font-weight: 600; }
        .btn-mint-action { background-color: #419d78 !important; border-color: #419d78 !important; color: #ffffff !important; transition: all 0.2s ease; }
        .btn-mint-action:hover { background-color: #2d6a4f !important; border-color: #2d6a4f !important; }
        .form-control:focus, .form-select:focus { border-color: #52b788; box-shadow: 0 0 0 0.25rem rgba(65, 157, 120, 0.2); }
        .table-mint-header { background-color: #2d6a4f !important; color: #ffffff !important; }
    </style>
</head>
<body class="bg-light">

    <!-- Navegación Dinámica -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-mint-custom mb-4 shadow-sm">
        <div class="container-fluid px-4">
            <a class="navbar-brand fw-bold fs-4" href="ventas.jsp">💊 FARMACIA</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                    <li class="nav-item"><a class="nav-link" href="ventas.jsp"><i class="bi bi-cart3"></i> Ventas</a></li>
                    <li class="nav-item"><a class="nav-link" href="clientes.jsp"><i class="bi bi-people"></i> Clientes</a></li>
                    <li class="nav-item"><a class="nav-link" href="categorias.jsp"><i class="bi bi-tags"></i> Categorías</a></li>
                    <li class="nav-item"><a class="nav-link" href="medicamentos.jsp"><i class="bi bi-capsule"></i> Medicamentos</a></li>
                    <li class="nav-item"><a class="nav-link active fw-semibold" href="pagos.jsp"><i class="bi bi-cash-stack"></i> Pagos</a></li>
                </ul>
                <div class="d-flex align-items-center gap-3">
                    <span class="text-light small">
                        Usuario: <strong><%= nombreUsuario %></strong> 
                        <span class="badge badge-rol px-2 py-1"><%= rol %></span>
                    </span>
                    <a href="login.jsp" class="btn btn-outline-light btn-sm"><i class="bi bi-box-arrow-right"></i> Salir</a>
                </div>
            </div>
        </div>
    </nav>

    <div class="container-fluid px-4">
        <h3 class="mb-4 text-mint-custom fw-bold"><i class="bi bi-credit-card-2-front me-2"></i>Consulta y Registro de Pagos</h3>

        <div class="row">
            <!-- Formulario de Registro de Pago -->
            <div class="col-md-4 mb-4">
                <div class="card shadow-sm border-0">
                    <div class="card-header bg-white py-3 fw-bold text-mint-custom">
                        <i class="bi bi-plus-circle me-1"></i> Registrar Nuevo Pago
                    </div>
                    <div class="card-body">
                        <form action="PagoController" method="POST">
                            <input type="hidden" name="accion" value="guardar">

                            <div class="mb-3">
                                <label class="form-label fw-semibold">ID de Venta</label>
                                <input type="number" name="txtidventa" class="form-control" placeholder="Ej: 1001" required>
                            </div>
                            <div class="mb-3">
                                <label class="form-label fw-semibold">Método de Pago</label>
                                <select name="txtmetodo" class="form-select" required>
                                    <option value="" selected disabled>Seleccione...</option>
                                    <option value="Efectivo">💵 Efectivo</option>
                                    <option value="Tarjeta de Crédito/Débito">💳 Tarjeta de Crédito/Débito</option>
                                    <option value="Transferencia">📱 Transferencia</option>
                                </select>
                            </div>
                            <div class="mb-3">
                                <label class="form-label fw-semibold">Monto ($)</label>
                                <div class="input-group">
                                    <span class="input-group-text">$</span>
                                    <input type="number" step="0.01" name="txtmonto" class="form-control" placeholder="0.00" required>
                                </div>
                            </div>
                            
                            <button type="submit" class="btn btn-mint-action w-100 fw-bold py-2 shadow-sm">
                                <i class="bi bi-check-lg me-1"></i> Registrar Pago
                            </button>
                        </form>
                    </div>
                </div>
            </div>

            <!-- Tabla de Historial de Pagos -->
            <div class="col-md-8">
                <div class="card shadow-sm border-0">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0">
                            <thead class="table-mint-header">
                                <tr>
                                    <th>ID Pago</th>
                                    <th>ID Venta</th>
                                    <th>Método de Pago</th>
                                    <th>Monto Total</th>
                                    <th>Fecha de Pago</th>
                                    <th class="text-center">Acciones</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    PagoDAO pdao = new PagoDAO();
                                    List<Pago> listaPagos = pdao.listar();
                                    if (listaPagos != null && !listaPagos.isEmpty()) {
                                        for (Pago p : listaPagos) {
                                %>
                                <tr>
                                    <td class="fw-bold text-secondary">#<%= p.getIdPago() %></td>
                                    <td><span class="badge bg-secondary">Venta #<%= p.getIdVenta() %></span></td>
                                    <td class="fw-semibold"><%= p.getMetodoPago() %></td>
                                    <td class="text-mint-custom fw-bold">$<%= String.format("%.2f", p.getMonto()) %></td>
                                    <td class="text-muted"><%= p.getFechaPago() != null ? p.getFechaPago() : "N/A" %></td>
                                    <td class="text-center">
                                        <a href="PagoController?accion=eliminar&id=<%= p.getIdPago() %>" 
                                           class="btn btn-sm btn-outline-danger" 
                                           title="Eliminar Pago"
                                           onclick="return confirm('¿Está seguro de que desea eliminar el Pago #<%= p.getIdPago() %>?');">
                                            <i class="bi bi-trash"></i>
                                        </a>
                                    </td>
                                </tr>
                                <%
                                        }
                                    } else {
                                %>
                                <tr>
                                    <td colspan="6" class="text-center text-muted py-4">No hay pagos registrados.</td>
                                </tr>
                                <%
                                    }
                                %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>