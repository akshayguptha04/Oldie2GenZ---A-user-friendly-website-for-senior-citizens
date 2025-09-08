package com.sc;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class ViewMedicalRemainderServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final String URL = "jdbc:postgresql://localhost:5432/mydb";
    private static final String USER = "postgres";
    private static final String PASSWORD = "Post1gre2";

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        

        try {
            Class.forName("org.postgresql.Driver");
            Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
            conn.setAutoCommit(false);

            // Set schema
            Statement schemaStmt = conn.createStatement();
            schemaStmt.execute("SET search_path TO \"SeniorCitizen\"");

            /* Retrieve all input values (arrays for multiple rows)
            String[] medNames = request.getParameterValues("medicineName");
            String[] medDates = request.getParameterValues("medDate");
            String[] daysArray = request.getParameterValues("days");
            String[] bTimes = request.getParameterValues("bTime");
            String[] bDosages = request.getParameterValues("bDosage");
            String[] lTimes = request.getParameterValues("lTime");
            String[] lDosages = request.getParameterValues("lDosage");
            String[] dTimes = request.getParameterValues("dTime");
            String[] dDosages = request.getParameterValues("dDosage");

            if (medNames != null) {
                String insertSQL = "INSERT INTO \"SeniorCitizen\".\"Medical\" "
                        + "(\"SC_seq\", \"Med_name\", \"Med_date\", \"Med_days\", "
                        + "\"Med_bftime\", \"Med_bf_dosage\", \"Med_lunchtime\", \"Med_lunch_dosage\", "
                        + "\"Med_dinnertime\", \"Med_dinner_dosage\") "
                        + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

                PreparedStatement pstmt = conn.prepareStatement(insertSQL);
                
                HttpSession sess = request.getSession(false);
                int scSeq = Integer.parseInt(sess.getAttribute("seq").toString());

                for (int i = 0; i < medNames.length; i++) {
                    pstmt.setInt(1, scSeq);
                    pstmt.setString(2, medNames[i]);
                    pstmt.setDate(3, java.sql.Date.valueOf(medDates[i]));
                    pstmt.setInt(4, Integer.parseInt(daysArray[i]));

                    // Convert HH:mm to HH:mm:00 (required for java.sql.Time)
                    pstmt.setTime(5, java.sql.Time.valueOf(bTimes[i] + ":00"));
                    pstmt.setInt(6, Integer.parseInt(bDosages[i]));

                    pstmt.setTime(7, java.sql.Time.valueOf(lTimes[i] + ":00"));
                    pstmt.setInt(8, Integer.parseInt(lDosages[i]));

                    pstmt.setTime(9, java.sql.Time.valueOf(dTimes[i] + ":00"));
                    pstmt.setInt(10, Integer.parseInt(dDosages[i]));

                    pstmt.addBatch();
                }

                pstmt.executeBatch();
                conn.commit();
                pstmt.close();
                conn.close();

                //response.getRequestDispatcher("SeniorCitizen/pages/MedicalRemainder.html").include(request, response);
                response.sendRedirect("pages/MedicalRemainder.html");
            } else {
                //out.println("<h3 style='color:red;'>❌ No medicine data received!</h3>");
            }
*/
            String selectSQL = "SELECT  \"Medical\".\"Med_name\", \"Medical\".\"Med_date\", \"Medical\".\"Med_days\", " +
                    "\"Medical\".\"Med_bftime\", \"Medical\".\"Med_bf_dosage\", \"Medical\".\"Med_lunchtime\", \"Medical\".\"Med_lunch_dosage\", " +
                    "\"Medical\".\"Med_dinnertime\", \"Medical\".\"Med_dinner_dosage\" " +
                    "FROM \"SeniorCitizen\".\"Medical\" where \"Medical\".\"SC_seq\" = ?";
            
            System.out.println(selectSQL);
            HttpSession sess = request.getSession(false);
            int scSeq = Integer.parseInt(sess.getAttribute("seq").toString());

            PreparedStatement pstmt = conn.prepareStatement(selectSQL);
            pstmt.setInt(1, scSeq);
            ResultSet rs = pstmt.executeQuery();
            
            while(rs.next())
            {
            	String name = rs.getString(1);
            	String date = rs.getString(2);
            	String days = rs.getString(3);
            	String bftime = rs.getString(4);
            	String bfdose = rs.getString(5);
            	String ltime = rs.getString(6);
            	String ldose = rs.getString(7);
            	String dtime = rs.getString(8);
            	String ddose = rs.getString(9);  
            	
            	System.out.println(name + " "+date+ " "+days+ " "+bftime+ " "+bfdose+ " "+ltime+ " "+ldose+ " "+dtime+ " "+ddose);
            }
            pstmt.close();
            conn.close();

        } catch (Exception e) {
            e.printStackTrace();
            out.println("<p style='color:red;'>❌ Error: " + e.getMessage() + "</p>");
        }
    }
}
