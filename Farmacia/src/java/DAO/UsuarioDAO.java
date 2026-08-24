package DAO;

import Conexion.Conexion;
import Modelo.Usuario;
import java.sql.*;

public class UsuarioDAO {

    public Usuario validar(String usuario, String clave) {
        Usuario u = null;
        // 1. Corregido: Se usa 'contrasena' en lugar de 'clave'
        String sql = "SELECT * FROM usuario WHERE usuario = ? AND contrasena = ?";
        
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            Conexion cn = new Conexion();
            con = cn.getConexion();

            if (con == null) {
                System.err.println("❌ ERROR CRÍTICO: No se pudo conectar a la Base de Datos (con es null).");
                return null;
            }

            ps = con.prepareStatement(sql);
            ps.setString(1, usuario != null ? usuario.trim() : "");
            ps.setString(2, clave != null ? clave.trim() : "");
            rs = ps.executeQuery();

            if (rs.next()) {
                u = new Usuario();
                
                // Intento flexible para obtener idUsuario / id_usuario
                try {
                    u.setIdUsuario(rs.getInt("id_usuario"));
                } catch (SQLException e) {
                    try { u.setIdUsuario(rs.getInt("idUsuario")); } catch (SQLException ex) { u.setIdUsuario(rs.getInt(1)); }
                }

                // Intento flexible para obtener nombre
                try {
                    u.setNombre(rs.getString("nombre"));
                } catch (SQLException e) {
                    u.setNombre("Usuario");
                }

                u.setUsuario(rs.getString("usuario"));
                
                // 2. Corregido: Se lee el campo 'contrasena'
                try {
                    u.setClave(rs.getString("contrasena"));
                } catch (SQLException e) {
                    u.setClave(rs.getString("clave"));
                }

                // Intento flexible para obtener rol
                try {
                    u.setRol(rs.getString("rol"));
                } catch (SQLException e) {
                    u.setRol("Vendedor");
                }
            }
        } catch (SQLException e) {
            System.err.println("❌ ERROR SQL EN UsuarioDAO: " + e.getMessage());
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return u;
    }
}