package Controlador;

import DAO.ClienteDAO;
import Modelo.Cliente;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet(name = "ClienteController", urlPatterns = {"/ClienteController"})
public class ClienteController extends HttpServlet {

    private ClienteDAO dao = new ClienteDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        String accion = request.getParameter("accion");

        String dni = request.getParameter("txtdni");
        String nombre = request.getParameter("txtnombre");
        String telefono = request.getParameter("txttelefono");
        String direccion = request.getParameter("txtdireccion");

        if ("modificar".equalsIgnoreCase(accion)) {
            int id = Integer.parseInt(request.getParameter("txtid"));
            Cliente c = new Cliente(id, dni, nombre, telefono, direccion);
            dao.modificar(c);
        } else {
            Cliente c = new Cliente();
            c.setDni(dni);
            c.setNombre(nombre);
            c.setTelefono(telefono);
            c.setDireccion(direccion);
            dao.guardar(c);
        }
        
        response.sendRedirect("clientes.jsp");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String accion = request.getParameter("accion");
        
        if ("eliminar".equalsIgnoreCase(accion)) {
            int id = Integer.parseInt(request.getParameter("id"));
            dao.eliminar(id);
        }
        
        response.sendRedirect("clientes.jsp");
    }
}