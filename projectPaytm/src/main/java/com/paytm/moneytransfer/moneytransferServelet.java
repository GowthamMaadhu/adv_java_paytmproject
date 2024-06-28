package com.paytm.moneytransfer;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class moneytransferServelet
 */
@WebServlet("/moneytransferServelet")
public class moneytransferServelet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    /**
     * @see HttpServlet#HttpServlet()
     */
    public moneytransferServelet() {
        super();
        // TODO Auto-generated constructor stub
    }

    /**
     * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
     *      response)
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // TODO Auto-generated method stub
        // response.getWriter().append("Served at: ").append(request.getContextPath());
    }

    /**
     * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
     *      response)
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html");
        String number = request.getParameter("mobilenumber");
        int amount = Integer.parseInt(request.getParameter("money"));
        String name = request.getParameter("username");
        String reciever = request.getParameter("name");

        PrintWriter pw = response.getWriter();
        pw.println("<!DOCTYPE html>");
        pw.println("<html lang=\"en\">");
        pw.println("<head>");
        pw.println("<meta charset=\"UTF-8\">");
        pw.println("<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">");
        pw.println("<title>Transaction Status</title>");
        // Adding Bootstrap CSS link
        pw.println("<link rel='stylesheet' href='https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css'>");
        pw.println("</head>");
        pw.println("<body>");

        // Container div with Bootstrap classes
        pw.println("<div class=\"container\">");
        Connection con = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost/paytmproject", "root", "Gowtham@123");

            int balance1 = checkBalance(con, name);
            if (amount <= balance1) {
                int finalAmount = balance1 - amount;
                withdraw(con, name, finalAmount);
                recordTransaction(con, name, number, amount, reciever);
              pw.println("<div class=\"animation-container\">");
               pw.println("<img src=\"images/paytmsucess2.gif\" alt=\"Success Animation\" style=\"width: 200px; height: auto;\">");
            pw.println("</div>");
                pw.println("<div class=\"alert alert-success\" role=\"alert\">");
                pw.println("Withdrawal of " + amount + " successful. New balance: " + finalAmount);
                pw.println("</div>");
            } else {
                pw.println("<div class=\"alert alert-danger\" role=\"alert\">");
                pw.println("Insufficient funds. Please check your balance.");
                pw.println("</div>");
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (con != null) {
                    con.close(); // Close the connection
                }
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        }
        pw.println("</div>");

        // Closing HTML document
        pw.println("</body>");
        pw.println("</html>");
    }

    private int checkBalance(Connection con, String name) throws Exception {
        int balance = 0;
        try {
            PreparedStatement stmt = con.prepareStatement("SELECT balance FROM userdata WHERE username = ?");
            stmt.setString(1, name);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                balance = rs.getInt(1);
                System.out.println(balance);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return balance;
    }

    private void withdraw(Connection con, String name, int finalamount) throws SQLException {
        PreparedStatement stmt = con.prepareStatement("UPDATE userdata SET balance = ? WHERE username = ?");
        stmt.setInt(1, finalamount);
        stmt.setString(2, name);
        stmt.executeUpdate();

    }

    private void recordTransaction(Connection con, String name, String number, int amount, String reciever)
            throws SQLException {
        PreparedStatement stmt = con.prepareStatement(
                "INSERT INTO payment_history (username, timestamp, number, name, transationamount_phonenumber) VALUES (?, NOW(), ?, ?, ?)");
        stmt.setString(1, name);
        stmt.setString(2, number);
        stmt.setString(3, reciever);
        stmt.setInt(4, amount);
        stmt.executeUpdate();
    }

}
