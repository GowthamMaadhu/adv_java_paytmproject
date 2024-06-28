<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.sql.Connection, java.sql.DriverManager, java.util.Random, java.util.HashSet, java.util.Set" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Booking Confirmation</title>
    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f8f9fa;
            margin: 0;
            padding: 0;
            display: flex;
            flex-direction: column;
            min-height: 100vh;
        }
        .header, .footer {
            background-color: #00B9F1;
            color: white;
            text-align: center;
            padding: 10px 0;
        }
        .container {
            flex: 1;
            margin-top: 20px;
        }
        .table {
            margin-top: 20px;
            border-collapse: collapse;
            width: 100%;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }
        .table th, .table td {
            padding: 8px;
            text-align: left;
            border-bottom: 1px solid #dee2e6;
        }
        .table thead {
            background-color: #343a40;
            color: white;
        }
        .table tbody tr:nth-child(odd) {
            background-color: #f2f2f2;
        }
        .table tbody tr:hover {
            background-color: #e9ecef;
        }
        .footer {
            margin-top: auto;
            text-align: center;
            background-color: #343a40;
            color: white;
            padding: 10px 0;
        }
        .alert {
            margin-top: 20px;
        }
        .happy-journey {
            font-size: 24px;
            font-weight: bold;
            color: #00B9F1;
            text-align: center;
            margin-top: 20px;
        }
        .slideshow-container {
            max-width: 1000px;
            position: relative;
            margin: auto;
            margin-top: 20px;
        }
        .mySlides {
            display: none;
            width: 100%;
        }
        .prev, .next {
            cursor: pointer;
            position: absolute;
            top: 50%;
            width: auto;
            padding: 16px;
            margin-top: -22px;
            color: white;
            font-weight: bold;
            font-size: 18px;
            transition: 0.6s ease;
            border-radius: 0 3px 3px 0;
            background-color: rgba(0, 0, 0, 0.5);
        }
        .next {
            right: 0;
            border-radius: 3px 0 0 3px;
        }
        .prev:hover, .next:hover {
            background-color: rgba(0, 0, 0, 0.8);
        }
        .text {
            color: #f2f2f2;
            font-size: 15px;
            padding: 8px 12px;
            position: absolute;
            bottom: 8px;
            width: 100%;
            text-align: center;
        }
        .dots {
            text-align: center;
            margin-top: 20px;
        }
        .dot {
            cursor: pointer;
            height: 15px;
            width: 15px;
            margin: 0 2px;
            background-color: #bbb;
            border-radius: 50%;
            display: inline-block;
            transition: background-color 0.6s ease;
        }
        .active, .dot:hover {
            background-color: #717171;
        }
    </style>
</head>
<body>
<!-- Header -->
<div class="header">
    <h1>Bus Booking Confirmation</h1>
</div>

