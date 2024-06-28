<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="java.sql.*,java.sql.Connection,java.sql.DriverManager" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Train Booking</title>
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
        .nav-options {
            display: flex;
            gap: 20px; /* Adjust the gap between navigation links */
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
            background-color: #007B9A;
            color: white;
            text-align: center;
            padding: 10px 0;
            position: fixed;
            bottom: 0;
            width: 100%;
        }
        .table-container {
            margin-top: 20px;
        }
    </style>
</head>
<body>

<!-- Header -->
<div class="header">
    <div class="container">
        <div>
            <img src="images/Paytm_logo.jpg" width="100" height="30" alt="Paytm Logo">
            Train Bookings
        </div>
        <div class="nav-options">
            <a href="#">Home</a>
            <a href="#">Profile</a>
            <a href="#">Bookings</a>
            <!-- Add a Back button to navigate back -->
            <a href="#" onclick="history.back();" class="btn btn-secondary">Back</a>
        </div>
    </div>
</div>

<div class="container">
    <h1>Booking Details</h1>

    <div class="table-container">
        <table class="table table-striped">
            <thead>
                <tr>
                    <th>Train Number</th>
                    <th>Train Name</th>
                    <th>Train ID</th>
                    <th>SL Price</th>
                    <th>AC Price</th>
                </tr>
            </thead>
            <tbody>
                <%
                    String username = request.getParameter("username");
                    String trainname = request.getParameter("name");
                    String number = request.getParameter("number");
                    String journeydate = request.getParameter("journeydate");
                    int trainid = Integer.parseInt(request.getParameter("trainId"));

                    Class.forName("com.mysql.cj.jdbc.Driver");
                    Connection con = DriverManager.getConnection("jdbc:mysql://localhost/paytmproject", "root", "Gowtham@123");

                    String getBalanceQuery = "SELECT balance FROM userdata WHERE username=?";
                    PreparedStatement stmt = con.prepareStatement(getBalanceQuery);
                    stmt.setString(1, username);
                    ResultSet rs = stmt.executeQuery();
                    int balance = 0;
                    if (rs.next()) {
                        balance = rs.getInt("balance");
                        session.setAttribute("balance", balance);
                    }

                    String quary2 = "SELECT slprice, acprice FROM trains WHERE id=?";
                    PreparedStatement priceStmt = con.prepareStatement(quary2);
                    priceStmt.setInt(1, trainid);
                    ResultSet priceRs = priceStmt.executeQuery();
                    int slprice = 0;
                    int acprice = 0;
                    if (priceRs.next()) {
                        slprice = priceRs.getInt("slprice");
                        acprice = priceRs.getInt("acprice");
                    }
                %>
                <tr>
                    <td><%= number %></td>
                    <td><%= trainname %></td>
                    <td><%= trainid %></td>
                    <td><%= slprice %></td>
                    <td><%= acprice %></td>
                </tr>
            </tbody>
        </table>
    </div>

    <div class="container mt-5">
        <form action="trainconforming.jsp" class="needs-validation">
            <input type="hidden" name="formCount" value="1" id="formCount">
            <input type="hidden" name="username" value="<%= username %>">
            <input type="hidden" name="trainid" value="<%= trainid %>">
            <input type="hidden" name="slprice" value="<%= slprice %>">
            <input type="hidden" name="acprice" value="<%= acprice %>">
            <input type="hidden" name="journeydate" value="<%= journeydate %>">

            <div id="form1" class="border p-3 mb-3">
                <h2>Passenger Details: 1</h2>
                <div class="form-group">
                    <label for="name1">Passenger Name:</label>
                    <input type="text" class="form-control" id="name1" name="name1" required>
                    <div class="invalid-feedback">Please provide a name.</div>
                </div>
                <div class="form-group">
                    <label for="age1">Age:</label>
                    <input type="number" class="form-control" id="age1" name="age1" required>
                    <div class="invalid-feedback">Please provide an age.</div>
                </div>
                <h3>Coach Type:</h3>
                <div class="form-check">
                    <input type="radio" class="form-check-input" id="sl1" name="coach_type1" value="sl" required>
                    <label class="form-check-label" for="sl1">SL</label>
                </div>
                <div class="form-check">
                    <input type="radio" class="form-check-input" id="ac1" name="coach_type1" value="ac" required>
                    <label class="form-check-label" for="ac1">AC</label>
                </div>
            </div>

            <button type="button" class="btn btn-primary mb-3" onclick="addForm()">Add Passenger</button>

            <c:if test="<%= balance < slprice %>">
                <p style="color: red;">Insufficient balance to make the booking.</p>
            </c:if>

            <button type="submit" class="btn btn-success">Confirm Booking</button>
        </form>
    </div>
</div>
<br><br><br><br><br><br><br><br><br><br><br><br>
<!-- Footer -->
<div class="footer">
    <p>&copy; 2024 Paytm</p>
</div>

<!-- Bootstrap JS and dependencies -->
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>

<script>
    function addForm() {
        var formCount = parseInt(document.getElementById('formCount').value);
        formCount++; // Increment the form counter

        // Create a new form section with incremented ID
        var newForm = document.createElement('div');
        newForm.id = 'form' + formCount;
        newForm.className = 'border p-3 mb-3';
        newForm.innerHTML = '<h2>Passenger Details: ' + formCount + '</h2>' +
                            '<div class="form-group">' +
                                '<label for="name' + formCount + '">Passenger Name:</label>' +
                                '<input type="text" class="form-control" id="name' + formCount + '" name="name' + formCount + '" required>' +
                                '<div class="invalid-feedback">Please provide a name.</div>' +
                            '</div>' +
                            '<div class="form-group">' +
                                '<label for="age' + formCount + '">Age:</label>' +
                                '<input type="number" class="form-control" id="age' + formCount + '" name="age' + formCount + '" required>' +
                                '<div class="invalid-feedback">Please provide an age.</div>' +
                            '</div>' +
                            '<h3>Coach Type:</h3>' +
                            '<div class="form-check">' +
                                '<input type="radio" class="form-check-input" id="sl' + formCount + '" name="coach_type' + formCount + '" value="sl" required>' +
                                '<label class="form-check-label" for="sl' + formCount + '">SL</label>' +
                            '</div>' +
                            '<div class="form-check">' +
                                '<input type="radio" class="form-check-input" id="ac' + formCount + '" name="coach_type' + formCount + '" value="ac" required>' +
                                '<label class="form-check-label" for="ac' + formCount + '">AC</label>' +
                            '</div>';
        document.getElementById('form1').appendChild(newForm);
        document.getElementById('formCount').value = formCount; // Update the form counter value
    }
</script>

</body>
</html>
