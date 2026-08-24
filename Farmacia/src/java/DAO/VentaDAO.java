package DAO;

import Conexion.Conexion;
import Modelo.Venta;
import java.sql.*;

public class VentaDAO {

    private Conexion cn = new Conexion();
    private Connection con;
    private PreparedStatement ps;
    private ResultSet rs;

    // Método original (Abre su propia conexión)
    public int registrarVenta(Venta v) {
        try {
            con = cn.getConexion();
            return registrarVenta(v, con);
        } catch (SQLException e) {
            System.err.println("❌ ERROR EN VentaDAO: " + e.getMessage());
            return 0;
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    // Sobrecarga transaccional (Recibe la conexión compartida del VentaController)
    public int registrarVenta(Venta v, Connection con) throws SQLException {
        int idVentaGenerado = 0;
        String sql = "INSERT INTO venta (id_usuario, id_cliente, total, estado) VALUES (?, ?, ?, ?)";

        try (PreparedStatement statement = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            statement.setInt(1, v.getIdUsuario());
            statement.setInt(2, v.getIdCliente());
            statement.setDouble(3, v.getTotal());
            statement.setString(4, v.getEstado() != null ? v.getEstado() : "Completada");

            statement.executeUpdate();

            try (ResultSet generatedKeys = statement.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    idVentaGenerado = generatedKeys.getInt(1);
                }
            }
        }
        return idVentaGenerado;
    }

    // Método requerido para cargar los datos en comprobante.jsp
    public Venta buscarPorId(int idVenta) {
        Venta v = null;
        String sql = "SELECT * FROM venta WHERE id_venta = ?";
        try (Connection conn = cn.getConexion();
             PreparedStatement statement = conn.prepareStatement(sql)) {
            statement.setInt(1, idVenta);
            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    v = new Venta();
                    v.setIdVenta(resultSet.getInt("id_venta"));
                    v.setIdUsuario(resultSet.getInt("id_usuario"));
                    v.setIdCliente(resultSet.getInt("id_cliente"));
                    v.setTotal(resultSet.getDouble("total"));
                    v.setEstado(resultSet.getString("estado"));
                    
                    // Manejo del campo fecha_hora de la base de datos
                    Timestamp fecha = resultSet.getTimestamp("fecha_hora");
                    if (fecha != null) {
                        v.setFechaVenta(fecha.toString());
                    }
                }
            }
        } catch (SQLException e) {
            System.err.println("❌ ERROR AL BUSCAR VENTA POR ID: " + e.getMessage());
        }
        return v;
    }
}