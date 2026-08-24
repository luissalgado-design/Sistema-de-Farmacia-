<%@page import="DAO.MedicamentoDAO"%>
<%@page import="DAO.CategoriaDAO"%>
<%@page import="Modelo.Medicamento"%>
<%@page import="Modelo.Categoria"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // 1. Validar inicio de sesión
    HttpSession sesion = request.getSession(false);
    if (sesion == null || sesion.getAttribute("nombre") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String rol = (String) sesion.getAttribute("rol");
    String nombreUsuario = (String) sesion.getAttribute("nombre");
    boolean esVendedor = "Vendedor".equalsIgnoreCase(rol);

    // 2. Cargar datos (SE PERMITE ACCESO A AMBOS ROLES)
    MedicamentoDAO mdao = new MedicamentoDAO();
    CategoriaDAO cdao = new CategoriaDAO();

    List<Medicamento> listaMedicamentos = mdao.listar();
    List<Categoria> listaCategorias = cdao.listar();
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Consulta de Medicamentos - Farmacia</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <link rel="stylesheet" href="css/estilos.css">

    <style>
        /* Paleta Verde Menta / Esmeralda */
        .bg-mint-custom {
            background-color: #419d78 !important;
        }

        .text-mint-custom {
            color: #2d6a4f !important;
        }

        .badge-rol {
            background-color: #d8f3dc !important;
            color: #1b4332 !important;
            font-weight: 600;
        }

        .btn-mint-action {
            background-color: #419d78 !important;
            border-color: #419d78 !important;
            color: #ffffff !important;
            transition: all 0.2s ease;
        }

        .btn-mint-action:hover {
            background-color: #2d6a4f !important;
            border-color: #2d6a4f !important;
        }

        .form-control:focus, .form-select:focus {
            border-color: #52b788;
            box-shadow: 0 0 0 0.25rem rgba(65, 157, 120, 0.2);
        }

        .table-mint-header {
            background-color: #2d6a4f !important;
            color: #ffffff !important;
        }
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
                    
                    <%-- Mostrar pestañas adicionales solo si es Administrador --%>
                    <% if (!esVendedor) { %>
                        <li class="nav-item"><a class="nav-link" href="categorias.jsp"><i class="bi bi-tags"></i> Categorías</a></li>
                    <% } %>
                    
                    <li class="nav-item"><a class="nav-link active fw-semibold" href="medicamentos.jsp"><i class="bi bi-capsule"></i> Medicamentos</a></li>
                    
                    <% if (!esVendedor) { %>
                        <li class="nav-item"><a class="nav-link" href="pagos.jsp"><i class="bi bi-cash-stack"></i> Pagos</a></li>
                    <% } %>
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

    <!-- Contenido Principal -->
    <div class="container-fluid px-4">
        <div class="mb-4">
            <h3 class="fw-bold text-mint-custom m-0"><i class="bi bi-capsule-pill me-2"></i>Consulta y Gestión de Medicamentos</h3>
        </div>

        <div class="row g-4">
            
            <%-- Formulario de Registro: SOLO VISIBLE PARA ADMINISTRADORES --%>
            <% if (!esVendedor) { %>
            <div class="col-lg-4">
                <div class="card shadow-sm border-0">
                    <div class="card-header bg-white py-3 fw-bold text-mint-custom">
                        <i class="bi bi-plus-circle me-1"></i>Nuevo Medicamento
                    </div>
                    <div class="card-body p-4">
                        <form action="MedicamentoController" method="POST">
                            <input type="hidden" name="accion" value="guardar">

                            <div class="mb-3">
                                <label class="form-label fw-semibold">Código / Barra</label>
                                <input type="text" name="txtcodigo" class="form-control" placeholder="Ej: MED-001" required>
                            </div>

                            <div class="mb-3">
                                <label class="form-label fw-semibold">Nombre Comercial</label>
                                <input type="text" name="txtnombre" class="form-control" placeholder="Ej: Paracetamol 500mg" required>
                            </div>

                            <div class="mb-3">
                                <label class="form-label fw-semibold">Categoría</label>
                                <select name="txtidCategoria" class="form-select" required>
                                    <option value="" disabled selected>Seleccione una categoría...</option>
                                    <% if (listaCategorias != null && !listaCategorias.isEmpty()) {
                                        for (Categoria cat : listaCategorias) { %>
                                            <option value="<%= cat.getIdCategoria() %>"><%= cat.getNombre() %></option>
                                    <%  }
                                       } %>
                                </select>
                            </div>

                            <div class="row g-2 mb-3">
                                <div class="col-6">
                                    <label class="form-label fw-semibold">Precio ($)</label>
                                    <div class="input-group">
                                        <span class="input-group-text">$</span>
                                        <input type="number" step="0.01" name="txtprecioVenta" class="form-control" placeholder="0.00" required>
                                    </div>
                                </div>
                                <div class="col-6">
                                    <label class="form-label fw-semibold">Stock Actual</label>
                                    <input type="number" name="txtstockActual" class="form-control" placeholder="10" required>
                                </div>
                            </div>

                            <div class="mb-3">
                                <label class="form-label fw-semibold">Stock Mínimo</label>
                                <input type="number" name="txtstockMinimo" class="form-control" value="5" required>
                            </div>

                            <button type="submit" class="btn btn-mint-action w-100 fw-bold py-2 mt-2 shadow-sm">
                                <i class="bi bi-save me-1"></i> Guardar Medicamento
                            </button>
                        </form>
                    </div>
                </div>
            </div>
            <% } %>

            <!-- Tabla de Registros: Ocupa todo el ancho si es Vendedor -->
            <div class="<%= esVendedor ? "col-lg-12" : "col-lg-8" %>">
                <div class="card shadow-sm border-0">
                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <table class="table table-hover align-middle m-0">
                                <thead class="table-mint-header">
                                    <tr>
                                        <th class="ps-3">ID</th>
                                        <th>Código</th>
                                        <th>Nombre</th>
                                        <th>Precio</th>
                                        <th>Stock Disponible</th>
                                        <% if (!esVendedor) { %>
                                            <th class="text-center">Acciones</th>
                                        <% } %>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% if (listaMedicamentos != null && !listaMedicamentos.isEmpty()) {
                                        for (Medicamento m : listaMedicamentos) { %>
                                            <tr>
                                                <td class="ps-3 fw-bold text-secondary">#<%= m.getIdMedicamento() %></td>
                                                <td><span class="badge bg-light text-dark border"><%= m.getCodigo() != null ? m.getCodigo() : "N/A" %></span></td>
                                                <td class="fw-semibold"><%= m.getNombre() %></td>
                                                <td class="text-mint-custom fw-bold">$<%= String.format("%.2f", m.getPrecioVenta()) %></td>
                                                <td>
                                                    <span class="badge <%= m.getStockActual() <= m.getStockMinimo() ? "bg-danger" : "bg-success" %>">
                                                        <%= m.getStockActual() %> unidades
                                                    </span>
                                                </td>
                                                <% if (!esVendedor) { %>
                                                    <td class="text-center">
                                                        <a href="MedicamentoController?accion=eliminar&id=<%= m.getIdMedicamento() %>" 
                                                           class="btn btn-outline-danger btn-sm"
                                                           onclick="return confirm('¿Está seguro de eliminar este medicamento?')">
                                                            <i class="bi bi-trash"></i>
                                                        </a>
                                                    </td>
                                                <% } %>
                                            </tr>
                                    <%  }
                                       } else { %>
                                            <tr>
                                                <td colspan="<%= esVendedor ? "5" : "6" %>" class="text-center py-4 text-muted">
                                                    <i class="bi bi-inbox fs-3 d-block mb-2"></i>
                                                    No hay medicamentos registrados.
                                                </td>
                                            </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>

        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>