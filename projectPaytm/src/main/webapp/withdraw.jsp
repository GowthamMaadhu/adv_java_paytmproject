<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Withdrawal Page</title>
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css">
<style>
    body {
        font-family: Arial, sans-serif;
        display: flex;
        flex-direction: column;
        min-height: 100vh;
        position: relative; /* Ensure the body is relatively positioned */
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
        position: relative; /* Ensure the container is relatively positioned */
    }
    .form-container {
        border: 1px solid #ccc;
        border-radius: 5px;
        padding: 20px;
        background-color: #f9f9f9;
        z-index: 1; /* Ensure the form container is above the picture */
        width: 300px; /* Adjust as needed */
    }
    .picture-container {
        position: absolute;
        top: 0;
        right: 0;
        width: 500px; /* Adjust the width of the picture container */
        height: 100%; /* Full height of the container */
        background-color: #f9f9f9; /* Match the background color of the form */
        z-index: 0; /* Ensure the picture is behind the form */
    }
    .picture-container img {
        width: 100%;
        height: 100%;
        object-fit: cover; /* Ensure the image covers the container */
    }
    .back-button {
        position: absolute;
        top: 10px;
        left: 10px;
        color: #fff;
        background-color: #00B9F1;
        padding: 5px 10px;
        border-radius: 5px;
        text-decoration: none;
        transition: background-color 0.3s;
    }
    .back-button:hover {
        background-color: #007B9A; /* Darken the background on hover */
    }
</style>
<script>
    function validateForm() {
        var amount = document.forms["transactionForm"]["amount"].value;
        if (amount == "" || amount <= 0 || isNaN(amount)) {
            alert("Please enter a valid amount greater than zero.");
            return false;
        }
        return true;
    }
    function displayErrorMessage(message) {
        alert(message);
    }
</script>
</head>
<body>
<% String username = request.getParameter("username"); %>

<a href="javascript:history.back()" class="back-button">Back</a>

<div class="header">
    <div class="container">
        <img src="images/Paytm_logo.jpg" alt="Logo">
        <h1>Transaction Form</h1>
        <div class="nav-options">
            <a href="login.jsp">LogOut</a>
            <a href="javascript:history.back()" class="btn btn-outline-light">Back</a>
        </div>
    </div>
</div>

<div class="main-container">
    <div class="form-container">
        <form name="transactionForm" action="TransactionServlet" method="post" onsubmit="return validateForm()">
            <input type="hidden" name="username" value="<%= username %>">
            <div class="form-group">
                <label for="action">Action:</label>
                <select class="form-control" aria-label="Action" name="action">
                    <option value="withdraw">Withdraw</option>
                </select>
            </div>
            <div class="form-group">
                <label for="amount">Amount:</label>
                <input type="text" name="amount" class="form-control">
            </div>
            <button type="submit" class="btn btn-success btn-block">Withdraw</button>
        </form>
    </div>
    
    <div class="picture-container">
        <img src="images/dep.png" alt="Side Picture" class="img-fluid">
    </div>
</div>

<div class="footer">
    <p>&copy; 2024 Paytm</p>
</div>
<% String errorMessage = (String) request.getAttribute("errorMessage");
   if (errorMessage != null) { %>
    <script>
        displayErrorMessage("<%= errorMessage %>");
    </script>
<% } %>

</body>
</html>
