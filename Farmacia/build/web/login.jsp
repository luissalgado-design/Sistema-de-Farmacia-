<%-- 
    Document   : login
    Created on : 14 ago 2026, 10:11:00 a. m.
    Author     : LABH5-PC-11
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Acceso al Sistema - Farmacia</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Iconos Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    
<style>
    body {
        min-height: 100vh;
        display: flex;
        align-items: center;
        justify-content: center;
        background: linear-gradient(rgba(255, 255, 255, 0.1), rgba(255, 255, 255, 0.1)), 
                    url('https://images.unsplash.com/photo-1586015555751-63bb77f4322a?q=80&w=1920&auto=format&fit=crop');
        background-size: cover;
        background-position: center;
        background-repeat: no-repeat;
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    }

    .login-card {
        width: 100%;
        max-width: 420px;
        padding: 2.5rem;
        border-radius: 16px;
        background: #ffffff;
        box-shadow: 0 20px 50px rgba(0, 0, 0, 0.3);
    }

    .logo-icon {
        width: 70px;
        height: 70px;
        background: #e8f5e9;
        color: #2e7d32;
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        margin: 0 auto 1rem auto;
        font-size: 2rem;
    }

    .form-control {
        border-radius: 8px;
        padding: 0.75rem 1rem;
        border: 1px solid #ced4da;
        transition: all 0.2s ease;
    }

    .form-control:focus {
        box-shadow: 0 0 0 0.25rem rgba(46, 125, 50, 0.15);
        border-color: #4caf50;
    }

    .btn-success-custom {
        border-radius: 8px;
        padding: 0.75rem;
        font-weight: 600;
        background-color: #419d78;
        color: #ffffff;
        border: none;
        transition: background-color 0.2s ease;
    }

    .btn-success-custom:hover {
        background-color: #2d6a4f;
        color: #ffffff;
    }
</style>
</head>
<body>

    <div class="login-card">
        <!-- Encabezado / Logo -->
        <div class="text-center mb-4">
            <div class="logo-icon">
                <i class="bi bi-capsule"></i>
            </div>
            <h3 class="fw-bold text-dark mb-1">FARMACIA</h3>
            <p class="text-muted small">Ingresa tus credenciales para acceder</p>
        </div>

        <!-- Alerta de error si falla el login (detecta atributos de Forward y de Redirect) -->
        <% 
            String msgError = (String) request.getAttribute("error");
            if (msgError == null && request.getParameter("error") != null) {
                msgError = "Usuario o contraseña incorrectos.";
            }
            if (msgError != null) { 
        %>
            <div class="alert alert-danger alert-dismissible fade show p-2 text-center small mb-3" role="alert">
                <i class="bi bi-exclamation-triangle-fill me-1"></i>
                <%= msgError %>
            </div>
        <% } %>

        <!-- Formulario vinculado con UsuarioController -->
        <form action="UsuarioController" method="POST">
            <input type="hidden" name="accion" value="login">

            <div class="mb-3 text-start">
                <label class="form-label fw-semibold text-secondary small">Usuario</label>
                <div class="input-group">
                    <span class="input-group-text bg-light text-muted border-end-0" style="border-radius: 8px 0 0 8px;">
                        <i class="bi bi-person"></i>
                    </span>
                    <input type="text" name="txtusuario" class="form-control border-start-0" placeholder="Ej. admin" required autofocus>
                </div>
            </div>

            <div class="mb-4 text-start">
                <label class="form-label fw-semibold text-secondary small">Contraseña</label>
                <div class="input-group">
                    <span class="input-group-text bg-light text-muted border-end-0" style="border-radius: 8px 0 0 8px;">
                        <i class="bi bi-lock"></i>
                    </span>
                    <input type="password" name="txtclave" class="form-control border-start-0" placeholder="••••••••" required>
                </div>
            </div>

            <button type="submit" class="btn btn-success-custom w-100 shadow-sm">
                Ingresar al Sistema <i class="bi bi-arrow-right-short ms-1"></i>
            </button>
        </form>
    </div>

</body>
</html>