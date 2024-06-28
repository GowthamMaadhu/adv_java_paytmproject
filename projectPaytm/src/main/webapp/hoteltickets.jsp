<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*,java.sql.Connection,java.sql.DriverManager" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="ISO-8859-1">
    <title>Hotel Bookings</title>
    <!-- Bootstrap CSS -->
    <link href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            font-family: Arial, sans-serif;
        }
        .header, .footer {
            background-color: #00B9F1;
            color: #fff;
            padding: 10px 0;
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
        .footer {
            text-align: center;
            position: fixed;
            bottom: 0;
            width: 100%;
        }
        .navbar-nav .nav-item .nav-link {
            padding: 10px 15px; /* Add padding to navbar items */
        }
        .container {
            margin-top: 20px;
        }
        .city-image {
            width: 100%;
            height: auto;
            margin-top: 20px;
        }
        .highlight-form {
            background-color: #f8f9fa; /* Light background color */
            border: 2px solid #00B9F1; /* Border color to match the header and footer */
            box-shadow: 0 4px 8px rgba(0,0,0,0.1); /* Subtle shadow */
            padding: 20px;
            border-radius: 10px;
            margin-top: 20px;
        }
        .highlight-form h1 {
            color: #00B9F1;
        }
        .carousel-item img {
            width: 100%;
            height: 300px;
            object-fit: cover;
        }
    </style>
</head>
<body>
<%
    String username = (String)request.getAttribute("username");
%>
<!-- Header -->
<div class="header">
    <div class="container">
        
            <img src="images/Paytm_logo.jpg" width="100" height="30" class="d-inline-block align-top" alt="">
            Hotel Booking
       
        <div class="nav-options">
            <a href="login.jsp">LogOut</a>
            <a href="javascript:history.back()" class="btn btn-outline-light">Back</a>
        </div>
    </div>
</div>

<!-- City Image -->
<img src="images/hotelpage.jpg" alt="City View" class="city-image">

<div class="container mt-5">
    <!-- Highlighted City Form -->
    <div class="highlight-form text-center">
        <form action="hoteltickets.jsp">
            <input type="hidden" name="username" value="<%= username %>">
            <div class="form-group">
                <h1>City Name:</h1>
                <input type="text" class="form-control" name="cityname" required />
            </div>
            <button type="submit" class="btn btn-primary">Submit</button>
        </form>
    </div>

    <table class="table table-bordered table-striped mt-5">
        <thead class="thead-dark">
            <tr>
                <th>Hotel Name</th>
                <th>Price</th>
                <th>Book</th>
            </tr>
        </thead>
        <tbody>
<%
    String city = request.getParameter("cityname");
    String user = request.getParameter("username");
    if (city != null && !city.isEmpty()) {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost/paytmproject", "root", "Gowtham@123");
        String sql = "select hotelname, price from hotelbookings where city=?";
        PreparedStatement stmt = con.prepareStatement(sql);
        stmt.setString(1, city);
        ResultSet rs = stmt.executeQuery();
        while (rs.next()) {
%>
            <tr>
                <td><%= rs.getString("hotelname") %></td>
                <td><%= rs.getInt("price") %></td>
<%
            String value1 = rs.getString("hotelname");
            String value2 = user;
%>
                <td><a href="bookings.jsp?hotelname=<%= value1 %>&user=<%= value2 %>" class="btn btn-success">Book</a></td>
            </tr>
<%
        }
        rs.close();
        stmt.close();
        con.close();
    }
%>
        </tbody>
    </table>

    <!-- Slideshow -->
    <div id="carouselExampleIndicators" class="carousel slide mt-5" data-ride="carousel">
        <ol class="carousel-indicators">
            <li data-target="#carouselExampleIndicators" data-slide-to="0" class="active"></li>
            <li data-target="#carouselExampleIndicators" data-slide-to="1"></li>
            <li data-target="#carouselExampleIndicators" data-slide-to="2"></li>
            <li data-target="#carouselExampleIndicators" data-slide-to="3"></li>
        </ol>
        <div class="carousel-inner">
            <div class="carousel-item active">
                <img src="images/hotel1.jpg" class="d-block w-100" alt="...">
            </div>
            <div class="carousel-item">
                <img src="images/hotel2.jpg" class="d-block w-100" alt="...">
            </div>
            <div class="carousel-item">
                <img src="images/hotel3.jpg" class="d-block w-100" alt="...">
            </div>
            <div class="carousel-item">
                <img src="images/hotel4.jpg" class="d-block w-100" alt="...">
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
</div>
<br><br><br><br>
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
