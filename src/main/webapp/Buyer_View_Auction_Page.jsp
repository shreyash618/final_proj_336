<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="com.techbarn.webapp.ApplicationDB" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Tech Barn - View Auction</title>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet">
  <style>
    * {
      margin: 0;
      padding: 0;
      box-sizing: border-box;
      font-family: 'Inter', sans-serif;
    }

    body, html {
      height: 100%;
      width: 100%;
      background: url('Images/backgrounds/login_screen_background') no-repeat center center/cover;
      background-attachment: fixed;
      display: flex;
      justify-content: center;
      align-items: center;
    }

    .page-wrapper {
      width: 100%;
      max-width: 900px;
      background: #ffffff;
      border-radius: 20px;
      padding: 2.5rem 2.5rem 2rem;
      box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
      display: flex;
      gap: 2rem;
    }

    .left {
      flex: 1;
    }

    .right {
      flex: 1.2;
    }

    h1 {
      margin-bottom: 0.5rem;
      color: #2d3748;
      font-weight: 700;
      font-size: 2rem;
      letter-spacing: -0.5px;
    }

    .subtitle {
      font-size: 0.9rem;
      color: #718096;
      margin-bottom: 1.2rem;
    }

    label {
      display: block;
      font-size: 0.9rem;
      font-weight: 600;
      color: #4a5568;
      margin-top: 6px;
    }

    .form-input {
      width: 100%;
      padding: 12px 16px;
      margin: 6px 0 12px 0;
      border: 2px solid #e2e8f0;
      border-radius: 10px;
      font-size: 1rem;
      outline: none;
      transition: all 0.3s ease;
      background: #f7fafc;
      color: #2d3748;
    }

    .form-input:focus {
      border-color: #667eea;
      background: #ffffff;
      box-shadow: 0 0 0 4px rgba(102, 126, 234, 0.1);
      transform: translateY(-1px);
    }

    .submit-button {
      width: 100%;
      padding: 12px;
      margin-top: 6px;
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      color: #fff;
      font-size: 1rem;
      font-weight: 600;
      border: none;
      border-radius: 10px;
      cursor: pointer;
      transition: all 0.3s ease;
      box-shadow: 0 4px 15px rgba(102, 126, 234, 0.4);
    }

    .submit-button:hover {
      transform: translateY(-2px);
      box-shadow: 0 6px 20px rgba(102, 126, 234, 0.5);
    }

    .message {
      margin-top: 10px;
      padding: 10px 12px;
      border-radius: 8px;
      font-size: 0.9rem;
      font-weight: 500;
    }

    .message.error {
      background: #fed7d7;
      color: #742a2a;
      border: 1px solid #fc8181;
    }

    .message.success {
      background: #c6f6d5;
      color: #22543d;
      border: 1px solid #9ae6b4;
    }

    .section-title {
      font-size: 1rem;
      font-weight: 600;
      color: #2d3748;
      margin-bottom: 0.35rem;
      margin-top: 0.75rem;
    }

    .info-box {
      background: #f7fafc;
      border-radius: 10px;
      padding: 10px 14px;
      border: 1px solid #e2e8f0;
      font-size: 0.9rem;
      color: #2d3748;
      margin-bottom: 0.5rem;
    }

    .info-row {
      display: flex;
      justify-content: space-between;
      margin: 2px 0;
    }

    .info-row span:first-child {
      color: #718096;
    }

    .small-muted {
      font-size: 0.8rem;
      color: #a0aec0;
      margin-top: 3px;
    }

    ul {
      list-style: none;
      padding-left: 0;
      margin-top: 4px;
      font-size: 0.9rem;
    }

    li {
      margin-bottom: 4px;
    }

    .tag {
      display: inline-block;
      font-size: 0.75rem;
      padding: 2px 6px;
      border-radius: 999px;
      background: #ebf4ff;
      color: #4c51bf;
      margin-left: 4px;
    }

    .back-link {
      margin-top: 16px;
      font-size: 0.9rem;
      color: #667eea;
      text-decoration: none;
      display: inline-block;
    }

    .back-link:hover {
      color: #764ba2;
      text-decoration: underline;
    }

    a {
      transition: color 0.2s ease;
    }

    a:hover {
      text-decoration: underline;
    }

    .item-preview {
      background: #ffffff;
      border: 2px solid #e2e8f0;
      border-radius: 12px;
      padding: 16px;
      margin-bottom: 20px;
      display: flex;
      flex-direction: column;
      gap: 16px;
      align-items: center;
    }

    .item-preview-image {
      flex-shrink: 0;
      width: 100%;
      max-width: 200px;
      height: 180px;
      border-radius: 8px;
      overflow: hidden;
      background: #f7fafc;
      display: flex;
      align-items: center;
      justify-content: center;
      margin: 0 auto;
    }

    .item-preview-image img {
      width: 100%;
      height: 100%;
      object-fit: contain;
    }

    .item-preview-content {
      width: 100%;
      text-align: center;
    }

    .item-preview-title {
      font-size: 1.1rem;
      font-weight: 700;
      color: #2d3748;
      margin-bottom: 8px;
      line-height: 1.3;
    }

    .item-preview-title a {
      color: #2d3748;
      text-decoration: none;
    }

    .item-preview-title a:hover {
      color: #667eea;
      text-decoration: underline;
    }

    .item-preview-specs {
      font-size: 0.85rem;
      color: #718096;
      line-height: 1.6;
      margin-bottom: 8px;
      display: flex;
      flex-direction: column;
      gap: 4px;
      align-items: center;
    }

    .item-preview-specs span {
      display: block;
    }

    .item-preview-description {
      font-size: 0.85rem;
      color: #4a5568;
      line-height: 1.5;
      margin-top: 8px;
      display: -webkit-box;
      -webkit-line-clamp: 2;
      line-clamp: 2;
      -webkit-box-orient: vertical;
      overflow: hidden;
    }

    .stock-badge {
      display: inline-block;
      padding: 2px 8px;
      border-radius: 12px;
      font-size: 0.75rem;
      font-weight: 600;
      text-transform: uppercase;
      margin-top: 4px;
    }

    .stock-badge.in-stock {
      background: #c6f6d5;
      color: #22543d;
    }

    .stock-badge.out-of-stock {
      background: #fed7d7;
      color: #742a2a;
    }

    .view-full-item {
      margin-top: 12px;
      display: inline-block;
      font-size: 0.85rem;
      color: #667eea;
      text-decoration: none;
      font-weight: 600;
    }

    .view-full-item:hover {
      text-decoration: underline;
      color: #764ba2;
    }

    .section-label {
      font-size: 0.9rem;
      font-weight: 600;
      color: #4a5568;
      margin: 20px 0 12px 0;
    }

    .divider-line {
      width: 100%;
      height: 1px;
      background: #e2e8f0;
      margin: 20px 0;
    }

    @media (max-width: 900px) {
      body, html {
        align-items: flex-start;
        padding: 1rem;
      }
      .page-wrapper {
        margin-top: 2rem;
        flex-direction: column;
      }
    }
  </style>
