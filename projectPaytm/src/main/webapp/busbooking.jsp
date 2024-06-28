<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.sql.Connection,java.sql.DriverManager" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bus Booking</title>
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
        .booking-form {
            background-color: #ffffff;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }
        .booking-form label {
            font-weight: bold;
        }
        .booking-form input[type=text], 
        .booking-form input[type=email], 
        .booking-form input[type=number] {
            width: 100%;
            padding: 10px;
            margin-bottom: 15px;
            border: 1px solid #ddd;
            border-radius: 4px;
        }
        .booking-form .passenger-details {
            border: 1px solid #ddd;
            padding: 10px;
            margin-bottom: 15px;
            border-radius: 4px;
        }
        .booking-form .passenger-details label {
            font-weight: normal;
        }
        .booking-form .passenger-details .form-row {
            display: flex;
            align-items: center;
            margin-bottom: 10px;
        }
        .booking-form .passenger-details .form-row .form-group {
            flex: 1;
            margin-right: 10px;
        }
        .booking-form .passenger-details .form-row .form-group:last-child {
            margin-right: 0;
        }
        .booking-form .passenger-details .remove-passenger {
            color: white;
            cursor: pointer;
            margin-left: 10px;
        }
        .booking-form .passenger-details .add-passenger {
            margin-top: 10px;
            cursor: pointer;
        }
        .booking-form button {
            padding: 10px 20px;
        }
        .btn-sm {
            padding: 0.25rem 0.5rem;
            font-size: 0.875rem;
            line-height: 1.5;
            border-radius: 0.2rem;
        }
        #totalPrice {
            font-size: 1.25rem;
            font-weight: bold;
            color: #28a745;
        }
    </style>
