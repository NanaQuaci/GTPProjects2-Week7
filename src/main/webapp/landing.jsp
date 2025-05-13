<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Welcome | Task Management System</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter&display=swap" rel="stylesheet">
    <style>
        body {
            margin: 0;
            padding: 0;
            font-family: 'Inter', sans-serif;
            background: linear-gradient(to right, #eef2f3, #8e9eab);
            display: flex;
            align-items: center;
            justify-content: center;
            height: 100vh;
            color: #333;
        }

        .landing-container {
            text-align: center;
            background: white;
            padding: 40px;
            border-radius: 12px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
        }

        .landing-container h1 {
            margin-bottom: 10px;
            font-size: 32px;
        }

        .landing-container p {
            font-size: 16px;
            color: #555;
            margin-bottom: 30px;
        }

        .btn-primary {
            background-color: #007bff;
            color: white;
            border: none;
            padding: 12px 24px;
            font-size: 16px;
            border-radius: 6px;
            cursor: pointer;
            text-decoration: none;
            transition: background-color 0.3s ease;
        }

        .btn-primary:hover {
            background-color: #0056b3;
        }

        .logo {
            width: 80px;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>

<div class="landing-container">
    <img src="https://img.icons8.com/?size=512&id=GxmaUBcke4oO&format=png" class="logo" alt="Task Management Icon"/>
    <h1>Welcome to Task Management System</h1>
    <p>Simplify your task tracking, stay organized, and improve productivity.</p>
    <a href="tasks" class="btn-primary">View Tasks</a>
</div>

</body>
</html>
