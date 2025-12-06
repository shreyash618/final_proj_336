<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
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
      background: url('Images/backgrounds/login_screen_background.jpg') no-repeat center center/cover;
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
            Class.forName("com.mysql.cj.jdbc.Driver");
            String url = "jdbc:mysql://localhost:3306/tech_barn?useUnicode=true&useSSL=false";
            String user = "root";
            String pass = "saad2012";
            con = DriverManager.getConnection(url, user, pass);

            int auctionIdInt = Integer.parseInt(auctionIdParam.trim());

            String sqlAuction =
                "SELECT a.auction_id, a.status, a.start_time, a.end_time, " +
                "       a.minimum_price, a.starting_price, a.increment, " +
                "       i.title, i.brand, i.condition, i.color, " +
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
                auctionInfo.put("title", rsAuction.getString("title"));
                auctionInfo.put("brand", rsAuction.getString("brand"));
                auctionInfo.put("condition", rsAuction.getString("condition"));
                auctionInfo.put("color", rsAuction.getString("color"));
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
            try { if (con != null) con.close(); } catch (Exception ignore) {}
        }
    }
%>

<div class="page-wrapper">
  <div class="left">
    <h1>View Auction</h1>
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

    <% if (errorMessage != null) { %>
      <div class="message error"><%= errorMessage %></div>
    <% } %>

    <a class="back-link" href="welcome.jsp">Back to Home</a>
  </div>

  <div class="right">
    <% if (auctionInfo != null && errorMessage == null) { %>
      <div class="section-title">Auction Details</div>
      <div class="info-box">
        <div class="info-row">
          <span>Item</span>
          <span><%= auctionInfo.get("title") %> (<%= auctionInfo.get("brand") %>)</span>
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
                Auction #<%= sim.get("auction_id") %> – <%= sim.get("title") %> (<%= sim.get("brand") %>)
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
      <p class="small-muted">Enter an auction ID on the left and click “Load Auction”.</p>
    <% } %>
  </div>
</div>

</body>
</html>
