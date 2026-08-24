<%@page import="DAO.ClienteDAO"%>
<%@page import="Modelo.Cliente"%>
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
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Clientes - Farmacia</title>
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
            color: #ffffff !important;
        }

        .form-control:focus {
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
                    <li class="nav-item"><a class="nav-link active fw-semibold" href="clientes.jsp"><i class="bi bi-people"></i> Clientes</a></li>
                    <li class="nav-item"><a class="nav-link" href="medicamentos.jsp"><i class="bi bi-capsule"></i> Medicamentos</a></li>
                    
                    <%-- Mostrar pestañas adicionales solo si es Administrador --%>
                    <% if (!esVendedor) { %>
                        <li class="nav-item"><a class="nav-link" href="categorias.jsp"><i class="bi bi-tags"></i> Categorías</a></li>
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
            <h3 class="fw-bold text-mint-custom m-0"><i class="bi bi-person-lines-fill me-2"></i>Gestión de Clientes</h3>
        </div>

        <div class="row g-4">
            <!-- Formulario de Registro / Edición -->
            <div class="col-lg-4">
                <div class="card shadow-sm border-0">
                    <div class="card-header bg-white py-3 fw-bold text-mint-custom" id="formTitulo">
                        <i class="bi bi-person-plus me-1"></i>Nuevo Cliente
                    </div>
                    <div class="card-body p-4">
                        <form action="ClienteController" method="POST">
                            <input type="hidden" name="accion" id="accion" value="guardar">
                            <input type="hidden" name="txtid" id="txtid" value="0">

                            <div class="mb-3">
                                <label class="form-label fw-semibold">DNI / Identificación</label>
                                <input type="text" name="txtdni" id="txtdni" class="form-control" placeholder="Ej. 1712345678" required>
                            </div>

                            <div class="mb-3">
                                <label class="form-label fw-semibold">Nombre Completo</label>
                                <input type="text" name="txtnombre" id="txtnombre" class="form-control" placeholder="Ej. Juan Pérez" required>
                            </div>
                            
                            <div class="mb-3">
                                <label class="form-label fw-semibold">Teléfono</label>
                                <input type="text" name="txttelefono" id="txttelefono" class="form-control" placeholder="Ej. 0991234567" required>
                            </div>

                            <div class="mb-3">
                                <label class="form-label fw-semibold">Dirección</label>
                                <input type="text" name="txtdireccion" id="txtdireccion" class="form-control" placeholder="Ej. Av. Principal #123" required>
                            </div>
                            
                            <button type="submit" id="btnGuardar" class="btn btn-mint-action w-100 fw-bold py-2 mb-2 shadow-sm">
                                <i class="bi bi-save me-1"></i> Guardar Cliente
                            </button>
                            <button type="button" id="btnCancelar" class="btn btn-outline-secondary w-100 fw-bold d-none py-2" onclick="limpiarFormulario()">
                                <i class="bi bi-x-circle me-1"></i> Cancelar
                            </button>
                        </form>
                    </div>
                </div>
            </div>

            <!-- Tabla de Datos -->
            <div class="col-lg-8">
                <div class="card shadow-sm border-0">
                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <table class="table table-hover align-middle m-0">
                                <thead class="table-mint-header">
                                    <tr>
                                        <th class="ps-3">ID</th>
                                        <th>DNI / N° Doc</th>
                                        <th>Nombre Completo</th>
                                        <th>Teléfono</th>
                                        <th>Dirección</th>
                                        <th class="text-center">Acciones</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <%
                                        ClienteDAO cdao = new ClienteDAO();
                                        List<Cliente> lista = cdao.listar();
                                        if (lista != null && !lista.isEmpty()) {
                                            for (Cliente c : lista) {
                                                String dniMostrar = (c.getDni() == null) ? "" : c.getDni();
                                    %>
                                    <tr>
                                        <td class="ps-3 fw-bold text-secondary">#<%= c.getIdCliente() %></td>
                                        <td><span class="badge bg-light text-dark border"><%= dniMostrar %></span></td>
                                        <td class="fw-semibold"><%= c.getNombre() %></td>
                                        <td><%= c.getTelefono() %></td>
                                        <td class="text-muted"><%= c.getDireccion() %></td>
                                        <td class="text-center">
                                            <button class="btn btn-outline-warning btn-sm me-1" 
                                                    onclick="editarCliente('<%= c.getIdCliente() %>', '<%= dniMostrar %>', '<%= c.getNombre() %>', '<%= c.getTelefono() %>', '<%= c.getDireccion() %>')">
                                                <i class="bi bi-pencil"></i>
                                            </button>
                                            <a href="ClienteController?accion=eliminar&id=<%= c.getIdCliente() %>" 
                                               class="btn btn-outline-danger btn-sm"
                                               onclick="return confirm('¿Seguro de eliminar este cliente?');">
                                                <i class="bi bi-trash"></i>
                                            </a>
                                        </td>
                                    </tr>
                                    <%
                                            }
                                        } else {
                                    %>
                                    <tr>
                                        <td colspan="6" class="text-center py-4 text-muted">
                                            <i class="bi bi-inbox fs-3 d-block mb-2"></i>
                                            No hay clientes registrados en la Base de Datos.
                                        </td>
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
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function editarCliente(id, dni, nombre, telefono, direccion) {
            document.getElementById('txtid').value = id;
            document.getElementById('txtdni').value = dni;
            document.getElementById('txtnombre').value = nombre;
            document.getElementById('txttelefono').value = telefono;
            document.getElementById('txtdireccion').value = direccion;
            
            document.getElementById('accion').value = 'modificar';
            document.getElementById('formTitulo').innerHTML = '<i class="bi bi-pencil-square me-1"></i>Editar Cliente ID: #' + id;
            
            const btnGuardar = document.getElementById('btnGuardar');
            btnGuardar.innerHTML = '<i class="bi bi-arrow-repeat me-1"></i> Actualizar Cliente';
            btnGuardar.className = 'btn btn-warning text-dark w-100 fw-bold py-2 mb-2 shadow-sm';
            
            document.getElementById('btnCancelar').classList.remove('d-none');
        }

        function limpiarFormulario() {
            document.getElementById('txtid').value = '0';
            document.getElementById('txtdni').value = '';
            document.getElementById('txtnombre').value = '';
            document.getElementById('txttelefono').value = '';
            document.getElementById('txtdireccion').value = '';
            
            document.getElementById('accion').value = 'guardar';
            document.getElementById('formTitulo').innerHTML = '<i class="bi bi-person-plus me-1"></i>Nuevo Cliente';
            
            const btnGuardar = document.getElementById('btnGuardar');
            btnGuardar.innerHTML = '<i class="bi bi-save me-1"></i> Guardar Cliente';
            btnGuardar.className = 'btn btn-mint-action w-100 fw-bold py-2 mb-2 shadow-sm';
            
            document.getElementById('btnCancelar').classList.add('d-none');
        }
    </script>
</body>
</html>