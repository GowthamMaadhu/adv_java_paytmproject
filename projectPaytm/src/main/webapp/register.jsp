<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="ISO-8859-1">
    <title>Paytm Registration</title>
    <link rel='stylesheet' href='css/bootstrap.css'>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

     <style>
        body {
            background-image: url('images/signup.png'); /* Replace with your image path */
            background-size: auto 100%; /* Auto width and full height */
            background-repeat: no-repeat; /* Do not repeat the background image */
            background-position: left center; /* Position the background image to the left and center vertically */
            margin: 0;
            font-family: Arial, sans-serif;
        }

        .header {
            background-color: #00B9F1;
            color: white;
            padding: 15px 0;
            text-align: center;
        }

        .footer {
            background-color: #00B9F1;
            color: white;
            text-align: center;
            padding: 10px;
            position: fixed;
            bottom: 0;
            left: 0;
            width: 100%;
        }

        .form-container {
            width: 1065px; /* Set a specific width */
            margin: 0 auto; /* Center the form horizontally */
            padding: 20px;
            background-color: #fff; /* White background */
            border: 1px solid #ccc; /* Border */
            border-radius: 10px; /* Rounded corners */
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1); /* Drop shadow */
            margin-left: calc(50% - 650px); /* Adjust margin left to center and expand leftwards */
        }

        .form-control {
            border: 2px solid rgba(0, 0, 0, .2);
        }

         .btn-primary {
            background: #0ef;
            border: none;
            color: #081b29;
            font-weight: 600;
            width: 200px; /* Set a specific width for the button */
            margin: 0 auto; /* Center the button */
            display: block; /* Center the button */
        }

        .btn-primary:hover {
            background: #081b29;
            color: #fff;
            border: 2px solid #0ef;
        }

        .signin-link {
            text-align: center;
            margin-top: 20px;
        }

        .signin-link a {
            color: #0ef;
        }

        .signin-link a:hover {
            text-decoration: underline;
        }

        .form-check-input {
            margin-right: 5px;
        }

        .register-message {
            font-family: 'Times New Roman', Times, serif; /* Change font family */
            font-size: 24px; /* Change font size */
            color: #007B9A; /* Change font color */
           /* color:black;*/
            font-weight: bold;
        }
       
    </style>
</head>
<body>
<header class="header">
    <img src="images/Paytm_logo.jpg" width="150" height="50" alt="Paytm Logo">
</header>

<section>
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-6"></div> <!-- Empty column for spacing -->
            <div class="col-md-6">
                <div class="form-container">
                    <h1 class="register-message text-center my-4">Paytm, where futures ignite,<br> Register today, step into the light....</h1>
                    <form action="registerservelet" method="post" onsubmit="return validateForm()">

                        <div class="form-group row">
                            <label for="username" class="col-sm-4 col-form-label"><i class="bi bi-person-fill"></i><b> Username:</b></label>
                            <div class="col-sm-8">
                                <input type="text" class="form-control" id="username" name="username" placeholder="Enter the username" required>
                            </div>
                        </div>

                        <div class="form-group row">
                            <label for="password" class="col-sm-4 col-form-label"><i class="bi bi-key-fill"></i><b> Password:</b></label>
                            <div class="col-sm-8">
                                <input type="password" class="form-control" id="password" name="password" placeholder="Enter the password" required>
                            </div>
                        </div>

                        <div class="form-group row">
                            <label for="mobilenumber" class="col-sm-4 col-form-label"><i class="bi bi-telephone-fill"></i><b> Mobile Number:</b></label>
                            <div class="col-sm-8">
                                <input type="text" class="form-control" id="mobilenumber" name="mobilenumber" placeholder="Enter the phone number" required>
                            </div>
                        </div>

                        <div class="form-group row">
                            <label for="email" class="col-sm-4 col-form-label"><i class="bi bi-envelope-open-fill"></i><b> Email:</b></label>
                            <div class="col-sm-8">
                                <input type="email" class="form-control" id="email" name="email" placeholder="Enter the email" required>
                            </div>
                        </div>

                        <div class="form-group row">
                            <label for="accno" class="col-sm-4 col-form-label"><i class="bi bi-safe"></i><b> Account Number:</b></label>
                            <div class="col-sm-8">
                                <input type="text" class="form-control" id="accno" name="accno" placeholder="Enter the account number" required>
                            </div>
                        </div>

                        <div class="form-group row">
                            <label for="name" class="col-sm-4 col-form-label"><i class="bi bi-person-vcard-fill"></i><b> Account Holder Name:</b></label>
                            <div class="col-sm-8">
                                <input type="text" class="form-control" id="name" name="name" placeholder="Enter the account holder name" required>
                            </div>
                        </div>

                        <div class="form-group row">
                            <label for="isfc" class="col-sm-4 col-form-label"><i class="bi bi-upc-scan"></i><b> IFSC Code:</b></label>
                            <div class="col-sm-8">
                                <input type="text" class="form-control" id="isfc" name="isfc" placeholder="Enter the IFSC code" required>
                            </div>
                        </div>

                        <div class="form-group row">
                            <label for="branch" class="col-sm-4 col-form-label"><i class="bi bi-bank"></i><b> Branch:</b></label>
                            <div class="col-sm-8">
                                <input type="text" class="form-control" id="branch" name="branch" placeholder="Enter the branch" required>
                            </div>
                        </div>

                        <div class="form-group row">
                            <label class="col-sm-4 col-form-label"><b>Gender:</b></label>
                            <div class="col-sm-8">
                                <div class="form-check form-check-inline">
                                    <input class="form-check-input" type="radio" id="male" name="gender" value="Male" required>
                                    <label class="form-check-label" for="male">Male</label>
                                </div>
                                <div class="form-check form-check-inline">
                                    <input class="form-check-input" type="radio" id="female" name="gender" value="Female" required>
                                    <label class="form-check-label" for="female">Female</label>
                                </div>
                            </div>
                        </div>

                        <div class="form-group row">
                            <div class="col-sm-4"></div>
                            <div class="col-sm-8">
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" id="terms" name="terms" required>
                                    <label class="form-check-label" for="terms">I agree to the terms and conditions</label>
                                </div>
                            </div>
                        </div>

                        <div class="form-group row">
                            <div class="col-sm-12">
                                <button type="submit" class="btn btn-primary btn-block">Register</button>
                            </div>
                        </div>

                    </form>
                    <div class="signin-link">
                        <p>Already have an account? <a href="login.jsp">Sign in</a></p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<footer class="footer">
    <p>&copy; 2024 Paytm. All rights reserved.</p>
</footer>

<script>
    function validateForm() {
        var username = document.getElementById("username").value;
        var password = document.getElementById("password").value;
        var mobilenumber = document.getElementById("mobilenumber").value;
        var email = document.getElementById("email").value;
        var accno = document.getElementById("accno").value;
        var holder = document.getElementById("name").value;
        var isfc = document.getElementById("isfc").value;
        var branch = document.getElementById("branch").value;

        if (username === "" || password === "" || mobilenumber === "" || email === "" || accno === "" || holder === "" || isfc === "" || branch === "") {
            alert("Please fill in all required fields.");
            return false;
        }
        return true;
    }
</script>

</body>
</html>
