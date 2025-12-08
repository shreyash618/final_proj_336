<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.techbarn.webapp.ApplicationDB" %>
<%
    // Check if user is logged in
    if (session.getAttribute("user_id") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    int userId = (Integer) session.getAttribute("user_id");
    String firstName = (String) session.getAttribute("first_name");
    String lastName = (String) session.getAttribute("last_name");
    
    // Handle delete auction action
    String action = request.getParameter("action");
    String auctionIdParam = request.getParameter("auction_id");
    String message = "";
    String messageType = "";
    
    if ("delete".equals(action) && auctionIdParam != null) {
        Connection conn = null;
        PreparedStatement stmt = null;
        try {
            conn = ApplicationDB.getConnection();
            int auctionId = Integer.parseInt(auctionIdParam);
            
            // Delete auction (bids will be deleted via foreign key cascade if set up)
            String deleteQuery = "DELETE FROM Auction WHERE auction_id = ? AND seller_id = ?";
            stmt = conn.prepareStatement(deleteQuery);
            stmt.setInt(1, auctionId);
            stmt.setInt(2, userId);
            
            int deleted = stmt.executeUpdate();
            if (deleted > 0) {
                message = "Auction deleted successfully!";
                messageType = "success";
            } else {
                message = "Could not delete auction. It may have bids.";
                messageType = "error";
            }
        } catch (Exception e) {
            message = "Error deleting auction: " + e.getMessage();
            messageType = "error";
        } finally {
            if (stmt != null) try { stmt.close(); } catch (SQLException e) {}
            if (conn != null) try { conn.close(); } catch (SQLException e) {}
        }
    }
    
    // Get filter parameter
    String statusFilter = request.getParameter("filter");
    if (statusFilter == null) statusFilter = "all";
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Tech Barn - Seller Dashboard</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: Arial, sans-serif;
            background: #f5f5f5;
        }
        
        .header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 20px 40px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        
        .header h1 {
            font-size: 24px;
        }
        
        .header-right {
            display: flex;
            align-items: center;
            gap: 20px;
        }
        
        .user-info {
            text-align: right;
        }
        
        .user-name {
            font-weight: 600;
        }
        
        .logout-btn {
            background: rgba(255,255,255,0.2);
            color: white;
            padding: 8px 16px;
            border: 1px solid white;
            border-radius: 5px;
            text-decoration: none;
            transition: background 0.3s;
        }
        
        .logout-btn:hover {
            background: rgba(255,255,255,0.3);
        }
        
        .container {
            max-width: 1400px;
            margin: 40px auto;
            padding: 0 20px;
        }
        
        .welcome-section {
            background: white;
            padding: 30px;
            border-radius: 10px;
            margin-bottom: 30px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        
        .welcome-section h2 {
            color: #333;
            margin-bottom: 10px;
        }
        
        .welcome-section p {
            color: #666;
            margin-bottom: 20px;
        }
        
        .new-auction-btn {
            display: inline-block;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 15px 30px;
            border-radius: 8px;
            text-decoration: none;
            font-weight: 600;
            font-size: 16px;
            transition: transform 0.2s;
        }
        
        .new-auction-btn:hover {
            transform: translateY(-2px);
        }
        
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .stat-card {
            background: white;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        
        .stat-number {
            font-size: 36px;
            font-weight: bold;
            color: #667eea;
            margin-bottom: 5px;
        }
        
        .stat-label {
            color: #666;
            font-size: 14px;
        }
        
        .auctions-section {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        
        .section-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            flex-wrap: wrap;
            gap: 15px;
        }
        
        .section-header h3 {
            color: #333;
            font-size: 20px;
        }
        
        .filter-tabs {
            display: flex;
            gap: 10px;
        }
        
        .filter-tab {
            padding: 8px 16px;
            border: 2px solid #667eea;
            background: white;
            color: #667eea;
            border-radius: 5px;
            cursor: pointer;
            text-decoration: none;
            font-weight: 600;
            transition: all 0.3s;
        }
        
        .filter-tab:hover {
            background: #f0f0f0;
        }
        
        .filter-tab.active {
            background: #667eea;
            color: white;
        }
        
        .auction-table {
            width: 100%;
            border-collapse: collapse;
        }
        
        .auction-table th {
            background: #f8f9fa;
            padding: 12px;
            text-align: left;
            font-weight: 600;
            color: #333;
            border-bottom: 2px solid #dee2e6;
        }
        
        .auction-table td {
            padding: 12px;
            border-bottom: 1px solid #dee2e6;
            color: #666;
        }
        
        .auction-table tr:hover {
            background: #f8f9fa;
        }
        
        .status-badge {
            display: inline-block;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
        }
        
        .status-active {
            background: #d4edda;
            color: #155724;
        }
        
        .status-closed {
            background: #f8d7da;
            color: #721c24;
        }
        
        .status-upcoming {
            background: #d1ecf1;
            color: #0c5460;
        }
        
        .no-auctions {
            text-align: center;
            padding: 40px;
            color: #999;
        }
        
        .price {
            font-weight: 600;
            color: #28a745;
        }
        
        .action-buttons {
            display: flex;
            gap: 8px;
        }
        
        .btn-small {
            padding: 6px 12px;
            border-radius: 4px;
            font-size: 12px;
            font-weight: 600;
            cursor: pointer;
            text-decoration: none;
            border: none;
            transition: transform 0.2s;
        }
        
        .btn-small:hover {
            transform: translateY(-1px);
        }
        
        .btn-view {
            background: #17a2b8;
            color: white;
        }
        
        .btn-edit {
            background: #ffc107;
            color: #333;
        }
        
        .btn-delete {
            background: #dc3545;
            color: white;
        }
        
        .message {
            padding: 12px;
            border-radius: 5px;
            margin-bottom: 20px;
            text-align: center;
        }
        
        .success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        
        .error {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        
        .bid-details {
            display: none;
            background: #f8f9fa;
            padding: 15px;
            margin-top: 10px;
            border-radius: 5px;
        }
        
        .bid-details.show {
            display: block;
        }
        
        .bid-item {
            padding: 8px;
            border-bottom: 1px solid #dee2e6;
        }
        
        .bid-item:last-child {
            border-bottom: none;
        }
    </style>
    <script>
        function confirmDelete(auctionId, itemTitle) {
            if (confirm('Are you sure you want to delete the auction for "' + itemTitle + '"? This action cannot be undone.')) {
                window.location.href = 'sellerhomepage.jsp?action=delete&auction_id=' + auctionId;
            }
        }
        
        function toggleBids(auctionId) {
            var bidDetails = document.getElementById('bids-' + auctionId);
            if (bidDetails.classList.contains('show')) {
                bidDetails.classList.remove('show');
            } else {
                bidDetails.classList.add('show');
            }
        }
    </script>
</head>
<body>
    <div class="header">
        <h1>🛒 Tech Barn - Seller Dashboard</h1>
        <div class="header-right">
            <a href="alerts.jsp" class="logout-btn" style="margin-right: 10px;">🔔 My Alerts</a>
            <div class="user-info">
                <div class="user-name"><%= firstName %> <%= lastName %></div>
                <div style="font-size: 12px; opacity: 0.9;">Seller Account</div>
            </div>
            <a href="logout.jsp" class="logout-btn">Logout</a>
        </div>
    </div>
    
    <div class="container">
        <div class="welcome-section">
            <h2>Welcome back, <%= firstName %>! 👋</h2>
            <p>Ready to start selling? Create a new auction to list your tech items.</p>
            <a href="createauction.jsp" class="new-auction-btn">+ Begin New Auction</a>
        </div>
        
        <% if (!message.isEmpty()) { %>
            <div class="message <%= messageType %>">
                <%= message %>
            </div>
        <% } %>
        
        <%
            Connection conn = null;
            PreparedStatement statsStmt = null;
            PreparedStatement auctionsStmt = null;
            ResultSet statsRs = null;
            ResultSet auctionsRs = null;
            
            int activeAuctions = 0;
            int closedAuctions = 0;
            int totalBids = 0;
            
            try {
                conn = DBConnection.getConnection();
                
                // Get statistics
                String statsQuery = "SELECT " +
                    "SUM(CASE WHEN status = 'active' THEN 1 ELSE 0 END) as active_count, " +
                    "SUM(CASE WHEN status = 'closed' THEN 1 ELSE 0 END) as closed_count, " +
                    "(SELECT COUNT(*) FROM Bid b JOIN Auction a ON b.auction_id = a.auction_id WHERE a.seller_id = ?) as total_bids " +
                    "FROM Auction WHERE seller_id = ?";
                statsStmt = conn.prepareStatement(statsQuery);
                statsStmt.setInt(1, userId);
                statsStmt.setInt(2, userId);
                statsRs = statsStmt.executeQuery();
                
                if (statsRs.next()) {
                    activeAuctions = statsRs.getInt("active_count");
                    closedAuctions = statsRs.getInt("closed_count");
                    totalBids = statsRs.getInt("total_bids");
                }
        %>
        
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-number"><%= activeAuctions %></div>
                <div class="stat-label">Active Auctions</div>
            </div>
            <div class="stat-card">
                <div class="stat-number"><%= closedAuctions %></div>
                <div class="stat-label">Closed Auctions</div>
            </div>
            <div class="stat-card">
                <div class="stat-number"><%= totalBids %></div>
                <div class="stat-label">Total Bids Received</div>
            </div>
            <div class="stat-card">
                <div class="stat-number"><%= activeAuctions + closedAuctions %></div>
                <div class="stat-label">Total Auctions</div>
            </div>
        </div>
        
        <div class="auctions-section">
            <div class="section-header">
                <h3>Manage Your Auctions</h3>
                <div class="filter-tabs">
                    <a href="sellerhomepage.jsp?filter=all" class="filter-tab <%= "all".equals(statusFilter) ? "active" : "" %>">All</a>
                    <a href="sellerhomepage.jsp?filter=active" class="filter-tab <%= "active".equals(statusFilter) ? "active" : "" %>">Active</a>
                    <a href="sellerhomepage.jsp?filter=closed" class="filter-tab <%= "closed".equals(statusFilter) ? "active" : "" %>">Closed</a>
                </div>
            </div>
            
            <%
                // Build query based on filter
                String auctionsQuery = "SELECT a.auction_id, a.status, a.starting_price, a.end_time, a.start_time, " +
                    "i.title, i.brand, i.condition, i.item_id, " +
                    "(SELECT MAX(amount) FROM Bid WHERE auction_id = a.auction_id) as current_bid, " +
                    "(SELECT COUNT(*) FROM Bid WHERE auction_id = a.auction_id) as bid_count " +
                    "FROM Auction a " +
                    "JOIN Item i ON a.item_id = i.item_id " +
                    "WHERE a.seller_id = ?";
                
                if ("active".equals(statusFilter)) {
                    auctionsQuery += " AND a.status = 'active'";
                } else if ("closed".equals(statusFilter)) {
                    auctionsQuery += " AND a.status = 'closed'";
                }
                
                auctionsQuery += " ORDER BY a.start_time DESC";
                
                auctionsStmt = conn.prepareStatement(auctionsQuery);
                auctionsStmt.setInt(1, userId);
                auctionsRs = auctionsStmt.executeQuery();
                
                boolean hasAuctions = false;
            %>
            
            <table class="auction-table">
                <thead>
                    <tr>
                        <th>Item</th>
                        <th>Status</th>
                        <th>Starting Price</th>
                        <th>Current Bid</th>
                        <th>Bids</th>
                        <th>End Time</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        while (auctionsRs.next()) {
                            hasAuctions = true;
                            int auctionId = auctionsRs.getInt("auction_id");
                            int itemId = auctionsRs.getInt("item_id");
                            String status = auctionsRs.getString("status");
                            double startingPrice = auctionsRs.getDouble("starting_price");
                            String title = auctionsRs.getString("title");
                            String brand = auctionsRs.getString("brand");
                            String condition = auctionsRs.getString("condition");
                            Timestamp endTime = auctionsRs.getTimestamp("end_time");
                            int bidCount = auctionsRs.getInt("bid_count");
                            
                            Double currentBid = auctionsRs.getDouble("current_bid");
                            if (auctionsRs.wasNull()) {
                                currentBid = null;
                            }
                            
                            String statusClass = "";
                            if ("active".equals(status)) statusClass = "status-active";
                            else if ("closed".equals(status)) statusClass = "status-closed";
                            else statusClass = "status-upcoming";
                    %>
                    <tr>
                        <td>
                            <strong><%= title %></strong><br>
                            <small><%= brand %> - <%= condition %></small>
                        </td>
                        <td>
                            <span class="status-badge <%= statusClass %>"><%= status.toUpperCase() %></span>
                        </td>
                        <td class="price">$<%= String.format("%.2f", startingPrice) %></td>
                        <td class="price">
                            <%= currentBid != null ? "$" + String.format("%.2f", currentBid) : "No bids" %>
                        </td>
                        <td><%= bidCount %></td>
                        <td><%= endTime %></td>
                        <td>
                            <div class="action-buttons">
                                <% if (bidCount > 0) { %>
                                    <button class="btn-small btn-view" onclick="toggleBids(<%= auctionId %>)">View Bids</button>
                                <% } %>
                                <% if ("active".equals(status) && bidCount == 0) { %>
                                    <a href="editauction.jsp?auction_id=<%= auctionId %>" class="btn-small btn-edit">Edit</a>
                                <% } %>
                                <button class="btn-small btn-delete" onclick="confirmDelete(<%= auctionId %>, '<%= title %>')">Delete</button>
                            </div>
                        </td>
                    </tr>
                    <% if (bidCount > 0) { %>
                    <tr>
                        <td colspan="7" style="padding: 0;">
                            <div id="bids-<%= auctionId %>" class="bid-details">
                                <strong>Bid History:</strong>
                                <%
                                    PreparedStatement bidStmt = null;
                                    ResultSet bidRs = null;
                                    try {
                                        String bidQuery = "SELECT b.amount, b.bid_time, u.username " +
                                            "FROM Bid b JOIN User u ON b.buyer_id = u.user_id " +
                                            "WHERE b.auction_id = ? ORDER BY b.bid_time DESC";
                                        bidStmt = conn.prepareStatement(bidQuery);
                                        bidStmt.setInt(1, auctionId);
                                        bidRs = bidStmt.executeQuery();
                                        
                                        while (bidRs.next()) {
                                            double amount = bidRs.getDouble("amount");
                                            Timestamp bidTime = bidRs.getTimestamp("bid_time");
                                            String username = bidRs.getString("username");
                                %>
                                <div class="bid-item">
                                    <strong>$<%= String.format("%.2f", amount) %></strong> by <%= username %> at <%= bidTime %>
                                </div>
                                <%
                                        }
                                    } finally {
                                        if (bidRs != null) try { bidRs.close(); } catch (SQLException e) {}
                                        if (bidStmt != null) try { bidStmt.close(); } catch (SQLException e) {}
                                    }
                                %>
                            </div>
                        </td>
                    </tr>
                    <% } %>
                    <%
                        }
                        
                        if (!hasAuctions) {
                    %>
                    <tr>
                        <td colspan="7" class="no-auctions">
                            No auctions found. Click "Begin New Auction" to get started!
                        </td>
                    </tr>
                    <%
                        }
                    %>
                </tbody>
            </table>
            
            <%
            } catch (SQLException e) {
                e.printStackTrace();
            %>
                <p style="color: red; text-align: center;">Error loading auctions: <%= e.getMessage() %></p>
            <%
            } finally {
                if (statsRs != null) try { statsRs.close(); } catch (SQLException e) {}
                if (auctionsRs != null) try { auctionsRs.close(); } catch (SQLException e) {}
                if (statsStmt != null) try { statsStmt.close(); } catch (SQLException e) {}
                if (auctionsStmt != null) try { auctionsStmt.close(); } catch (SQLException e) {}
                if (conn != null) try { conn.close(); } catch (SQLException e) {}
            }
            %>
        </div>
    </div>
</body>
</html>