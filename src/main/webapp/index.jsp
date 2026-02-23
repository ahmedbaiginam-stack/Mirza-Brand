<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.model.User" %>
<%
    User appUser = (User) session.getAttribute("user");
    String role = (appUser != null) ? appUser.getRole() : "CUSTOMER";
    String userName = (appUser != null) ? appUser.getName() : "Guest";
%>
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width,initial-scale=1" />
  <title>MIRZA | Global Lifestyle Atelier</title>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600&family=Playfair+Display:wght@700&display=swap" rel="stylesheet">
  
  <style>
    :root {
      --bg: #000000; --fg: #ffffff; --accent: #c5a059; --line: rgba(255,255,255,0.15);
      --font-main: 'Inter', sans-serif; --font-serif: 'Playfair Display', serif;
    }
    
    /* Global & Scroll Settings */
    * { margin:0; padding:0; box-sizing:border-box; }
    html { scroll-behavior: smooth; background-color: #000; }
    body { background: var(--bg); color: var(--fg); font-family: var(--font-main); line-height: 1.6; overflow-x: hidden; }
    
    /* Hide scrollbar for Chrome, Safari and Opera */
    body::-webkit-scrollbar { display: none; }
    body { -ms-overflow-style: none; scrollbar-width: none; }

    /* Animation: Reveal on Scroll */
    .reveal { opacity: 0; transform: translateY(30px); transition: all 1s cubic-bezier(0.16, 1, 0.3, 1); }
    .reveal.active { opacity: 1; transform: translateY(0); }

    /* Navigation */
    header { position: fixed; top: 0; width: 100%; z-index: 1000; border-bottom: 1px solid var(--line); background: rgba(0,0,0,0.85); backdrop-filter: blur(15px); }
    nav { display: flex; justify-content: space-between; align-items: center; padding: 20px 50px; }
    .logo { font-family: var(--font-serif); font-size: 1.8rem; letter-spacing: 6px; font-weight: 700; text-transform: uppercase; cursor: pointer; }
    .nav-links { display: flex; gap: 40px; text-transform: uppercase; font-size: 0.7rem; letter-spacing: 2px; }
    .nav-links a, .nav-links span { cursor: pointer; color: var(--fg); text-decoration: none; transition: 0.3s; }
    .nav-links a:hover, .nav-links span:hover { color: var(--accent); }

    /* Horizontal Scroller Section */
    #categories { padding: 120px 0 60px; }
    .horizontal-scroller { 
        display: flex; gap: 30px; overflow-x: auto; padding: 20px 50px;
        scroll-snap-type: x mandatory; scrollbar-width: none; 
    }
    .horizontal-scroller::-webkit-scrollbar { display: none; }
    
    .category-item { 
        min-width: 350px; flex-shrink: 0; scroll-snap-align: start; 
        position: relative; cursor: pointer; overflow: hidden;
    }
    .img-wrapper { width: 100%; height: 450px; overflow: hidden; background: #111; }
    .img-wrapper img { width: 100%; height: 100%; object-fit: cover; transition: 1.2s cubic-bezier(0.16, 1, 0.3, 1); filter: grayscale(0.5); }
    .category-item:hover img { transform: scale(1.1); filter: grayscale(0); }
    .category-item span { 
        position: absolute; bottom: 30px; left: 30px; font-size: 0.8rem; 
        letter-spacing: 4px; font-weight: 600; text-shadow: 0 0 10px rgba(0,0,0,0.5); 
    }

    /* Filter Bar */
    .filter-bar { display: flex; justify-content: center; gap: 40px; padding: 25px; border-bottom: 1px solid var(--line); font-size: 0.65rem; letter-spacing: 3px; text-transform: uppercase; background: var(--bg); position: sticky; top: 80px; z-index: 900; }
    .filter-item { cursor: pointer; color: #666; transition: 0.3s; position: relative; }
    .filter-item.active, .filter-item:hover { color: #fff; }
    .filter-item.active::after { content: ''; position: absolute; bottom: -5px; left: 0; width: 100%; height: 1px; background: #fff; }

    /* Product Grid */
    .section-title { padding: 60px 50px 20px; font-size: 0.8rem; letter-spacing: 4px; text-transform: uppercase; color: var(--accent); border-bottom: 1px solid var(--line); }
    .product-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(350px, 1fr)); min-height: 400px; }
    .product-card { border-right: 1px solid var(--line); border-bottom: 1px solid var(--line); padding: 50px; transition: 0.4s; }
    .img-container { width: 100%; aspect-ratio: 4/5; background: #111; margin-bottom: 30px; overflow: hidden; }
    .img-container img { width: 100%; height: 100%; object-fit: cover; transition: 0.8s; }
    .product-card:hover { background: #0a0a0a; }

    /* Drawer */
    .drawer { position: fixed; top:0; right:-100%; width: 450px; height: 100%; background: #000; z-index: 2000; padding: 60px 40px; border-left: 1px solid var(--line); transition: 0.5s cubic-bezier(0.16, 1, 0.3, 1); }
    .drawer.active { right: 0; }

    /* Footer */
   footer {
    background: #050505; /* Slightly lighter than pure black for depth */
    padding: 100px 50px 40px;
    border-top: 1px solid var(--line);
}

.footer-top {
    text-align: center;
    margin-bottom: 80px;
}

.footer-cta h3 {
    font-family: var(--font-serif);
    font-size: 2.5rem;
    letter-spacing: 10px;
    margin-bottom: 15px;
}

.footer-cta p {
    font-size: 0.7rem;
    color: #888;
    letter-spacing: 2px;
    margin-bottom: 30px;
}

.footer-newsletter {
    display: flex;
    justify-content: center;
    max-width: 500px;
    margin: 0 auto;
    border-bottom: 1px solid var(--line);
}

.footer-newsletter input {
    background: none;
    border: none;
    color: white;
    padding: 15px;
    width: 100%;
    font-size: 0.7rem;
    letter-spacing: 2px;
}

.footer-newsletter button {
    background: none;
    border: none;
    color: var(--accent);
    cursor: pointer;
    font-size: 0.7rem;
    letter-spacing: 2px;
    font-weight: bold;
}

.footer-grid {
    display: grid;
    grid-template-columns: 1.5fr 1fr 1fr 1fr;
    gap: 40px;
    margin-bottom: 60px;
}

.footer-col h4 {
    font-size: 0.65rem;
    letter-spacing: 3px;
    color: var(--accent);
    margin-bottom: 25px;
}

.footer-col ul { list-style: none; }

.footer-col li { margin-bottom: 12px; }

.footer-col a {
    color: #888;
    text-decoration: none;
    font-size: 0.75rem;
    transition: 0.3s;
}

.footer-col a:hover {
    color: #fff;
    padding-left: 5px; /* Subtle slide effect on hover */
}

.footer-bottom {
    display: flex;
    justify-content: space-between;
    padding-top: 30px;
    border-top: 1px solid rgba(255,255,255,0.05);
    font-size: 0.55rem;
    letter-spacing: 2px;
    color: #444;
}

.brand-bio {
    font-size: 0.75rem;
    color: #666;
    margin: 20px 0;
    max-width: 250px;
}
/* Enhanced New Added Section */
.new-added-section { 
    height: 90vh; /* Taller for more impact */
    display: flex; 
    align-items: stretch;
    border-bottom: 1px solid var(--line); 
    margin-top: 80px;
    background: #050505;
}

.new-hero-text { 
    flex: 1; 
    padding: 0 10%; 
    display: flex; 
    flex-direction: column; 
    justify-content: center;
    border-right: 1px solid var(--line);
}

.new-hero-text h2 { 
    font-size: 0.7rem; 
    letter-spacing: 6px; 
    color: var(--accent); 
    margin-bottom: 25px;
    font-weight: 400;
}

.new-hero-text h1 { 
    font-family: var(--font-serif); 
    font-size: 5.5vw; 
    line-height: 0.9; 
    font-weight: 700;
    margin-bottom: 40px;
    text-transform: uppercase;
}

.new-hero-img { 
    flex: 1.4; 
    background: url('https://images.unsplash.com/photo-1539109136881-3be06109477a?q=80&w=1500') center/cover; 
    transition: transform 1.5s cubic-bezier(0.16, 1, 0.3, 1);
    cursor: crosshair;
}

/* Luxury Hover: Image zooms slightly and shifts focus */
.new-added-section:hover .new-hero-img {
    transform: scale(1.03);
}

/* Micro-interaction for the button */
.btn-monolith {
    width: 240px;
    padding: 18px;
    background: transparent;
    border: 1px solid var(--accent);
    color: var(--accent);
    text-transform: uppercase;
    font-size: 0.65rem;
    letter-spacing: 4px;
    cursor: pointer;
    transition: 0.5s ease;
    position: relative;
    overflow: hidden;
}

.btn-monolith:hover {
    color: #000;
    background: var(--accent);
    box-shadow: 0 10px 30px rgba(197, 160, 89, 0.2);
}
    .btn-buy { width: 100%; padding: 15px; background: none; border: 1px solid var(--fg); color: var(--fg); cursor: pointer; font-size: 0.7rem; letter-spacing: 2px; text-transform: uppercase; transition: 0.3s; }
    .btn-buy:hover { background: var(--fg); color: var(--bg); }
    /* Transition class for JS */
.fade-out {
    opacity: 0;
    transform: translateY(10px);
    transition: opacity 0.8s ease, transform 0.8s ease;
}

#heroImg {
    transition: background-image 1.2s cubic-bezier(0.4, 0, 0.2, 1);
}

.reveal-content {
    transition: opacity 0.8s ease, transform 0.8s ease;
}
/* Progress Bar for Slider */
.hero-progress-container {
    position: absolute;
    bottom: 0;
    left: 0;
    width: 100%;
    height: 4px;
    background: rgba(255,255,255,0.1);
    z-index: 10;
}

#heroProgressBar {
    height: 100%;
    width: 0%;
    background: var(--accent);
    transition: width 5s linear; /* Matches the 5sec interval */
}

/* Fix for broken image visibility */
#heroImg {
    background-size: cover;
    background-position: center;
    background-color: #111; /* Fallback color */
    transition: background-image 1.2s cubic-bezier(0.4, 0, 0.2, 1);
}


.hero-progress-container {
    position: absolute;
    bottom: 0;
    left: 0;
    width: 100%;
    height: 4px;
    background: rgba(255,255,255,0.1);
    z-index: 10;
}

#heroProgressBar {
    height: 100%;
    width: 0%;
    background: var(--accent);
    transition: width 5s linear;
}
.offer-section {
    position: relative;
    padding: 160px 50px; /* Increased padding for more breathing room */
    text-align: center;
    /* High-Contrast Gradient + Textured Fabric Background */
    background: linear-gradient(180deg, rgba(0,0,0,0.95) 0%, rgba(0,0,0,0.7) 50%, rgba(0,0,0,0.95) 100%), 
                url('./image/ww.');
    background-size: cover;
    background-position: center;
    background-attachment: fixed;
    border-top: 1px solid var(--line);
    border-bottom: 1px solid var(--line);
    color: #fff;
    overflow: hidden;
}

.offer-section h1 {
    font-family: var(--font-serif);
    font-size: 4.5rem; /* Larger for more impact */
    letter-spacing: 12px;
    text-transform: uppercase;
    margin-bottom: 20px;
    font-weight: 800;
    /* Text stroke for a hollow luxury effect */
    -webkit-text-stroke: 1px rgba(255,255,255,0.3);
    color: transparent;
    background: linear-gradient(to bottom, #fff, #888);
    -webkit-background-clip: text;
}

.offer-section p {
    font-size: 0.8rem;
    letter-spacing: 6px;
    color: #ffffff;
    opacity: 0.8;
    text-transform: uppercase;
    margin-bottom: 50px;
}

/* Updated Monolith Button Styling */
.offer-btn a {
    display: inline-block;
    padding: 20px 60px;
    background: #fff; /* White background for maximum pop */
    color: #000;
    text-decoration: none;
    letter-spacing: 5px;
    font-size: 0.75rem;
    font-weight: 900;
    text-transform: uppercase;
    transition: all 0.6s cubic-bezier(0.16, 1, 0.3, 1);
    border: 1px solid #fff;
}

.offer-btn a:hover {
    background: transparent;
    color: #fff;
    transform: scale(1.05);
    box-shadow: 0 0 40px rgba(255,255,255,0.1);
}

/* Film Grain Noise */
.noise-overlay {
    position: absolute; top: 0; left: 0; width: 100%; height: 100%;
    pointer-events: none; z-index: 5; opacity: 0.04;
    background: url('data:image/svg+xml,%3Csvg viewBox="0 0 200 200" xmlns="http://www.w3.org/2000/svg"%3E%3Cfilter id="noiseFilter"%3E%3CfeTurbulence type="fractalNoise" baseFrequency="0.8" numOctaves="3" stitchTiles="stitch"/%3E%3C/filter%3E%3Crect width="100%25" height="100%25" filter="url(%23noiseFilter)"/%3E%3C/svg%3E');
}

/* The Heavy Shutter Element */
.new-added-section { position: relative; overflow: hidden; }

.monolith-shutter {
    position: absolute; top: 0; right: 0; width: 58.33%; /* Covers just the image area (flex 1.4 ratio) */
    height: 100%; background: #000; z-index: 4;
    transform: scaleY(0); transform-origin: top;
    transition: transform 0.8s cubic-bezier(0.7, 0, 0.3, 1); /* Dramatic easing */
}

/* When active, it slides down. When removed, it slides up from the bottom */
.monolith-shutter.active { 
    transform: scaleY(1); 
    transform-origin: bottom; 
}
  </style>
</head>
<body>

  <header>
    <nav>
      <div class="nav-links">
        <span onclick="document.getElementById('productGrid').scrollIntoView()">Collection</span>
        <span><a href="about.jsp">About</a></span>
      </div>
      <div class="logo">MIRZA</div>
     <div class="nav-links">
    <% if (appUser == null) { %>
        <a href="login.jsp">Login</a>
        <a href="signup.jsp" style="color: var(--accent)">Join</a>
    <% } else { %>
        <% if ("ADMIN".equals(role)) { %>
    <a href="admin.jsp" class="nav-admin-btn">Atelier Dashboard</a>
	<% } %>
        
        <a href="account.jsp">Hi, <%= userName %></a>
        <a href="logout" style="color: var(--accent)">Logout</a>
    <% } %>
    <span onclick="toggleCart()" id="cartBtn">Bag (0)</span>
	</div>
    </nav>
  </header>
<section class="new-added-section reveal" id="heroSlider">
    <div class="new-hero-text">
        <div class="reveal-content">
            <h2 id="s-subtitle">NEW ADDED // RELEASE 0.4
            <div class="monolith-shutter" id="shutter">
            </div>
			<div class="noise-overlay"></div></h2>
            <h1 id="s-title">The <br><span style="font-style: italic; font-weight: 300;">Monolith</span><br>Archive</h1>
            <p id="s-desc" style="font-size: 0.85rem; letter-spacing: 1px; color: #888; margin-bottom: 40px; max-width: 400px;">
                A study in structural permanence. This collection introduces our bespoke heavy-gauge denim and cold-pressed hardware.
            </p>
            <button class="btn-monolith" onclick="updateFilter(null, 'new')">
                View Collection
            </button>
        </div>
    </div>
    <div class="new-hero-img" id="heroImg"></div>
</section>
  <section id="categories" class="reveal">
    <h2 class="section-title">THE ARCHIVE DEPARTMENTS</h2>

    <div class="horizontal-scroller">

        <div class="category-item" onclick="updateFilter(null, 'rajputana')">
            <div class="img-wrapper">
                <img src="./image/d (1).jpg" alt="Rajputana Denim">
            </div>
            <span>01. PUNE</span>
        </div>

        <div class="category-item" onclick="updateFilter(null, 'maharaja')">
            <div class="img-wrapper">
                <img src="./image/d (2).jpg" alt="Maharaja Edition">
            </div>
            <span>02. BENGULURU</span>
        </div>

        <div class="category-item" onclick="updateFilter(null, 'varanasi')">
            <div class="img-wrapper">
                <img src="./image/d (3).jpg" alt="Varanasi Craft">
            </div>
            <span>03. Mumbai</span>
        </div>

        <div class="category-item" onclick="updateFilter(null, 'kashmir')">
            <div class="img-wrapper">
                <img src="./image/d (4).jpg" alt="Kashmir Atelier">
            </div>
            <span>04. Hyderabad</span>
        </div>

		
        <div class="category-item" onclick="updateFilter(null, 'indus')">
            <div class="img-wrapper">
                <img src="./image/ww.jpg" alt="Indus Line">
            </div>
            <span>05. Belagavi</span>
        </div>

        <div class="category-item" onclick="updateFilter(null, 'indus')">
            <div class="img-wrapper">
                <img src="./image/d (5).jpg" alt="Indus Line">
            </div>
            <span>06. Delhi</span>
        </div>

    </div>
</section>
<div class="hero-progress-container">
    <div id="heroProgressBar"></div>
</div>

<section class="offer-section">

    <h1>Hurry! This Exclusive Offer Ends Soon</h1>
    <p>Don't miss out on our limited-edition collection. Once it's gone, it's gone forever!</p>

    <div class="countdown">
        <div class="time-box">
            <h2 id="days">00</h2>
            <span>DAYS</span>
        </div>
        <div class="time-box">
            <h2 id="hours">00</h2>
            <span>HOURS</span>
        </div>
        <div class="time-box">
            <h2 id="minutes">00</h2>
            <span>MINUTES</span>
        </div>
        <div class="time-box">
            <h2 id="seconds">00</h2>
            <span>SECONDS</span>
        </div>
    </div>

    <div class="offer-btn">
        <a href="#">Claim Your Deal</a>
    </div>

</section>
  <div class="filter-bar">
    <div class="filter-item active" onclick="updateFilter(this, 'all')">All Objects</div>
    <div class="filter-item" onclick="updateFilter(this, 'MEN')">Men</div>
    <div class="filter-item" onclick="updateFilter(this, 'WOMEN')">Women</div>
    <div class="filter-item" onclick="updateFilter(this, 'JACKET')">Jackets</div>
    <div class="filter-item" onclick="updateFilter(this, 'GOGGLE')">Eyewear</div>
    <div class="filter-item" onclick="updateFilter(this, 'WATCH')">Watches</div>
</div>

  <h2 class="section-title" id="gridTitle">Featured Objects</h2>
  <main class="product-grid reveal" id="productGrid"></main>

  <aside class="drawer" id="cartDrawer">
    <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom: 50px;">
        <h2 style="letter-spacing: 4px; font-size: 1.2rem;">YOUR BAG</h2>
        <span onclick="toggleCart()" style="cursor:pointer; color:var(--accent)">CLOSE</span>
    </div>
    <div id="cartItems"></div>
    <div style="position: absolute; bottom: 60px; left: 40px; right: 40px;">
        <p style="display:flex; justify-content:space-between; margin-bottom: 20px;">
            <span>TOTAL</span><span id="cartTotal">$0.00</span>
        </p>
        <button class="btn-buy" onclick="window.location.href='checkout.jsp'">Proceed to Checkout</button>
    </div>
  </aside>

  <footer class="reveal">
    <div class="footer-top">
        <div class="footer-cta">
            <h3>JOIN THE ARCHIVE</h3>
            <p>Subscribe to receive early access to new collections and atelier updates.</p>
            <form class="footer-newsletter">
                <input type="email" placeholder="YOUR EMAIL ADDRESS">
                <button type="submit">SUBSCRIBE</button>
            </form>
        </div>
    </div>

    <div class="footer-grid">
        <div class="footer-col">
            <div class="footer-logo">MIRZA</div>
            <p class="brand-bio">Defining the intersection of modern utility and timeless luxury. Established 2026.</p>
            <div class="social-icons">
                <a href="#">IG</a> <a href="#">TW</a> <a href="#">TK</a>
            </div>
        </div>
        <div class="footer-col">
            <h4>COLLECTIONS</h4>
            <ul>
                <li><a href="#">Ready to Wear</a></li>
                <li><a href="#">Horology</a></li>
                <li><a href="#">Bespoke Tailoring</a></li>
                <li><a href="#">Objects</a></li>
            </ul>
        </div>
        <div class="footer-col">
            <h4>ASSISTANCE</h4>
            <ul>
                <li><a href="#">Shipping & Returns</a></li>
                <li><a href="#">Sizing Guide</a></li>
                <li><a href="#">Care Instructions</a></li>
                <li><a href="#">Contact Atelier</a></li>
            </ul>
        </div>
        <div class="footer-col">
            <h4>LEGAL</h4>
            <ul>
                <li><a href="#">Privacy Policy</a></li>
                <li><a href="#">Terms of Service</a></li>
                <li><a href="#">Cookie Settings</a></li>
            </ul>
        </div>
    </div>

    <div class="footer-bottom">
        <span>&copy; 2026 MIRZA ATELIER. ALL RIGHTS RESERVED.</span>
        <span>GLOBAL SHIPPING AVAILABLE</span>
    </div>
</footer>

<script>

    var uRole = '<%= role %>';
	var ctx = '<%= request.getContextPath() %>';
    
    // Corrected Intersection Observer
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('active');
            }
        });
    }, { threshold: 0.1 });

    // Initialize Page
    window.addEventListener('load', () => {
        fetchProducts('all'); 
        resetProgressBar();
        heroInterval = setInterval(rotateHero, 5000);
        
        document.querySelectorAll('.reveal').forEach(el => observer.observe(el));
        
        const heroSection = document.getElementById('heroSlider');
        if(heroSection) {
            heroSection.addEventListener('mouseenter', () => clearInterval(heroInterval));
            heroSection.addEventListener('mouseleave', () => {
                heroInterval = setInterval(rotateHero, 5000);
                resetProgressBar();
            });
        }
    });
    

    // --- PRODUCT FETCHING LOGIC ---
    async function fetchProducts(category) {
    var container = document.getElementById('productGrid');
    container.style.opacity = "0.5";
    
    try {
        var url = ctx + '/getProducts' + (category !== 'all' ? '?category=' + category : '');
        var res = await fetch(url);
        var products = await res.json();
        
        var html = '';
        products.forEach(function(p) {
            // FIX: Remove the leading "./" if it exists and add the context path
            let cleanImgPath = p.img.startsWith('./') ? p.img.substring(2) : p.img;
            let fullImgUrl = ctx + '/' + cleanImgPath;

            html += '<article class="product-card reveal">';
            html += '  <div class="img-container"><img src="' + fullImgUrl + '" onerror="this.src=\'https://via.placeholder.com/400x500\'"></div>';
            html += '  <div class="product-info"><span>' + p.name + '</span><span>$' + p.price.toLocaleString() + '</span></div>';
            html += '  <button class="btn-buy" onclick="addToCart(' + p.id + ')">Add to Bag</button>';
            html += '</article>';
        });
        container.innerHTML = html;
        container.style.opacity = "1";
        
        document.querySelectorAll('.product-card').forEach(el => observer.observe(el));
    } catch(e) { 
        container.innerHTML = '<p style="padding:100px;">Archive unavailable.</p>'; 
    }
}
    // --- FILTER & CART LOGIC ---
    function updateFilter(el, cat) {
        if(el) {
            var items = document.querySelectorAll('.filter-item');
            items.forEach(i => i.classList.remove('active'));
            el.classList.add('active');
        }
        fetchProducts(cat);
        document.getElementById('gridTitle').scrollIntoView();
    }

    function toggleCart() { document.getElementById('cartDrawer').classList.toggle('active'); }

    async function updateCartUI() {
        try {
            var res = await fetch(ctx + '/getCartDetails');
            var data = await res.json();
            document.getElementById('cartBtn').innerText = 'Bag (' + data.count + ')';
            document.getElementById('cartTotal').innerText = '$' + data.total.toLocaleString();
            let html = '';
            data.items.forEach(i => {
                // Prepend context path for cart images if needed
                let cartImg = i.img.startsWith('./') ? i.img.replace('./', ctx + '/') : i.img;
                html += '<div class="cart-item" style="display:flex; gap:15px; margin-bottom: 20px;">' +
                        '<img src="'+cartImg+'" style="width:70px; height:90px; object-fit:cover;">' +
                        '<div><p style="font-size:0.8rem; text-transform:uppercase;">'+i.name+'</p>' +
                        '<p style="font-size:0.7rem; color:#888;">QTY: '+i.qty+'</p></div></div>';
            });
            document.getElementById('cartItems').innerHTML = html;
        } catch(e) { console.error("Cart update failed", e); }
    }

    // --- HERO SLIDER LOGIC ---
    const slides = [
    {
        subtitle: "NEW ADDED // RELEASE 0.4",
        title: "The <br><span class='italic-light'>Monolith</span><br>Archive",
        desc: "A study in structural permanence. Introducing bespoke heavy-gauge denim engineered for longevity.",
        img: ctx + "/image/slide (2).jpg"
    },
    {
        subtitle: "EDITORIAL // SPRING 2026",
        title: "Liquid <br><span class='italic-light'>Chrome</span><br>Series",
        desc: "Reflective surfaces meet avant-garde tailoring. Designed for statement silhouettes.",
        img: ctx + "/image/slide (2).jpg"
    },
    {
        subtitle: "ATELIER // LIMITED",
        title: "Obsidian <br><span class='italic-light'>Minimal</span><br>Utility",
        desc: "Functional silhouettes reimagined for the modern urban landscape.",
        img: ctx + "/image/slide (3).jpg"
    },
    {
        subtitle: "DROP 05 // EXCLUSIVE",
        title: "Silent <br><span class='italic-light'>Velocity</span><br>Capsule",
        desc: "Precision cuts with aerodynamic flow. Where movement defines form.",
        img: ctx + "/image/slide (4).jpg"
    },
    {
        subtitle: "ARCHIVE // SIGNATURE",
        title: "Noir <br><span class='italic-light'>Essential</span><br>Layering",
        desc: "Layered monochrome textures crafted with technical finesse.",
        img: ctx + "/image/slide (5).jpg"
    },
    {
        subtitle: "RUNWAY // 2026",
        title: "Prism <br><span class='italic-light'>Edge</span><br>Collection",
        desc: "Sharp geometry blended with fluid motion for bold expression.",
        img: ctx + "/image/men (6).jpg"
    }
];

    let currentSlide = 0;
    let heroInterval;

    function resetProgressBar() {
        const bar = document.getElementById('heroProgressBar');
        if(!bar) return;
        bar.style.transition = 'none';
        bar.style.width = '0%';
        setTimeout(() => {
            bar.style.transition = 'width 5s linear';
            bar.style.width = '100%';
        }, 50);
    }

    function rotateHero() {
        const textCont = document.querySelector('.reveal-content');
        const heroImg = document.getElementById('heroImg');
        
        if (!textCont || !heroImg) return;

        // Fade Out Text
        textCont.style.opacity = "0";
        textCont.style.transform = "translateY(20px)";
        
        setTimeout(() => {
            currentSlide = (currentSlide + 1) % slides.length;
            const s = slides[currentSlide];
            
            // Update Text
            document.getElementById('s-subtitle').innerText = s.subtitle;
            document.getElementById('s-title').innerHTML = s.title;
            document.getElementById('s-desc').innerText = s.desc;
            
            // Update Image with proper URL formatting
            heroImg.style.backgroundImage = "url('" + s.img + "')";
            
            // Fade In Text
            textCont.style.opacity = "1";
            textCont.style.transform = "translateY(0)";
            
            resetProgressBar();
        }, 800); 
    }
    // --- INITIALIZATION ---
    window.addEventListener('load', () => {
        fetchProducts('all'); // Initial load
        resetProgressBar();
        heroInterval = setInterval(rotateHero, 11000);
        
        // Pause on hover logic
        const heroSection = document.getElementById('heroSlider');
        if(heroSection) {
            heroSection.addEventListener('mouseenter', () => clearInterval(heroInterval));
            heroSection.addEventListener('mouseleave', () => {
                heroInterval = setInterval(rotateHero, 10000);
                resetProgressBar();
            });
        }
    });
    
    async function addToCart(productId) {
        try {
            // 1. Matches your Servlet mapping: /cartAction
            // 2. Includes the 'action=add' parameter required by your CartServlet logic
            const response = await fetch(ctx + '/cartAction?action=add&productId=' + productId, {
                method: 'POST'
            });

            if (response.ok) {
                // Success: Refresh the cart sidebar UI and open it
                await updateCartUI();
                toggleCart();
            } else if (response.status === 401) {
                // Handle guest users based on your Servlet's user == null check
                alert("Please login to add items to your archive.");
                window.location.href = "login.jsp";
            } else {
                console.error("Server error: " + response.status);
            }
        } catch (error) {
            console.error("Connection error:", error);
        }
    }
 // Set offer end date
    const offerEnd = new Date("March 5, 2026 23:59:59").getTime();

    const timer = setInterval(function(){

        const now = new Date().getTime();
        const distance = offerEnd - now;

        const days = Math.floor(distance / (1000 * 60 * 60 * 24));
        const hours = Math.floor((distance % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
        const minutes = Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60));
        const seconds = Math.floor((distance % (1000 * 60)) / 1000);

        document.getElementById("days").innerHTML = days.toString().padStart(2, '0');
        document.getElementById("hours").innerHTML = hours.toString().padStart(2, '0');
        document.getElementById("minutes").innerHTML = minutes.toString().padStart(2, '0');
        document.getElementById("seconds").innerHTML = seconds.toString().padStart(2, '0');
        if(distance < 0){
            clearInterval(timer);
            document.querySelector(".countdown").innerHTML = "<h2>Offer Expired</h2>";
        }

    },1000);
  
</script>
</body>
</html>