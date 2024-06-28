<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.math.BigDecimal" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Balance Check</title>
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css">
<style>
    body {
        font-family: Arial, sans-serif;
        display: flex;
        flex-direction: column;
        min-height: 100vh;
    }
    .header, .footer {
        background-color: #00B9F1;
        color: #fff;
        padding: 10px 0;
        text-align: center;
    }
    .header .container {
        display: flex;
        justify-content: space-between;
        align-items: center;
    }
    .header img {
        max-height: 50px; /* Adjust as needed */
    }
    .nav-options {
        display: flex;
        gap: 15px;
    }
    .nav-options a {
        color: #fff;
        text-decoration: none;
        padding: 5px 10px;
        border-radius: 5px;
        transition: background-color 0.3s;
    }
    .nav-options a:hover {
        background-color: #007B9A; /* Darken the background on hover */
    }
    .main-container {
        flex: 1;
        display: flex;
        justify-content: center;
        align-items: center;
        text-align: center;
    }
    .balance-message {
        border: 1px solid #ccc;
        border-radius: 5px;
        padding: 20px;
        background-color: #f9f9f9;
    }
    .btn-custom {
        background-color: #00B9F1;
        color: #fff;
    }
    .btn-custom:hover {
        background-color: #007B9A;
        color: #fff;
    }
</style>
</head>
<body>
 <% 
            String username = request.getParameter("username");
 %>
<div class="header">
    <div class="container">
        <img src="images/Paytm_logo.jpg" alt="Logo">
        <h1>Balance Check</h1>
        <div class="nav-options">
            <a href="login.jsp">LogOut</a>
            <a href="javascript:history.back()" class="btn btn-outline-light">Back</a>
        </div>
    </div>
</div>

<div class="main-container">
    <div class="balance-message">
        <h2>Your Current Balance</h2>
       <% 
            BigDecimal balance = BigDecimal.ZERO;
            
            if (username != null && !username.isEmpty()) {
                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost/paytmproject", "root", "Gowtham@123");
                    PreparedStatement stmt = conn.prepareStatement("SELECT balance FROM userdata WHERE username = ?");
                    stmt.setString(1, username);
                    ResultSet rs = stmt.executeQuery();
                    
                    if (rs.next()) {
                        balance = rs.getBigDecimal("balance");
                    }
                    
                    conn.close();
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        %>
        <p>Your balance is: <strong><%= balance %></strong></p>
        <a href="loginSuccess.jsp?username=<%= username %>" class="btn btn-custom">Go to Main Menu</a>
        <a href="transaction.jsp?username=<%= username %>" class="btn btn-custom">Perform Another Transaction</a>
    </div>
</div>

<div class="footer">
    <p>&copy; 2024 Paytm</p>
</div>
</body>
</html>
