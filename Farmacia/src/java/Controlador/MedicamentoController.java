package Controlador;

import DAO.MedicamentoDAO;
import Modelo.Medicamento;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet(name = "MedicamentoController", urlPatterns = {"/MedicamentoController"})
public class MedicamentoController extends HttpServlet {

    private MedicamentoDAO dao = new MedicamentoDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        
        // Validación de sesión y rol
        HttpSession session = request.getSession();
        String rol = (String) session.getAttribute("rol");

        // Si es Vendedor, se rechaza la modificación o creación
        if ("Vendedor".equalsIgnoreCase(rol)) {
            response.sendRedirect("medicamentos.jsp?error=unauthorized");
            return;
        }

        String accion = request.getParameter("accion");

        try {
            String codigo = request.getParameter("txtcodigo");
            String nombre = request.getParameter("txtnombre");
            
            // Parseo con compatibilidad para comas/puntos y sincronizado con el JSP
            double precio = parseDouble(request.getParameter("txtprecioVenta"), 0.0);
            int idCat = parseInt(request.getParameter("txtidCategoria"), 1);
            int stockActual = parseInt(request.getParameter("txtstockActual"), 0);
            int stockMinimo = parseInt(request.getParameter("txtstockMinimo"), 0);

            if ("modificar".equalsIgnoreCase(accion)) {
                int id = parseInt(request.getParameter("txtid"), 0);
                Medicamento m = new Medicamento(id, codigo, nombre, precio, idCat, stockActual, stockMinimo);
                dao.modificar(m);
            } else if ("guardar".equalsIgnoreCase(accion)) {
                Medicamento m = new Medicamento();
                m.setCodigo(codigo);
                m.setNombre(nombre);
                m.setPrecioVenta(precio);
                m.setIdCategoria(idCat);
                m.setStockActual(stockActual);
                m.setStockMinimo(stockMinimo);
                dao.guardar(m);
            }
        } catch (Exception e) {
            System.err.println("❌ ERROR EN MedicamentoController doPost: " + e.getMessage());
            e.printStackTrace();
        }
        
        response.sendRedirect("medicamentos.jsp");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Validación de sesión y rol
        HttpSession session = request.getSession();
        String rol = (String) session.getAttribute("rol");
        String accion = request.getParameter("accion");
        
        if ("eliminar".equalsIgnoreCase(accion)) {
            // Si es Vendedor, bloquea la eliminación directa por URL
            if ("Vendedor".equalsIgnoreCase(rol)) {
                response.sendRedirect("medicamentos.jsp?error=unauthorized");
                return;
            }

            try {
                int id = parseInt(request.getParameter("id"), 0);
                if (id > 0) {
                    dao.eliminar(id);
                }
            } catch (Exception e) {
                System.err.println("❌ ERROR EN MedicamentoController doGet (eliminar): " + e.getMessage());
            }
        }
        
        response.sendRedirect("medicamentos.jsp");
    }

    // Métodos de ayuda para parseo seguro
    private int parseInt(String value, int defaultValue) {
        try {
            return (value != null && !value.trim().isEmpty()) ? Integer.parseInt(value.trim()) : defaultValue;
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }

    private double parseDouble(String value, double defaultValue) {
        try {
            if (value != null && !value.trim().isEmpty()) {
                return Double.parseDouble(value.trim().replace(",", "."));
            }
            return defaultValue;
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }
}