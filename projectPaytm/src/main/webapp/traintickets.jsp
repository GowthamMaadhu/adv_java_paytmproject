<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*,java.sql.Connection,java.sql.DriverManager" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Search Trains</title>
<!-- Bootstrap CSS -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
<style>
    /* Custom CSS styles */
    body {
        font-family: Arial, sans-serif;
        background-color: #f8f9fa;
        margin: 0;
        padding: 0;
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
        background-color: #00B9F1;
        color: white;
        text-align: center;
        padding: 10px 0;
        position: fixed;
        bottom: 0;
        width: 100%;
    }
    .confirmation-message {
        margin-top: 50px;
    }
    .carousel-item {
        height: 400px;
    }
    .carousel-item img {
        object-fit: cover;
        height: 100%;
        width: 100%;
    }
</style>
</head>
<body>
<%
    String username = (String) request.getAttribute("username");
    if (username == null) {
        username = request.getParameter("username");
    }
%>
<!-- Header -->
<div class="header">
    <div class="container">
        <div>
            <img src="images/Paytm_logo.jpg" width="100" height="30" alt="Paytm Logo">
            Train Bookings
        </div>
        <div class="nav-options">
            <a href="#">Home</a>
            <a href="#">Profile</a>
            <a href="#">Bookings</a>
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
            <img src="images/train1.png" class="d-block w-100" alt="Slide 1">
        </div>
        <div class="carousel-item">
            <img src="images/train2.png" class="d-block w-100" alt="Slide 2">
        </div>
        <div class="carousel-item">
            <img src="images/train3.png" class="d-block w-100" alt="Slide 3">
        </div>
        <div class="carousel-item">
            <img src="images/train4.png" class="d-block w-100" alt="Slide 4">
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

<div class="container">
    <h1>Search Trains</h1>
    <form action="traintickets.jsp" method="get">
        <div class="form-group">
            <input type="hidden" name="username" value="<%= username %>"/>
            <label for="fromStation">From</label>
            <input type="text" class="form-control" id="fromStation" name="fromStation" required>
        </div>
        <div class="form-group">
            <label for="toStation">To</label>
            <input type="text" class="form-control" id="toStation" name="toStation" required>
        </div>
        <div class="form-group">
            <label for="journeyDate">Journey Date</label>
            <input type="date" class="form-control" id="journeyDate" name="journeyDate" required>
        </div>
        <button type="submit" class="btn btn-primary">Search</button>
    </form>

    <h2>Search Results</h2>
    <%
        String fromStation = request.getParameter("fromStation");
        String toStation = request.getParameter("toStation");
        String journeyDate = request.getParameter("journeyDate");

        if (fromStation != null && toStation != null && journeyDate != null) {
            Connection con = null;
            PreparedStatement stmt = null;
            ResultSet rs = null;
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                con = DriverManager.getConnection("jdbc:mysql://localhost/paytmproject", "root", "Gowtham@123");

                // Retrieve trains matching the search criteria
                String sql = "SELECT * FROM trains WHERE from_station = ? AND to_station = ?";
                stmt = con.prepareStatement(sql);
                stmt.setString(1, fromStation);
                stmt.setString(2, toStation);
                rs = stmt.executeQuery();

                if (rs.next()) {
    %>
                    <table class="table table-striped">
                        <thead>
                            <tr>
                                <th>Train Number</th>
                                <th>Train Name</th>
                                <th>From</th>
                                <th>To</th>
                                <th>Departure</th>
                                <th>Arrival</th>
                                <th>SL Seats Available</th>
                                <th>AC Seats Available</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
    <%
                            do {
    %>
                                <tr>
                                    <td><%= rs.getString("train_number") %></td>
                                    <td><%= rs.getString("train_name") %></td>
                                    <td><%= rs.getString("from_station") %></td>
                                    <td><%= rs.getString("to_station") %></td>
                                    <td><%= rs.getTime("departure_time") %></td>
                                    <td><%= rs.getTime("arrival_time") %></td>
                                    <td><%= rs.getInt("slseats_available") %></td>
                                    <td><%= rs.getInt("acseats_available") %></td>
                                    <td>
                                        <form action="booking.jsp" method="post">
                                            <input type="hidden" name="username" value="<%= username %>"/>
                                            <input type="hidden" name="number" value="<%= rs.getString("train_number") %>"/>
                                            <input type="hidden" name="trainId" value="<%= rs.getInt("id") %>"/>
                                            <input type="hidden" name="name" value="<%= rs.getString("train_name") %>"/>
                                            <input type="hidden" name="journeyDate" value="<%= journeyDate %>"/> <!-- Include journeyDate in the form -->
                                            <button type="submit" class="btn btn-success">Book</button>
                                        </form>
                                    </td>
                                </tr>
    <%
                            } while (rs.next());
    %>
                        </tbody>
                    </table>
    <%
                } else {
                    out.println("<p>No trains found for the specified route on " + journeyDate + ".</p>");
                }
            } catch (Exception e) {
                e.printStackTrace();
                out.println("<p>Error: " + e.getMessage() + "</p>");
            } finally {
                try {
                    if (rs != null) rs.close();
                    if (stmt != null) stmt.close();
                    if (con != null) con.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    %>
</div>
<br><br><br><br><br><br>
<!-- Footer -->
<div class="footer">
    <p>&copy; 2024 Paytm</p>
</div>

</body>
</html>
