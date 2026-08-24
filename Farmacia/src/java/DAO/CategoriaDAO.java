package DAO;

import Conexion.Conexion;
import Modelo.Categoria;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CategoriaDAO {
    private Conexion cn = new Conexion();
    private Connection con;
    private PreparedStatement ps;
    private ResultSet rs;

    public boolean agregar(Categoria c) {
        String sql = "INSERT INTO categoria (nombre, descripcion) VALUES (?, ?)";
        try {
            con = cn.getConexion();
            ps = con.prepareStatement(sql);
            ps.setString(1, c.getNombre());
            ps.setString(2, c.getDescripcion());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("❌ ERROR AL GUARDAR CATEGORÍA: " + e.getMessage());
            return false;
        } finally {
            cerrarConexiones();
        }
    }

    public List<Categoria> listar() {
        List<Categoria> lista = new ArrayList<>();
        String sql = "SELECT * FROM categoria";
        try {
            con = cn.getConexion();
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                Categoria c = new Categoria();
                c.setIdCategoria(rs.getInt("id_categoria"));
                c.setNombre(rs.getString("nombre"));
                c.setDescripcion(rs.getString("descripcion"));
                lista.add(c);
            }
        } catch (SQLException e) {
            System.err.println("❌ ERROR AL LISTAR CATEGORÍAS: " + e.getMessage());
        } finally {
            cerrarConexiones();
        }
        return lista;
    }

    public boolean modificar(Categoria c) {
        String sql = "UPDATE categoria SET nombre=?, descripcion=? WHERE id_categoria=?";
        try {
            con = cn.getConexion();
            ps = con.prepareStatement(sql);
            ps.setString(1, c.getNombre());
            ps.setString(2, c.getDescripcion());
            ps.setInt(3, c.getIdCategoria());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("❌ ERROR AL MODIFICAR CATEGORÍA: " + e.getMessage());
            return false;
        } finally {
            cerrarConexiones();
        }
    }

    public boolean eliminar(int id) {
        String sqlDelete = "DELETE FROM categoria WHERE id_categoria = ?";
        String sqlCount = "SELECT COUNT(*) FROM categoria";
        String sqlReset = "ALTER TABLE categoria AUTO_INCREMENT = 1";

        try {
            con = cn.getConexion();
            ps = con.prepareStatement(sqlDelete);
            ps.setInt(1, id);
            int filasAfectadas = ps.executeUpdate();

            if (filasAfectadas > 0) {
                // Verificar si la tabla quedó totalmente vacía
                ps = con.prepareStatement(sqlCount);
                rs = ps.executeQuery();
                if (rs.next() && rs.getInt(1) == 0) {
                    // Resetear auto_increment a 1
                    ps = con.prepareStatement(sqlReset);
                    ps.executeUpdate();
                }
                return true;
            }
        } catch (SQLException e) {
            System.err.println("❌ ERROR AL ELIMINAR CATEGORÍA: " + e.getMessage());
        } finally {
            cerrarConexiones();
        }
        return false;
    }

    private void cerrarConexiones() {
        try {
            if (rs != null) rs.close();
            if (ps != null) ps.close();
            if (con != null) con.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}