</head>
<body>
<%
    String username = (String) request.getParameter("username");
    String busNumber = (String) request.getParameter("busNumber");
    String busId = (String) request.getParameter("busId");
    String busName = (String) request.getParameter("busName");
    out.println(username);

    // Initialize variables to store bus details
    String busNameDb = "";
    String pickup = "";
    String dropPoint = "";
    Time departureTime = null;
    Time arrivalTime = null;
    int seatsAvailability = 0;
    String busType = "";
    int ticketPrice = 0;
    int userBalance = 0;

    // Fetch bus details from the database
    Connection con = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        con = DriverManager.getConnection("jdbc:mysql://localhost/paytmproject", "root", "Gowtham@123");

        String sql = "SELECT * FROM buses WHERE bus_number = ?";
        stmt = con.prepareStatement(sql);
        stmt.setString(1, busNumber);
        rs = stmt.executeQuery();

        if (rs.next()) {
            busNameDb = rs.getString("busname");
            pickup = rs.getString("pickup");
            dropPoint = rs.getString("drop_point");
            departureTime = rs.getTime("departure_time");
            arrivalTime = rs.getTime("arrival_time");
            seatsAvailability = rs.getInt("seats_availability");
            busType = rs.getString("bus_type");
            ticketPrice = rs.getInt("price");
        }
        // Fetch user balance
        String getBalanceQuery = "SELECT balance FROM userdata WHERE username=?";
        PreparedStatement stmt1 = con.prepareStatement(getBalanceQuery);
        stmt1.setString(1, username);
        ResultSet rs1 = stmt1.executeQuery();
        if (rs1.next()) {
            userBalance = rs1.getInt("balance");
            session.setAttribute("balance", userBalance);
            out.println(userBalance);
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
%>
<!-- Header -->
<div class="header">
    <div class="container">
        <img src="images/Paytm_logo.jpg" width="100" height="30" class="d-inline-block align-top" alt="Paytm Logo">
        <h1>Bus Booking</h1>
        <div class="nav-options">
            <a href="#">Home</a>
            <a href="#">Profile</a>
            <a href="#">Bookings</a>
            <a href="javascript:history.back()" class="btn btn-outline-light">Back</a>
        </div>
    </div>
</div>

<div class="container">
    <div class="bus-details">
        <h2>Bus Details - <%= busNameDb %></h2>
        <table class="table table-bordered">
            <tr>
                <th>Bus Name</th>
                <td><%= busNameDb %></td>
            </tr>
            <tr>
                <th>Pickup</th>
                <td><%= pickup %></td>
            </tr>
            <tr>
                <th>Drop Point</th>
                <td><%= dropPoint %></td>
            </tr>
            <tr>
                <th>Departure Time</th>
                <td><%= departureTime %></td>
            </tr>
            <tr>
                <th>Arrival Time</th>
                <td><%= arrivalTime %></td>
            </tr>
            <tr>
                <th>Seats Availability</th>
                <td><%= seatsAvailability %></td>
            </tr>
            <tr>
                <th>Bus Type</th>
                <td><%= busType %></td>
            </tr>
            <tr>
                <th>Ticket Price</th>
                <td id="ticketPrice"><%= ticketPrice %></td>
            </tr>
        </table>
    </div>

    <div class="booking-form">
        <h2>Book Bus - <%= busName %></h2>
        <form action="busconfirming.jsp" method="post" id="bookingForm">
            <input type="hidden" name="username" value="<%= username %>">
            <input type="hidden" name="busNumber" value="<%= busNumber %>">
            <input type="hidden" name="busId" value="<%= busId %>">
            <input type="hidden" name="ticketPrice" value="<%= ticketPrice %>">
            <input type="hidden" name="balance" value="<%= userBalance %>">

            <!-- Passenger Details -->
            <div class="passenger-details" id="passengerDetails">
                <h3>Passenger Details</h3>
                <div class="form-row">
                    <div class="form-group">
                        <label for="passengerName1">Passenger Name</label>
                        <input type="text" class="form-control" id="passengerName1" name="passengerName[]" required>
                    </div>
                    <div class="form-group">
                        <label for="passengerAge1">Age</label>
                        <input type="text" class="form-control" id="passengerAge1" name="passengerAge[]" required>
                    </div>
                    <div class="form-group">
                        <label for="passengerStart1">Starting Point</label>
                        <input type="text" class="form-control" id="passengerStart1" name="passengerStart[]" required>
                    </div>
                    <div class="form-group">
                        <label for="passengerDrop1">Dropping Point</label>
                        <input type="text" class="form-control" id="passengerDrop1" name="passengerDrop[]" required>
                    </div>
                    <button type="button" class="btn btn-sm btn-danger remove-passenger" onclick="removePassenger(this)">Remove</button>
                </div>
                <div id="additionalPassengers"></div>
                <div class="add-passenger">
                    <button type="button" class="btn btn-sm btn-primary" onclick="addPassenger()">Add Passenger</button>
                </div>
            </div>
            <!-- Display total price -->
            <p id="totalPrice">Total Price: ₹<span id="totalPriceValue">0</span></p>
            <%-- Script to calculate total price and show/hide booking button based on balance --%>
            <script>
                let passengerCount = 1;

                function addPassenger() {
                    passengerCount++;
                    const newPassengerHtml = `
                        <div class="passenger-details" id="passenger${passengerCount}">
                            <div class="form-row">
                                <div class="form-group">
                                    <label for="passengerName${passengerCount}">Passenger Name</label>
                                    <input type="text" class="form-control" id="passengerName${passengerCount}" name="passengerName[]" required>
                                </div>
                                <div class="form-group">
                                    <label for="passengerAge${passengerCount}">Age</label>
                                    <input type="text" class="form-control" id="passengerAge${passengerCount}" name="passengerAge[]" required>
                                </div>
                                <div class="form-group">
                                    <label for="passengerStart${passengerCount}">Starting Point</label>
                                    <input type="text" class="form-control" id="passengerStart${passengerCount}" name="passengerStart[]" required>
                                </div>
                                <div class="form-group">
                                    <label for="passengerDrop${passengerCount}">Dropping Point</label>
                                    <input type="text" class="form-control" id="passengerDrop${passengerCount}" name="passengerDrop[]" required>
                                </div>
                                <button type="button" class="btn btn-sm btn-danger remove-passenger" onclick="removePassenger(this)">Remove</button>
                            </div>
                        </div>`;
                    document.getElementById('additionalPassengers').insertAdjacentHTML('beforeend', newPassengerHtml);
                    updateTotalPrice();
                }

                function removePassenger(button) {
                    button.closest('.passenger-details').remove();
                    updateTotalPrice();
                }

                function updateTotalPrice() {
                    const ticketPrice = parseInt(<%= ticketPrice %>);
                    const passengerForms = document.querySelectorAll('.passenger-details').length;
                    const totalPrice = ticketPrice * passengerForms;
                    const userBalance = parseInt(<%= userBalance %>);
                    const submitButton = document.querySelector('button[type="submit"]');
                    const insufficientFundsMessage = document.getElementById('insufficientFunds');
                    const totalPriceValue = document.getElementById('totalPriceValue');

                    totalPriceValue.textContent = totalPrice;

                    if (userBalance >= totalPrice) {
                        submitButton.style.display = 'block';
                        insufficientFundsMessage.style.display = 'none';
                    } else {
                        submitButton.style.display = 'none';
                        insufficientFundsMessage.style.display = 'block';
                    }
                }
                // Initial call to update total price on page load
                updateTotalPrice();
            </script>

            <p id="insufficientFunds" class="text-danger" style="display: none;">Insufficient balance to book this bus.</p>

            <!-- Submit button -->
            <button type="submit" class="btn btn-success">Confirm Booking</button>
        </form>
    </div>
</div>
<br><br><br><br>
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

</body>
</html>
