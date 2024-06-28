<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*,java.sql.Connection,java.sql.DriverManager" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Search Buses</title>
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
    .carousel-item {
        height: 400px;
    }
    .carousel-item img {
        object-fit: cover;
        height: 100%;
        width: 100%;
    }
      .form-group label {
        color: #007bff;
    }
    .form-control {
        border-color: #007bff;
        border-radius: 5px;
        padding: 12px 20px;
        margin-bottom: 15px;
    }
    .form-control:focus {
        border-color: #0056b3;
        box-shadow: none;
    }
    .btn-primary {
        background-color: #007bff;
        border-color: #007bff;
        padding: 10px 20px;
        border-radius: 5px;
    }
    .btn-primary:hover {
        background-color: #0056b3;
        border-color: #0056b3;
    }
    .btn-success {
        background-color: #28a745;
        border-color: #28a745;
        padding: 10px 20px;
        border-radius: 5px;
    }
    .btn-success:hover {
        background-color: #218838;
        border-color: #218838;
    }
    table {
        margin-top: 20px;
    }
    table th {
        background-color: black;
        color: white;
    }
</style>
</head>
<body>
<%
    String username = (String) request.getAttribute("username");
    if (username == null) {
        username = request.getParameter("username");
        out.println(username);
    }
%>
<!-- Header -->
<div class="header">
    <div class="container">
        <img src="images/Paytm_logo.jpg" width="100" height="30" class="d-inline-block align-top" alt="Paytm Logo">
        <h1>Search Buses</h1>
        <div class="nav-options">
            <a href="#">Home</a>
            <a href="#">Profile</a>
            <a href="#">Bookings</a>
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
            <img src="images/bus1.jpg" class="d-block w-100" alt="Slide 1">
        </div>
        <div class="carousel-item">
            <img src="images/bus2.jpg" class="d-block w-100" alt="Slide 2">
        </div>
        <div class="carousel-item">
            <img src="images/bus3.jpg" class="d-block w-100" alt="Slide 3">
        </div>
        <div class="carousel-item">
            <img src="images/bus4.jpg" class="d-block w-100" alt="Slide 4">
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
    <h1>Search Buses</h1>
    <form action="bustickets.jsp" method="get">
        <div class="form-group">
            <input type="hidden" name="username" value="<%= username %>"/>
            <label for="fromStation">From</label>
            <input type="text" class="form-control" id="fromStation" placeholder="Enter your starting point" name="fromStation" required>
        </div>
        <div class="form-group">
            <label for="toStation">To</label>
            <input type="text" class="form-control" id="toStation" placeholder="Enter your ending point" name="toStation" required>
        </div>
        <button type="submit" class="btn btn-primary">Search</button>
    </form>

    <h2>Search Results</h2>
    <%
        String fromStation = request.getParameter("fromStation");
        String toStation = request.getParameter("toStation");
            		String username1=request.getParameter("username");
            		out.println(username1);

        if (fromStation != null && toStation != null) {
            Connection con = null;
            PreparedStatement stmt = null;
            ResultSet rs = null;
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                con = DriverManager.getConnection("jdbc:mysql://localhost/paytmproject", "root", "Gowtham@123");

                String sql = "SELECT * FROM buses WHERE pickup = ? AND drop_point = ?";
                stmt = con.prepareStatement(sql);
                stmt.setString(1, fromStation);
                stmt.setString(2, toStation);
                rs = stmt.executeQuery();

                if (rs.next()) {
    %>
                    <table class="table table-striped">
                        <thead>
                            <tr>
                                <th>Bus Number</th>
                                <th>Bus Name</th>
                                <th>Pickup</th>
                                <th>Drop Point</th>
                                <th>Departure</th>
                                <th>Arrival</th>
                                <th>Seats Available</th>
                                <th>Bus Type</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
    <%
                    do {
    %>
                        <tr>
                            <td><%= rs.getInt("bus_number") %></td>
                            <td><%= rs.getString("busname") %></td>
                            <td><%= rs.getString("pickup") %></td>
                            <td><%= rs.getString("drop_point") %></td>
                            <td><%= rs.getTime("departure_time") %></td>
                            <td><%= rs.getTime("arrival_time") %></td>
                            <td><%= rs.getInt("seats_availability") %></td>
                            <td><%= rs.getString("bus_type") %></td>
                            <td>
                                <form action="busbooking.jsp" method="post">
                                    <input type="hidden" name="username" value="<%= username1 %>"/>
                                    <input type="hidden" name="busNumber" value="<%= rs.getString("bus_number") %>"/>
                                    <input type="hidden" name="busId" value="<%= rs.getInt("id") %>"/>
                                    <input type="hidden" name="busName" value="<%= rs.getString("busname") %>"/>
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
                    out.println("<p>No buses found for the specified route.</p>");
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
    <div class="container">
        <p>&copy; 2024 Paytm</p>
    </div>
</div>

<!-- jQuery, Popper.js, and Bootstrap JS -->
<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.9.2/dist/umd/popper.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>

<script>
    // Initialize the carousel
    $(document).ready(function() {
        $('#carouselExampleIndicators').carousel();
    });
</script>

</body>
</html>
