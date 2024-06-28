<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>LogInSuccess</title>
<link rel='stylesheet' href='https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css'>
<style>
    body {
        font-family: Arial, sans-serif;
    }
    .header, .footer {
        background-color: #00B9F1;
        color: #fff;
        padding: 10px 0;
    }
    .header {
        text-align: center;
    }
    .footer {
        text-align: center;
        position: fixed;
        bottom: 0;
        width: 100%;
    }
    .container {
        margin-top: 20px;
    }
    .action-links {
        display: flex;
        flex-wrap: wrap;
        justify-content: center;
        gap: 20px;
    }
    .action-item {
        display: flex;
        flex-direction: column;
        align-items: center;
    }
    .action-item img {
        display: block;
        cursor: pointer;
        margin-bottom: 5px;
    }
</style>
<script>
function postToTransactionServlet(action, username) {
    const form = document.createElement('form');
    form.method = 'POST';
    form.action = 'TransactionServlet';
    
    const usernameInput = document.createElement('input');
    usernameInput.type = 'hidden';
    usernameInput.name = 'username';
    usernameInput.value = username;
    form.appendChild(usernameInput);
    
    const actionInput = document.createElement('input');
    actionInput.type = 'hidden';
    actionInput.name = 'action';
    actionInput.value = action;
    form.appendChild(actionInput);
    
    document.body.appendChild(form);
    form.submit();
}

function postToBookingServlet(action, username) {
    const form = document.createElement('form');
    form.method = 'POST';
    form.action = 'BookingServlets';
    
    const usernameInput = document.createElement('input');
    usernameInput.type = 'hidden';
    usernameInput.name = 'username';
    usernameInput.value = username;
    form.appendChild(usernameInput);
    
    const actionInput = document.createElement('input');
    actionInput.type = 'hidden';
    actionInput.name = 'action';
    actionInput.value = action;
    form.appendChild(actionInput);
    
    document.body.appendChild(form);
    form.submit();
}
</script>
</head>
<body>
<%
    String username = (String)request.getAttribute("username");
%>
<div class="header">
    <h1>Hey, <%= username %></h1>
</div>
<div class="container mt-5">
    <!-- Services Row -->
    <div class="container mb-5">
        <h2 class="text-center">Services</h2>
        <div class="row action-links">
            <div class="col-md-2 action-item">
                <a href="deposite.jsp?username=<%= username %>">
                    <img src="images/deposite.jpg" alt="Deposit" class="img-fluid" style="width: 100px;">
                </a>
                <span>Deposit</span>
            </div>
            <div class="col-md-2 action-item">
                <a href="withdraw.jsp?username=<%= username %>">
                    <img src="images/withdraw1.jpg" alt="Withdraw" class="img-fluid" style="width: 100px;">
                </a>
                <span>Withdraw</span>
            </div>
            <div class="col-md-2 action-item">
                <a href="#" onclick="postToTransactionServlet('checkbalance', '<%= username %>')">
                    <img src="images/checkbalance.png" alt="Check Balance" class="img-fluid" style="width: 100px;">
                </a>
                <span>Check Balance</span>
            </div>
            <div class="col-md-2 action-item">
                <a href="#" onclick="postToTransactionServlet('paymenthistory', '<%= username %>')">
                    <img src="images/paymenthistory.png" alt="Payment History" class="img-fluid" style="width: 100px;">
                </a>
                <span>Payment History</span>
            </div>
            <div class="col-md-2 action-item">
                <a href="#" onclick="postToTransactionServlet('moneytransfer', '<%= username %>')">
                    <img src="images/moneytransfer.png" alt="Money Transfer" class="img-fluid" style="width: 100px;">
                </a>
                <span>Money Transfer</span>
            </div>
        </div>
    </div>
    <!-- Bookings Row -->
    <div class="container">
        <h2 class="text-center">Bookings</h2>
        <div class="row action-links">
            <div class="col-md-2 action-item">
                <a href="#" onclick="postToBookingServlet('hotel', '<%= username %>')">
                    <img src="images/hotel.png" alt="Hotel" class="img-fluid" style="width: 100px;">
                </a>
                <span>Hotel</span>
            </div>
            <div class="col-md-2 action-item">
                <a href="#" onclick="postToBookingServlet('movie', '<%= username %>')">
                    <img src="images/movie.png" alt="Movie" class="img-fluid" style="width: 100px;">
                </a>
                <span>Movie</span>
            </div>
            <div class="col-md-2 action-item">
                <a href="#" onclick="postToBookingServlet('train', '<%= username %>')">
                    <img src="images/train.png" alt="Train" class="img-fluid" style="width: 100px;">
                </a>
                <span>Train</span>
            </div>
            <div class="col-md-2 action-item">
                <a href="#" onclick="postToBookingServlet('bus', '<%= username %>')">
                    <img src="images/bus.png" alt="Bus" class="img-fluid" style="width: 100px;">
                </a>
                <span>Bus</span>
            </div>
            <div class="col-md-2 action-item">
                <a href="#" onclick="postToBookingServlet('bookinghis', '<%= username %>')">
                    <img src="images/bookinghis.png" alt="Bus" class="img-fluid" style="width: 100px;">
                </a>
                <span>Bus</span>
            </div>
        </div>
    </div>
</div>
<div class="footer">
    <p>&copy; 2024 Paytm</p>
</div>
<!-- Add Bootstrap JS script link here if needed -->
<script src="https://code.jquery.com/jquery-3.3.1.slim.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"></script>
</body>
</html>
