package com.sc;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Statement;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class DeleteMedical extends HttpServlet {
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private static final String URL = "jdbc:postgresql://localhost:5432/mydb";
    private static final String USER = "postgres";
    private static final String PASSWORD = "Post1gre2";

    protected void service(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        
        String str = null;

        // Print request info for debugging
        //out.println("<h3>Request Info: " + request.getRequestURL() + "</h3>");

        try {
            // Load PostgreSQL JDBC driver
            Class.forName("org.postgresql.Driver");
            System.out.println("<p>Driver loaded successfully!</p>");

            // Establish connection
            Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
            conn.setAutoCommit(false);
            
            System.out.println("<p>Connected to database!</p>");

            // Set schema
            Statement schemaStmt = conn.createStatement();
            schemaStmt.execute("SET search_path TO \"SeniorCitizen\"");

            // SQL query to update SC_name to 'Raj' where SC_seq = 1
            String updateSQL = "DELETE FROM \"SeniorCitizen\".\"Medical\" WHERE \"Medical\".\"Med_seq\" = ? ";
            PreparedStatement pstmt = conn.prepareStatement(updateSQL);

            // Set the new name and the SC_seq condition
            int  seq =Integer.parseInt(request.getParameter("Med_seq"));
            
            pstmt.setInt(1, seq); // New name to set

            int rowsUpdated = pstmt.executeUpdate();
            conn.commit(); // Commit the transaction
            pstmt.close();
            conn.close();
            
            if (rowsUpdated > 0) {
                System.out.println("Deleted"+seq);
                response.sendRedirect("pages/ViewMedicalRemainder.jsp");
            } else {
                out.println("<p style='color:red;'>❌ No record found for SC_seq = 1</p>");
            }
           
            
        } catch (SQLException e) {
            out.println("<p style='color:red;'>❌ SQL Error: " + e.getMessage() + "</p>");
            e.printStackTrace();
        } catch (ClassNotFoundException e) {
            out.println("<p style='color:red;'>❌ Driver Error: " + e.getMessage() + "</p>");
            e.printStackTrace();
        } catch (Exception e) {
            out.println("<p style='color:red;'>❌ General Error: " + e.getMessage() + "</p>");
            e.printStackTrace();
        }
    }
}
