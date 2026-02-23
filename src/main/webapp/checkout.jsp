<%@ page session="true" %>
<!DOCTYPE html>
<html>
<head>
    <title>MIRZA | Atelier Checkout</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600&display=swap" rel="stylesheet">
    <style>
        :root { --accent: #c5a059; --bg: #000; }
        body { background: var(--bg); color: #fff; font-family: 'Inter', sans-serif; display: flex; justify-content: center; align-items: center; min-height: 100vh; margin: 0; }
        .checkout-card { width: 400px; border: 1px solid rgba(255,255,255,0.1); padding: 40px; text-align: center; }
        .qr-box { background: #fff; padding: 15px; width: 220px; height: 220px; margin: 25px auto; border-radius: 4px; }
        .qr-box img { width: 100%; height: 100%; }
        .btn-pay { width: 100%; padding: 15px; background: none; border: 1px solid var(--accent); color: var(--accent); cursor: pointer; text-transform: uppercase; letter-spacing: 2px; transition: 0.3s; margin-top: 15px; }
        .btn-pay:hover { background: var(--accent); color: #000; }
        .total-amount { font-size: 2rem; margin: 10px 0; font-weight: 600; }
    </style>
</head>
<body>
    <div class="checkout-card">
        <span style="letter-spacing: 4px; color: var(--accent); font-size: 0.7rem;">SECURE CHECKOUT</span>
        <div class="total-amount" id="checkoutDisplay">$0.00</div>
        
        <p style="font-size: 0.7rem; color: #666; margin-bottom: 20px;">SCAN QR FOR PHONEPE / UPI</p>
        <div class="qr-box">
            <img src="https://api.qrserver.com/v1/create-qr-code/?size=200x200&data=MIRZE-ATELIER-PAY" alt="Payment QR">
        </div>

        <form action="completeOrder" method="POST">
            <button type="submit" class="btn-pay">I Have Paid via UPI</button>
            <button type="button" class="btn-pay" style="border-color: #333; color: #666;" onclick="history.back()">Back to Bag</button>
        </form>
    </div>

    <script>
        // Retrieve total from URL or Session
        const urlParams = new URLSearchParams(window.location.search);
        const total = urlParams.get('amount') || "0.00";
        document.getElementById('checkoutDisplay').innerText = "$" + total;
    </script>
</body>
</html>