<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Atelier & Careers | MIRZA</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600&family=Playfair+Display:ital,wght@0,700;1,300&display=swap" rel="stylesheet">

    <style>
        /* 1. Global Variables */
        :root {
            --bg: #000000; 
            --fg: #ffffff; 
            --accent: #c5a059; 
            --line: rgba(255,255,255,0.15);
            --font-main: 'Inter', sans-serif; 
            --font-serif: 'Playfair Display', serif;
        }

        /* 2. Reset & Base Styles */
        * { margin: 0; padding: 0; box-sizing: border-box; }
        
        body {
            background-color: var(--bg);
            color: var(--fg);
            font-family: var(--font-main);
            line-height: 1.6;
            overflow-x: hidden;
            -webkit-font-smoothing: antialiased;
        }

        /* 3. Header Styling */
        header {
            position: fixed; top: 0; width: 100%; z-index: 1000;
            padding: 30px 50px; display: flex; justify-content: space-between;
            align-items: center; background: linear-gradient(to bottom, rgba(0,0,0,0.8), transparent);
        }
        .logo { font-family: var(--font-serif); font-size: 1.5rem; letter-spacing: 5px; text-decoration: none; color: #fff; }
        nav a { color: #fff; text-decoration: none; margin-left: 30px; font-size: 0.7rem; letter-spacing: 2px; text-transform: uppercase; }

        /* 4. Reveal Animation */
        .reveal { opacity: 0; transform: translateY(40px); transition: all 1.2s cubic-bezier(0.16, 1, 0.3, 1); }
        .reveal.active { opacity: 1; transform: translateY(0); }

        /* 5. Overview Section */
        .atelier-overview { padding: 200px 50px 100px; border-bottom: 1px solid var(--line); }
        .overview-container { display: flex; gap: 80px; align-items: center; max-width: 1400px; margin: 0 auto; }
        .overview-content { flex: 1; }
        .overview-visual { flex: 1.2; }
        .section-tagline { font-size: 0.7rem; letter-spacing: 5px; color: var(--accent); margin-bottom: 25px; text-transform: uppercase; }
        .monolith-title { font-family: var(--font-serif); font-size: 4rem; line-height: 1.1; margin-bottom: 40px; text-transform: uppercase; }
        .italic-light { font-style: italic; font-weight: 300; }
        .atelier-text { font-size: 1rem; color: #888; line-height: 1.8; margin-bottom: 60px; max-width: 550px; }
        .atelier-stats { display: flex; gap: 60px; border-top: 1px solid var(--line); padding-top: 40px; }
        .stat-item span { display: block; font-size: 0.6rem; letter-spacing: 3px; color: #444; margin-bottom: 10px; }
        .stat-item strong { font-size: 1.5rem; font-weight: 400; font-family: var(--font-serif); }
        .visual-box { width: 100%; height: 600px; background: #111; overflow: hidden; border: 1px solid var(--line); }
        .visual-box img { width: 100%; height: 100%; object-fit: cover; filter: grayscale(1); transition: 1.5s; }
        .visual-box:hover img { filter: grayscale(0); transform: scale(1.05); }

        /* 6. Careers Section */
        .careers-section { padding: 120px 0 0; background: #050505; }
        .section-title { font-family: var(--font-serif); letter-spacing: 4px; font-weight: 400; margin-left: 50px; margin-bottom: 40px; }
        .careers-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(400px, 1fr)); border-top: 1px solid var(--line); }
        .job-card { padding: 80px 50px; border-right: 1px solid var(--line); border-bottom: 1px solid var(--line); transition: 0.5s; }
        .job-card:hover { background: #000; }
        .job-location { font-size: 0.65rem; color: var(--accent); letter-spacing: 4px; display: block; margin-bottom: 20px; }
        .job-title { font-family: var(--font-serif); font-size: 2rem; margin-bottom: 25px; }
        .job-desc { font-size: 0.9rem; color: #666; margin-bottom: 40px; }
        .btn-apply { display: inline-block; padding: 15px 40px; border: 1px solid var(--line); color: #fff; text-decoration: none; font-size: 0.7rem; letter-spacing: 3px; text-transform: uppercase; transition: 0.4s; cursor: pointer; }
        .btn-apply:hover { background: #fff; color: #000; }

        /* 7. Application Drawer */
        .app-drawer { position: fixed; top: 0; right: -100%; width: 500px; height: 100%; background: #000; z-index: 3000; padding: 60px 40px; border-left: 1px solid var(--line); transition: 0.6s cubic-bezier(0.16, 1, 0.3, 1); }
        .app-drawer.active { right: 0; }
        .drawer-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 50px; }
        .close-drawer { cursor: pointer; font-size: 0.7rem; letter-spacing: 2px; color: var(--accent); }
        .input-group { margin-bottom: 30px; }
        .input-group label { display: block; font-size: 0.6rem; color: var(--accent); letter-spacing: 2px; margin-bottom: 10px; }
        .input-group input, .input-group textarea { width: 100%; background: none; border: none; border-bottom: 1px solid #333; color: #fff; padding: 10px 0; outline: none; }
        .btn-submit-app { width: 100%; padding: 20px; background: var(--accent); border: none; font-weight: 700; letter-spacing: 3px; cursor: pointer; }

        /* 8. Footer Styling */
        footer { padding: 100px 50px; border-top: 1px solid var(--line); background: #000; }
        .footer-grid { display: grid; grid-template-columns: 2fr 1fr 1fr; gap: 50px; max-width: 1400px; margin: 0 auto; }
        .footer-logo { font-family: var(--font-serif); font-size: 2rem; margin-bottom: 20px; }
        .footer-link { display: block; color: #666; text-decoration: none; font-size: 0.8rem; margin-bottom: 10px; transition: 0.3s; }
        .footer-link:hover { color: var(--accent); }
        .copyright { margin-top: 80px; font-size: 0.6rem; color: #333; letter-spacing: 2px; text-align: center; }
    </style>
</head>
<body>

    <header>
        <a href="index.jsp" class="logo">MIRZE</a>
        <nav>
            <a href="index.jsp">Home</a>
            <a href="about.jsp" style="color: var(--accent);">Atelier</a>
            <a href="shop.jsp">Archive</a>
            <a href="cart.jsp">Cart</a>
        </nav>
    </header>

    <section class="atelier-overview reveal">
        <div class="overview-container">
            <div class="overview-content">
                <h2 class="section-tagline">THE PHILOSOPHY</h2>
                <h1 class="monolith-title">Defining the <br>Modern <span class="italic-light">Archive</span></h1>
                <p class="atelier-text">
                    Founded in 2026, MIRZA is a global lifestyle atelier operating at the intersection of technical utility and avant-garde luxury. 
                </p>
                <div class="atelier-stats">
                    <div class="stat-item"><span>Est.</span><strong>2026</strong></div>
                    <div class="stat-item"><span>Global</span><strong>Ateliers</strong></div>
                </div>
            </div>
            <div class="overview-visual">
                <div class="visual-box">
                    <img src="${pageContext.request.contextPath}/image/ww.jpg" alt="Atelier">
                </div>
            </div>
        </div>
    </section>

    <section class="careers-section reveal" id="careers">
        <h2 class="section-title">JOIN THE ATELIER</h2>
        <div class="careers-grid">
            <div class="job-card">
                <span class="job-location">VARANASI // REMOTE</span>
                <h3 class="job-title">Textile Engineer</h3>
                <p class="job-desc">Developing heavy-gauge denim for the 0.5 Release.</p>
                <div class="btn-apply" onclick="toggleDrawer()">Inquire</div>
            </div>
            <div class="job-card">
                <span class="job-location">BENGALURU // HYBRID</span>
                <h3 class="job-title">Creative Developer</h3>
                <p class="job-desc">Building luxury digital commerce experiences.</p>
                <div class="btn-apply" onclick="toggleDrawer()">Inquire</div>
            </div>
        </div>
    </section>

    <footer>
        <div class="footer-grid">
            <div>
                <div class="footer-logo">MIRZA</div>
                <p style="color: #444; font-size: 0.8rem; max-width: 300px;">Structural permanence and material science. Engineered for the modern human silhouette.</p>
            </div>
            <div>
                <h4 style="font-size: 0.7rem; letter-spacing: 2px; margin-bottom: 20px;">EXPLORE</h4>
                <a href="#" class="footer-link">Archive</a>
                <a href="#" class="footer-link">Atelier</a>
                <a href="#" class="footer-link">Sizing</a>
            </div>
            <div>
                <h4 style="font-size: 0.7rem; letter-spacing: 2px; margin-bottom: 20px;">CONTACT</h4>
                <a href="#" class="footer-link">Instagram</a>
                <a href="#" class="footer-link">Email</a>
            </div>
        </div>
        <div class="copyright">© 2026 MIRZA ATELIER. ALL RIGHTS RESERVED.</div>
    </footer>

    <div class="app-drawer" id="appDrawer">
        <div class="drawer-header">
            <h3>APPLICATION</h3>
            <span class="close-drawer" onclick="toggleDrawer()">CLOSE</span>
        </div>
        <form action="submitApplication" method="POST">
            <div class="input-group"><label>NAME</label><input type="text" name="name" required></div>
            <div class="input-group"><label>EMAIL</label><input type="email" name="email" required></div>
            <div class="input-group"><label>PORTFOLIO</label><input type="url" name="portfolio"></div>
            <button type="submit" class="btn-submit-app">SEND</button>
        </form>
    </div>

    <script>
        // Reveal Logic
        const observer = new IntersectionObserver((entries) => {
            entries.forEach(entry => { if (entry.isIntersecting) entry.target.classList.add('active'); });
        }, { threshold: 0.1 });
        document.querySelectorAll('.reveal').forEach(el => observer.observe(el));

        // Drawer Logic
        function toggleDrawer() {
            document.getElementById('appDrawer').classList.toggle('active');
        }
    </script>
</body>
</html>