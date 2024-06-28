<%@ page import="java.sql.*, java.util.*, java.time.*, java.time.format.*,java.time.temporal.ChronoUnit" %>
<%@ page import="java.util.Random" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Confirm Booking</title>
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
        .card {
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            border: none;
            border-radius: 10px;
        }
        .card-header {
            background-color: #007B9A;
            color: white;
            font-size: 1.5rem;
            text-align: center;
            border-top-left-radius: 10px;
            border-top-right-radius: 10px;
        }
        .card-body {
            padding: 20px;
        }
        .btn-primary {
            background-color: #00B9F1;
            border: none;
        }
        .btn-primary:hover {
            background-color: #007B9A;
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
        .tick-icon {
            width: 100px;
            height: 100px;
            margin: 0 auto;
            animation: scale 0.5s ease-in-out;
        }
        @keyframes scale {
            0% {
                transform: scale(0);
            }
            100% {
                transform: scale(1);
            }
        }
    </style>
</head>
<body>

<!-- Header -->
<div class="header">
    <div class="container">
        <div>
            <img src="images/Paytm_logo.jpg" width="100" height="30" alt="Paytm Logo">
            Confirm Booking
        </div>
        <div class="nav-options">
           <a href="login.jsp">LogOut</a>
            <a href="javascript:history.back()" class="btn btn-outline-light">Back</a>
        </div>
    </div>
</div>

<div class="container">
    <div class="card mt-4">
        <div class="card-header">
            Booking Confirmation
        </div>
        <div class="card-body">
            <%
                String hotelname = request.getParameter("hotelname");
                String username = request.getParameter("username");
                String guestName = request.getParameter("guestName");
                LocalDate checkInDate = LocalDate.parse(request.getParameter("checkInDate"));
                LocalDate checkOutDate = LocalDate.parse(request.getParameter("checkOutDate"));
                int guests = Integer.parseInt(request.getParameter("guests"));
                int balance = (Integer) session.getAttribute("balance");
                

                // Calculate booking duration
                long bookingDuration = ChronoUnit.DAYS.between(checkInDate, checkOutDate);

                // Assuming you have connection established earlier
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection con=DriverManager.getConnection("jdbc:mysql://localhost/paytmproject","root","Gowtham@123");
                String getPriceQuery = "SELECT price FROM hotelbookings WHERE hotelname=?";
                PreparedStatement priceStmt = con.prepareStatement(getPriceQuery);
                priceStmt.setString(1, hotelname);
                ResultSet priceRs = priceStmt.executeQuery();
                int price = 0;
                if (priceRs.next()) {
                    price = priceRs.getInt("price");
                }

                // Calculate total booking cost
                int totalCost = price * guests * (int) bookingDuration;
                if (totalCost <= balance) {

                    // Update user's balance
                    String updateBalanceQuery = "UPDATE userdata SET balance=balance-? WHERE username=?";
                    PreparedStatement updateBalanceStmt = con.prepareStatement(updateBalanceQuery);
                    updateBalanceStmt.setInt(1, totalCost);
                    updateBalanceStmt.setString(2, username);
                    updateBalanceStmt.executeUpdate();
            %>
            
            <h1>Booking Confirmed</h1>
            <p>Your booking for <%= hotelname %> has been confirmed.</p>
            <p>Total Cost: <%= totalCost %></p>
            <p>Thank you for booking with us!</p>

            <% } else {
                    out.println("Invalid funds!");
                }

                // Save booking history
                String saveBookingQuery = "INSERT INTO hotelbookinghistory (username, hotelname, guestname, checkindate, checkoutdate, guests, totalcost, transactionid) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
                PreparedStatement saveBookingStmt = con.prepareStatement(saveBookingQuery);
                saveBookingStmt.setString(1, username);
                saveBookingStmt.setString(2, hotelname);
                saveBookingStmt.setString(3, guestName);
                saveBookingStmt.setString(4, checkInDate.toString());
                saveBookingStmt.setString(5, checkOutDate.toString());
                saveBookingStmt.setInt(6, guests);
                saveBookingStmt.setInt(7, totalCost);
               //saveBookingStmt.setString(8, transactionID);
                
                // Generate random transaction ID
                Random rand = new Random();
                int transactionID = rand.nextInt(1000000000); // Generate a 9-digit random number
                saveBookingStmt.setInt(8, transactionID);

                saveBookingStmt.executeUpdate();
            %>

            <div id="tickAnimation" class="text-center mt-4">
                <!-- Tick icon will be dynamically inserted here using JavaScript -->
            </div>
        </div>
    </div>
</div>

<!-- Success Modal -->
<div class="modal fade" id="successModal" tabindex="-1" role="dialog" aria-labelledby="successModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="successModalLabel">Booking Confirmed</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <p>Your booking for <%= hotelname %> has been confirmed.</p>
                <p>Total Cost: <%= totalCost %></p>
                <p>Transaction ID: <%= transactionID %></p>
                <p>Thank you for booking with us!</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary" data-dismiss="modal">Close</button>
            </div>
        </div>
    </div>
</div>

<!-- Footer -->
<div class="footer">
    <p>&copy; 2024 Paytm</p>
</div>

<!-- Bootstrap JS and dependencies -->
<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.9.2/dist/umd/popper.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>

<script>
    // JavaScript to show success modal upon successful booking confirmation
    $(document).ready(function() {
        <% if (totalCost <= balance) { %>
            $('#successModal').modal('show');
        <% } %>
    });
</script>

</body>
</html>
