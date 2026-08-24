package Controlador;

import Conexion.Conexion;
import DAO.DetalleVentaDAO;
import DAO.MedicamentoDAO;
import DAO.PagoDAO;
import DAO.VentaDAO;
import Modelo.DetalleVenta;
import Modelo.Pago;
import Modelo.Venta;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet(name = "VentaController", urlPatterns = {"/VentaController"})
public class VentaController extends HttpServlet {

    private VentaDAO vdao = new VentaDAO();
    private DetalleVentaDAO dvdao = new DetalleVentaDAO();
    private MedicamentoDAO mdao = new MedicamentoDAO();
    private PagoDAO pdao = new PagoDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        
        HttpSession sesion = request.getSession(false);
        if (sesion == null || sesion.getAttribute("nombre") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String accion = request.getParameter("accion");

        if ("procesarVenta".equalsIgnoreCase(accion)) {
            Connection con = null;
            try {
                Object idSesionObj = sesion.getAttribute("idUsuario");
                int idUsuarioSesion = 1;
                if (idSesionObj instanceof Integer) {
                    idUsuarioSesion = (Integer) idSesionObj;
                } else if (idSesionObj != null) {
                    try {
                        idUsuarioSesion = Integer.parseInt(idSesionObj.toString());
                    } catch (NumberFormatException e) {
                        idUsuarioSesion = 1;
                    }
                }

                int idCliente = parseInteger(request.getParameter("txtidCliente"), 1);
                int idMedicamento = parseInteger(request.getParameter("txtidMedicamento"), 0);
                int cantidad = parseInteger(request.getParameter("txtcantidad"), 0);
                double precioUnitario = parseDouble(request.getParameter("txtprecio"), 0.0);
                
                if (idMedicamento <= 0 || cantidad <= 0) {
                    System.err.println("❌ ERROR: Datos de medicamento o cantidad inválidos.");
                    response.sendRedirect("ventas.jsp?error=invalid_data");
                    return;
                }

                // --- VALIDACIÓN DE STOCK DISPONIBLE ---
                int stockDisponible = mdao.obtenerStock(idMedicamento);
                if (cantidad > stockDisponible) {
                    System.err.println("❌ ERROR: Cantidad solicitada (" + cantidad + ") supera el stock (" + stockDisponible + ")");
                    response.sendRedirect("ventas.jsp?error=stock_insuficiente");
                    return;
                }

                double total = cantidad * precioUnitario;
                String metodoPago = request.getParameter("txtmetodoPago");
                if (metodoPago == null || metodoPago.trim().isEmpty()) {
                    metodoPago = "Efectivo";
                }

                Conexion conexionObj = new Conexion();
                con = conexionObj.getConexion();
                con.setAutoCommit(false);

                Venta v = new Venta();
                v.setIdCliente(idCliente);
                v.setIdUsuario(idUsuarioSesion);
                v.setTotal(total);
                v.setEstado("Completada");

                int idVentaGenerado = vdao.registrarVenta(v, con);

                if (idVentaGenerado > 0) {
                    DetalleVenta dv = new DetalleVenta();
                    dv.setIdVenta(idVentaGenerado);
                    dv.setIdMedicamento(idMedicamento);
                    dv.setCantidad(cantidad);
                    dv.setPrecioUnitario(precioUnitario);
                    dv.setSubtotal(total);
                    dvdao.guardarDetalle(dv, con);

                    mdao.actualizarStock(idMedicamento, cantidad, con);

                    Pago p = new Pago();
                    p.setIdVenta(idVentaGenerado);
                    p.setMetodoPago(metodoPago);
                    p.setMonto(total);
                    p.setEstadoPago("Completado");
                    
                    pdao.registrarPago(p, con);

                    con.commit();
                    
                    response.sendRedirect("comprobante.jsp?idVenta=" + idVentaGenerado);
                    return;
                } else {
                    con.rollback();
                    response.sendRedirect("ventas.jsp?error=insert_failed");
                    return;
                }

            } catch (Exception e) {
                if (con != null) {
                    try { con.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
                }
                System.err.println("❌ ERROR EN VentaController: " + e.getMessage());
                e.printStackTrace();
                response.sendRedirect("ventas.jsp?error=exception");
                return;
            } finally {
                if (con != null) {
                    try { con.close(); } catch (SQLException e) { e.printStackTrace(); }
                }
            }
        }
        response.sendRedirect("ventas.jsp");
    }

    private int parseInteger(String value, int defaultValue) {
        try {
            return value != null && !value.trim().isEmpty() ? Integer.parseInt(value.trim()) : defaultValue;
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }

    private double parseDouble(String value, double defaultValue) {
        try {
            return value != null && !value.trim().isEmpty() ? Double.parseDouble(value.trim().replace(",", ".")) : defaultValue;
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }
}