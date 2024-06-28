<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*, java.util.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Confirm Booking</title>
<link rel='stylesheet' href='css/bootstrap.min.css'>
<style>
    /* Custom CSS styles */
    body {
        font-family: Arial, sans-serif;
        background-color: #f8f9fa;
        margin: 0;
        padding: 0;
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
        background-color: #00B9F1; /* Match header color */
        padding: 10px 0;
    }
    .container {
        margin-top: 20px;
    }
    .booking-table {
        margin-top: 20px;
    }
    .table {
        width: 100%;
        margin-bottom: 1rem;
        color: #212529;
        border-collapse: collapse;
    }
    .table th,
    .table td {
        padding: .75rem;
        vertical-align: top;
        border-top: 1px solid #dee2e6;
    }
    .table thead th {
        vertical-align: bottom;
        border-bottom: 2px solid #dee2e6;
    }
    .table-striped tbody tr:nth-of-type(odd) {
        background-color: rgba(0, 123, 154, 0.1); /* Light striped background */
    }
</style>
</head>
<body>

<!-- Header -->
<div class="header">
    <div class="container">
        <img src="images/Paytm_logo.jpg" width="100" height="30" class="d-inline-block align-top" alt="Paytm Logo">
        <span class="header-title">Train Ticket Confirming</span>
        <div class="nav-options">
            <a href="#">Home</a>
            <a href="#">Profile</a>
            <a href="#">Bookings</a>
            <a href="javascript:history.back()" class="btn btn-outline-light">Back</a>
        </div>
    </div>
</div>

<!-- Main content -->
<div class="container mt-5">
    <h1>Confirm Booking</h1>
    
    <div class="booking-table">
        <table class="table table-striped">
            <thead>
                <tr>
                    <th>#</th>
                    <th>Passenger Name</th>
                    <th>Age</th>
                    <th>Coach Type</th>
                    <th>Seat Number</th>
                </tr>
            </thead>
            <tbody>
                <% 
                String username = request.getParameter("username");
                String journeydate = request.getParameter("journeydate");
                int trainid = Integer.parseInt(request.getParameter("trainid"));
                int slprice = Integer.parseInt(request.getParameter("slprice"));
                int acprice = Integer.parseInt(request.getParameter("acprice"));
                int formCount = Integer.parseInt(request.getParameter("formCount"));

                int totalPassengers = formCount;
                int totalPrice = 0;

                // Generate random seat numbers
                List<Integer> seatNumbers = new ArrayList<>();
                Random random = new Random();
                for (int i = 1; i <= formCount; i++) {
                    int seatNumber = random.nextInt(100) + 1; // Random seat number between 1 and 100
                    seatNumbers.add(seatNumber);
                }

                for (int i = 1; i <= formCount; i++) {
                    String name = request.getParameter("name" + i);
                    String age = request.getParameter("age" + i);
                    String coachType = request.getParameter("coach_type" + i);

                    if ("sl".equals(coachType)) {
                        totalPrice += slprice;
                    } else if ("ac".equals(coachType)) {
                        totalPrice += acprice;
                    }
                %>
                <tr>
                    <td><%= i %></td>
                    <td><%= name %></td>
                    <td><%= age %></td>
                    <td><%= coachType.toUpperCase() %></td>
                    <td><%= seatNumbers.get(i - 1) %></td>
                </tr>
                <% } %>
            </tbody>
        </table>

        <div class="total-info">
            <h3>Total Passengers: <%= totalPassengers %></h3>
            <h3>Total Price: <%= totalPrice %></h3>
        </div>

        <%
            Connection con = null;
            PreparedStatement stmt = null;
            ResultSet rs = null;
            int balance = 0;

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                con = DriverManager.getConnection("jdbc:mysql://localhost/paytmproject", "root", "Gowtham@123");

                String getBalanceQuery = "SELECT balance FROM userdata WHERE username=?";
                stmt = con.prepareStatement(getBalanceQuery);
                stmt.setString(1, username);
                rs = stmt.executeQuery();

                if (rs.next()) {
                    balance = rs.getInt("balance");
                }

                if (balance < totalPrice) {
                    out.println("<p style='color: red;'>Insufficient balance to make the booking.</p>");
                } else {
                    balance -= totalPrice;
                    session.setAttribute("balance", balance);

                    // Update the balance in the database
                    String updateBalanceQuery = "UPDATE userdata SET balance=? WHERE username=?";
                    stmt = con.prepareStatement(updateBalanceQuery);
                    stmt.setInt(1, balance);
                    stmt.setString(2, username);
                    stmt.executeUpdate();

                    // Insert booking details into the database
                    for (int i = 1; i <= formCount; i++) {
                        String name = request.getParameter("name" + i);
                        String age = request.getParameter("age" + i);
                        String coachType = request.getParameter("coach_type" + i);
                        int seatNumber = seatNumbers.get(i - 1);

                        String insertBookingQuery = "INSERT INTO bookings (username, trainid, passenger_name, age, coach_type, seat_number, journey_date) VALUES (?, ?, ?, ?, ?, ?, ?)";
                        stmt = con.prepareStatement(insertBookingQuery);
                        stmt.setString(1, username);
                        stmt.setInt(2, trainid);
                        stmt.setString(3, name);
                        stmt.setString(4, age);
                        stmt.setString(5, coachType);
                        stmt.setInt(6, seatNumber);
                        stmt.setString(7, journeydate);
                        stmt.executeUpdate();

                        // Update seat availability
                        if ("sl".equals(coachType)) {
                            String updateSLSeatsQuery = "UPDATE trains SET slseats_available = slseats_available - 1 WHERE id = ?";
                            stmt = con.prepareStatement(updateSLSeatsQuery);
                            stmt.setInt(1, trainid);
                            stmt.executeUpdate();
                        } else if ("ac".equals(coachType)) {
                            String updateACSeatsQuery = "UPDATE trains SET acseats_available = acseats_available - 1 WHERE id = ?";
                            stmt = con.prepareStatement(updateACSeatsQuery);
                            stmt.setInt(1, trainid);
                            stmt.executeUpdate();
                        }
                    }

                    out.println("<p style='color: green;'>Booking successfully completed!</p>");
                    out.println("<h3>Updated Balance: " + balance + "</h3>");
                }
            } catch (Exception e) {
                e.printStackTrace();
                out.println("<p style='color: red;'>An error occurred: " + e.getMessage() + "</p>");
            } finally {
                if (rs != null) try { rs.close(); } catch (Exception e) { /* ignored */ }
                if (stmt != null) try { stmt.close(); } catch (Exception e) { /* ignored */ }
                if (con != null) try { con.close(); } catch (Exception e) { /* ignored */ }
            }
        %>
    </div>
</div>

<!-- Footer -->
<div class="footer">
    <p>&copy; 2024 Paytm</p>
</div>

</body>
</html>
