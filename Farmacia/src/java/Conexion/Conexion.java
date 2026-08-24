package Conexion;

import java.sql.Connection;
import java.sql.DriverManager;

public class Conexion {

    private static final String URL = "jdbc:mysql://localhost:3306/farmacia";
    private static final String USER = "root";
    private static final String PASSWORD = "";

    public static Connection conectar() {
        Connection conexion = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conexion = DriverManager.getConnection(URL, USER, PASSWORD);
            System.out.println("Conexion exitosa");
        } catch (Exception e) {
            System.out.println("Error de conexion: " + e.getMessage());
        }
        return conexion;
    }

    // Método getConexion() para que tus DAO funcionen sin errores de compilación
    public Connection getConexion() {
        return conectar();
    }
}