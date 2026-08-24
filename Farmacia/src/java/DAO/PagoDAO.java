package DAO;

import Conexion.Conexion;
import Modelo.Pago;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PagoDAO {

    private Conexion cn = new Conexion();
    private Connection con;
    private PreparedStatement ps;
    private ResultSet rs;

    // Método para listar todos los pagos registrados
    public List<Pago> listar() {
        List<Pago> lista = new ArrayList<>();
        String sql = "SELECT * FROM pago ORDER BY id_pago DESC";
        try {
            con = cn.getConexion();
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                Pago p = new Pago();
                p.setIdPago(rs.getInt("id_pago"));
                p.setIdVenta(rs.getInt("id_venta"));
                p.setMetodoPago(rs.getString("metodo_pago"));
                p.setMonto(rs.getDouble("monto"));
                p.setFechaPago(rs.getString("fecha_pago"));
                p.setEstadoPago(rs.getString("estado_pago"));
                lista.add(p);
            }
        } catch (SQLException e) {
            System.err.println("❌ ERROR AL LISTAR PAGOS: " + e.getMessage());
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
    public boolean registrarPago(Pago p) {
        try {
            con = cn.getConexion();
            return registrarPago(p, con);
        } catch (SQLException e) {
            System.err.println("❌ ERROR EN PagoDAO: " + e.getMessage());
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

    // Sobrecarga transaccional (Recibe la conexión del controlador)
    public boolean registrarPago(Pago p, Connection con) throws SQLException {
        String sql = "INSERT INTO pago (id_venta, metodo_pago, monto, estado_pago) VALUES (?, ?, ?, ?)";
        try (PreparedStatement statement = con.prepareStatement(sql)) {
            statement.setInt(1, p.getIdVenta());
            statement.setString(2, p.getMetodoPago());
            statement.setDouble(3, p.getMonto());
            
            String estado = (p.getEstadoPago() != null && !p.getEstadoPago().trim().isEmpty()) 
                            ? p.getEstadoPago() 
                            : "Completado";
            statement.setString(4, estado);

            return statement.executeUpdate() > 0;
        }
    }

    // Método para eliminar un pago por su ID
    public boolean eliminar(int idPago) {
        String sql = "DELETE FROM pago WHERE id_pago = ?";
        try {
            con = cn.getConexion();
            ps = con.prepareStatement(sql);
            ps.setInt(1, idPago);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("❌ ERROR AL ELIMINAR PAGO: " + e.getMessage());
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
}