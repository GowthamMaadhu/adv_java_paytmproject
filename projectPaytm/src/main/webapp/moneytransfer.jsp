<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Money Transfer</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css">
    <style>
        body {
            font-family: Arial, sans-serif;
            display: flex;
            flex-direction: column;
            min-height: 100vh;
            position: relative; /* Ensure the body is relatively positioned */
            margin: 0;
            padding: 0;
            background-color: #f2f2f2;
            background-image: url('images/moneytransfer1.png'); /* Add your background image URL here */
            background-size: cover;
            background-position: center;
            background-repeat: no-repeat;
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
            display: flex;
            justify-content: flex-start; /* Align forms to the left */
            align-items: center;
            flex-grow: 1;
            padding: 20px;
        }
        .form-container {
            width: 100%; /* Take full width of container */
            max-width: 600px; /* Limit form width for readability */
            background-color: rgba(255, 255, 255, 0.9); /* Add opacity for readability */
            border: 1px solid #ccc;
            border-radius: 5px;
            padding: 20px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
            margin-bottom: 20px; /* Add margin bottom for spacing */
        }
        .form-container h2 {
            margin-bottom: 20px;
        }
        .form-group {
            margin-bottom: 20px;
        }
        .btn-primary {
            background-color: #007B9A;
            border-color: #007B9A;
        }
        .btn-primary:hover {
            background-color: #005E75;
            border-color: #005E75;
        }
        .footer {
            background-color: #00B9F1;
            color: #fff;
            text-align: center;
            padding: 10px 0;
            position: absolute;
            bottom: 0;
            width: 100%;
        }
        .footer p {
            margin: 0;
        }
    </style>
</head>
<body>

<div class="header">
    <div class="container">
     
        <img src="images/Paytm_logo.jpg" alt="Paytm Logo">
        <div class="nav-options">
            <a href="login.jsp">LogOut</a>
            <a href="javascript:history.back()" class="btn btn-outline-light">Back</a>
        </div>
    </div>
</div>

<div class="main-container">
    <div class="form-container">
        <% String username = (String) request.getAttribute("username"); %>
        
        <div id="mobileForm">
            <h2>Money Transfer with Mobile Number</h2>
            <form action="moneytransferServelet" method="post">
                <input type="hidden" name="username" value="<%= username %>">
                <div class="form-group">
                    <input type="number" class="form-control" name="mobilenumber" placeholder="Enter the mobile number" required>
                </div>
                <div class="form-group">
                    <input type="text" class="form-control" name="name" placeholder="Enter the receiver name" required>
                </div>
                <div class="form-group">
                    <input type="number" class="form-control" name="money" placeholder="Enter amount" required>
                </div>
                <button type="submit" class="btn btn-primary btn-block">Pay Now</button>
            </form>
        </div>

        <div id="accountForm" style="display: none;">
            <h2 class="mt-5">Money Transfer with Account Number</h2>
            <form action="acctransferservelet" method="post">
                <input type="hidden" name="username" value="<%= username %>">
                <div class="form-group">
                    <input type="number" class="form-control" name="accountnumber" placeholder="Enter the account number" required>
                </div>
                <div class="form-group">
                    <input type="text" class="form-control" name="accountholder" placeholder="Enter the account holder name" required>
                </div>
                <div class="form-group">
                    <input type="number" class="form-control" name="ifsccode" placeholder="Enter the IFSC code" required>
                </div>
                <div class="form-group">
                    <input type="number" class="form-control" name="money" placeholder="Enter amount" required>
                </div>
                <button type="submit" class="btn btn-primary btn-block">Pay Now</button>
            </form>
        </div>
        
        <div class="text-center mt-3">
            <button class="btn btn-link" onclick="toggleForm('mobileForm')">Mobile Number Transfer</button>
            <button class="btn btn-link" onclick="toggleForm('accountForm')">Account Number Transfer</button>
        </div>
    </div>
</div>

<div class="footer">
    <div class="container">
        <p>&copy; 2024 Paytm</p>
    </div>
</div>

<script>
    function toggleForm(formId) {
        document.getElementById('mobileForm').style.display = 'none';
        document.getElementById('accountForm').style.display = 'none';
        document.getElementById(formId).style.display = 'block';
    }
</script>

</body>
</html>
