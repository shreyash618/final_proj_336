<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="com.techbarn.webapp.ApplicationDB" %>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Tech Barn - Place a Bid</title>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet">
  <style>
    * { margin:0; padding:0; box-sizing:border-box; font-family:'Inter',sans-serif; }
    body,html{
      height:100%; width:100%;
      background:url('Images/devices4.jpg') no-repeat center center/cover;
      background-attachment:fixed;
      display:flex; justify-content:center; align-items:center;
    }
    .card{
      width:100%; max-width:520px;
      background:#fff; border-radius:20px;
      padding:2.5rem 2.5rem 2rem 2.5rem;
      box-shadow:0 20px 60px rgba(0,0,0,.35);
    }
    h1{margin-bottom:.5rem;color:#2d3748;font-weight:700;font-size:2rem;letter-spacing:-.5px;}
    .subtitle{font-size:.9rem;color:#718096;margin-bottom:1.5rem;}
    label{display:block;font-size:.9rem;font-weight:600;color:#4a5568;margin-bottom:.25rem;}
    .form-input{
      width:100%; padding:12px 16px; margin-bottom:1rem;
      border:2px solid #e2e8f0; border-radius:10px;
      font-size:.95rem; background:#f7fafc; color:#2d3748;
      outline:none; transition:all .2s ease;
    }
    .form-input:focus{
      border-color:#667eea;background:#fff;
      box-shadow:0 0 0 4px rgba(102,126,234,.1);
      transform:translateY(-1px);
    }
    .primary-btn{
      width:100%; padding:12px 18px; margin-top:.25rem;
      background:linear-gradient(135deg,#667eea 0%,#764ba2 100%);
      color:#fff; font-size:.95rem; font-weight:600;
      border:none;border-radius:10px; cursor:pointer;
      box-shadow:0 4px 15px rgba(102,126,234,.4);
      transition:all .2s ease;
    }
    .primary-btn:hover{transform:translateY(-1px);box-shadow:0 6px 20px rgba(102,126,234,.5);}
    .message{margin-top:1rem;padding:10px 12px;border-radius:8px;font-size:.9rem;font-weight:500;}
    .message.error{background:#fed7d7;color:#742a2a;border:1px solid #fc8181;}
    .message.success{background:#c6f6d5;color:#22543d;border:1px solid #9ae6b4;}
    .helper-text{font-size:.85rem;color:#718096;margin-top:.4rem;}
    .footer-link{display:inline-block;margin-top:1.2rem;font-size:.9rem;color:#667eea;text-decoration:none;}
    .footer-link:hover{text-decoration:underline;color:#764ba2;}
  </style>
</head>
<body>

<%
    String method = request.getMethod();
    String msgError = null;
    String msgSuccess = null;

    Integer auctionId = null;
    BigDecimal bidAmount = null;

    if ("POST".equalsIgnoreCase(method)) {
        String auctionIdStr = request.getParameter("auctionId");
        String bidAmountStr = request.getParameter("bidAmount");

        // Require login
        Integer userId = (Integer) session.getAttribute("userId");
        if (userId == null) {
            msgError = "You must be logged in to place a bid.";
        } else {
            try {
                auctionId = Integer.parseInt(auctionIdStr.trim());
                bidAmount = new BigDecimal(bidAmountStr.trim());
            } catch (Exception ex) {
                msgError = "Auction ID and Bid Amount must be valid numbers.";
            }

            if (msgError == null) {
                Connection conn = null;
                PreparedStatement psInfo = null;
                PreparedStatement psInsert = null;
                ResultSet rs = null;

                try {
                    ApplicationDB db = new ApplicationDB();
                    conn = db.getConnection();

                    String infoSql =
                        "SELECT a.status, a.minimum_price, a.starting_price, a.increment, " +
                        "       COALESCE(MAX(CASE WHEN b.status='ACTIVE' THEN b.amount END), a.starting_price) AS current_price " +
                        "FROM Auction a " +
                        "LEFT JOIN Bid b ON a.auction_id = b.auction_id " +
                        "WHERE a.auction_id = ? " +
                        "GROUP BY a.status, a.minimum_price, a.starting_price, a.increment";

                    psInfo = conn.prepareStatement(infoSql);
                    psInfo.setInt(1, auctionId);
                    rs = psInfo.executeQuery();

                    if (!rs.next()) {
                        msgError = "Auction not found.";
                    } else {
                        String status = rs.getString("status");
                        if (!"ACTIVE".equalsIgnoreCase(status)) {
                            msgError = "Auction is not active.";
                        } else {
                            BigDecimal minPrice     = rs.getBigDecimal("minimum_price");
                            BigDecimal startPrice   = rs.getBigDecimal("starting_price");
                            BigDecimal increment    = rs.getBigDecimal("increment");
                            BigDecimal currentPrice = rs.getBigDecimal("current_price");

                            BigDecimal baseline = currentPrice;
                            if (baseline == null) baseline = startPrice;
                            if (baseline == null) baseline = BigDecimal.ZERO;

                            BigDecimal minByIncrement = baseline.add(increment);
                            BigDecimal minAllowed = minByIncrement.max(minPrice);

                            if (bidAmount.compareTo(minAllowed) < 0) {
                                msgError = "Bid must be at least $" + minAllowed.toPlainString();
                            } else {
                                String insertSql =
                                    "INSERT INTO Bid (auction_id, status, amount, bid_time, auto_bid, max_bid, buyer_id) " +
                                    "VALUES (?, 'ACTIVE', ?, NOW(), 0, NULL, ?)";

                                psInsert = conn.prepareStatement(insertSql);
                                psInsert.setInt(1, auctionId);
                                psInsert.setBigDecimal(2, bidAmount);
                                psInsert.setInt(3, userId);
                                psInsert.executeUpdate();

                                msgSuccess = "Bid of $" + bidAmount.toPlainString() +
                                             " placed on auction #" + auctionId + ".";
                            }
                        }
                    }
                } catch (Exception ex) {
                    msgError = "Error placing bid: " + ex.getMessage();
                } finally {
                    try { if (rs != null) rs.close(); } catch (Exception ig) {}
                    try { if (psInfo != null) psInfo.close(); } catch (Exception ig) {}
                    try { if (psInsert != null) psInsert.close(); } catch (Exception ig) {}
                    try { if (conn != null) conn.close(); } catch (Exception ig) {}
                }
            }
        }
    }
%>

<div class="card">
  <h1>Place a Bid</h1>
  <p class="subtitle">Enter the auction ID and your bid amount.</p>

  <form action="Buyer_Create_Bid_Page.jsp" method="post">
    <label for="auctionId">Auction ID</label>
    <input type="number" id="auctionId" name="auctionId"
           class="form-input" required
           value="<%= request.getParameter("auctionId") != null ? request.getParameter("auctionId") : "" %>"
           placeholder="e.g. 1">

    <label for="bidAmount">Bid Amount ($)</label>
    <input type="number" id="bidAmount" name="bidAmount" step="0.01"
           class="form-input" required placeholder="e.g. 650.00">

    <button type="submit" class="primary-btn">Submit Bid</button>
    <p class="helper-text">Your bid must be at least current price + increment and meet the minimum price.</p>
  </form>

  <% if (msgError != null) { %>
    <div class="message error"><%= msgError %></div>
  <% } else if (msgSuccess != null) { %>
    <div class="message success"><%= msgSuccess %></div>
  <% } %>

  <a class="footer-link" href="welcome.jsp">Back to Home</a>
</div>

</body>
</html>
