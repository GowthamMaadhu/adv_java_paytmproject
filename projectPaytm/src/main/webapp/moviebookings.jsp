<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Select Theater</title>
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
    .card-img-top {
        max-height: 300px;
        object-fit: cover;
    }
    .theater-table td {
        cursor: pointer;
    }
</style>
</head>
<body>

<%
    String movie = request.getParameter("movie");
    String username = request.getParameter("username");
    String posterPath = "";
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost/paytmproject", "root", "Gowtham@123");
        PreparedStatement stmt;
        ResultSet rs;

        // Retrieve poster path for the movie
        String sqlPoster = "SELECT poster_path FROM movieslist WHERE movie=?";
        stmt = con.prepareStatement(sqlPoster);
        stmt.setString(1, movie);
        rs = stmt.executeQuery();

        if (rs.next()) {
            posterPath = rs.getString("poster_path");
        }

        rs.close();
        stmt.close();
    } catch (Exception e) {
        e.printStackTrace();
    }
%>

<!-- Header -->
<div class="header">
    <div class="container">
        <div>
            <img src="images/Paytm_logo.jpg" width="100" height="30" alt="Paytm Logo">
            Movie Bookings
        </div>
        <div class="nav-options">
            <a href="login.jsp">LogOut</a>
            <a href="javascript:history.back()" class="btn btn-outline-light">Back</a>
        </div>
    </div>
</div>

<div class="container">
    <h2>Select a theater for <%= movie %></h2>
    <div class="row">
        <div class="col-md-4">
            <img src="<%= posterPath %>" class="card-img-top" alt="<%= movie %>">
        </div>
        <div class="col-md-8">
            <table class="table theater-table">
                <thead>
                    <tr>
                        <th>Theater Name</th>
                    </tr>
                </thead>
                <tbody>
<%
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost/paytmproject", "root", "Gowtham@123");
        PreparedStatement stmt;
        ResultSet rs;

        // Retrieve distinct theater names for the movie
        String sql = "SELECT DISTINCT theater_name FROM movie_schedule WHERE movie_name=?";
        stmt = con.prepareStatement(sql);
        stmt.setString(1, movie);
        rs = stmt.executeQuery();

        while (rs.next()) {
            String theater = rs.getString("theater_name");
%>
                    <tr onclick="selectTheater('<%= theater %>')">
                        <td><%= theater %></td>
                    </tr>
<%
        }
        rs.close();
        stmt.close();
        con.close();
    } catch (Exception e) {
        e.printStackTrace();
    }
%>
                </tbody>
            </table>
        </div>
    </div>
</div>

<script>
function selectTheater(theater) {
    // Construct the URL for redirection
    var url = 'selectShowTime.jsp';
    url += '?movie=<%= movie %>';
    url += '&theater=' + encodeURIComponent(theater); // Ensure proper encoding
    url += '&username=<%= username %>';
    url += '&posterPath=' + encodeURIComponent('<%= posterPath %>');

    // Redirect to the constructed URL
    window.location.href = url;
}

</script>

<!-- Footer -->
<div class="footer">
    <p>&copy; 2024 Paytm</p>
</div>

</body>
</html>
