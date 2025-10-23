package com.healsphere;
import java.io.*;
import java.sql.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;

public class RegisterServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String fullname = request.getParameter("fullname");
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        try {
            Connection conn = DBConnect.getConnection();
            if (conn == null) {
                System.out.println("DB Connection Failed!");
                response.sendRedirect("register.jsp?msg=dberror");
                return;
            }

            PreparedStatement pst = conn.prepareStatement("INSERT INTO users(fullname, email, password) VALUES(?,?,?)");
            pst.setString(1, fullname);
            pst.setString(2, email);
            pst.setString(3, password);
            int row = pst.executeUpdate();

            if (row > 0) {
                System.out.println("User registered: " + email);
                response.sendRedirect("login.jsp?msg=registered");
            } else {
                System.out.println("Insert failed.");
                response.sendRedirect("register.jsp?msg=error");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("register.jsp?msg=exception");
        }
    }
}
