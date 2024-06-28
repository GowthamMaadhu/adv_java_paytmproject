package com.paytm.transaction;

import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/TransactionServlet")
public class TransactionServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html");
        String action = request.getParameter("action");
        String amountStr = request.getParameter("amount");
        String username = request.getParameter("username");
        BigDecimal amount = BigDecimal.ZERO;

        if (amountStr != null && !amountStr.isEmpty()) {
            amount = new BigDecimal(amountStr);
        }

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost/paytmproject", "root", "Gowtham@123");

            if (action.equals("deposit")) {
                deposit(conn, username, amount);
                RequestDispatcher rd = request.getRequestDispatcher("transactionSuccess.jsp");
                rd.forward(request, response);
            } else if (action.equals("withdraw")) {
                int balance = checkBalance(conn, username);
                if (amount.compareTo(new BigDecimal(balance)) > 0) {
                    request.setAttribute("errorMessage", "Insufficient funds.");
                    request.setAttribute("username", username);
                    request.getRequestDispatcher("withdraw.jsp").forward(request, response);
                } else {
                    withdraw(conn, username, amount);
                    recordTransaction(conn, username, "Withdrawal", amount);
                    RequestDispatcher rd = request.getRequestDispatcher("transactionSuccess.jsp");
                    rd.forward(request, response);
                }
            } else if (action.equals("checkbalance")) {
                int balance = checkBalance(conn, username);
                request.setAttribute("balance", balance);
                request.getRequestDispatcher("balance.jsp").forward(request, response);
            } else if (action.equals("paymenthistory")) {
                request.setAttribute("username", username);
                printTransactionHistory(conn, username, response.getWriter());
            } else if (action.equals("moneytransfer")) {
                request.setAttribute("username", username);
                RequestDispatcher rd = request.getRequestDispatcher("moneytransfer.jsp");
                rd.forward(request, response);
            }
            conn.close();
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
    }

    private void deposit(Connection conn, String username, BigDecimal amount) throws SQLException {
        PreparedStatement stmt = conn.prepareStatement("UPDATE userdata SET balance = balance + ? WHERE username = ?");
        stmt.setBigDecimal(1, amount);
        stmt.setString(2, username);
        stmt.executeUpdate();
    }

    private void withdraw(Connection conn, String username, BigDecimal amount) throws SQLException {
        PreparedStatement stmt = conn.prepareStatement("UPDATE userdata SET balance = balance - ? WHERE username = ?");
        stmt.setBigDecimal(1, amount);
        stmt.setString(2, username);
        stmt.executeUpdate();
    }

    private int checkBalance(Connection conn, String username) throws SQLException {
        int balance = 0;
        PreparedStatement stmt = conn.prepareStatement("SELECT balance FROM userdata WHERE username = ?");
        stmt.setString(1, username);
        ResultSet rs = stmt.executeQuery();
        if (rs.next()) {
            balance = rs.getInt(1);
        }
        return balance;
    }

    private void recordTransaction(Connection conn, String username, String action, BigDecimal amount) throws SQLException {
        PreparedStatement stmt = conn.prepareStatement(
                "INSERT INTO payment_history (username, action, amount, timestamp) VALUES (?, ?, ?, NOW())");
        stmt.setString(1, username);
        stmt.setString(2, action);
        stmt.setBigDecimal(3, amount);
        stmt.executeUpdate();
    }

    private void printTransactionHistory(Connection conn, String username, PrintWriter pw) throws SQLException {
        pw.println("<!DOCTYPE html>");
        pw.println("<html>");
        pw.println("<head>");
        pw.println("<meta charset='UTF-8'>");
        pw.println("<title>Payment History</title>");
        pw.println("<link rel='stylesheet' href='https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css'>");
        pw.println("<style>");
        pw.println(".header, .footer {");
        pw.println("    background-color: #00B9F1;");
        pw.println("    color: #fff;");
        pw.println("    padding: 10px 0;");
        pw.println("    text-align: center;");
        pw.println("}");
        pw.println(".header .container {");
        pw.println("    display: flex;");
        pw.println("    justify-content: space-between;");
        pw.println("    align-items: center;");
        pw.println("}");
        pw.println(".header img {");
        pw.println("    max-height: 50px;");
        pw.println("}");
        pw.println(".nav-options {");
        pw.println("    display: flex;");
        pw.println("    gap: 15px;");
        pw.println("}");
        pw.println(".nav-options a {");
        pw.println("    color: #fff;");
        pw.println("    text-decoration: none;");
        pw.println("    padding: 5px 10px;");
        pw.println("    border-radius: 5px;");
        pw.println("    transition: background-color 0.3s;");
        pw.println("}");
        pw.println(".nav-options a:hover {");
        pw.println("    background-color: #007B9A;");
        pw.println("}");
        pw.println("</style>");
        pw.println("</head>");
        pw.println("<body>");

        pw.println("<div class='header'>");
        pw.println("<div class='container'>");
        pw.println("<img src='images/Paytm_logo.jpg' alt='Logo'>");
        pw.println("<h1>Transaction History</h1>");
        pw.println("<div class='nav-options'>");
        
        pw.println("<a href=\"login.jsp\">LogOut</a>");
        pw.println("<a href=\"javascript:history.back()\" class=\"btn btn-outline-light\">Back</a>");
        pw.println("</div>");
        pw.println("</div>");
        pw.println("</div>");
        pw.println("<div class='container mt-5'>");
        pw.println("<h2 class='my-4'>Transaction History</h2>");
        pw.println("<div class='table-responsive'>");
        pw.println("<table class='table table-striped table-bordered'>");
        pw.println("<thead class='thead-dark'>");
        pw.println("<tr><th>Transaction ID</th><th>Action</th><th>Amount</th><th>Timestamp</th></tr>");
        pw.println("</thead>");
        pw.println("<tbody>");

        PreparedStatement stmt = conn.prepareStatement("SELECT * FROM payment_history WHERE username = ?");
        stmt.setString(1, username);
        ResultSet rs = stmt.executeQuery();

        while (rs.next()) {
            String transactionId = rs.getString("transaction_id");
            String action = rs.getString("action");
            double amount = rs.getDouble("amount");
            Timestamp timestamp = rs.getTimestamp("timestamp");

            pw.println("<tr>");
            pw.println("<td>" + transactionId + "</td>");
            pw.println("<td>" + action + "</td>");
            pw.println("<td>" + amount + "</td>");
            pw.println("<td>" + timestamp + "</td>");
            pw.println("</tr>");
        }

        pw.println("</tbody>");
        pw.println("</table>");
        pw.println("</div>");
        pw.println("</div>");

        pw.println("<div class='footer'>");
        pw.println("<p>&copy; 2024 Paytm</p>");
        pw.println("</div>");

        pw.println("</body>");
        pw.println("</html>");

        rs.close();
        stmt.close();
    }
}
