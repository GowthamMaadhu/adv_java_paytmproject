<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Select Show Time</title>
    <!-- Bootstrap CSS -->
    <link href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
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
        .show-time-table {
            cursor: pointer; /* Change cursor to pointer for clickable rows */
        }
        .selected-details {
            display: none; /* Initially hide selected details */
        }
    </style>
</head>
<body>

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

<%
    String movie = request.getParameter("movie");
    String theater = request.getParameter("theater");
    String username = request.getParameter("username");
    String posterPath = request.getParameter("posterPath");
    int balance = 0;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost/paytmproject", "root", "Gowtham@123");
        PreparedStatement balanceStmt = con.prepareStatement("SELECT balance FROM userdata WHERE username=?");
        balanceStmt.setString(1, username);
        ResultSet balanceRs = balanceStmt.executeQuery();
        
        if (balanceRs.next()) {
            balance = balanceRs.getInt("balance");
        }

        balanceRs.close();
        balanceStmt.close();
        con.close();
    } catch (Exception e) {
        e.printStackTrace();
    }
%>

<div class="container">
    <h2>Select a show time for <%= movie %> at <%= theater %></h2>
    <div class="row">
        <div class="col-md-4">
            <img src="<%= posterPath %>" class="card-img-top" alt="<%= movie %>">
        </div>
        <div class="col-md-8">
            <table class="table show-time-table">
                <thead>
                    <tr>
                        <th>Show Time</th>
                        <th>Ticket Price</th>
                    </tr>
                </thead>
                <tbody>
<%
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost/paytmproject", "root", "Gowtham@123");
        PreparedStatement stmt = con.prepareStatement("SELECT show_time, ticket_price FROM movie_schedule WHERE movie_name=? AND theater_name=?");
        stmt.setString(1, movie);
        stmt.setString(2, theater);
        ResultSet rs = stmt.executeQuery();

        while (rs.next()) {
            String showTime = rs.getString("show_time");
            int ticketPrice = rs.getInt("ticket_price");
%>
                    <tr onclick="showDetails('<%= showTime %>', <%= ticketPrice %>, <%= balance %>)">
                        <td><%= showTime %></td>
                        <td><%= ticketPrice %></td>
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

            <!-- Selected Show Time Details -->
            <div class="selected-details mt-4">
                <h3>Selected Show Time Details</h3>
                <p>Movie: <%= movie %></p>
                <p>Theater: <%= theater %></p>
                <p>Selected Show Time: <span id="selectedShowTime"></span></p>
                <p>Ticket Price: <span id="selectedTicketPrice"></span></p>
                <p>Balance: <span id="userBalance"><%= balance %></span></p>

                <form action="processBooking.jsp">
                    <input type="hidden" name="username" value="<%= username %>">
                    <input type="hidden" name="movie" value="<%= movie %>">
                    <input type="hidden" name="posterPath" value="<%= posterPath %>">
                    <input type="hidden" name="theater" value="<%= theater %>">
                    <input type="hidden" name="showTime" id="bookingShowTime" value="">
                    <input type="hidden" name="ticketPrice" id="bookingTicketPrice" value="">

                    <label for="numPersons">Select Number of Persons:</label>
                    <select id="numPersons" name="numPersons" class="form-control" required onchange="updateTotalPrice()">
                        <% for (int i = 1; i <= 10; i++) { %>
                            <option value="<%= i %>"><%= i %></option>
                        <% } %>
                    </select>

                    <p>Total Price: ₹<span id="totalPrice"></span></p>

                    <input type="hidden" name="totalPrice" id="bookingTotalPrice" value="">

                    <input type="submit" id="bookTicketButton" class="btn btn-primary mt-2" value="Book Ticket">
                </form>

                <p id="insufficientFundsMessage" class="text-danger" style="display: none;">Insufficient funds to book the ticket.</p>
            </div>
        </div>
    </div>
</div>

<!-- Footer -->
<div class="footer">
    <p>&copy; 2024 Paytm</p>
</div>

<!-- JavaScript to show selected details and calculate total price -->
<script>
function showDetails(showTime, ticketPrice, balance) {
    // Set selected details in the HTML
    document.getElementById('selectedShowTime').textContent = showTime;
    document.getElementById('selectedTicketPrice').textContent = ticketPrice;

    // Set hidden input values for form submission
    document.getElementById('bookingShowTime').value = showTime;
    document.getElementById('bookingTicketPrice').value = ticketPrice;

    // Show the selected details section
    document.querySelector('.selected-details').style.display = 'block';

    // Update total price initially
    updateTotalPrice();

    // Check if balance is sufficient
    if (ticketPrice <= balance) {
        document.getElementById('bookTicketButton').style.display = 'inline-block';
        document.getElementById('insufficientFundsMessage').style.display = 'none';
    } else {
        document.getElementById('bookTicketButton').style.display = 'none';
        document.getElementById('insufficientFundsMessage').style.display = 'block';
    }
}

function updateTotalPrice() {
    const ticketPrice = parseInt(document.getElementById('bookingTicketPrice').value);
    const numPersons = parseInt(document.getElementById('numPersons').value);
    const totalPrice = ticketPrice * numPersons;
    
    document.getElementById('totalPrice').textContent = totalPrice;
    document.getElementById('bookingTotalPrice').value = totalPrice;

    // Check if balance is sufficient
    const balance = parseInt(document.getElementById('userBalance').textContent);
    if (totalPrice <= balance) {
        document.getElementById('bookTicketButton').style.display = 'inline-block';
        document.getElementById('insufficientFundsMessage').style.display = 'none';
    } else {
        document.getElementById('bookTicketButton').style.display = 'none';
        document.getElementById('insufficientFundsMessage').style.display = 'block';
    }
}
</script>

</body>
</html>