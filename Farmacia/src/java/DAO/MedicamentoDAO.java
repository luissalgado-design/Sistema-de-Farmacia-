package DAO;

import Conexion.Conexion;
import Modelo.Medicamento;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class MedicamentoDAO {
    private PreparedStatement ps;
    private ResultSet rs;

    public List<Medicamento> listar() {
        List<Medicamento> lista = new ArrayList<>();
        String sql = "SELECT * FROM medicamento";
        Connection con = null;
        try {
            con = new Conexion().getConexion();
            if (con == null) return lista;
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                Medicamento m = new Medicamento();
                m.setIdMedicamento(rs.getInt("id_medicamento"));
                
                // Mapeo seguro para el código
                try { m.setCodigo(rs.getString("codigo")); } catch (SQLException e) { m.setCodigo(""); }
                
                m.setNombre(rs.getString("nombre"));
                
                // Mapeo exacto según tu tabla phpMyAdmin (precio_venta)
                try {
                    m.setPrecio(rs.getDouble("precio_venta"));
                } catch (SQLException e) {
                    m.setPrecio(rs.getDouble("precio"));
                }
                
                // Mapeo seguro para la categoría
                try { m.setIdCategoria(rs.getInt("id_categoria")); } catch (SQLException e) { m.setIdCategoria(1); }
                
                // Mapeo exacto según tu tabla phpMyAdmin (stock_actual)
                try {
                    m.setStock(rs.getInt("stock_actual"));
                } catch (SQLException e) {
                    m.setStock(rs.getInt("stock"));
                }
                
                // Mapeo para stock_minimo
                try { m.setStockMinimo(rs.getInt("stock_minimo")); } catch (SQLException e) { m.setStockMinimo(1); }
                
                lista.add(m);
            }
        } catch (SQLException e) {
            System.err.println("❌ ERROR AL LISTAR MEDICAMENTOS: " + e.getMessage());
        } finally {
            cerrarConexiones(con);
        }
        return lista;
    }

    public boolean guardar(Medicamento m) {
        String sql = "INSERT INTO medicamento (codigo, nombre, precio_venta, id_categoria, stock_actual, stock_minimo) VALUES (?, ?, ?, ?, ?, ?)";
        Connection con = null;
        try {
            con = new Conexion().getConexion();
            ps = con.prepareStatement(sql);
            ps.setString(1, m.getCodigo());
            ps.setString(2, m.getNombre());
            ps.setDouble(3, m.getPrecio());
            ps.setInt(4, m.getIdCategoria());
            ps.setInt(5, m.getStock());
            ps.setInt(6, m.getStockMinimo());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("❌ ERROR AL GUARDAR MEDICAMENTO: " + e.getMessage());
            return false;
        } finally {
            cerrarConexiones(con);
        }
    }

    public boolean modificar(Medicamento m) {
        String sql = "UPDATE medicamento SET codigo=?, nombre=?, precio_venta=?, id_categoria=?, stock_actual=?, stock_minimo=? WHERE id_medicamento=?";
        Connection con = null;
        try {
            con = new Conexion().getConexion();
            ps = con.prepareStatement(sql);
            ps.setString(1, m.getCodigo());
            ps.setString(2, m.getNombre());
            ps.setDouble(3, m.getPrecio());
            ps.setInt(4, m.getIdCategoria());
            ps.setInt(5, m.getStock());
            ps.setInt(6, m.getStockMinimo());
            ps.setInt(7, m.getIdMedicamento());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("❌ ERROR AL MODIFICAR MEDICAMENTO: " + e.getMessage());
            return false;
        } finally {
            cerrarConexiones(con);
        }
    }

    public boolean eliminar(int id) {
        String sql = "DELETE FROM medicamento WHERE id_medicamento=?";
        Connection con = null;
        try {
            con = new Conexion().getConexion();
            ps = con.prepareStatement(sql);
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("❌ ERROR AL ELIMINAR MEDICAMENTO: " + e.getMessage());
            return false;
        } finally {
            cerrarConexiones(con);
        }
    }

    public int obtenerStock(int idMedicamento) {
        String sql = "SELECT stock_actual FROM medicamento WHERE id_medicamento = ?";
        Connection con = null;
        try {
            con = new Conexion().getConexion();
            ps = con.prepareStatement(sql);
            ps.setInt(1, idMedicamento);
            rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("stock_actual");
            }
        } catch (SQLException e) {
            System.err.println("❌ ERROR AL OBTENER STOCK: " + e.getMessage());
        } finally {
            cerrarConexiones(con);
        }
        return 0;
    }

    public boolean actualizarStock(int idMedicamento, int cantidad, Connection con) throws SQLException {
        String sql = "UPDATE medicamento SET stock_actual = stock_actual - ? WHERE id_medicamento = ? AND stock_actual >= ?";
        ps = con.prepareStatement(sql);
        ps.setInt(1, cantidad);
        ps.setInt(2, idMedicamento);
        ps.setInt(3, cantidad);
        return ps.executeUpdate() > 0;
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