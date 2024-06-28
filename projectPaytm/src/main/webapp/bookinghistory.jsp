<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Booking History</title>
    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <!-- Custom CSS -->
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f8f9fa;
            margin: 0;
            padding: 0;
        }
        .container {
            padding: 20px;
        }
        .booking-section {
            margin-bottom: 30px;
        }
        .booking-header {
            background-color: #343a40;
            color: white;
            padding: 10px;
            margin-bottom: 10px;
        }
        .booking-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 10px;
        }
        .booking-table th, .booking-table td {
            padding: 8px;
            text-align: left;
            border-bottom: 1px solid #dee2e6;
        }
        .booking-table thead {
            background-color: #343a40;
            color: white;
        }
        .booking-table tbody tr:nth-child(odd) {
            background-color: #f2f2f2;
        }
        .booking-table tbody tr:hover {
            background-color: #e9ecef;
        }
        .header, .footer {
            background-color: #00aaff;
            color: white;
            padding: 10px 0;
            text-align: center;
        }
        .header .container {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .header .logo {
            display: flex;
            align-items: center;
        }
        .header .logo img {
            height: 40px;
        }
        .header .nav {
            display: flex;
            gap: 20px;
            margin-left: auto;
        }
        .header .nav a {
            color: white;
            text-decoration: none;
        }
        .back-button a {
            color: white;
            text-decoration: none;
            padding:20px;
        }
    </style>
</head>
<body>
    <div class="header">
        <div class="container">
            <div class="logo">
                <img src="images/Paytm_logo.jpg" alt="Paytm Logo">
            </div>
            <div class="nav">
                <a href="loginSuccess.jsp">Home</a>
                
                <a href="login.jsp">Logout</a>
            </div>
            <div class="back-button">
                <a href="javascript:history.back()">Back</a>
            </div>
        </div>
    </div>

    <div class="container">
        <h1>Booking History</h1>
        
        <!-- Get the username from request attribute -->
        <c:set var="username" value="${requestScope.username}" />

        <!-- Movie Bookings -->
        <div class="booking-section">
            <div class="booking-header">Movie Bookings</div>
            <table class="booking-table">
                <thead>
                    <tr>
                        <th>Booking ID</th>
                        <th>Movie Name</th>
                        <th>Theater_Name</th>
                        <th>show_Time</th>
                        <th>ticket_price</th>
                        <th>seats</th>
                        <th>no.persons</th>
                        <th>totalprice</th>
                    </tr>
                </thead>
                <tbody>
                    <sql:setDataSource var="db" driver="com.mysql.cj.jdbc.Driver"
                        url="jdbc:mysql://localhost/paytmproject"
                        user="root" password="Gowtham@123" />

                    <sql:query dataSource="${db}" var="movieBookings">
                        SELECT * FROM moviebookings WHERE username = ?;
                        <sql:param value="${username}" />
                    </sql:query>

                    <c:forEach var="movieBooking" items="${movieBookings.rows}">
                        <tr>
                            <td>${movieBooking.booking_id}</td>
                            <td>${movieBooking.movie_name}</td>
                            <td>${movieBooking.theater_name}</td>
                            <td>${movieBooking.show_time}</td>
                            <td>${movieBooking.ticket_price}</td>
                            <td>${movieBooking.seats}</td>
                            <td>${movieBooking.num_persons}</td>
                            <td>${movieBooking.total_price}</td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>

        <!-- Hotel Bookings -->
        <div class="booking-section">
            <div class="booking-header">Hotel Bookings</div>
            <table class="booking-table">
                <thead>
                    <tr>
                        <th>Booking ID</th>
                        <th>Hotel Name</th>
                        <th>Guest Name</th>
                        <th>Check-in Date</th>
                        <th>Check-out Date</th>
                        <th>Guests</th>
                        <th>Total Cost</th>
                        <th>Transaction ID</th>
                    </tr>
                </thead>
                <tbody>
                    <sql:query dataSource="${db}" var="hotelBookings">
                        SELECT * FROM hotelbookinghistory WHERE username = ?;
                        <sql:param value="${username}" />
                    </sql:query>

                    <c:forEach var="hotelBooking" items="${hotelBookings.rows}">
                        <tr>
                            <td>${hotelBooking.booking_id}</td>
                            <td>${hotelBooking.hotelname}</td>
                            <td>${hotelBooking.guestname}</td>
                            <td>${hotelBooking.checkindate}</td>
                            <td>${hotelBooking.checkoutdate}</td>
                            <td>${hotelBooking.guests}</td>
                            <td>${hotelBooking.totalcost}</td>
                            <td>${hotelBooking.transactionid}</td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>

        <!-- Train Bookings -->
        <div class="booking-section">
            <div class="booking-header">Train Bookings</div>
            <table class="booking-table">
                <thead>
                    <tr>
                        <th>Booking ID</th>
                        <th>Train Name</th>
                        <th>Passenger Name</th>
                        <th>Age</th>
                        <th>Coach Type</th>
                        <th>Seat Number</th>
                        <th>Journey Date</th>
                    </tr>
                </thead>
                <tbody>
                    <sql:query dataSource="${db}" var="trainBookings">
                        SELECT * FROM bookings WHERE username = ?;
                        <sql:param value="${username}" />
                    </sql:query>

                    <c:forEach var="trainBooking" items="${trainBookings.rows}">
                        <tr>
                            <td>${trainBooking.id}</td>
                            <td>${trainBooking.trainid}</td>
                            <td>${trainBooking.passenger_name}</td>
                            <td>${trainBooking.age}</td>
                            <td>${trainBooking.coach_type}</td>
                            <td>${trainBooking.seat_number}</td>
                            <td>${trainBooking.journey_date}</td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>

        <!-- Bus Bookings -->
        <div class="booking-section">
            <div class="booking-header">Bus Bookings</div>
            <table class="booking-table">
                <thead>
                    <tr>
                        <th>Booking ID</th>
                        <th>Bus Number</th>
                        <th>Passenger Name</th>
                        <th>Passenger Age</th>
                        <th>Starting Point</th>
                        <th>Dropping Point</th>
                        <th>Seat Number</th>
                    </tr>
                </thead>
                <tbody>
                    <sql:query dataSource="${db}" var="busBookings">
                        SELECT * FROM busbookings WHERE username = ?;
                        <sql:param value="${username}" />
                    </sql:query>

                    <c:forEach var="busBooking" items="${busBookings.rows}">
                        <tr>
                            <td>${busBooking.id}</td>
                            <td>${busBooking.bus_number}</td>
                            <td>${busBooking.passenger_name}</td>
                            <td>${busBooking.passenger_age}</td>
                            <td>${busBooking.starting_point}</td>
                            <td>${busBooking.dropping_point}</td>
                            <td>${busBooking.seat_no}</td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>

    <div class="footer">
        <p>&copy; 2024 Paytm. All rights reserved.</p>
    </div>
</body>
</html>
