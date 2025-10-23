<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register | HealSphere</title>
    <link rel="stylesheet" href="style.css">
</head>
<body class="auth-page">
    <div class="login-container">
        <h2>HealSphere</h2>
        <h1>Sign Up</h1>
        <form action="RegisterServlet" method="post">
            <div class="form-group">
                <label for="fullname">Full Name</label>
                <input type="text" id="fullname" name="fullname" required>
            </div>
            <div class="form-group">
                <label for="email">Email</label>
                <input type="email" id="email" name="email" required>
            </div>
            <div class="form-group">
                <label for="password">Password</label>
                <input type="password" id="password" name="password" required>
            </div>
            <button type="submit">Register</button>
        </form>
        <div class="signup-link">
            <p>Already have an account? <a href="login.jsp">Login</a></p>
        </div>
    </div>
</body>
</html>