<%@page import="DAO.DetalleVentaDAO"%>
<%@page import="DAO.MedicamentoDAO"%>
<%@page import="DAO.VentaDAO"%>
<%@page import="Modelo.DetalleVenta"%>
<%@page import="Modelo.Medicamento"%>
<%@page import="Modelo.Venta"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // Obtener idVenta de la URL
    String idVentaStr = request.getParameter("idVenta");
    int idVenta = 0;
    try {
        if (idVentaStr != null) {
            idVenta = Integer.parseInt(idVentaStr);
        }
    } catch (NumberFormatException e) {
        idVenta = 0;
    }

    VentaDAO vdao = new VentaDAO();
    DetalleVentaDAO dvdao = new DetalleVentaDAO();
    MedicamentoDAO mdao = new MedicamentoDAO();

    // Buscar venta y sus detalles
    Venta venta = (idVenta > 0) ? vdao.buscarPorId(idVenta) : null;
    List<DetalleVenta> detalles = (idVenta > 0) ? dvdao.listarPorVenta(idVenta) : null;
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Comprobante de Venta #<%= idVenta %></title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    
    <style>
        body { 
            background-color: #f4f7f6; 
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        .ticket { 
            max-width: 420px; 
            margin: 40px auto; 
            background: #ffffff; 
            padding: 25px; 
            border-radius: 12px; 
            box-shadow: 0 4px 15px rgba(0,0,0,0.05); 
            border-top: 5px solid #419d78;
        }

        .text-mint-custom {
            color: #2d6a4f !important;
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

        .badge-status {
            background-color: #d8f3dc !important;
            color: #1b4332 !important;
            font-weight: 600;
        }

        .table-ticket thead {
            border-bottom: 2px solid #e9ecef;
        }

        .table-ticket th {
            color: #2d6a4f;
            font-size: 0.85rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        @media print {
            body { background-color: #fff; }
            .no-print { display: none !important; }
            .ticket { 
                box-shadow: none; 
                margin: 0; 
                width: 100%; 
                max-width: 100%;
                padding: 0;
                border-top: none;
            }
        }
    </style>
</head>
<body>

<div class="container">
    <div class="ticket">
        <!-- Encabezado del Ticket -->
        <div class="text-center mb-3">
            <h4 class="fw-bold text-mint-custom mb-1"><i class="bi bi-capsule me-1"></i>FARMACIA</h4>
            <small class="text-muted fw-semibold">Comprobante de Venta</small>
            <hr class="my-3 text-secondary opacity-25">
        </div>

        <% if (venta != null) { %>
            <!-- Datos de la Venta -->
            <div class="row mb-2 small">
                <div class="col-6"><strong>N° Venta:</strong> <span class="text-secondary">#<%= venta.getIdVenta() %></span></div>
                <div class="col-6 text-end"><strong>Cliente ID:</strong> <span class="text-secondary"><%= venta.getIdCliente() %></span></div>
            </div>
            <div class="row mb-3 small">
                <div class="col-6">
                    <span class="text-muted">Fecha:</span><br>
                    <strong><%= venta.getFechaVenta() != null ? venta.getFechaVenta() : "N/A" %></strong>
                </div>
                <div class="col-6 text-end">
                    <span class="text-muted">Estado:</span><br>
                    <span class="badge badge-status px-2 py-1"><%= venta.getEstado() %></span>
                </div>
            </div>

            <!-- Tabla de Detalles -->
            <table class="table table-sm table-borderless table-ticket text-start small mb-3">
                <thead>
                    <tr>
                        <th>Cant</th>
                        <th>Producto</th>
                        <th class="text-end">P.Unit</th>
                        <th class="text-end">Subtotal</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        if (detalles != null && !detalles.isEmpty()) {
                            for (DetalleVenta d : detalles) {
                                Medicamento m = mdao.buscarPorId(d.getIdMedicamento());
                                String nombreMed = (m != null) ? m.getNombre() : "Producto #" + d.getIdMedicamento();
                    %>
                    <tr class="align-middle">
                        <td class="fw-bold"><%= d.getCantidad() %></td>
                        <td><%= nombreMed %></td>
                        <td class="text-end text-muted">$<%= String.format("%.2f", d.getPrecioUnitario()) %></td>
                        <td class="text-end fw-semibold">$<%= String.format("%.2f", d.getSubtotal()) %></td>
                    </tr>
                    <%
                            }
                        } else {
                    %>
                    <tr>
                        <td colspan="4" class="text-center text-muted py-3">Sin detalles registrados</td>
                    </tr>
                    <% } %>
                </tbody>
            </table>

            <hr class="my-3 text-secondary opacity-25">
            
            <!-- Total -->
            <div class="d-flex justify-content-between align-items-center fs-5 fw-bold my-3">
                <span class="text-dark">TOTAL:</span>
                <span class="text-mint-custom fs-4">$<%= String.format("%.2f", venta.getTotal()) %></span>
            </div>
        <% } else { %>
            <div class="alert alert-warning text-center border-0 shadow-sm my-4">
                <i class="bi bi-exclamation-triangle fs-4 d-block mb-2"></i>
                No se encontró el comprobante para la venta ID: <strong><%= idVenta %></strong>
            </div>
        <% } %>

        <!-- Botones de Acción -->
        <div class="mt-4 no-print d-flex gap-2">
            <button onclick="window.print()" class="btn btn-mint-action w-50 fw-bold shadow-sm">
                <i class="bi bi-printer me-1"></i> Imprimir
            </button>
            <a href="ventas.jsp" class="btn btn-outline-secondary w-50 fw-bold">
                <i class="bi bi-arrow-left me-1"></i> Volver
            </a>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>