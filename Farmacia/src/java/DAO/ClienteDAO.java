package DAO;

import Conexion.Conexion;
import Modelo.Cliente;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ClienteDAO {
    private PreparedStatement ps;
    private ResultSet rs;

    public boolean guardar(Cliente c) {
        String sql = "INSERT INTO cliente (numero_documento, nombre, telefono, direccion) VALUES (?, ?, ?, ?)";
        Connection con = null;
        try {
            con = new Conexion().getConexion();
            ps = con.prepareStatement(sql);
            ps.setString(1, c.getDni());
            ps.setString(2, c.getNombre());
            ps.setString(3, c.getTelefono());
            ps.setString(4, c.getDireccion());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("❌ ERROR AL GUARDAR CLIENTE: " + e.getMessage());
            return false;
        } finally {
            cerrarConexiones(con);
        }
    }

    public List<Cliente> listar() {
        List<Cliente> lista = new ArrayList<>();
        String sql = "SELECT * FROM cliente";
        Connection con = null;
        try {
            con = new Conexion().getConexion();
            if (con == null) {
                System.err.println("❌ ERROR: La conexión a la BD devolvió null.");
                return lista;
            }
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                Cliente c = new Cliente();
                c.setIdCliente(rs.getInt("id_cliente"));
                String dniVal = rs.getString("numero_documento");
                c.setDni(dniVal != null ? dniVal : "");
                c.setNombre(rs.getString("nombre"));
                c.setTelefono(rs.getString("telefono"));
                c.setDireccion(rs.getString("direccion"));
                lista.add(c);
            }
        } catch (SQLException e) {
            System.err.println("❌ ERROR AL LISTAR CLIENTES: " + e.getMessage());
        } finally {
            cerrarConexiones(con);
        }
        return lista;
    }

    public boolean modificar(Cliente c) {
        String sql = "UPDATE cliente SET numero_documento=?, nombre=?, telefono=?, direccion=? WHERE id_cliente=?";
        Connection con = null;
        try {
            con = new Conexion().getConexion();
            ps = con.prepareStatement(sql);
            ps.setString(1, c.getDni());
            ps.setString(2, c.getNombre());
            ps.setString(3, c.getTelefono());
            ps.setString(4, c.getDireccion());
            ps.setInt(5, c.getIdCliente());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("❌ ERROR AL MODIFICAR CLIENTE: " + e.getMessage());
            return false;
        } finally {
            cerrarConexiones(con);
        }
    }

    public boolean eliminar(int id) {
        String sqlDelete = "DELETE FROM cliente WHERE id_cliente = ?";
        String sqlCount = "SELECT COUNT(*) FROM cliente";
        String sqlReset = "ALTER TABLE cliente AUTO_INCREMENT = 1";
        Connection con = null;

        try {
            con = new Conexion().getConexion();
            ps = con.prepareStatement(sqlDelete);
            ps.setInt(1, id);
            int filasAfectadas = ps.executeUpdate();

            if (filasAfectadas > 0) {
                ps = con.prepareStatement(sqlCount);
                rs = ps.executeQuery();
                if (rs.next() && rs.getInt(1) == 0) {
                    ps = con.prepareStatement(sqlReset);
                    ps.executeUpdate();
                }
                return true;
            }
        } catch (SQLException e) {
            System.err.println("❌ ERROR AL ELIMINAR CLIENTE: " + e.getMessage());
        } finally {
            cerrarConexiones(con);
        }
        return false;
    }

    private void cerrarConexiones(Connection con) {
        try {
            if (rs != null) rs.close();
            if (ps != null) ps.close();
            if (con != null) con.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}