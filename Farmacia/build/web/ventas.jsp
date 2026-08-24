<%@page import="DAO.ClienteDAO"%>
<%@page import="DAO.MedicamentoDAO"%>
<%@page import="Modelo.Cliente"%>
<%@page import="Modelo.Medicamento"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    HttpSession sesion = request.getSession(false);
    if (sesion == null || sesion.getAttribute("nombre") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String rol = (String) sesion.getAttribute("rol");
    
    Object idSesionObj = sesion.getAttribute("idUsuario");
    int idUsuarioSesion = 1;
    if (idSesionObj instanceof Integer) {
        idUsuarioSesion = (Integer) idSesionObj;
    } else if (idSesionObj != null) {
        try { idUsuarioSesion = Integer.parseInt(idSesionObj.toString()); } catch (NumberFormatException e) { idUsuarioSesion = 1; }
    }

    String nombreUsuario = (String) sesion.getAttribute("nombre");
    boolean esVendedor = "Vendedor".equalsIgnoreCase(rol);

    ClienteDAO clienteDAO = new ClienteDAO();
    MedicamentoDAO medicamentoDAO = new MedicamentoDAO();
    
    List<Cliente> listaClientes = clienteDAO.listar();
    List<Medicamento> listaMedicamentos = medicamentoDAO.listar();
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Punto de Venta - Farmacia</title>
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
    </style>
</head>
<body class="bg-light">

    <nav class="navbar navbar-expand-lg navbar-dark bg-mint-custom mb-4 shadow-sm">
        <div class="container-fluid px-4">
            <a class="navbar-brand fw-bold fs-4" href="ventas.jsp">💊 FARMACIA</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                    <li class="nav-item"><a class="nav-link active fw-semibold" href="ventas.jsp"><i class="bi bi-cart3"></i> Ventas</a></li>
                    <li class="nav-item"><a class="nav-link" href="clientes.jsp"><i class="bi bi-people"></i> Clientes</a></li>
                    <% if (!esVendedor) { %>
                        <li class="nav-item"><a class="nav-link" href="categorias.jsp"><i class="bi bi-tags"></i> Categorías</a></li>
                        <li class="nav-item"><a class="nav-link" href="medicamentos.jsp"><i class="bi bi-capsule"></i> Medicamentos</a></li>
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

    <div class="container-fluid px-4">
        
        <% if (request.getParameter("error") != null) { %>
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="bi bi-exclamation-triangle-fill me-2"></i> 
                <% if ("stock_insuficiente".equals(request.getParameter("error"))) { %>
                    Error: La cantidad solicitada supera el stock disponible.
                <% } else { %>
                    Error al procesar la venta. Verifique los datos o seleccione un medicamento válido.
                <% } %>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        <% } %>

        <form action="VentaController" method="POST" id="formVenta">
            <input type="hidden" name="accion" value="procesarVenta">
            <input type="hidden" name="txtidUsuario" value="<%= idUsuarioSesion %>">

            <div class="row g-4">
                <div class="col-lg-7">
                    
                    <div class="card shadow-sm border-0 mb-4">
                        <div class="card-header bg-white py-3 fw-bold text-mint-custom">
                            <i class="bi bi-person-fill me-2"></i>1. Cliente y Vendedor
                        </div>
                        <div class="card-body">
                            <div class="row g-3">
                                <div class="col-md-8">
                                    <label class="form-label fw-semibold">Seleccionar Cliente</label>
                                    <select name="txtidCliente" class="form-select" required>
                                        <% if (listaClientes != null && !listaClientes.isEmpty()) {
                                            for (Cliente c : listaClientes) { %>
                                                <option value="<%= c.getIdCliente() %>">
                                                    <%= c.getNombre() %> (ID: <%= c.getIdCliente() %>)
                                                </option>
                                        <%  } 
                                           } else { %>
                                                <option value="1">Cliente Genérico / Consumidor Final</option>
                                        <% } %>
                                    </select>
                                </div>
                                <div class="col-md-4">
                                    <label class="form-label fw-semibold">Vendedor Atendiendo</label>
                                    <input type="text" class="form-control bg-light" value="<%= nombreUsuario %>" readonly>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="card shadow-sm border-0">
                        <div class="card-header bg-white py-3 fw-bold text-mint-custom">
                            <i class="bi bi-capsule-pill me-2"></i>2. Detalles del Producto
                        </div>
                        <div class="card-body">
                            <div class="row g-3">
                                <div class="col-12">
                                    <label class="form-label fw-semibold">Medicamento</label>
                                    <select id="selectMedicamento" name="txtidMedicamento" class="form-select" onchange="actualizarPrecio()" required>
                                        <option value="" disabled selected>Seleccione un medicamento...</option>
                                        <% if (listaMedicamentos != null && !listaMedicamentos.isEmpty()) {
                                            for (Medicamento m : listaMedicamentos) { %>
                                                <option value="<%= m.getIdMedicamento() %>" data-stock="<%= m.getStock() %>" data-precio="<%= m.getPrecio() %>">
                                                    <%= m.getNombre() %> (ID: <%= m.getIdMedicamento() %>) - Stock: <%= m.getStock() %>
                                                </option>
                                        <%  } 
                                           } %>
                                    </select>
                                </div>

                                <div class="col-md-6">
                                    <label class="form-label fw-semibold">Precio Unitario ($)</label>
                                    <div class="input-group">
                                        <span class="input-group-text">$</span>
                                        <input type="number" step="0.01" id="precio" name="txtprecio" class="form-control" value="2.00" oninput="calcularTotal()" required>
                                    </div>
                                </div>

                                <div class="col-md-6">
                                    <label class="form-label fw-semibold">Cantidad</label>
                                    <input type="number" id="cantidad" name="txtcantidad" class="form-control" value="1" min="1" oninput="calcularTotal()" required>
                                </div>
                            </div>
                        </div>
                    </div>

                </div>

                <div class="col-lg-5">
                    <div class="card shadow-sm border-0 sticky-top" style="top: 20px;">
                        <div class="card-header bg-dark text-white py-3 fw-bold">
                            <i class="bi bi-receipt me-2"></i>Resumen de Venta
                        </div>
                        <div class="card-body p-4">
                            
                            <div class="mb-4">
                                <label class="form-label fw-semibold">Método de Pago</label>
                                <select name="txtmetodoPago" class="form-select form-select-lg">
                                    <option value="Efectivo" selected>💵 Efectivo</option>
                                    <option value="Tarjeta">💳 Tarjeta de Crédito/Débito</option>
                                    <option value="Transferencia">📱 Transferencia Bancaria</option>
                                </select>
                            </div>

                            <hr>

                            <div class="d-flex justify-content-between align-items-center my-3">
                                <span class="fs-5 text-muted">Total a Pagar:</span>
                                <span class="display-6 fw-bold text-mint-custom">$<span id="totalDisplay">2.00</span></span>
                            </div>

                            <input type="hidden" id="total" name="txttotal" value="2.00">

                            <button type="submit" class="btn btn-mint-action btn-lg w-100 fw-bold py-3 mt-3 shadow">
                                <i class="bi bi-check-circle-fill me-2"></i> PROCESAR VENTA
                            </button>
                        </div>
                    </div>
                </div>

            </div>
        </form>
    </div>

    <script>
        function actualizarPrecio() {
            let select = document.getElementById('selectMedicamento');
            let optionSelected = select.options[select.selectedIndex];
            
            let precio = optionSelected.getAttribute('data-precio') || "2.00";
            let stock = optionSelected.getAttribute('data-stock') || "1";

            document.getElementById('precio').value = precio;
            
            let inputCantidad = document.getElementById('cantidad');
            inputCantidad.max = stock;
            
            calcularTotal();
        }

        function calcularTotal() {
            let select = document.getElementById('selectMedicamento');
            let optionSelected = select.options[select.selectedIndex];
            let stockDisponible = parseInt(optionSelected.getAttribute('data-stock')) || 0;

            let cantInput = document.getElementById('cantidad');
            let cant = parseInt(cantInput.value) || 0;
            let prec = parseFloat(document.getElementById('precio').value) || 0;

            if (stockDisponible > 0 && cant > stockDisponible) {
                alert('❌ La cantidad solicitada (' + cant + ') supera el stock disponible (' + stockDisponible + ').');
                cantInput.value = stockDisponible;
                cant = stockDisponible;
            }

            let total = (cant * prec).toFixed(2);
            
            document.getElementById('total').value = total;
            document.getElementById('totalDisplay').innerText = total;
        }

        document.addEventListener("DOMContentLoaded", function() {
            calcularTotal();
        });
    </script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>