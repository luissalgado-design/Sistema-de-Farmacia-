package Controlador;

import DAO.CategoriaDAO;
import Modelo.Categoria;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet(name = "CategoriaController", urlPatterns = {"/CategoriaController"})
public class CategoriaController extends HttpServlet {

    private CategoriaDAO dao = new CategoriaDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String accion = request.getParameter("accion");

        if ("guardar".equalsIgnoreCase(accion)) {
            Categoria c = new Categoria();
            c.setNombre(request.getParameter("txtnombre"));
            c.setDescripcion(request.getParameter("txtdescripcion"));
            dao.agregar(c);
        } else if ("modificar".equalsIgnoreCase(accion)) {
            Categoria c = new Categoria();
            c.setIdCategoria(Integer.parseInt(request.getParameter("txtid")));
            c.setNombre(request.getParameter("txtnombre"));
            c.setDescripcion(request.getParameter("txtdescripcion"));
            dao.modificar(c);
        }
        
        response.sendRedirect("categorias.jsp");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String accion = request.getParameter("accion");

        if ("eliminar".equalsIgnoreCase(accion)) {
            int id = Integer.parseInt(request.getParameter("id"));
            dao.eliminar(id);
        }

        response.sendRedirect("categorias.jsp");
    }
}