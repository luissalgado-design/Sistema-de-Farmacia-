package Modelo;

public class Pago {
    
    private int idPago;
    private int idVenta;
    private String metodoPago;
    private double monto;
    private String fechaPago;
    private String estadoPago; // Atributo faltante

    public Pago() {
    }

    public Pago(int idPago, int idVenta, String metodoPago, double monto, String fechaPago, String estadoPago) {
        this.idPago = idPago;
        this.idVenta = idVenta;
        this.metodoPago = metodoPago;
        this.monto = monto;
        this.fechaPago = fechaPago;
        this.estadoPago = estadoPago;
    }

    // Getters y Setters
    public int getIdPago() {
        return idPago;
    }

    public void setIdPago(int idPago) {
        this.idPago = idPago;
    }

    public int getIdVenta() {
        return idVenta;
    }

    public void setIdVenta(int idVenta) {
        this.idVenta = idVenta;
    }

    public String getMetodoPago() {
        return metodoPago;
    }

    public void setMetodoPago(String metodoPago) {
        this.metodoPago = metodoPago;
    }

    public double getMonto() {
        return monto;
    }

    public void setMonto(double monto) {
        this.monto = monto;
    }

    public String getFechaPago() {
        return fechaPago;
    }

    public void setFechaPago(String fechaPago) {
        this.fechaPago = fechaPago;
    }

    public String getEstadoPago() {
        return estadoPago;
    }

    public void setEstadoPago(String estadoPago) {
        this.estadoPago = estadoPago;
    }
}