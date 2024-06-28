<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="ISO-8859-1">
    <title>Booking Page</title>
    <!-- Bootstrap CSS -->
    <link href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f8f9fa;
            margin: 0;
            padding: 0;
        }
        .container {
            margin-top: 50px;
        }
        .card {
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            border: none;
            border-radius: 10px;
        }
        .card-header {
            background-color: #007B9A;
            color: white;
            font-size: 1.5rem;
            text-align: center;
            border-top-left-radius: 10px;
            border-top-right-radius: 10px;
        }
        .card-body {
            padding: 20px;
        }
        .btn-primary {
            background-color: #00B9F1;
            border: none;
        }
        .btn-primary:hover {
            background-color: #007B9A;
        }
        .header {
            background-color: #00B9F1;
            color: white;
            padding: 10px 0;
            margin-bottom: 20px;
        }
        .header .container {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .header img {
            max-height: 50px;
        }
        .nav-options a {
            color: white;
            text-decoration: none;
            padding: 5px 10px;
            border-radius: 5px;
            transition: background-color 0.3s;
        }
        .nav-options a:hover {
            background-color: #007B9A;
        }
        .footer {
            background-color: #007B9A;
            color: white;
            text-align: center;
            padding: 10px 0;
            position: fixed;
            bottom: 0;
            width: 100%;
        }
        .carousel-item {
            height: 300px; /* Adjust as needed */
        }
        .carousel-item img {
            object-fit: cover;
            height: 100%;
            width: 100%;
        }
    </style>
</head>
<body>
    <!-- Header -->
    <div class="header">
        <div class="container">
            <div>
                <img src="images/Paytm_logo.jpg" width="100" height="30" alt="Logo">
                Booking Page
            </div>
            <div class="nav-options">
               <a href="login.jsp">LogOut</a>
            <a href="javascript:history.back()" class="btn btn-outline-light">Back</a>
            </div>
        </div>
    </div>

    <!-- Slideshow -->
    <div id="carouselExampleIndicators" class="carousel slide" data-ride="carousel">
        <ol class="carousel-indicators">
            <li data-target="#carouselExampleIndicators" data-slide-to="0" class="active"></li>
            <li data-target="#carouselExampleIndicators" data-slide-to="1"></li>
            <li data-target="#carouselExampleIndicators" data-slide-to="2"></li>
            <li data-target="#carouselExampleIndicators" data-slide-to="3"></li>
        </ol>
        <div class="carousel-inner">
            <div class="carousel-item active">
                <img src="images/hotel1.jpg" class="d-block w-100" alt="Slide 1">
            </div>
            <div class="carousel-item">
                <img src="images/hotel2.jpg" class="d-block w-100" alt="Slide 2">
            </div>
            <div class="carousel-item">
                <img src="images/hotel3.jpg" class="d-block w-100" alt="Slide 3">
            </div>
            <div class="carousel-item">
                <img src="images/hotel4.jpg" class="d-block w-100" alt="Slide 4">
            </div>
        </div>
        <a class="carousel-control-prev" href="#carouselExampleIndicators" role="button" data-slide="prev">
            <span class="carousel-control-prev-icon" aria-hidden="true"></span>
            <span class="sr-only">Previous</span>
        </a>
        <a class="carousel-control-next" href="#carouselExampleIndicators" role="button" data-slide="next">
            <span class="carousel-control-next-icon" aria-hidden="true"></span>
            <span class="sr-only">Next</span>
        </a>
    </div>

    <!-- Booking Form Card -->
    <div class="container">
        <div class="card mt-4">
            <div class="card-header">
                Booking Details
            </div>
            <div class="card-body">
                <%
                    String hotelname = request.getParameter("hotelname");
                    String username = request.getParameter("user");
                    out.println(username);
                    // Assuming user's balance is stored in a SQL table called 'users' with columns 'username' and 'balance'
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    Connection con = DriverManager.getConnection("jdbc:mysql://localhost/paytmproject","root","Gowtham@123");
                    String getBalanceQuery = "SELECT balance FROM userdata WHERE username=?";
                    PreparedStatement balanceStmt = con.prepareStatement(getBalanceQuery);
                    balanceStmt.setString(1, username);
                    ResultSet balanceRs = balanceStmt.executeQuery();
                    int balance = 0;
                    if (balanceRs.next()) {
                        balance = balanceRs.getInt("balance");
                        session.setAttribute("balance", balance);
                    }
                %>
                <h2 class="text-center">Hotel: <%= hotelname %></h2>
               <!--   <h3 class="text-center">Your Balance: <%= balance %></h3> -->
                <%
                    // Retrieve price of the selected hotel
                    String getPriceQuery = "SELECT price FROM hotelbookings WHERE hotelname=?";
                    PreparedStatement priceStmt = con.prepareStatement(getPriceQuery);
                    priceStmt.setString(1, hotelname);
                    ResultSet priceRs = priceStmt.executeQuery();
                    int price = 0;
                    if (priceRs.next()) {
                        price = priceRs.getInt("price");
                    }
                %>
                <h3 class="text-center">Price: <%= price %></h3>
                <form action="confirmBooking.jsp" class="mt-4">
                    <input type="hidden" name="hotelname" value="<%= hotelname %>">
                    <input type="hidden" name="username" value="<%= username %>">
                    <div class="form-group">
                        <label for="guestName">Your Name:</label>
                        <input type="text" class="form-control" id="guestName" name="guestName" required>
                    </div>
                    <div class="form-group">
                        <label for="checkInDate">Check-in Date:</label>
                        <input type="date" class="form-control" id="checkInDate" name="checkInDate" required>
                    </div>
                    <div class="form-group">
                        <label for="checkOutDate">Check-out Date:</label>
                        <input type="date" class="form-control" id="checkOutDate" name="checkOutDate" required>
                    </div>
                    <div class="form-group">
                        <label for="guests">Number of Guests:</label>
                        <input type="number" class="form-control" id="guests" name="guests" required>
                    </div>
                    <div class="text-center">
                        <%
                            if (balance < price) {
                        %>
                            <p class="text-danger">Insufficient balance to make the booking.</p>
                        <%
                            } else {
                        %>
                            <input type="submit" class="btn btn-primary" value="Confirm Booking">
                        <%
                            }
                        %>
                    </div>
                </form>
            </div>
        </div>
    </div>
<br><br><br><br><br>
    <!-- Footer -->
    <div class="footer">
        <p>&copy; 2024 Paytm</p>
    </div>

    <!-- jQuery, Popper.js, and Bootstrap JS -->
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.9.2/dist/umd/popper.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>
