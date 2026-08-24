package Controlador;

import DAO.UsuarioDAO;
import Modelo.Usuario;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet(name = "UsuarioController", urlPatterns = {"/UsuarioController"})
public class UsuarioController extends HttpServlet {

    private UsuarioDAO udao = new UsuarioDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        
        String accion = request.getParameter("accion");

        if (accion != null && (accion.equalsIgnoreCase("login") || accion.equalsIgnoreCase("Ingresar"))) {
            String usuario = request.getParameter("txtusuario");
            String clave = request.getParameter("txtclave");

            Usuario user = udao.validar(usuario, clave);

            if (user != null) {
                HttpSession sesion = request.getSession(true);
                sesion.setAttribute("idUsuario", user.getIdUsuario());
                sesion.setAttribute("nombre", user.getNombre());
                sesion.setAttribute("rol", user.getRol());

                System.out.println("✅ LOGIN EXITOSO: " + user.getNombre() + " (" + user.getRol() + ")");
                response.sendRedirect("ventas.jsp");
            } else {
                System.err.println("❌ ERROR: Credenciales inválidas para " + usuario);
                request.setAttribute("error", "Usuario o contraseña incorrectos");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }
        } else {
            // Si entra por primera vez o acción desconocida
            response.sendRedirect("login.jsp");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }
}