</head>
<body>

<%
    String auctionIdParam = request.getParameter("auctionId");
    String errorMessage = null;
    String successMsg = null;
    
    // Handle bid submission
    String submitBid = request.getParameter("submitBid");
    if ("true".equals(submitBid) && "POST".equalsIgnoreCase(request.getMethod())) {
        String bidAmountStr = request.getParameter("bidAmount");
        Integer sessionUserId = (Integer) session.getAttribute("user_id");
        
        if (sessionUserId == null) {
            errorMessage = "You must be logged in to place a bid.";
        } else if (bidAmountStr == null || bidAmountStr.trim().isEmpty()) {
            errorMessage = "Bid amount is required.";
        } else {
            Connection conBid = null;
            PreparedStatement psCheck = null;
            ResultSet rsCheck = null;
            PreparedStatement psInsert = null;
            
            try {
                int auctionId = Integer.parseInt(auctionIdParam.trim());
                java.math.BigDecimal bidAmount = new java.math.BigDecimal(bidAmountStr.trim());
                
                conBid = ApplicationDB.getConnection();
                
                // Validate bid amount
                String checkSql = "SELECT a.minimum_price, a.starting_price, a.increment, " +
                                 "COALESCE(MAX(b.amount), a.starting_price) AS current_price " +
                                 "FROM Auction a " +
                                 "LEFT JOIN Bid b ON a.auction_id = b.auction_id " +
                                 "WHERE a.auction_id = ? " +
                                 "GROUP BY a.minimum_price, a.starting_price, a.increment";
                
                psCheck = conBid.prepareStatement(checkSql);
                psCheck.setInt(1, auctionId);
                rsCheck = psCheck.executeQuery();
                
                if (rsCheck.next()) {
                    java.math.BigDecimal minimumPrice = rsCheck.getBigDecimal("minimum_price");
                    java.math.BigDecimal currentPrice = rsCheck.getBigDecimal("current_price");
                    java.math.BigDecimal increment = rsCheck.getBigDecimal("increment");
                    
                    if (minimumPrice != null && bidAmount.compareTo(minimumPrice) < 0) {
                        errorMessage = "Your bid must be at least the minimum price ($" + minimumPrice + ").";
                    } else if (increment != null && increment.compareTo(java.math.BigDecimal.ZERO) > 0) {
                        java.math.BigDecimal minAllowed = currentPrice.add(increment);
                        if (bidAmount.compareTo(minAllowed) < 0) {
                            errorMessage = "Your bid must be at least current price + increment (>= $" + minAllowed + ").";
                        }
                    }
                    
                    if (errorMessage == null) {
                        // Insert bid
                        String insertSql = "INSERT INTO Bid (auction_id, buyer_id, amount, bid_time, status) " +
                                          "VALUES (?, ?, ?, ?, ?)";
                        psInsert = conBid.prepareStatement(insertSql);
                        psInsert.setInt(1, auctionId);
                        psInsert.setInt(2, sessionUserId);
                        psInsert.setBigDecimal(3, bidAmount);
                        psInsert.setTimestamp(4, new Timestamp(System.currentTimeMillis()));
                        psInsert.setString(5, "ACTIVE");
                        psInsert.executeUpdate();
                        
                        // Close resources before redirect
                        if (psInsert != null) { psInsert.close(); }
                        if (rsCheck != null) { rsCheck.close(); }
                        if (psCheck != null) { psCheck.close(); }
                        if (conBid != null) { ApplicationDB.closeConnection(conBid); }
                        
                        // Redirect to avoid duplicate submissions and refresh bid history
                        response.sendRedirect("Buyer_View_Auction_Page.jsp?auctionId=" + auctionId + "&bidSuccess=true");
                        return;
                    }
                } else {
                    errorMessage = "Auction not found.";
                }
                
            } catch (Exception e) {
                errorMessage = "Error placing bid: " + e.getMessage();
            } finally {
                // Ensure all resources are closed
                try { if (psInsert != null) psInsert.close(); } catch (Exception ignore) {}
                try { if (rsCheck != null) rsCheck.close(); } catch (Exception ignore) {}
                try { if (psCheck != null) psCheck.close(); } catch (Exception ignore) {}
                try { if (conBid != null) ApplicationDB.closeConnection(conBid); } catch (Exception ignore) {}
            }
        }
    }
    
    // Check for success message from redirect
    if ("true".equals(request.getParameter("bidSuccess"))) {
        successMsg = "Your bid has been placed successfully!";
    }

    Map<String, Object> auctionInfo = null;
    java.util.List<Map<String, Object>> bidHistory = new ArrayList<>();
    java.util.List<Map<String, Object>> similarAuctions = new ArrayList<>();

    if (auctionIdParam != null && !auctionIdParam.trim().isEmpty()) {
        Connection con = null;
        PreparedStatement psAuction = null;
        PreparedStatement psBids = null;
        PreparedStatement psSimilar = null;
        ResultSet rsAuction = null;
        ResultSet rsBids = null;
        ResultSet rsSimilar = null;

        try {
            con = ApplicationDB.getConnection();

            int auctionIdInt = Integer.parseInt(auctionIdParam.trim());

            String sqlAuction =
                "SELECT a.auction_id, a.status, a.start_time, a.end_time, " +
                "       a.minimum_price, a.starting_price, a.increment, " +
                "       i.item_id, i.title, i.brand, i.condition, i.color, " +
                "       i.image_path, i.description, i.in_stock, i.category_id, " +
                "       u.username AS seller_username " +
                "FROM Auction a " +
                "JOIN Item i ON a.item_id = i.item_id " +
                "JOIN `User` u ON a.seller_id = u.user_id " +
                "WHERE a.auction_id = ?";

            psAuction = con.prepareStatement(sqlAuction);
            psAuction.setInt(1, auctionIdInt);
            rsAuction = psAuction.executeQuery();

            if (rsAuction.next()) {
                auctionInfo = new HashMap<>();
                auctionInfo.put("auction_id", rsAuction.getInt("auction_id"));
                auctionInfo.put("status", rsAuction.getString("status"));
                auctionInfo.put("start_time", rsAuction.getTimestamp("start_time"));
                auctionInfo.put("end_time", rsAuction.getTimestamp("end_time"));
                auctionInfo.put("minimum_price", rsAuction.getBigDecimal("minimum_price"));
                auctionInfo.put("starting_price", rsAuction.getBigDecimal("starting_price"));
                auctionInfo.put("increment", rsAuction.getBigDecimal("increment"));
                auctionInfo.put("item_id", rsAuction.getInt("item_id"));
                auctionInfo.put("title", rsAuction.getString("title"));
                auctionInfo.put("brand", rsAuction.getString("brand"));
                auctionInfo.put("condition", rsAuction.getString("condition"));
                auctionInfo.put("color", rsAuction.getString("color"));
                auctionInfo.put("image_path", rsAuction.getString("image_path"));
                auctionInfo.put("description", rsAuction.getString("description"));
                auctionInfo.put("in_stock", rsAuction.getBoolean("in_stock"));
                auctionInfo.put("category_id", rsAuction.getInt("category_id"));
                auctionInfo.put("seller_username", rsAuction.getString("seller_username"));
            } else {
                errorMessage = "No auction found with ID " + auctionIdParam;
            }

            if (auctionInfo != null) {
                String sqlBids =
                    "SELECT b.bid_no, b.amount, b.bid_time, b.status, u.username " +
                    "FROM Bid b " +
                    "JOIN `User` u ON b.buyer_id = u.user_id " +
                    "WHERE b.auction_id = ? " +
                    "ORDER BY b.bid_time DESC";

                psBids = con.prepareStatement(sqlBids);
                psBids.setInt(1, auctionIdInt);
                rsBids = psBids.executeQuery();

                while (rsBids.next()) {
                    Map<String, Object> row = new HashMap<>();
                    row.put("bid_no", rsBids.getInt("bid_no"));
                    row.put("amount", rsBids.getBigDecimal("amount"));
                    row.put("bid_time", rsBids.getTimestamp("bid_time"));
                    row.put("status", rsBids.getString("status"));
                    row.put("buyer_username", rsBids.getString("username"));
                    bidHistory.add(row);
                }

                String sqlSimilar =
                    "SELECT a2.auction_id, i2.title, i2.brand, i2.condition, a2.starting_price " +
                    "FROM Auction a2 " +
                    "JOIN Item i2 ON a2.item_id = i2.item_id " +
                    "WHERE i2.category_id = ( " +
                    "    SELECT i.category_id " +
                    "    FROM Auction a " +
                    "    JOIN Item i ON a.item_id = i.item_id " +
                    "    WHERE a.auction_id = ? " +
                    ") " +
                    "AND a2.auction_id <> ? " +
                    "AND a2.status = 'ACTIVE' " +
                    "LIMIT 5";

                psSimilar = con.prepareStatement(sqlSimilar);
                psSimilar.setInt(1, auctionIdInt);
                psSimilar.setInt(2, auctionIdInt);
                rsSimilar = psSimilar.executeQuery();

                while (rsSimilar.next()) {
                    Map<String, Object> row = new HashMap<>();
                    row.put("auction_id", rsSimilar.getInt("auction_id"));
                    row.put("title", rsSimilar.getString("title"));
                    row.put("brand", rsSimilar.getString("brand"));
                    row.put("condition", rsSimilar.getString("condition"));
                    row.put("starting_price", rsSimilar.getBigDecimal("starting_price"));
                    similarAuctions.add(row);
                }
            }

        } catch (Exception e) {
            errorMessage = "Error loading auction: " + e.getMessage();
        } finally {
            try { if (rsSimilar != null) rsSimilar.close(); } catch (Exception ignore) {}
            try { if (rsBids != null) rsBids.close(); } catch (Exception ignore) {}
            try { if (rsAuction != null) rsAuction.close(); } catch (Exception ignore) {}
            try { if (psSimilar != null) psSimilar.close(); } catch (Exception ignore) {}
            try { if (psBids != null) psBids.close(); } catch (Exception ignore) {}
            try { if (psAuction != null) psAuction.close(); } catch (Exception ignore) {}
            try { if (con != null) ApplicationDB.closeConnection(con); } catch (Exception ignore) {}
        }
    }
