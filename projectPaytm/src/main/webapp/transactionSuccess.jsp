<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    <%@ page import="java.math.BigDecimal,
                 com.paytm.transaction.TransactionServlet"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Transaction Success</title>
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
        flex-direction: column;
        align-items: center;
        text-align: center;
        padding: 20px;
    }
    .success-message {
        border: 1px solid #ccc;
        border-radius: 5px;
        padding: 20px;
        background-color: #f9f9f9;
        width: 100%;
        max-width: 600px;
    }
    .btn-custom {
        background-color: #00B9F1;
        color: #fff;
        margin: 5px;
    }
    .btn-custom:hover {
        background-color: #007B9A;
        color: #fff;
    }
    .animation-container {
        margin-bottom: 20px;
    }
    .animation-container img {
        width: 200px; /* Adjust as needed */
        height: auto;
    }
</style>
</head>
<body>
<%
String username = request.getParameter("username");
    // Generate a random 12-digit transaction ID
    java.util.Random random = new java.util.Random();
    long transactionId = Math.abs(random.nextLong()) % 1000000000000L;
    BigDecimal amount = new BigDecimal(request.getParameter("amount"));
    String action = request.getParameter("action");
%>
<div class="header">
    <div class="container">
        <img src="images/Paytm_logo.jpg" alt="Logo">
        <h1>Transaction Success</h1>
        <div class="nav-options">
            <a href="loginSuccess.jsp?username=<%= username %>">Main Menu</a>
            <a href="login.jsp">LogOut</a>
            <a href="javascript:history.back()" class="btn btn-outline-light">Back</a>
        </div>
    </div>
</div>

<div class="main-container">
    <!-- Animation GIF -->
    <div class="animation-container">
        <img src="images/paytmsucess1.gif" alt="Success Animation">
    </div>
    
    <div class="success-message">
        <h2>Transaction Successful!</h2>
        <p>Your transaction has been processed successfully.</p>
        <p>Transaction ID: <strong><%= transactionId %></strong></p>
        <p>Amount : <strong><%= amount %></strong></p>
        <p><strong><%= action %></strong> Completed Sucefully </p>   
         <a href="loginSuccess.jsp?username=<%= username %>" class="btn btn-custom">Go to Main Menu</a>
    </div>
</div>

<div class="footer">
    <p>&copy; 2024 Paytm</p>
</div>
</body>
</html>
