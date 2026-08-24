package TestConexion;

import Conexion.Conexion;
import java.sql.Connection;

public class TestConexion {

    public static void main(String[] args) {

        Connection con = Conexion.conectar();

        if (con != null) {

            System.out.println(
                    "La conexion funciona correctamente"
            );

        } else {

            System.out.println(
                    "No se puede conectar"
            );
        }
    }
}