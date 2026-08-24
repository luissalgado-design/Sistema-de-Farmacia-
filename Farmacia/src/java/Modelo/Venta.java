package Modelo;

public class Venta {

    private int idVenta;
    private int idUsuario;
    private int idCliente;
    private double total;
    private String estado;
    private String fechaVenta; // Atributo para la fecha/hora

    public Venta() {
    }

    public Venta(int idVenta, int idUsuario, int idCliente, double total, String estado, String fechaVenta) {
        this.idVenta = idVenta;
        this.idUsuario = idUsuario;
        this.idCliente = idCliente;
        this.total = total;
        this.estado = estado;
        this.fechaVenta = fechaVenta;
    }

    // Getters y Setters
    public int getIdVenta() {
        return idVenta;
    }

    public void setIdVenta(int idVenta) {
        this.idVenta = idVenta;
    }

    public int getIdUsuario() {
        return idUsuario;
    }

    public void setIdUsuario(int idUsuario) {
        this.idUsuario = idUsuario;
    }

    public int getIdCliente() {
        return idCliente;
    }

    public void setIdCliente(int idCliente) {
        this.idCliente = idCliente;
    }

    public double getTotal() {
        return total;
    }

    public void setTotal(double total) {
        this.total = total;
    }

    public String getEstado() {
        return estado;
    }

    public void setEstado(String estado) {
        this.estado = estado;
    }

    public String getFechaVenta() {
        return fechaVenta;
    }

    public void setFechaVenta(String fechaVenta) {
        this.fechaVenta = fechaVenta;
    }
}