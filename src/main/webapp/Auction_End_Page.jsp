<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Tech Barn - Auction Result</title>
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
      background: #f7fafc;
      display: flex;
      justify-content: center;
      align-items: center;
    }

    .card {
      width: 100%;
      max-width: 520px;
      background: #ffffff;
      border-radius: 20px;
      padding: 2.5rem 2.5rem 2rem;
      box-shadow: 0 20px 50px rgba(15, 23, 42, 0.18);
    }

    h1 {
      margin-bottom: 0.6rem;
      color: #1f2933;
      font-weight: 700;
      font-size: 1.9rem;
      letter-spacing: -0.4px;
    }

    .subtitle {
      font-size: 0.9rem;
      color: #6b7280;
      margin-bottom: 1.3rem;
    }

    label {
      display: block;
      font-size: 0.85rem;
      font-weight: 600;
      color: #4b5563;
      margin-bottom: 4px;
    }

    .form-input {
      width: 100%;
      padding: 12px 16px;
      margin-bottom: 12px;
      border-radius: 10px;
      border: 2px solid #e5e7eb;
      background: #f9fafb;
      font-size: 0.95rem;
      outline: none;
      transition: all 0.2s ease;
    }

    .form-input:focus {
      border-color: #6366f1;
      background: #ffffff;
      box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.15);
    }

    .submit-button {
      width: 100%;
      padding: 12px;
      border-radius: 10px;
      border: none;
      cursor: pointer;
      font-size: 0.95rem;
      font-weight: 600;
      color: #ffffff;
      background: linear-gradient(135deg, #6366f1, #8b5cf6);
      box-shadow: 0 8px 20px rgba(99, 102, 241, 0.4);
      transition: all 0.2s ease;
      margin-top: 4px;
    }

    .submit-button:hover {
      transform: translateY(-1px);
      box-shadow: 0 10px 24px rgba(99, 102, 241, 0.5);
    }

    .message {
      margin-top: 12px;
      padding: 10px 12px;
      border-radius: 9px;
      font-size: 0.9rem;
      font-weight: 500;
    }

    .message.error {
      background: #fee2e2;
      border: 1px solid #fecaca;
      color: #b91c1c;
    }

    .message.info {
      background: #eff6ff;
      border: 1px solid #bfdbfe;
      color: #1d4ed8;
    }

    .message.success {
      background: #dcfce7;
      border: 1px solid #bbf7d0;
      color: #166534;
    }

    .section-title {
      margin-top: 1.1rem;
      margin-bottom: 0.4rem;
      font-size: 0.95rem;
      font-weight: 600;
      color: #111827;
    }

    .info-box {
      border-radius: 10px;
      border: 1px solid #e5e7eb;
      background: #f9fafb;
      padding: 10px 12px;
      font-size: 0.9rem;
      color: #374151;
    }

    .info-row {
      display: flex;
      justify-content: space-between;
      margin: 3px 0;
    }

    .info-row span:first-child {
      color: #6b7280;
    }

    .winner-name {
      font-weight: 700;
    }

    .amount {
      font-weight: 600;
    }

    .small-muted {
      font-size: 0.8rem;
      color: #9ca3af;
      margin-top: 4px;
    }

    .back-link {
      margin-top: 16px;
      display: inline-block;
      font-size: 0.9rem;
      color: #6366f1;
      text-decoration: none;
    }

    .back-link:hover {
      text-decoration: underline;
      color: #4f46e5;
    }
  </style>
</head>
<body>

<%
    String auctionIdParam = request.getParameter("auctionId");
    String errorMessage = null;

    boolean auctionFound = false;
    boolean isEnded = false;
    String itemTitle = null;
    String auctionStatus = null;
    java.sql.Timestamp endTime = null;

    boolean hasBids = false;
    String winnerUsername = null;
    java.math.BigDecimal winningAmount = null;

    if (auctionIdParam != null && !auctionIdParam.trim().isEmpty()) {
        Connection con = null;
        PreparedStatement psAuction = null;
        PreparedStatement psWinner = null;
        ResultSet rsAuction = null;
        ResultSet rsWinner = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            String url  = "jdbc:mysql://localhost:3306/tech_barn?useUnicode=true&useSSL=false";
            String user = "root";
            String pass = "saad2012";

            con = DriverManager.getConnection(url, user, pass);

            int auctionIdInt = Integer.parseInt(auctionIdParam.trim());

            String sqlAuction =
                "SELECT a.auction_id, a.status, a.end_time, i.title " +
                "FROM Auction a " +
                "JOIN Item i ON a.item_id = i.item_id " +
                "WHERE a.auction_id = ?";

            psAuction = con.prepareStatement(sqlAuction);
            psAuction.setInt(1, auctionIdInt);
            rsAuction = psAuction.executeQuery();

            if (rsAuction.next()) {
                auctionFound = true;
                auctionStatus = rsAuction.getString("status");
                endTime = rsAuction.getTimestamp("end_time");
                itemTitle = rsAuction.getString("title");

                java.util.Date now = new java.util.Date();
                boolean timeEnded = (endTime != null && endTime.before(now));

                boolean statusEnded = false;
                if (auctionStatus != null) {
                    String s = auctionStatus.toUpperCase(Locale.ROOT);
                    statusEnded = s.equals("CLOSED") || s.equals("FINISHED") || s.equals("ENDED");
                }
                isEnded = timeEnded || statusEnded;

                String sqlWinner =
                    "SELECT b.amount, u.username " +
                    "FROM Bid b " +
                    "JOIN `User` u ON b.buyer_id = u.user_id " +
                    "WHERE b.auction_id = ? " +
                    "ORDER BY b.amount DESC, b.bid_time ASC " +
                    "LIMIT 1";

                psWinner = con.prepareStatement(sqlWinner);
                psWinner.setInt(1, auctionIdInt);
                rsWinner = psWinner.executeQuery();

                if (rsWinner.next()) {
                    hasBids = true;
                    winningAmount = rsWinner.getBigDecimal("amount");
                    winnerUsername = rsWinner.getString("username");
                }
            } else {
                errorMessage = "No auction found with ID " + auctionIdParam;
            }

        } catch (Exception e) {
            errorMessage = "Error loading auction result: " + e.getMessage();
        } finally {
            try { if (rsWinner != null) rsWinner.close(); } catch (Exception ignore) {}
            try { if (rsAuction != null) rsAuction.close(); } catch (Exception ignore) {}
            try { if (psWinner != null) psWinner.close(); } catch (Exception ignore) {}
            try { if (psAuction != null) psAuction.close(); } catch (Exception ignore) {}
            try { if (con != null) con.close(); } catch (Exception ignore) {}
        }
    }