<div class="container">
<%
    String username = request.getParameter("username");
    String busNumber = request.getParameter("busNumber");
    String busId = request.getParameter("busId");
    int ticketPrice = Integer.parseInt(request.getParameter("ticketPrice"));
    int balance = Integer.parseInt(request.getParameter("balance"));
    String[] passengerNames = request.getParameterValues("passengerName[]");
    String[] passengerAges = request.getParameterValues("passengerAge[]");
    String[] passengerStarts = request.getParameterValues("passengerStart[]");
    String[] passengerDrops = request.getParameterValues("passengerDrop[]");

    int totalPassengers = passengerNames.length;
    int totalPrice = totalPassengers * ticketPrice;

    Random random = new Random();
    long bookingId = Math.abs(random.nextLong() % 1000000000000L);  // Generate a random 12-digit number

    // Generate unique seat numbers
    Set<Integer> seatNumbersSet = new HashSet<>();
    while (seatNumbersSet.size() < totalPassengers) {
        seatNumbersSet.add(random.nextInt(220) + 1);
    }
    Integer[] seatNumbers = seatNumbersSet.toArray(new Integer[0]);

    Connection con = null;
    PreparedStatement updateBalanceStmt = null;
    PreparedStatement insertBookingStmt = null;
    PreparedStatement updateSeatsStmt = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        con = DriverManager.getConnection("jdbc:mysql://localhost/paytmproject", "root", "Gowtham@123");

        // Update user balance
        String updateBalanceQuery = "UPDATE userdata SET balance = ? WHERE username = ?";
        updateBalanceStmt = con.prepareStatement(updateBalanceQuery);
        updateBalanceStmt.setInt(1, balance - totalPrice);
        updateBalanceStmt.setString(2, username);
        int balanceUpdateCount = updateBalanceStmt.executeUpdate();

        if (balanceUpdateCount > 0) {
            // Insert booking details
            String insertBookingQuery = "INSERT INTO busbookings (booking_id, username, bus_number, passenger_name, passenger_age, starting_point, dropping_point, seat_no) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
            insertBookingStmt = con.prepareStatement(insertBookingQuery);

            for (int i = 0; i < totalPassengers; i++) {
                insertBookingStmt.setLong(1, bookingId);
                insertBookingStmt.setString(2, username);
                insertBookingStmt.setString(3, busNumber);
                insertBookingStmt.setString(4, passengerNames[i]);
                insertBookingStmt.setInt(5, Integer.parseInt(passengerAges[i]));
                insertBookingStmt.setString(6, passengerStarts[i]);
                insertBookingStmt.setString(7, passengerDrops[i]);
                insertBookingStmt.setInt(8, seatNumbers[i]);
                insertBookingStmt.addBatch();
            }

            int[] bookingUpdateCounts = insertBookingStmt.executeBatch();

            // Update bus seats availability
            String updateSeatsQuery = "UPDATE buses SET seats_availability = seats_availability - ? WHERE bus_number = ?";
            updateSeatsStmt = con.prepareStatement(updateSeatsQuery);
            updateSeatsStmt.setInt(1, totalPassengers);
            updateSeatsStmt.setString(2, busNumber);
            int seatsUpdateCount = updateSeatsStmt.executeUpdate();

            if (seatsUpdateCount > 0) {
%>
                <div class='alert alert-success' role='alert'>
                    <h4 class='alert-heading'>Booking Confirmed!</h4>
                    <p>Your booking has been successfully confirmed.</p>
                    <hr>
                    <p class='mb-0'>Thank you for booking with us, <%= username %>.</p>
                </div>
                <div class="happy-journey">
                    <p>Have a <span style="color: #00B9F1; font-size: 36px;">Happy Journey</span>!</p>
                </div>
                <table class="table">
                    <thead>
                        <tr>
                            <th>Booking ID</th>
                            <th>Passenger Name</th>
                            <th>Passenger Age</th>
                            <th>Starting Point</th>
                            <th>Dropping Point</th>
                            <th>Seat Number</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            for (int i = 0; i < totalPassengers; i++) {
                        %>
                        <tr>
                            <td><%= bookingId %></td>
                            <td><%= passengerNames[i] %></td>
                            <td><%= passengerAges[i] %></td>
                            <td><%= passengerStarts[i] %></td>
                            <td><%= passengerDrops[i] %></td>
                            <td><%= seatNumbers[i] %></td>
                        </tr>
                        <%
                            }
                        %>
                    </tbody>
                </table>
                <!-- Slideshow -->
                <div class="slideshow-container">
                    <div class="mySlides fade">
                        <img src="images/bus1.jpg" style="width:100%">
                    </div>
                    <div class="mySlides fade">
                        <img src="images/bus2.jpg" style="width:100%">
                    </div>
                    <div class="mySlides fade">
                        <img src="images/bus3.jpg" style="width:100%">
                    </div>
                    <div class="mySlides fade">
                        <img src="images/bus4.jpg" style="width:100%">
                    </div>
                    <a class="prev" onclick="plusSlides(-1)">&#10094;</a>
                    <a class="next" onclick="plusSlides(1)">&#10095;</a>
                </div>
                <div style="text-align:center" class="dots">
                    <span class="dot" onclick="currentSlide(1)"></span>
                    <span class="dot" onclick="currentSlide(2)"></span>
                    <span class="dot" onclick="currentSlide(3)"></span>
                    <span class="dot" onclick="currentSlide(4)"></span>
                </div>
<%
            } else {
                throw new Exception("Failed to update seats availability.");
            }
        } else {
            throw new Exception("Failed to update user balance.");
        }
    } catch (Exception e) {
        e.printStackTrace();
%>
        <div class='alert alert-danger' role='alert'>
            <h4 class='alert-heading'>Booking Failed</h4>
            <p>There was an error processing your booking. Please try again later.</p>
            <hr>
            <p class='mb-0'>Error: <%= e.getMessage() %></p>
        </div>
<%
    } finally {
        try {
            if (updateBalanceStmt != null) updateBalanceStmt.close();
            if (insertBookingStmt != null) insertBookingStmt.close();
            if (updateSeatsStmt != null) updateSeatsStmt.close();
            if (con != null) con.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
%>
</div>

<!-- Footer -->
<div class="footer">
    <p>&copy; 2024 Paytm</p>
</div>

<!-- jQuery, Popper.js, and Bootstrap JS -->
<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.9.2/dist/umd/popper.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>

<!-- Slideshow Script -->
<script>
    var slideIndex = 1;
    showSlides(slideIndex);

    function plusSlides(n) {
        showSlides(slideIndex += n);
    }

    function currentSlide(n) {
        showSlides(slideIndex = n);
    }

    function showSlides(n) {
        var i;
        var slides = document.getElementsByClassName("mySlides");
        var dots = document.getElementsByClassName("dot");
        if (n > slides.length) {slideIndex = 1}
        if (n < 1) {slideIndex = slides.length}
        for (i = 0; i < slides.length; i++) {
            slides[i].style.display = "none";
        }
        for (i = 0; i < dots.length; i++) {
            dots[i].className = dots[i].className.replace(" active", "");
        }
        slides[slideIndex-1].style.display = "block";
        dots[slideIndex-1].className += " active";
    }
</script>
</body>
</html>
