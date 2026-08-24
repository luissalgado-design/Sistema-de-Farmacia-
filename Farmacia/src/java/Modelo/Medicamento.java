package Modelo;

public class Medicamento {
    private int idMedicamento;
    private String codigo;
    private String nombre;
    private double precio;
    private int idCategoria;
    private int stock;
    private int stockMinimo;

    public Medicamento() {
    }

    public Medicamento(int idMedicamento, String nombre, double precio, int stock) {
        this.idMedicamento = idMedicamento;
        this.nombre = nombre;
        this.precio = precio;
        this.stock = stock;
    }

    public Medicamento(int idMedicamento, String codigo, String nombre, double precio, int idCategoria, int stock, int stockMinimo) {
        this.idMedicamento = idMedicamento;
        this.codigo = codigo;
        this.nombre = nombre;
        this.precio = precio;
        this.idCategoria = idCategoria;
        this.stock = stock;
        this.stockMinimo = stockMinimo;
    }

    public int getIdMedicamento() { return idMedicamento; }
    public void setIdMedicamento(int idMedicamento) { this.idMedicamento = idMedicamento; }

    public String getCodigo() { return codigo; }
    public void setCodigo(String codigo) { this.codigo = codigo; }

    public String getNombre() { return nombre; }
    public void setNombre(String nombre) { this.nombre = nombre; }

    public double getPrecio() { return precio; }
    public void setPrecio(double precio) { this.precio = precio; }

    public int getIdCategoria() { return idCategoria; }
    public void setIdCategoria(int idCategoria) { this.idCategoria = idCategoria; }

    public int getStock() { return stock; }
    public void setStock(int stock) { this.stock = stock; }

    public int getStockMinimo() { return stockMinimo; }
    public void setStockMinimo(int stockMinimo) { this.stockMinimo = stockMinimo; }

    // Métodos alias de compatibilidad
    public void setPrecioVenta(double precio) { this.precio = precio; }
    public double getPrecioVenta() { return this.precio; }

    public void setStockActual(int stock) { this.stock = stock; }
    public int getStockActual() { return this.stock; }
}