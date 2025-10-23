<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login | HealSphere</title>
    <link rel="stylesheet" href="style.css">
</head>
<body class="auth-page">
    <div class="login-container">
        <h2>HealSphere</h2>
        <h1>Welcome Back</h1>
        <form action="LoginServlet" method="post">
            <div class="form-group">
                <label for="email">Email</label>
                <input type="email" id="email" name="email" required>
            </div>
            <div class="form-group">
                <label for="password">Password</label>
                <input type="password" id="password" name="password" required>
            </div>
            <button type="submit">Login</button>
        </form>
        <div class="signup-link">
            <p>Don't have an account? <a href="register.jsp">Sign Up</a></p>
        </div>
    </div>
</body>
</html>