%>

<div class="card">
  <h1>Auction Result</h1>
  <p class="subtitle">Enter an auction ID to see if it has ended and who the winner is.</p>

  <form method="get" action="Auction_End_Page.jsp">
    <label for="auctionId">Auction ID</label>
    <input type="number"
           id="auctionId"
           name="auctionId"
           class="form-input"
           placeholder="e.g. 1"
           value="<%= auctionIdParam != null ? auctionIdParam : "" %>"
           required />

    <button type="submit" class="submit-button">Show Result</button>
  </form>

  <% if (errorMessage != null) { %>
    <div class="message error"><%= errorMessage %></div>
  <% } %>

  <% if (auctionFound && errorMessage == null) { %>
    <div class="section-title">Auction Info</div>
    <div class="info-box">
      <div class="info-row">
        <span>Item</span>
        <span><%= itemTitle %></span>
      </div>
      <div class="info-row">
        <span>Status</span>
        <span><%= auctionStatus %></span>
      </div>
      <div class="info-row">
        <span>End Time</span>
        <span><%= endTime %></span>
      </div>
      <p class="small-muted">
        An auction is treated as "ended" if the end time has passed
        or the status is CLOSED / FINISHED / ENDED.
      </p>
    </div>

    <% if (!isEnded) { %>
      <div class="message info" style="margin-top:10px;">
        This auction has <strong>not ended yet</strong>. No winner is available.
      </div>
    <% } else if (!hasBids) { %>
      <div class="message info" style="margin-top:10px;">
        The auction has ended, but there were <strong>no bids</strong>.
      </div>
    <% } else { %>
      <div class="section-title">Winner</div>
      <div class="info-box">
        <div class="info-row">
          <span>Winner</span>
          <span class="winner-name"><%= winnerUsername %></span>
        </div>
        <div class="info-row">
          <span>Winning Bid</span>
          <span class="amount">$<%= winningAmount %></span>
        </div>
      </div>
      <div class="message success" style="margin-top:10px;">
        The auction has ended. <span class="winner-name"><%= winnerUsername %></span>
        won the item "<%= itemTitle %>" with a bid of
        <span class="amount">$<%= winningAmount %></span>.
      </div>
    <% } %>
  <% } %>

  <a href="welcome.jsp" class="back-link">Back to Home</a>
</div>

</body>
</html>
