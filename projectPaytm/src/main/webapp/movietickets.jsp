<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*,java.sql.Connection,java.sql.DriverManager" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="ISO-8859-1">
    <title>Movies List</title>
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
        .carousel-inner img {
            width: 100%;
            height: 400px; /* Adjust the height as needed */
        }
        .highlighted-form {
            background-color: #e9ecef;
            border-radius: 5px;
            padding: 15px;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>

<%
    String username = request.getParameter("username");
    if (username == null || username.isEmpty()) {
        response.sendRedirect("login.jsp"); // Redirect to login page if username is not found
        return;
    }
%>

<!-- Header -->
<div class="header">
    <div class="container">
        <div>
            <img src="images/Paytm_logo.jpg" width="100" height="30" alt="Paytm Logo">
            Movies List
        </div>
        <div class="nav-options">
           <a href="login.jsp">LogOut</a>
            <a href="javascript:history.back()" class="btn btn-outline-light">Back</a>
        </div>
    </div>
</div>

<!-- Carousel -->
<div id="carouselExampleIndicators" class="carousel slide" data-ride="carousel">
    <ol class="carousel-indicators">
        <li data-target="#carouselExampleIndicators" data-slide-to="0" class="active"></li>
        <li data-target="#carouselExampleIndicators" data-slide-to="1"></li>
        <li data-target="#carouselExampleIndicators" data-slide-to="2"></li>
    </ol>
    <div class="carousel-inner">
        <div class="carousel-item active">
            <img src="images/moviemain1.jpg" class="d-block w-100" alt="Slide 1">
        </div>
        <div class="carousel-item">
            <img src="images/moviemain2.png" class="d-block w-100" alt="Slide 2">
        </div>
        <div class="carousel-item">
            <img src="images/moviemain3.jpg" class="d-block w-100" alt="Slide 3">
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
    <!-- Highlighted City Name Form -->
    <div class="highlighted-form">
        <form class="text-center" action="movietickets.jsp">
            <input type="hidden" name="username" value="<%= username %>">
            <h1>City Name:</h1>
            <div class="form-group">
                <input type="text" name="cityname" placeholder="Enter your City Name" class="form-control w-50 mx-auto" />
            </div>
            <input type="submit" value="Submit" class="btn btn-primary" />
        </form>
    </div>

    <!-- Running Shows Container -->
    <div class="container">
        <h2>Running Shows in Your Location</h2>
        <div class="row">
            <%
                String city = request.getParameter("cityname");
                if (city != null && !city.isEmpty()) {
                    try {
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        Connection con = DriverManager.getConnection("jdbc:mysql://localhost/paytmproject", "root", "Gowtham@123");
                        String currentSql = "SELECT movie, poster_path FROM movieslist WHERE city = ?";
                        PreparedStatement currentStmt = con.prepareStatement(currentSql);
                        currentStmt.setString(1, city); // Set the city parameter
                        ResultSet currentRs = currentStmt.executeQuery();
                        boolean hasResults = false;
                        while (currentRs.next()) {
                            hasResults = true;
                            String movie = currentRs.getString("movie");
                            String posterPath = currentRs.getString("poster_path");
            %>
            <div class="col-md-3">
                <div class="card mb-3">
                    <a href="moviebookings.jsp?movie=<%= movie %>&username=<%= username %>">
                        <img src="<%= posterPath %>" class="card-img-top" alt="<%= movie %>">
                    </a>
                    <div class="card-body text-center">
                        <h5 class="card-title">
                            <a href="moviebookings.jsp?movie=<%= movie %>&username=<%= username %>"><%= movie %></a>
                        </h5>
                    </div>
                </div>
            </div>
            <%
                        }
                        if (!hasResults) {
            %>
            <div class="col-12">
                <div class="alert alert-info text-center" role="alert">
                    No shows running at your location.
                </div>
            </div>
            <%
                        }
                        currentRs.close();
                        currentStmt.close();
                        con.close();
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }
            %>
        </div>
    </div>

    <!-- Upcoming Movies Container -->
    <div class="container">
        <h2>Upcoming Movies</h2>
        <div class="row">
            <%
                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    Connection con = DriverManager.getConnection("jdbc:mysql://localhost/paytmproject", "root", "Gowtham@123");
                    String upcomingSql = "SELECT movie, release_date, poster_path FROM upcoming_movies";
                    PreparedStatement upcomingStmt = con.prepareStatement(upcomingSql);
                    ResultSet upcomingRs = upcomingStmt.executeQuery();
                    while (upcomingRs.next()) {
                        String upcomingMovie = upcomingRs.getString("movie");
                        Date releaseDate = upcomingRs.getDate("release_date");
                        String formattedDate = new java.text.SimpleDateFormat("MMM dd, yyyy").format(releaseDate);
                        String upcomingPosterPath = upcomingRs.getString("poster_path");
            %>
            <div class="col-md-3">
                <div class="card mb-3">
                    <img src="<%= upcomingPosterPath %>" class="card-img-top" alt="<%= upcomingMovie %>">
                    <div class="card-body text-center">
                        <h5 class="card-title"><%= upcomingMovie %></h5>
                        <p class="card-text">Release Date: <%= formattedDate %></p>
                    </div>
                </div>
            </div>
            <%
                    }
                    upcomingRs.close();
                    upcomingStmt.close();
                    con.close();
                } catch (Exception e) {
                    e.printStackTrace();
                }
            %>
        </div>
    </div>
</div>
<br><br><br><br><br><br>
<!-- Footer -->
<div class="footer">
    <p>&copy; 2024 Paytm</p>
</div>

<!-- Bootstrap JS and dependencies -->
<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.9.2/dist/umd/popper.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>

</body>
</html>
