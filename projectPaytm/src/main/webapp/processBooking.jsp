<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Booking Confirmation</title>
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
        .confirmation-message {
            margin-top: 50px;
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

<div class="container">
<%
    String username = request.getParameter("username");
    String movie = request.getParameter("movie");
    String posterPath = request.getParameter("posterPath");
    String theater = request.getParameter("theater");
    String showTime = request.getParameter("showTime");
    int ticketPrice = Integer.parseInt(request.getParameter("ticketPrice"));
    int numPersons = Integer.parseInt(request.getParameter("numPersons"));
    int totalPrice = Integer.parseInt(request.getParameter("totalPrice"));

    int balance = 0;
    boolean bookingSuccess = false;
    String bookingId = "";
    List<String> assignedSeats = new ArrayList<>();
    Random rand = new Random();
    String seat;

    // Generate random 12-digit booking ID
    long lowerBound = 100000000000L;
    long upperBound = 999999999999L;
    bookingId = String.valueOf(lowerBound + (long)(rand.nextDouble() * (upperBound - lowerBound)));

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost/paytmproject", "root", "Gowtham@123");
        PreparedStatement balanceStmt = con.prepareStatement("SELECT balance FROM userdata WHERE username=?");
        balanceStmt.setString(1, username);
        ResultSet balanceRs = balanceStmt.executeQuery();
        
        if (balanceRs.next()) {
            balance = balanceRs.getInt("balance");
        }

        if (balance >= totalPrice) {
            balance -= totalPrice;

            // Assign random seats
            for (int i = 0; i < numPersons; i++) {
                char row = (char) ('A' + rand.nextInt(26));
                int seatNumber = 1 + rand.nextInt(10);
                seat = "" + row + seatNumber;
                assignedSeats.add(seat);
            }

            // Update user's balance
            PreparedStatement updateBalanceStmt = con.prepareStatement("UPDATE userdata SET balance=? WHERE username=?");
            updateBalanceStmt.setInt(1, balance);
            updateBalanceStmt.setString(2, username);
            updateBalanceStmt.executeUpdate();
            updateBalanceStmt.close();

            // Insert booking details
            PreparedStatement bookingStmt = con.prepareStatement("INSERT INTO moviebookings (booking_id, username, movie_name, theater_name, show_time, ticket_price, seats, num_persons, total_price) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)");
            bookingStmt.setString(1, bookingId);
            bookingStmt.setString(2, username);
            bookingStmt.setString(3, movie);
            bookingStmt.setString(4, theater);
            bookingStmt.setString(5, showTime);
            bookingStmt.setInt(6, ticketPrice);
            bookingStmt.setString(7, String.join(",", assignedSeats));
            bookingStmt.setInt(8, numPersons);
            bookingStmt.setInt(9, totalPrice);
            bookingStmt.executeUpdate();
            bookingStmt.close();

            bookingSuccess = true;
        }

        balanceRs.close();
        balanceStmt.close();
        con.close();
    } catch (Exception e) {
        e.printStackTrace();
    }

    if (bookingSuccess) {
%>
    <div class="confirmation-message">
        <h2>Booking Confirmation</h2>
        <div class="row">
            <div class="col-md-4">
                <img src="<%= posterPath %>" class="img-fluid" alt="<%= movie %>">
            </div>
            <div class="col-md-8">
                <p>Booking ID: <%= bookingId %></p>
                <p>Movie: <%= movie %></p>
                <p>Theater: <%= theater %></p>
                <p>Show Time: <%= showTime %></p>
                <p>Number of Persons: <%= numPersons %></p>
                <p>Seats: <%= String.join(", ", assignedSeats) %></p>
                <p>Total Price: ₹<%= totalPrice %></p>
                <p>Remaining Balance: ₹<%= balance %></p>
                <a href="login.jsp" class="btn btn-primary">Go to Home</a>
            </div>
        </div>
    </div>
<%
    } else {
%>
    <div class="confirmation-message">
        <h2>Booking Failed</h2>
        <p>Insufficient balance to book the ticket(s).</p>
        <a href="selectShowTime.jsp?movie=<%= movie %>&theater=<%= theater %>&username=<%= username %>&posterPath=<%= posterPath %>" class="btn btn-primary">Go Back</a>
    </div>
<%
    }
%>
</div>

<!-- Footer -->
<div class="footer">
    <p>&copy; 2024 Paytm</p>
</div>

<!-- Bootstrap JS and dependencies -->
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>

</body>
</html>
