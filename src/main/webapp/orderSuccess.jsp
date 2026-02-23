<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!doctype html>
<html>
<head>
    <title>MIRZA | Success</title>
    <style>
        body { background: #000; color: #fff; font-family: sans-serif; text-align: center; padding-top: 200px; }
        .success-icon { font-size: 50px; color: #c5a059; margin-bottom: 20px; }
        a { color: #fff; text-decoration: underline; font-size: 0.8rem; }
    </style>
</head>
<body>
    <div class="success-icon">✓</div>
    <h1 style="font-weight:300; letter-spacing:5px;">ORDER PLACED</h1>
    <p style="color:#666; margin-bottom:40px;">Order ID: #<%= request.getParameter("id") %></p>
    <p>Your luxury objects are being prepared for shipment.</p>
    <br>
    <a href="index.jsp">Return to Archive</a>
</body>
</html>