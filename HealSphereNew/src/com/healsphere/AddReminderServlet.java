package com.healsphere;

// 1. Import the necessary annotation
import jakarta.servlet.annotation.WebServlet;

// Standard Java/Jakarta EE imports
import java.io.IOException;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.Time;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.SQLException; // Import SQLException for detailed error handling

// 2. Add the annotation to map the URL to this class
@WebServlet("/AddReminderServlet")
public class AddReminderServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false); // Don't create a new session if one doesn't exist

        // --- Security Check: Ensure user is logged in ---
        if (session == null || session.getAttribute("user_id") == null) {
            // User is not logged in, redirect to login page
            response.sendRedirect("login.jsp?error=session_expired");
            return; // Stop further execution
        }

        // --- Retrieve User ID from Session ---
        int userId = (int) session.getAttribute("user_id");

        // --- Retrieve Form Data ---
        String medicineName = request.getParameter("medicineName");
        String dosage = request.getParameter("dosage");
        String reminderTimeStr = request.getParameter("reminderTime"); // Format: "HH:mm"
        String startDateStr = request.getParameter("startDate"); // Format: "yyyy-MM-dd"
        String endDateStr = request.getParameter("endDate");
        String totalStockStr = request.getParameter("totalStock");

        // --- Input Validation (Basic Example) ---
        if (medicineName == null || medicineName.isEmpty() ||
            reminderTimeStr == null || reminderTimeStr.isEmpty() ||
            startDateStr == null || startDateStr.isEmpty() ||
            endDateStr == null || endDateStr.isEmpty() ||
            totalStockStr == null || totalStockStr.isEmpty()) {
            // Redirect back with an error if required fields are missing
            response.sendRedirect("welcome.jsp?msg=missing_fields");
            return;
        }

        int totalStock;
        try {
            totalStock = Integer.parseInt(totalStockStr);
            if (totalStock < 0) throw new NumberFormatException(); // Ensure stock is not negative
        } catch (NumberFormatException e) {
            // Handle invalid number format for stock
            response.sendRedirect("welcome.jsp?msg=invalid_stock");
            return;
        }

        // --- Database Interaction ---
        Connection conn = null;
        PreparedStatement pst = null;

        try {
            conn = DBConnect.getConnection(); // Get database connection
            if (conn == null) {
                throw new SQLException("Failed to establish database connection.");
            }

            // SQL query to insert data into the 'reminders' table
            String sql = "INSERT INTO reminders (user_id, medicine_name, dosage, reminder_time, start_date, end_date, total_stock, current_stock) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

            pst = conn.prepareStatement(sql);

            // Set the parameters for the SQL query
            pst.setInt(1, userId);
            pst.setString(2, medicineName);
            pst.setString(3, dosage); // Dosage can be null/empty if not required
            pst.setTime(4, Time.valueOf(reminderTimeStr + ":00")); // Convert "HH:mm" string to SQL TIME
            pst.setDate(5, Date.valueOf(startDateStr)); // Convert "yyyy-MM-dd" string to SQL DATE
            pst.setDate(6, Date.valueOf(endDateStr));
            pst.setInt(7, totalStock);
            pst.setInt(8, totalStock); // Set initial 'current_stock' same as 'total_stock'

            // Execute the SQL statement
            int row = pst.executeUpdate();

            // --- Handle Result ---
            if (row > 0) {
                // Success! Redirect back to the dashboard with a success message.
                response.sendRedirect("welcome.jsp?msg=reminder_added");
            } else {
                // Insertion failed (should not happen without an exception usually)
                response.sendRedirect("welcome.jsp?msg=save_error");
            }
        } catch (SQLException e) {
            // Handle database errors (e.g., connection issues, constraint violations)
            e.printStackTrace(); // Log the full error to the server console
            response.sendRedirect("welcome.jsp?msg=db_error");
        } catch (IllegalArgumentException e) {
            // Handle errors from invalid date/time formats
            e.printStackTrace();
            response.sendRedirect("welcome.jsp?msg=format_error");
        } catch (Exception e) {
            // Catch any other unexpected errors
            e.printStackTrace();
            response.sendRedirect("welcome.jsp?msg=generic_error");
        } finally {
            // --- IMPORTANT: Close Database Resources ---
            // Always close PreparedStatement and Connection in a finally block
            try {
                if (pst != null) pst.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
            try {
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}