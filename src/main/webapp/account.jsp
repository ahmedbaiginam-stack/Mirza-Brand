<%@ page session="true" %>
<%@ page import="com.model.User" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.mirza.util.DBConnection" %>
<%
    // 1. Security check
    User appUser = (User) session.getAttribute("user");
    
    if(appUser == null){
        response.sendRedirect("login.jsp");
        return;
    }
    
    // 2. Fetch data from session
    String userName = appUser.getName();
    String userEmail = appUser.getEmail();
    String userRole = appUser.getRole();
    int userId = appUser.getUserId();
    
    // 3. Null-safe check for Phone
    String userPhone = (appUser.getPhone() != null && !appUser.getPhone().trim().isEmpty()) ? appUser.getPhone() : "Not Provided";
    
    // 4. Null-safe check for Address
    String userAddress = (appUser.getAddress() != null && !appUser.getAddress().trim().isEmpty()) ? appUser.getAddress() : "No address on file";
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <title>MIRZA | Dashboard</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600&family=Playfair+Display:wght@700&display=swap" rel="stylesheet">
    <style>
        :root { 
            --bg: #050505; --card-bg: #0c0c0c; --accent: #c5a059; 
            --text: #ffffff; --sub-text: #a0a0a0; --line: rgba(255,255,255,0.05); 
        }
        
        body { margin: 0; background: var(--bg); color: var(--text); font-family: 'Inter', sans-serif; -webkit-font-smoothing: antialiased; }

        /* Navigation Bar */
        .header { 
            padding: 15px 50px; border-bottom: 1px solid var(--line);
            display: flex; justify-content: space-between; align-items: center; 
            background: rgba(0,0,0,0.9); backdrop-filter: blur(15px); position: sticky; top: 0; z-index: 1000;
        }
        .header h2 { font-family: 'Playfair Display', serif; letter-spacing: 6px; margin: 0; font-size: 1.2rem; }
        .header nav a { color: var(--text); text-decoration: none; font-size: 0.7rem; letter-spacing: 2px; text-transform: uppercase; margin-left: 25px; transition: color 0.3s; }
        .header nav a:hover { color: var(--accent); }

        /* Layout Structure */
        .dashboard-wrapper { display: grid; grid-template-columns: 280px 1fr; max-width: 1400px; margin: 50px auto; padding: 0 30px; gap: 50px; }

        /* Left Sidebar Navigation */
        .sidebar { position: sticky; top: 100px; height: fit-content; }
        .user-intro { padding-bottom: 30px; border-bottom: 1px solid var(--line); margin-bottom: 30px; }
        .user-intro span { font-size: 0.65rem; text-transform: uppercase; letter-spacing: 2px; color: var(--accent); display: block; margin-bottom: 5px; }
        .user-intro h3 { margin: 0; font-size: 1.4rem; font-family: 'Playfair Display', serif; font-weight: 700; }

        .nav-menu a { 
            display: block; padding: 12px 0; color: var(--sub-text); 
            text-decoration: none; font-size: 0.85rem; transition: 0.3s; border-left: 2px solid transparent;
            cursor: pointer;
        }
        .nav-menu a:hover, .nav-menu a.active { color: var(--text); padding-left: 15px; border-left: 2px solid var(--accent); }
        .admin-btn { color: #ff5555 !important; border-top: 1px solid var(--line); margin-top: 20px; padding-top: 20px !important; }

        /* Content Areas */
        .grid-content { display: flex; flex-direction: column; gap: 30px; }
        .card { background: var(--card-bg); border: 1px solid var(--line); padding: 35px; border-radius: 2px; position: relative; overflow: hidden; }
        .card::before { content: ""; position: absolute; top: 0; left: 0; width: 100%; height: 1px; background: linear-gradient(90deg, var(--accent), transparent); }
        
        .card h4 { margin-top: 0; font-size: 0.8rem; letter-spacing: 3px; text-transform: uppercase; color: var(--accent); margin-bottom: 25px; }
        
        .info-row { display: flex; justify-content: space-between; padding: 15px 0; border-bottom: 1px solid var(--line); }
        .label { color: var(--sub-text); font-size: 0.8rem; }
        .value { color: var(--text); font-size: 0.9rem; font-weight: 500; }

        .btn { 
            display: inline-block; margin-top: 20px; padding: 12px 35px; 
            border: 1px solid var(--accent); color: var(--accent); 
            text-decoration: none; font-size: 0.7rem; letter-spacing: 2px; 
            text-transform: uppercase; transition: 0.4s; background: none; cursor: pointer;
        }
        .btn:hover { background: var(--accent); color: #000; }

        /* Stats Section */
        .stats-bar { display: grid; grid-template-columns: repeat(3, 1fr); gap: 20px; }
        .stat-item { background: var(--card-bg); padding: 20px; border: 1px solid var(--line); text-align: center; }
        .stat-item b { display: block; font-size: 1.5rem; color: var(--accent); margin-bottom: 5px; }
        .stat-item small { font-size: 0.6rem; color: var(--sub-text); text-transform: uppercase; letter-spacing: 1px; }

        /* Table Styling */
        table { width: 100%; border-collapse: collapse; margin-top: 10px; font-size: 0.85rem; }
        th { text-align: left; color: var(--accent); border-bottom: 1px solid var(--line); padding: 10px 0; text-transform: uppercase; letter-spacing: 1px; font-size: 0.7rem; }
        td { padding: 15px 0; border-bottom: 1px solid var(--line); color: var(--sub-text); }

        /* Modal */
        #editModal { display:none; position:fixed; top:0; left:0; width:100%; height:100%; background:rgba(0,0,0,0.9); z-index:2000; align-items:center; justify-content:center; }
    </style>
</head>
<body>

<header class="header">
    <h2 onclick="window.location.href='index.jsp'" style="cursor:pointer;">MIRZE</h2>
    <nav>
        <a href="index.jsp">Home</a>
        <a href="logout">Logout</a>
    </nav>
</header>

<div class="dashboard-wrapper">
    <aside class="sidebar">
        <div class="user-intro">
            <span>Client Member</span>
            <h3><%= userName %></h3>
        </div>
        <nav class="nav-menu">
            <a onclick="showSection('overview')" id="nav-overview" class="active">Account Overview</a>
            <a onclick="showSection('orders')" id="nav-orders">Order History</a>
            <a onclick="showSection('shipping')" id="nav-shipping">Shipping Address</a>
            <a href="#">Security & Privacy</a>
            <% if("ADMIN".equals(userRole)){ %>
                <a href="admin.jsp" class="admin-btn">Atelier Management</a>
            <% } %>
        </nav>
    </aside>

    <div class="grid-content">
        <div id="section-overview">
            <div class="stats-bar" style="margin-bottom: 30px;">
                <div class="stat-item">
                    <b><%= appUser.getOrderCount() %></b>
                    <small>Orders Placed</small>
                </div>
                <div class="stat-item">
                    <b>Gold</b>
                    <small>Status Level</small>
                </div>
                <div class="stat-item">
                    <b><%= userRole %></b>
                    <small>Access Tier</small>
                </div>
            </div>

            <div class="card">
                <h4>Profile Information</h4>
                <div class="info-row"><span class="label">Full Name</span><span class="value"><%= userName %></span></div>
                <div class="info-row"><span class="label">Email Address</span><span class="value"><%= userEmail %></span></div>
                <div class="info-row"><span class="label">Phone Number</span><span class="value"><%= userPhone %></span></div>
                <div class="info-row"><span class="label">Account ID</span><span class="value">#MZ-00<%= userId %></span></div>
                <button class="btn" onclick="toggleModal()">Edit Profile</button>
            </div>
        </div>

        <div id="section-orders" style="display:none;">
            <div class="card">
                <h4>Order History</h4>
                <table>
                    <tr>
                        <th>Object</th>
                        <th>Date</th>
                        <th>Qty</th>
                        <th>Price</th>
                        <th>Status</th>
                    </tr>
                    <%
                        try (Connection conn = DBConnection.getConnection()) {
                            String sql = "SELECT PRODUCT_NAME, ORDER_DATE, QUANTITY, PRICE, STATUS FROM ORDERS_MIRZA WHERE USER_ID = ? ORDER BY ORDER_DATE DESC";
                            PreparedStatement ps = conn.prepareStatement(sql);
                            ps.setInt(1, userId);
                            ResultSet rs = ps.executeQuery();
                            boolean hasOrders = false;
                            while(rs.next()) {
                                hasOrders = true;
                    %>
                    <tr>
                        <td style="color:#fff;"><%= rs.getString("PRODUCT_NAME") %></td>
                        <td><%= rs.getTimestamp("ORDER_DATE").toLocalDateTime().toLocalDate() %></td>
                        <td><%= rs.getInt("QUANTITY") %></td>
                        <td>$<%= String.format("%,.0f", rs.getDouble("PRICE")) %></td>
                        <td style="color: var(--accent);"><%= rs.getString("STATUS") %></td>
                    </tr>
                    <% 
                            }
                            if(!hasOrders) { out.print("<tr><td colspan='5'>No acquisitions found in your archive.</td></tr>"); }
                        } catch(Exception e) { out.print("<tr><td colspan='5'>Unable to load history.</td></tr>"); }
                    %>
                </table>
            </div>
        </div>

        <div id="section-shipping" style="display:none;">
            <div class="card">
                <div style="display: flex; justify-content: space-between; align-items: flex-start;">
                    <h4>Shipping Destination</h4>
                    <span style="font-size: 0.6rem; color: var(--accent); border: 1px solid var(--accent); padding: 2px 8px; letter-spacing: 1px;">PRIMARY</span>
                </div>
                <div style="margin: 15px 0;">
                    <p style="color: #fff; font-size: 1rem; margin-bottom: 5px; font-weight: 600;"><%= userName %></p>
                    <p style="color: var(--sub-text); line-height: 1.8; font-size: 0.9rem; max-width: 300px;">
                        <%= userAddress %><br>
                        <span style="color: var(--accent); font-size: 0.8rem;">Contact: <%= userPhone %></span>
                    </p>
                </div>
                <button class="btn" onclick="toggleModal()">Update Address</button>
            </div>
        </div>
    </div>
</div>

<div id="editModal">
    <div class="card" style="width:450px; border:1px solid var(--accent);">
        <h4>Update Atelier Profile</h4>
        <form action="updateProfile" method="POST">
            <div style="margin-bottom:15px;">
                <label style="font-size:0.7rem; color:var(--sub-text);">FULL NAME</label>
                <input type="text" name="name" value="<%= userName %>" required style="width:100%; background:#000; border:1px solid var(--line); color:#fff; padding:10px; margin-top:5px;">
            </div>
            <div style="margin-bottom:15px;">
                <label style="font-size:0.7rem; color:var(--sub-text);">PHONE NUMBER</label>
                <input type="text" name="phone" value="<%= userPhone.equals("Not Provided") ? "" : userPhone %>" style="width:100%; background:#000; border:1px solid var(--line); color:#fff; padding:10px; margin-top:5px;">
            </div>
            <div style="margin-bottom:15px;">
                <label style="font-size:0.7rem; color:var(--sub-text);">SHIPPING ADDRESS</label>
                <textarea name="address" rows="3" style="width:100%; background:#000; border:1px solid var(--line); color:#fff; padding:10px; margin-top:5px;"><%= userAddress.equals("No address on file") ? "" : userAddress %></textarea>
            </div>
            <div style="display:flex; gap:10px;">
                <button type="submit" class="btn" style="background:var(--accent); color:#000; flex:1; margin-top:0;">Save</button>
                <button type="button" onclick="toggleModal()" class="btn" style="flex:1; margin-top:0;">Cancel</button>
            </div>
        </form>
    </div>
</div>

<script>
    function toggleModal() {
        const modal = document.getElementById('editModal');
        modal.style.display = (modal.style.display === 'none' || modal.style.display === '') ? 'flex' : 'none';
    }

    function showSection(sectionId) {
        // Hide all
        document.getElementById('section-overview').style.display = 'none';
        document.getElementById('section-orders').style.display = 'none';
        document.getElementById('section-shipping').style.display = 'none';
        
        // Deactivate all links
        document.querySelectorAll('.nav-menu a').forEach(a => a.classList.remove('active'));

        // Show selected
        document.getElementById('section-' + sectionId).style.display = 'block';
        document.getElementById('nav-' + sectionId).classList.add('active');
    }
</script>

</body>
</html>