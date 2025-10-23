package com.healsphere;
import java.sql.*;

public class DBConnect {
    private static Connection conn;

    public static Connection getConnection() {
        try {
            if (conn == null || conn.isClosed()) {
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/healsphere", "root", "root123");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return conn;
    }
}
