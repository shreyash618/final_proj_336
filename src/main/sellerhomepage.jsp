<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="util.DBConnection" %>
<%
    // Check if user is logged in and is a seller
    if (session.getAttribute("user_id") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    Boolean isSeller = (Boolean) session.getAttribute("isSeller");
    if (isSeller == null || !isSeller) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    int userId = (Integer) session.getAttribute("user_id");
    String firstName = (String) session.getAttribute("first_name");
    String lastName = (String) session.getAttribute("last_name");
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
            max-width: 1200px;
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
        }
        
        .section-header h3 {
            color: #333;
            font-size: 20px;
        }
        
        .manage-link {
            color: #667eea;
            text-decoration: none;
            font-weight: 600;
        }
        
        .manage-link:hover {
            text-decoration: underline;
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
    </style>
</head>
<body>
    <div class="header">
        <h1>🛒 Tech Barn - Seller Dashboard</h1>
        <div class="header-right">
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
                <h3>Your Recent Auctions</h3>
                <a href="manageauctions.jsp" class="manage-link">Manage All Auctions →</a>
            </div>
            
            <%
                // Get recent auctions
                String auctionsQuery = "SELECT a.auction_id, a.status, a.starting_price, a.end_time, " +
                    "i.title, i.brand, i.condition, " +
                    "(SELECT MAX(amount) FROM Bid WHERE auction_id = a.auction_id) as current_bid, " +
                    "(SELECT COUNT(*) FROM Bid WHERE auction_id = a.auction_id) as bid_count " +
                    "FROM Auction a " +
                    "JOIN Item i ON a.item_id = i.item_id " +
                    "WHERE a.seller_id = ? " +
                    "ORDER BY a.start_time DESC LIMIT 5";
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
                    </tr>
                </thead>
                <tbody>
                    <%
                        while (auctionsRs.next()) {
                            hasAuctions = true;
                            int auctionId = auctionsRs.getInt("auction_id");
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
                    </tr>
                    <%
                        }
                        
                        if (!hasAuctions) {
                    %>
                    <tr>
                        <td colspan="6" class="no-auctions">
                            No auctions yet. Click "Begin New Auction" to get started!
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