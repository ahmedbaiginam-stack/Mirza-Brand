<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.model.User" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.mirza.util.DBConnection" %>
<%
User appUser = (User) session.getAttribute("user");
if(appUser == null || !"ADMIN".equals(appUser.getRole())){
    response.sendRedirect("../login.jsp");
    return;
}
%>
<!doctype html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <title>MIRZA | Admin Atelier</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600&family=Playfair+Display:wght@700&display=swap" rel="stylesheet">
    <style>
        :root { --bg: #000; --fg: #fff; --accent: #c5a059; --line: rgba(255,255,255,0.1); }
        body { background: var(--bg); color: var(--fg); font-family: 'Inter', sans-serif; margin: 0; display: flex; }
        
        /* Sidebar */
        .sidebar { width: 280px; height: 100vh; border-right: 1px solid var(--line); padding: 50px 40px; position: fixed; background: #000; z-index: 100; }
        .sidebar h2 { font-family: 'Playfair Display', serif; letter-spacing: 5px; font-size: 1.4rem; margin-bottom: 60px; cursor: pointer; }
        .nav-item { display: block; color: #666; text-decoration: none; font-size: 0.75rem; letter-spacing: 2px; margin-bottom: 30px; cursor: pointer; transition: 0.3s; text-transform: uppercase; }
        .nav-item:hover, .nav-item.active { color: var(--accent); }
        .notif-badge { background: var(--accent); color: #000; font-size: 0.6rem; padding: 2px 6px; border-radius: 10px; margin-left: 5px; font-weight: 700; }

        /* Content */
        .main-content { margin-left: 320px; padding: 60px; width: calc(100% - 320px); min-height: 100vh; }
        .panel { display: none; width: 100%; max-width: 900px; animation: fadeIn 0.4s ease; }
        .panel.active { display: block; }
        
        h3 { font-size: 0.9rem; letter-spacing: 4px; text-transform: uppercase; margin-bottom: 40px; color: var(--accent); border-bottom: 1px solid var(--line); padding-bottom: 20px; }
        
        /* Tables */
        table { width: 100%; border-collapse: collapse; margin-top: 20px; font-size: 0.8rem; }
        th { text-align: left; color: #444; text-transform: uppercase; letter-spacing: 2px; padding: 15px 10px; border-bottom: 1px solid var(--line); }
        td { padding: 20px 10px; border-bottom: 1px solid var(--line); color: #ccc; }
        
        /* Forms */
        .form-row { display: flex; gap: 20px; }
        .form-group { flex: 1; margin-bottom: 20px; }
        label { display: block; font-size: 0.65rem; color: #888; text-transform: uppercase; margin-bottom: 8px; }
        input, textarea, select { width: 100%; background: #0a0a0a; border: 1px solid var(--line); color: #fff; padding: 12px; font-size: 0.85rem; outline: none; transition: 0.3s; }
        input:focus, select:focus { border-color: var(--accent); }
        
        .btn-submit { padding: 12px 25px; background: var(--fg); color: #000; border: none; font-size: 0.7rem; font-weight: 700; letter-spacing: 2px; cursor: pointer; text-transform: uppercase; transition: 0.3s; }
        .btn-submit:hover { background: var(--accent); }
        /* Update this in your <style> block */
#responseLog { 
    margin-top: 25px; 
    padding: 25px; 
    border: 1px solid var(--accent); 
    background: rgba(197, 160, 89, 0.05); /* Very subtle gold tint */
    color: var(--accent); 
    font-size: 0.85rem; 
    line-height: 1.6;
    display: none; /* Hidden until a search is performed */
}

/* Optional: Style for the data fields inside the log */
#responseLog b { color: #fff; text-transform: uppercase; font-size: 0.7rem; letter-spacing: 1px; }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(10px); } to { opacity: 1; transform: translateY(0); } }
    </style>
</head>
<body>

    <aside class="sidebar">
        <h2 onclick="window.location.href='index.jsp'">MIRZA</h2>
        <span class="nav-item active" onclick="switchTab('addPanel', this)">Add New Products</span>
        <span class="nav-item" onclick="switchTab('managePanel', this)">Inventory</span>
        <span class="nav-item" onclick="switchTab('ordersPanel', this)">
            Orders 
            <%
                int unread = 0;
                try (Connection conn = DBConnection.getConnection()) {
                    ResultSet rs = conn.createStatement().executeQuery("SELECT COUNT(*) FROM ADMIN_NOTIFICATIONS WHERE IS_READ = 0");
                    if(rs.next()) unread = rs.getInt(1);
                } catch(Exception e) {}
                if(unread > 0) { out.print("<span class='notif-badge'>" + unread + "</span>"); }
            %>
        </span>
        <span class="nav-item" onclick="switchTab('updatePanel', this)">Modify Object</span>
        
        <div style="margin-top: 80px; border-top: 1px solid var(--line); padding-top: 30px;">
            <a href="index.jsp" class="nav-item">Home</a>
            <a href="<%=request.getContextPath()%>/logout" class="nav-item" style="color: var(--accent)">Logout</a>
        </div>
    </aside>

    <main class="main-content">
        <section id="addPanel" class="panel active">
            <h3>Add New Object</h3>
            <form id="addForm">
                <input type="hidden" name="authType" value="addProduct">
                <div class="form-group"><label>Object Name</label><input type="text" name="name" required placeholder="Name of Product"></div>
                
				<div class="form-row">
				    <div class="form-group">
				        <label>Category</label>
				        <input type="text" step="0.01" name="category" required placeholder="Men, Women, Watch, Goggle........"></div>
				    </div>
				    <div class="form-group">
				        <label>Brand</label>
				        <input type="text" name="brand" placeholder="e.g., MIRZA Private Label">
				    </div>
				</div>
                <div class="form-row">
                    <div class="form-group"><label>Price ($)</label><input type="number" step="0.01" name="price" required></div>
                    <div class="form-group"><label>Stock Units</label><input type="number" name="stock" required></div>
                </div>
                <div class="form-group"><label>Image URL</label><input type="text" name="image"></div>
                <div class="form-group"><label>Narrative</label><textarea name="description" rows="4"></textarea></div>
                <button type="button" class="btn-submit" onclick="handleAction('addForm')">Confirm Archive</button>
            </form>
        </section>

        <section id="managePanel" class="panel">
            <h3>Inventory Management</h3>
            <div class="form-group">
                <label>Search Inventory</label>
                <div style="display: flex; gap: 10px;">
                    <input type="text" id="searchKeyword" placeholder="Enter name or ID...">
                    <button class="btn-submit" onclick="searchInventory()">Search</button>
                </div>
            </div>
            <div style="margin-top: 50px; border-top: 1px solid var(--line); padding-top: 30px;">
                <label>Delete Object (ID)</label>
                <div style="display: flex; gap: 10px;">
                    <input type="number" id="deleteTargetId" placeholder="ID to remove">
                    <button class="btn-submit" style="background: #400; color: #fff;" onclick="deleteInventory()">Delete</button>
                </div>
            </div>
        </section>

        <section id="ordersPanel" class="panel">
            <h3>Atelier Order Fulfillment</h3>
            <table>
                <tr>
                    <th>ID</th>
                    <th>Client ID</th>
                    <th>Object</th>
                    <th>Current Status</th>
                    <th>Update Status</th>
                </tr>
                <%
                    try (Connection conn = DBConnection.getConnection()) {
                        String sql = "SELECT ORDER_ID, PRODUCT_NAME, STATUS, USER_ID FROM ORDERS_MIRZA ORDER BY ORDER_DATE DESC";
                        Statement stmt = conn.createStatement();
                        ResultSet rs = stmt.executeQuery(sql);
                        while(rs.next()) {
                            int oid = rs.getInt("ORDER_ID");
                            String status = rs.getString("STATUS");
                %>
                <tr>
                    <td>#<%= oid %></td>
                    <td>CLIENT_<%= rs.getInt("USER_ID") %></td>
                    <td><%= rs.getString("PRODUCT_NAME") %></td>
                    <td style="color: var(--accent);"><%= status %></td>
                    <td>
                        <form action="updateStatus" method="POST" style="display:flex; gap:10px;">
                            <input type="hidden" name="orderId" value="<%= oid %>">
                            <select name="newStatus" style="padding: 5px;">
                                <option value="Processing" <%= "Processing".equals(status) ? "selected" : "" %>>Processing</option>
                                <option value="Shipped" <%= "Shipped".equals(status) ? "selected" : "" %>>Shipped</option>
                                <option value="Delivered" <%= "Delivered".equals(status) ? "selected" : "" %>>Delivered</option>
                                <option value="Cancelled" <%= "Cancelled".equals(status) ? "selected" : "" %>>Cancelled</option>
                            </select>
                            <button type="submit" class="btn-submit" style="padding: 5px 10px; font-size: 0.6rem;">Save</button>
                        </form>
                    </td>
                </tr>
                <% 
                        }
                    } catch(Exception e) { out.print("Error loading orders."); }
                %>
            </table>
        </section>

        <section id="updatePanel" class="panel">
            <h3>Modify Existing Object</h3>
            <form id="updateForm">
                <input type="hidden" name="authType" value="updateProduct">
                <div class="form-group"><label>Object ID (Target)</label><input type="number" name="productId" required></div>
                <div class="form-group"><label>New Name</label><input type="text" name="name" required></div>
                <div class="form-row">
                    <div class="form-group"><label>New Price ($)</label><input type="number" step="0.01" name="price" required></div>
                    <div class="form-group"><label>New Stock</label><input type="number" name="stock" required></div>
                </div>
                <button type="button" class="btn-submit" onclick="handleAction('updateForm')">Apply Modifications</button>
            </form>
        </section>

        <div id="responseLog">System ready...</div>
    </main>

    <script>
        const ctx = '<%= request.getContextPath() %>';

        function switchTab(id, el) {
            document.querySelectorAll('.panel').forEach(p => p.classList.remove('active'));
            document.querySelectorAll('.nav-item').forEach(n => n.classList.remove('active'));
            document.getElementById(id).classList.add('active');
            el.classList.add('active');
            
            // If switching to orders, we could mark notifications as read here via fetch
        }

        async function handleAction(formId) {
            const log = document.getElementById('responseLog');
            log.style.display = "block";
            log.innerHTML = "Processing...";
            try {
                const formData = new URLSearchParams(new FormData(document.getElementById(formId)));
                const response = await fetch(ctx + '/adminAction', { method: 'POST', body: formData });
                log.innerHTML = await response.text();
                if(response.ok) document.getElementById(formId).reset();
                setTimeout(() => { log.style.display = "none"; }, 3000);
            } catch (e) { log.innerHTML = "Servlet Error."; }
        }

        async function searchInventory() {
            const key = document.getElementById('searchKeyword').value;
            const params = new URLSearchParams({ authType: 'searchProduct', keyword: key });
            const log = document.getElementById('responseLog');
            log.style.display = "block";
            try {
                const res = await fetch(ctx + '/adminAction', { method: 'POST', body: params });
                log.innerHTML = await res.text();
            } catch (e) { log.innerHTML = "Search failed."; }
        }

        async function deleteInventory() {
            const id = document.getElementById('deleteTargetId').value;
            if(!id || !confirm("Delete this product?")) return;
            const params = new URLSearchParams({ authType: 'deleteProduct', productId: id });
            const log = document.getElementById('responseLog');
            log.style.display = "block";
            try {
                const res = await fetch(ctx + '/adminAction', { method: 'POST', body: params });
                log.innerHTML = await res.text();
            } catch (e) { log.innerHTML = "Delete failed."; }
        }
    </script>
</body>
</html>