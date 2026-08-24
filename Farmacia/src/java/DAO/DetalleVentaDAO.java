package DAO;

import Conexion.Conexion;
import Modelo.DetalleVenta;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class DetalleVentaDAO {

    private Conexion cn = new Conexion();
    private Connection con;
    private PreparedStatement ps;
    private ResultSet rs;

    // Método para obtener la lista de items de una venta específica
    public List<DetalleVenta> listarPorVenta(int idVenta) {
        List<DetalleVenta> lista = new ArrayList<>();
        String sql = "SELECT * FROM detalle_venta WHERE id_venta = ?";
        try {
            con = cn.getConexion();
            ps = con.prepareStatement(sql);
            ps.setInt(1, idVenta);
            rs = ps.executeQuery();
            while (rs.next()) {
                DetalleVenta dv = new DetalleVenta();
                dv.setIdDetalle(rs.getInt("id_detalle"));
                dv.setIdVenta(rs.getInt("id_venta"));
                dv.setIdMedicamento(rs.getInt("id_medicamento"));
                dv.setCantidad(rs.getInt("cantidad"));
                dv.setPrecioUnitario(rs.getDouble("precio_unitario"));
                dv.setSubtotal(rs.getDouble("subtotal"));
                lista.add(dv);
            }
        } catch (SQLException e) {
            System.err.println("❌ ERROR AL LISTAR DETALLES POR VENTA: " + e.getMessage());
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return lista;
    }

    // Método original (Abre su propia conexión)
    public boolean guardarDetalle(DetalleVenta dv) {
        try {
            con = cn.getConexion();
            return guardarDetalle(dv, con);
        } catch (SQLException e) {
            System.err.println("❌ ERROR EN DetalleVentaDAO: " + e.getMessage());
            return false;
        } finally {
            try {
                if (ps != null) ps.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    // Sobrecarga transaccional (Usa la conexión compartida del controlador)
    public boolean guardarDetalle(DetalleVenta dv, Connection con) throws SQLException {
        String sql = "INSERT INTO detalle_venta (id_venta, id_medicamento, cantidad, precio_unitario, subtotal) VALUES (?, ?, ?, ?, ?)";
        try (PreparedStatement statement = con.prepareStatement(sql)) {
            statement.setInt(1, dv.getIdVenta());
            statement.setInt(2, dv.getIdMedicamento());
            statement.setInt(3, dv.getCantidad());
            statement.setDouble(4, dv.getPrecioUnitario());
            statement.setDouble(5, dv.getSubtotal());
            return statement.executeUpdate() > 0;
        }
    }
}