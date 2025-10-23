package com.healsphere;
import java.io.*;
import java.sql.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;

public class LoginServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        try {
            Connection conn = DBConnect.getConnection();
            PreparedStatement pst = conn.prepareStatement("SELECT * FROM users WHERE email=? AND password=?");
            pst.setString(1, email);
            pst.setString(2, password);

            ResultSet rs = pst.executeQuery();
            if (rs.next()) {
                HttpSession session = request.getSession();
                session.setAttribute("name", rs.getString("fullname"));
                response.sendRedirect("welcome.jsp");
            } else {
                response.sendRedirect("login.jsp?msg=invalid");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("login.jsp?msg=error");
        }
    }
}
