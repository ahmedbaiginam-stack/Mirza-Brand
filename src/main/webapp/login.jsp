<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!doctype html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <title>MIRZA | Sign In</title>
    <style>
        :root {
            --bg: #000000; --fg: #ffffff; --accent: #c5a059; --line: rgba(255,255,255,0.1);
            --font-main: 'Inter', sans-serif;
        }
        body { background: var(--bg); color: var(--fg); font-family: var(--font-main); display: flex; align-items: center; justify-content: center; height: 100vh; margin: 0; }
        
        .auth-container { width: 100%; max-width: 400px; padding: 60px; border: 1px solid var(--line); text-align: center; background: #050505; }
        .logo { font-size: 2rem; letter-spacing: 8px; margin-bottom: 40px; font-weight: 700; cursor: pointer; }
        
        .form-group { margin-bottom: 25px; text-align: left; }
        .form-group label { display: block; font-size: 0.6rem; letter-spacing: 2px; text-transform: uppercase; margin-bottom: 10px; color: var(--accent); }
        
        input { 
            width: 100%; background: transparent; border: none; border-bottom: 1px solid var(--line); 
            color: #fff; padding: 12px 0; font-size: 0.9rem; outline: none; transition: 0.3s;
        }
        input:focus { border-color: var(--accent); }
        
        .btn-submit { 
            width: 100%; padding: 18px; background: var(--fg); color: #000; border: none; 
            font-size: 0.75rem; font-weight: 700; letter-spacing: 3px; cursor: pointer; 
            text-transform: uppercase; margin-top: 20px; transition: 0.3s;
        }
        .btn-submit:hover { background: var(--accent); color: #fff; }
        
        .footer-link { margin-top: 30px; display: block; color: #444; font-size: 0.7rem; text-decoration: none; letter-spacing: 1px; }
        .footer-link:hover { color: var(--fg); }

        .status-msg { font-size: 0.7rem; margin-bottom: 25px; letter-spacing: 1px; padding: 10px; }
        .success { color: var(--accent); border: 1px solid var(--accent); }
        .error { color: #ff4444; border: 1px solid #ff4444; }
    </style>
</head>
<body>

    <div class="auth-container">
        <div class="logo" onclick="window.location.href='index.jsp'">MIRZA</div>

        <% if ("1".equals(request.getParameter("success"))) { %>
            <div class="status-msg success">ACCOUNT CREATED. PLEASE SIGN IN.</div>
        <% } %>
        
        <% if ("invalid".equals(request.getParameter("error"))) { %>
            <div class="status-msg error">INVALID EMAIL OR PASSWORD.</div>
        <% } %>

        <form action="login" method="POST">
            <div class="form-group">
                <label>Email Address</label>
                <input type="email" name="email" required>
            </div>
            
            <div class="form-group">
                <label>Password</label>
                <input type="password" name="password" required>
            </div>

            <button type="submit" class="btn-submit">Sign In</button>
        </form>

        <a href="signup.jsp" class="footer-link">NOT A MEMBER? JOIN THE ATELIER</a>
    </div>

</body>
</html>