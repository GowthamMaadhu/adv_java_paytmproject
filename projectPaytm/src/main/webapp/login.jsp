<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login</title>
    <link rel='stylesheet' href='css/bootstrap.css'>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

    <style>
        body {
            display: flex;
            min-height: 100vh;
            margin: 0;
            flex-direction: column;
        }

        .header {
            background-color: #00B9F1;
            color: white;
            padding: 10px 0;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            z-index: 1000; /* Ensure header stays above other content */
        }

        .header .container {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0 20px; /* Optional: Add padding to the header content */
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
            margin-left: 10px;
        }

        .nav-options a:hover {
            background-color: #007B9A;
        }

        .content {
            display: flex;
            flex: 1;
        }

        .left-side {
            flex: 1;
            background-image: url('images/loginpaytm.png');
            background-size: cover;
            background-position: center;
        }

        .right-side {
            flex: 1;
            display: flex;
            justify-content: center;
            align-items: center;
            background-color: white;
            flex-direction: column;
            padding: 20px; /* Optional: Add padding for spacing */
        }

        .form-container {
            width: 500px;
            background-color: rgba(240, 240, 240, 0.9);
            padding: 20px;
            border-radius: 10px;
            border: 2px solid #000;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
            margin-top: 20px;
        }

        .welcome-message {
            font-size: 1.5em;
            font-weight: bold;
            text-align: center;
            margin-bottom: 20px;
            font-family: 'Arial', sans-serif;
        }

        .footer {
            background-color: #00B9F1;
            color: white;
            text-align: center;
            padding: 10px 0;
            width: 100%;
            position: fixed;
            bottom: 0;
            left: 0;
            z-index: 1000; /* Ensure footer stays above other content */
        }

        .right-side a {
            color: red; /* Set link color to red */
            text-decoration: underline;
        }

        .right-side a:hover {
            text-decoration: none; /* Remove underline on hover if needed */
        }
    </style>
</head>
<body>
    <div class="header">
        <div class="container">
            <div>
                <img src="images/Paytm_logo.jpg" width="100" height="30" alt="Paytm Logo">
            </div>
            <div class="nav-options">
                
                <a href="javascript:history.back()" class="btn btn-outline-light">Back</a>
            </div>
        </div>
    </div>

    <div class="content">
        <div class="left-side"></div>
        <div class="right-side">
            <div class="welcome-message">
                <p>Welcome to our secure login portal</p>
                <p>Your journey begins here, safe and sure....</p>
            </div>
            <div class="form-container">
                <h1 class="text-center">Login</h1>
                <form action="loginservelet" method="post">
                    <div class="form-group">
                        <i class="bi bi-person-fill"></i>
                        <label for="User">User:</label>
                        <input type="text" class="form-control" id="User" name="User" required>
                    </div>
                    <div class="form-group">
                        <i class="bi bi-key-fill"></i>
                        <label for="password">Password:</label>
                        <input type="password" class="form-control" id="password" name="password" required><br><br>
                    </div>
                    <button type="submit" class="btn btn-primary btn-block">Login</button>
                </form>
               
            </div>
            <p> <a href="register.jsp">Register here if you don't have an account</a></p>
        </div>
    </div>

    <div class="footer">
        <p>&copy; 2024 Paytm</p>
    </div>
</body>
</html>
