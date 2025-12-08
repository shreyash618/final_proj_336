<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.techbarn.webapp.ApplicationDB" %>
<%
    // Get user id from session
    Integer userIdObj = (Integer) session.getAttribute("user_id");
    if (userIdObj == null) {
        // Not logged in – redirect to login
        response.sendRedirect("login.jsp");
        return;
    }
    int userId = userIdObj;

    request.setCharacterEncoding("UTF-8");
    String message = null;
    String error = null;

    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        conn = ApplicationDB.getConnection();

        // ====== HANDLE CREATE ALERT FORM SUBMISSION ======
        String action = request.getParameter("action");
        if ("create".equals(action)) {
            String itemIdStr = request.getParameter("item_id");
            String minPriceStr = request.getParameter("min_price");
            String maxPriceStr = request.getParameter("max_price");
            String keyword = request.getParameter("keyword");

            if (itemIdStr == null || itemIdStr.trim().isEmpty()
                    || maxPriceStr == null || maxPriceStr.trim().isEmpty()) {
                error = "Item and max price are required.";
            } else {
                int itemId = Integer.parseInt(itemIdStr);
                Double minPrice = null;
                if (minPriceStr != null && !minPriceStr.trim().isEmpty()) {
                    minPrice = Double.parseDouble(minPriceStr);
                }
                double maxPrice = Double.parseDouble(maxPriceStr);

                if (keyword != null && keyword.length() > 10) {
                    keyword = keyword.substring(0, 10); // Alert.keyword is varchar(10)
                }

                String insertSql =
                    "INSERT INTO Alert (min_price, max_price, keyword, active, user_id, item_id) " +
                    "VALUES (?, ?, ?, 'ACTIVE', ?, ?)";

                ps = conn.prepareStatement(insertSql);
                if (minPrice == null) {
                    ps.setNull(1, java.sql.Types.DECIMAL);
                } else {
                    ps.setDouble(1, minPrice);
                }
                ps.setDouble(2, maxPrice);
                ps.setString(3, (keyword == null || keyword.trim().isEmpty()) ? null : keyword.trim());
                ps.setInt(4, userId);
                ps.setInt(5, itemId);

                int rows = ps.executeUpdate();
                if (rows > 0) {
                    message = "Alert created successfully!";
                } else {
                    error = "Failed to create alert.";
                }
                ps.close();
            }
        }

        // ====== HANDLE DEACTIVATE ALERT ======
        if ("deactivate".equals(action)) {
            String alertIdStr = request.getParameter("alert_id");
            if (alertIdStr != null && !alertIdStr.trim().isEmpty()) {
                int alertId = Integer.parseInt(alertIdStr);
                String deactivateSql = "UPDATE Alert SET active = 'INACTIVE' WHERE alert_id = ? AND user_id = ?";
                ps = conn.prepareStatement(deactivateSql);
                ps.setInt(1, alertId);
                ps.setInt(2, userId);
                int rows = ps.executeUpdate();
                if (rows > 0) {
                    message = "Alert deactivated.";
                } else {
                    error = "Could not deactivate alert.";
                }
                ps.close();
            }
        }

        // ====== LOAD ITEMS FOR DROPDOWN ======
        String itemsSql =
            "SELECT item_id, title, brand, in_stock " +
            "FROM Item " +
            "ORDER BY title ASC";

        PreparedStatement psItems = conn.prepareStatement(itemsSql);
        ResultSet rsItems = psItems.executeQuery();
        
        // Store items in a list to reuse
        java.util.List<java.util.Map<String, Object>> itemsList = new java.util.ArrayList<>();
        while (rsItems.next()) {
            java.util.Map<String, Object> item = new java.util.HashMap<>();
            item.put("item_id", rsItems.getInt("item_id"));
            item.put("title", rsItems.getString("title"));
            item.put("brand", rsItems.getString("brand"));
            item.put("in_stock", rsItems.getBoolean("in_stock"));
            itemsList.add(item);
        }
        rsItems.close();
        psItems.close();

        // ====== LOAD USER ALERTS ======
        String alertsSql =
            "SELECT a.alert_id, a.min_price, a.max_price, a.keyword, a.active, " +
            "       i.title, i.brand, i.in_stock " +
            "FROM Alert a " +
            "JOIN Item i ON a.item_id = i.item_id " +
            "WHERE a.user_id = ? " +
            "ORDER BY a.alert_id DESC";

        PreparedStatement psAlerts = conn.prepareStatement(alertsSql);
        psAlerts.setInt(1, userId);
        ResultSet rsAlerts = psAlerts.executeQuery();

        // ====== LOAD "READY" ALERTS (ITEM NOW IN STOCK) ======
        String readySql =
            "SELECT a.alert_id, i.title, i.brand " +
            "FROM Alert a " +
            "JOIN Item i ON a.item_id = i.item_id " +
            "WHERE a.user_id = ? AND a.active = 'ACTIVE' AND i.in_stock = 1";

        PreparedStatement psReady = conn.prepareStatement(readySql);
        psReady.setInt(1, userId);
        ResultSet rsReady = psReady.executeQuery();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>My Alerts - Tech Barn</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet">
    <style>
        body { 
            font-family: 'Inter', Arial, sans-serif; 
            margin: 0;
            padding: 0;
            background: #f7fafc;
        }
        .main-content {
            padding: 20px;
        }
        .container {
            max-width: 1200px;
            margin: 0 auto;
        }
        h1, h2 { color: #1f2933; }
        h1 { font-size: 2rem; margin-bottom: 0.5rem; }
        h2 { font-size: 1.5rem; margin-top: 2rem; margin-bottom: 1rem; }
        .msg { 
            padding: 12px 16px; 
            margin-bottom: 16px; 
            border-radius: 8px; 
            font-size: 0.95rem;
        }
        .msg.success { 
            background-color: #d1fae5; 
            border: 1px solid #6ee7b7; 
            color: #065f46; 
        }
        .msg.error { 
            background-color: #fee2e2; 
            border: 1px solid #fca5a5; 
            color: #991b1b; 
        }
        form { 
            background: white;
            padding: 24px;
            border-radius: 12px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
            margin-bottom: 24px; 
        }
        label { 
            display: block; 
            margin-top: 12px;
            margin-bottom: 6px;
            font-weight: 600;
            color: #4b5563;
            font-size: 0.9rem;
        }
        input[type="text"], input[type="number"], select {
            padding: 10px 14px;
            width: 100%;
            max-width: 400px;
            box-sizing: border-box;
            border: 2px solid #e5e7eb;
            border-radius: 8px;
            font-size: 0.95rem;
            transition: border-color 0.2s;
        }
        input[type="text"]:focus, input[type="number"]:focus, select:focus {
            outline: none;
            border-color: #6366f1;
        }
        input[type="submit"] {
            margin-top: 16px;
            padding: 12px 24px;
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            transition: transform 0.2s;
        }
        input[type="submit"]:hover {
            transform: translateY(-2px);
        }
        table { 
            border-collapse: collapse; 
            width: 100%; 
            margin-top: 15px;
            background: white;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
        }
        th, td { 
            border: 1px solid #e5e7eb; 
            padding: 12px; 
            text-align: left; 
        }
        th { 
            background-color: #f9fafb;
            font-weight: 600;
            color: #4b5563;
        }
        .badge { 
            padding: 4px 8px; 
            border-radius: 6px; 
            font-size: 0.75rem;
            font-weight: 600;
            text-transform: uppercase;
        }
        .badge.instock { 
            background-color: #d1fae5; 
            color: #065f46; 
        }
        .badge.outstock { 
            background-color: #fee2e2; 
            color: #991b1b; 
        }
        .btn-link {
            background: none;
            border: none;
            color: #6366f1;
            cursor: pointer;
            text-decoration: underline;
            padding: 0;
            font: inherit;
            font-size: 0.9rem;
        }
        .btn-link:hover {
            color: #4f46e5;
        }
        .alert-section {
            background: white;
            padding: 20px;
            border-radius: 12px;
            margin-bottom: 24px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
        }
        .alert-section ul {
            margin: 10px 0;
            padding-left: 20px;
        }
        .alert-section li {
            margin: 8px 0;
            line-height: 1.6;
        }
        hr {
            border: none;
            border-top: 2px solid #e5e7eb;
            margin: 32px 0;
        }
        .back-link {
            display: inline-block;
            margin-top: 24px;
            color: #6366f1;
            text-decoration: none;
            font-weight: 600;
        }
        .back-link:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>

<!-- Include navbar -->
<jsp:include page="navbar.jsp" />

<div class="main-content">
<div class="container">
    <h1>🔔 My Alerts</h1>
    <p style="color: #6b7280; margin-bottom: 24px;">Get notified when items you're interested in become available.</p>

    <% if (message != null) { %>
        <div class="msg success"><%= message %></div>
    <% } %>
    <% if (error != null) { %>
        <div class="msg error"><%= error %></div>
    <% } %>

    <!-- Section: Items that have triggered alerts (in stock now) -->
    <div class="alert-section">
        <h2>✅ Items Available Now</h2>
        <%
            boolean hasReady = false;
            while (rsReady.next()) {
                if (!hasReady) {
        %>
            <ul>
        <%
                    hasReady = true;
                }
        %>
                <li>
                    Alert #<%= rsReady.getInt("alert_id") %>:
                    <strong><%= rsReady.getString("brand") %> - <%= rsReady.getString("title") %></strong>
                    is now <span class="badge instock">IN STOCK</span>
                </li>
        <%
            }
            if (hasReady) {
        %>
            </ul>
        <%
            } else {
        %>
            <p style="color: #6b7280;">No active alerts have been triggered yet.</p>
        <%
            }
        %>
    </div>

    <!-- Section: Create new alert -->
    <h2>Create a New Alert</h2>
    <form method="post" action="alertspage.jsp">
        <input type="hidden" name="action" value="create" />

        <label for="item_id">Item: *</label>
        <select name="item_id" id="item_id" required>
            <option value="">-- Select an item --</option>
            <%
                for (java.util.Map<String, Object> item : itemsList) {
                    int itemId = (Integer) item.get("item_id");
                    String title = (String) item.get("title");
                    String brand = (String) item.get("brand");
                    boolean inStock = (Boolean) item.get("in_stock");
            %>
                <option value="<%= itemId %>">
                    <%= brand %> - <%= title %>
                    (<%= inStock ? "In stock" : "Out of stock" %>)
                </option>
            <%
                }
            %>
        </select>

        <label for="min_price">Minimum Price (optional):</label>
        <input type="number" step="0.01" name="min_price" id="min_price" placeholder="e.g. 100.00" />

        <label for="max_price">Maximum Price: *</label>
        <input type="number" step="0.01" name="max_price" id="max_price" placeholder="e.g. 500.00" required />

        <label for="keyword">Keyword (optional, max 10 chars):</label>
        <input type="text" name="keyword" id="keyword" maxlength="10"
               placeholder="e.g. laptop" />

        <input type="submit" value="Create Alert" />
    </form>

    <!-- Section: Existing alerts -->
    <h2>My Alerts</h2>
    <table>
        <tr>
            <th>ID</th>
            <th>Item</th>
            <th>Price Range</th>
            <th>Keyword</th>
            <th>Item Stock</th>
            <th>Status</th>
            <th>Actions</th>
        </tr>
    <%
        boolean hasAlerts = false;
        while (rsAlerts.next()) {
            hasAlerts = true;
            int alertId = rsAlerts.getInt("alert_id");
            String itemTitle = rsAlerts.getString("title");
            String itemBrand = rsAlerts.getString("brand");
            double minPrice = rsAlerts.getDouble("min_price");
            boolean minWasNull = rsAlerts.wasNull();
            double maxPrice = rsAlerts.getDouble("max_price");
            String kw = rsAlerts.getString("keyword");
            String activeStr = rsAlerts.getString("active");
            boolean inStock = rsAlerts.getBoolean("in_stock");
    %>
        <tr>
            <td><%= alertId %></td>
            <td><strong><%= itemBrand %></strong> - <%= itemTitle %></td>
            <td>
                <% if (minWasNull) { %>
                    up to $<%= String.format("%.2f", maxPrice) %>
                <% } else { %>
                    $<%= String.format("%.2f", minPrice) %> – $<%= String.format("%.2f", maxPrice) %>
                <% } %>
            </td>
            <td><%= (kw == null ? "-" : kw) %></td>
            <td>
                <% if (inStock) { %>
                    <span class="badge instock">IN STOCK</span>
                <% } else { %>
                    <span class="badge outstock">OUT OF STOCK</span>
                <% } %>
            </td>
            <td><%= activeStr %></td>
            <td>
                <% if ("ACTIVE".equalsIgnoreCase(activeStr)) { %>
                    <form method="post" action="alertspage.jsp" style="display:inline;">
                        <input type="hidden" name="action" value="deactivate" />
                        <input type="hidden" name="alert_id" value="<%= alertId %>" />
                        <button type="submit" class="btn-link">Deactivate</button>
                    </form>
                <% } else { %>
                    -
                <% } %>
            </td>
        </tr>
    <%
        }
        rsAlerts.close();
        psAlerts.close();
        rsReady.close();
        psReady.close();

        if (!hasAlerts) {
    %>
        <tr>
            <td colspan="7" style="text-align: center; color: #6b7280;">You have no alerts yet. Create one above!</td>
        </tr>
    <%
        }
    %>
    </table>

    <a href="welcome.jsp" class="back-link">← Back to Home</a>
</div>
</div>

</body>
</html>

<%
    } catch (Exception e) {
        e.printStackTrace();
        out.println("<div class='msg error'>Error: " + e.getMessage() + "</div>");
    } finally {
        try { if (rs != null) rs.close(); } catch (Exception ignore) {}
        try { if (ps != null) ps.close(); } catch (Exception ignore) {}
        try { if (conn != null) conn.close(); } catch (Exception ignore) {}
    }
%>
