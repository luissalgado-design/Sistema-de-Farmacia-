package Controlador;

import DAO.PagoDAO;
import Modelo.Pago;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet(name = "PagoController", urlPatterns = {"/PagoController"})
public class PagoController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String accion = request.getParameter("accion");
        PagoDAO pdao = new PagoDAO();

        if ("guardar".equalsIgnoreCase(accion)) {
            try {
                int idVenta = Integer.parseInt(request.getParameter("txtidventa"));
                String metodoPago = request.getParameter("txtmetodo");
                double monto = Double.parseDouble(request.getParameter("txtmonto"));

                Pago p = new Pago();
                p.setIdVenta(idVenta);
                p.setMetodoPago(metodoPago);
                p.setMonto(monto);

                pdao.registrarPago(p);
            } catch (Exception e) {
                System.err.println("❌ ERROR AL GUARDAR PAGO: " + e.getMessage());
            }
        } else if ("eliminar".equalsIgnoreCase(accion)) {
            try {
                int idPago = Integer.parseInt(request.getParameter("id"));
                pdao.eliminar(idPago);
            } catch (Exception e) {
                System.err.println("❌ ERROR AL ELIMINAR PAGO: " + e.getMessage());
            }
        }
        
        response.sendRedirect("pagos.jsp");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }
}