%>

<div class="page-wrapper">
  <div class="left">
    <% if (auctionIdParam == null || auctionIdParam.isEmpty()) { %>
    <h1>View Auction</h1>
    
    <% if (auctionInfo != null && errorMessage == null) { %>
      <div class="item-preview-image" style="margin-bottom: 20px;">
        <%
          String imagePath = (String) auctionInfo.get("image_path");
          if (imagePath == null || imagePath.isEmpty()) {
            // Default image based on category
            Integer categoryId = (Integer) auctionInfo.get("category_id");
            if (categoryId != null) {
              if (categoryId == 1) {
                imagePath = "Images/item_photos/z_stock/stock_phone.jpg";
              } else if (categoryId == 2) {
                imagePath = "Images/item_photos/z_stock/stock_tv.png";
              } else if (categoryId == 3) {
                imagePath = "Images/item_photos/z_stock/stock_headphones.jpg";
              } else {
                imagePath = "Images/item_photos/z_stock/stock_phone.jpg"; // fallback
              }
            } else {
              imagePath = "Images/item_photos/z_stock/stock_phone.jpg"; // fallback
            }
          }
        %>
        <img src="<%= imagePath %>" alt="<%= auctionInfo.get("title") %>">
      </div>
      <div class="divider-line"></div>
    <% } %>
    
    <div class="section-label">Auction Lookup</div>
    <p class="subtitle">Enter an auction ID to see details, pricing, and bid history.</p>

    <form method="get" action="Buyer_View_Auction_Page.jsp">
      <label for="auctionId">Auction ID</label>
      <input type="number"
             id="auctionId"
             name="auctionId"
             class="form-input"
             placeholder="e.g. 1"
             value="<%= auctionIdParam != null ? auctionIdParam : "" %>"
             required />

      <button type="submit" class="submit-button">Load Auction</button>
    </form>
    <% } else { %>
    <h1>Auction #<%= auctionIdParam %></h1>
    <p class="subtitle">View auction details and place your bid below.</p>
    
    <% if (auctionInfo != null && errorMessage == null) { %>
      <div class="item-preview-image" style="margin-bottom: 20px;">
        <%
          String imagePath = (String) auctionInfo.get("image_path");
          if (imagePath == null || imagePath.isEmpty()) {
            // Default image based on category
            Integer categoryId = (Integer) auctionInfo.get("category_id");
            if (categoryId != null) {
              if (categoryId == 1) {
                imagePath = "Images/item_photos/z_stock/stock_phone.jpg";
              } else if (categoryId == 2) {
                imagePath = "Images/item_photos/z_stock/stock_tv.png";
              } else if (categoryId == 3) {
                imagePath = "Images/item_photos/z_stock/stock_headphones.jpg";
              } else {
                imagePath = "Images/item_photos/z_stock/stock_phone.jpg"; // fallback
              }
            } else {
              imagePath = "Images/item_photos/z_stock/stock_phone.jpg"; // fallback
            }
          }
        %>
        <img src="<%= imagePath %>" alt="<%= auctionInfo.get("title") %>">
      </div>
      <div class="divider-line"></div>
    <% } %>
    <% } %>

    <% if (errorMessage != null) { %>
      <div class="message error"><%= errorMessage %></div>
    <% } %>
    
    <% if (successMsg != null) { %>
      <div class="message success"><%= successMsg %></div>
    <% } %>

    <a class="back-link" href="welcome.jsp">Back to Home</a>
    
    <% if (auctionInfo != null && errorMessage == null) { %>
      <a class="back-link" href="Buyer_Create_Bid_Page.jsp?auctionId=<%= auctionInfo.get("auction_id") %>" 
         style="display: block; margin-top: 8px;">
        Create New Bid
      </a>
    <% } %>
  </div>

  <div class="right">
    <% if (auctionInfo != null && errorMessage == null) { %>
      <div class="section-title">Auction Details</div>
      <div class="info-box">
        <div class="info-row">
          <span>Item</span>
          <span><a href="item?itemId=<%= auctionInfo.get("item_id") %>" style="color: #667eea; text-decoration: none;"><%= auctionInfo.get("title") %></a> (<%= auctionInfo.get("brand") %>)</span>
        </div>
        <div class="info-row">
          <span>Condition</span>
          <span><%= auctionInfo.get("condition") %>, <%= auctionInfo.get("color") %></span>
        </div>
        <div class="info-row">
          <span>Seller</span>
          <span><%= auctionInfo.get("seller_username") %></span>
        </div>
        <div class="info-row">
          <span>Status</span>
          <span><%= auctionInfo.get("status") %></span>
        </div>
        <div class="info-row">
          <span>Min Price</span>
          <span>$<%= auctionInfo.get("minimum_price") %></span>
        </div>
        <div class="info-row">
          <span>Starting Price</span>
          <span>$<%= auctionInfo.get("starting_price") %></span>
        </div>
        <div class="info-row">
          <span>Increment</span>
          <span>$<%= auctionInfo.get("increment") %></span>
        </div>
        <p class="small-muted">
          Starts: <%= auctionInfo.get("start_time") %> · Ends: <%= auctionInfo.get("end_time") %>
        </p>
      </div>

      <div class="section-title">Place Your Bid</div>
      <div class="info-box">
        <% if ("ACTIVE".equalsIgnoreCase(String.valueOf(auctionInfo.get("status")))) { %>
          <form method="post" action="Buyer_View_Auction_Page.jsp">
            <input type="hidden" name="auctionId" value="<%= auctionIdParam %>" />
            <input type="hidden" name="submitBid" value="true" />
            
            <label for="bidAmount">Bid Amount ($)</label>
            <input type="number" 
                   id="bidAmount" 
                   name="bidAmount" 
                   class="form-input"
                   min="<%= auctionInfo.get("starting_price") %>"
                   step="<%= auctionInfo.get("increment") %>"
                   placeholder="Enter your bid amount"
                   required />
            
            <p class="small-muted">
              Minimum bid: $<%= auctionInfo.get("starting_price") %> · 
              Increment: $<%= auctionInfo.get("increment") %>
            </p>
            
            <button type="submit" class="submit-button">Place Bid</button>
          </form>
        <% } else { %>
          <p class="small-muted">This auction is <%= auctionInfo.get("status") %> and not accepting bids.</p>
        <% } %>
      </div>

      <div class="section-title">Bid History</div>
      <div class="info-box">
        <% if (bidHistory.isEmpty()) { %>
          <p>No bids yet. Be the first to bid!</p>
        <% } else { %>
          <ul>
            <% 
              int index = 0;
              for (Map<String, Object> bid : bidHistory) { 
            %>
              <li>
                $<%= bid.get("amount") %> by <%= bid.get("buyer_username") %>
                <span class="tag"><%= bid.get("status") %></span><br/>
                <span class="small-muted">
                  Bid #<%= bid.get("bid_no") %> · <%= bid.get("bid_time") %>
                </span>
              </li>
            <% 
                index++;
              } 
            %>
          </ul>
        <% } %>
      </div>

      <div class="section-title">Similar Items</div>
      <div class="info-box">
        <% if (similarAuctions.isEmpty()) { %>
          <p>No similar active auctions found.</p>
        <% } else { %>
          <ul>
            <% for (Map<String, Object> sim : similarAuctions) { %>
              <li>
                <a href="Buyer_View_Auction_Page.jsp?auctionId=<%= sim.get("auction_id") %>" style="color: #667eea; text-decoration: none; font-weight: 600;">
                  Auction #<%= sim.get("auction_id") %> – <%= sim.get("title") %> (<%= sim.get("brand") %>)
                </a>
                <br />
                <span class="small-muted">
                  Condition: <%= sim.get("condition") %> · Starting at $<%= sim.get("starting_price") %>
                </span>
              </li>
            <% } %>
          </ul>
        <% } %>
      </div>
    <% } else { %>
      <p class="small-muted">Enter an auction ID on the left and click "Load Auction".</p>
    <% } %>
  </div>
</div>

</body>
</html>
