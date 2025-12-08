<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="com.techbarn.webapp.ApplicationDB" %>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Tech Barn - My Account</title>
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
      background: #f3f4f6;
    }

    body {
      display: flex;
      justify-content: center;
      padding: 2rem 0;
      overflow-y: auto;
    }

    .card {
      width: 100%;
      max-width: 700px;
      background: #ffffff;
      border-radius: 20px;
      padding: 2.5rem;
      box-shadow: 0 20px 50px rgba(15, 23, 42, 0.15);
      margin: auto;
    }

    h1 {
      margin-bottom: 0.4rem;
      color: #111827;
      font-weight: 700;
      font-size: 1.9rem;
      letter-spacing: -0.4px;
    }

    .subtitle {
      font-size: 0.9rem;
      color: #6b7280;
      margin-bottom: 1.3rem;
    }

    .section-title {
      margin-top: 1rem;
      margin-bottom: 0.4rem;
      font-size: 0.95rem;
      font-weight: 600;
      color: #111827;
    }

    .info-grid {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 10px 18px;
      margin-bottom: 0.6rem;
    }

    .info-label {
      font-size: 0.8rem;
      text-transform: uppercase;
      letter-spacing: 0.03em;
      color: #9ca3af;
    }

    .info-value {
      font-size: 0.95rem;
      color: #111827;
      font-weight: 500;
    }

    .tag {
      display: inline-flex;
      align-items: center;
      border-radius: 999px;
      padding: 3px 10px;
      font-size: 0.8rem;
      font-weight: 500;
      margin-right: 6px;
    }

    .tag-buyer {
      background: #eff6ff;
      color: #1d4ed8;
    }

    .tag-seller {
      background: #ecfdf5;
      color: #047857;
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

    .message.success {
      background: #dcfce7;
      border: 1px solid #bbf7d0;
      color: #166534;
    }

    .message.info {
      background: #eff6ff;
      border: 1px solid #bfdbfe;
      color: #1d4ed8;
    }

    .actions {
      margin-top: 1.4rem;
      display: flex;
      justify-content: space-between;
      align-items: center;
      gap: 12px;
      flex-wrap: wrap;
    }

    .danger-button {
      padding: 10px 14px;
      border-radius: 10px;
      border: none;
      cursor: pointer;
      font-size: 0.9rem;
      font-weight: 600;
      background: #ef4444;
      color: #ffffff;
      box-shadow: 0 6px 16px rgba(239, 68, 68, 0.45);
      transition: all 0.15s ease;
    }

    .danger-button:hover {
      background: #dc2626;
      transform: translateY(-1px);
      box-shadow: 0 8px 20px rgba(220, 38, 38, 0.55);
    }

    .back-link {
      font-size: 0.9rem;
      color: #6366f1;
      text-decoration: none;
    }

    .bid-card {
      background: white;
      border-radius: 8px;
      padding: 1rem;
      margin-bottom: 0.75rem;
    }

    .bid-card.winning {
      border-left: 4px solid #059669;
    }

    .bid-card.losing {
      border-left: 4px solid #f59e0b;
    }

    .bid-price-winning {
      font-weight: 600;
      color: #059669;
    }

    .bid-price-losing {
      font-weight: 600;
      color: #dc2626;
    }

    .scrollable-section {
      max-height: 400px;
      overflow-y: auto;
      padding-right: 0.5rem;
    }

    .scrollable-section::-webkit-scrollbar {
      width: 8px;
    }

    .scrollable-section::-webkit-scrollbar-track {
      background: #f1f1f1;
      border-radius: 10px;
    }

    .scrollable-section::-webkit-scrollbar-thumb {
      background: #888;
      border-radius: 10px;
    }

    .scrollable-section::-webkit-scrollbar-thumb:hover {
      background: #555;
    }

    .back-link:hover {
      text-decoration: underline;
      color: #4f46e5;
    }

    .small-muted {
      font-size: 0.8rem;
      color: #9ca3af;
      margin-top: 4px;
    }

    @media (max-width: 640px) {
      .card {
        margin: 1rem;
        padding: 1.8rem;
      }
      .info-grid {
        grid-template-columns: 1fr;
      }
    }
  </style>
</head>
<body>

<%

    Integer userId = null;
    Object sessionUserIdObj = session.getAttribute("user_id");

    if (sessionUserIdObj instanceof Integer) {
        userId = (Integer) sessionUserIdObj;
    } else if (sessionUserIdObj instanceof String) {
        try {
            userId = Integer.parseInt((String) sessionUserIdObj);
        } catch (NumberFormatException ignore) {}
    }

    if (userId == null) {
        String param = request.getParameter("userId");
        if (param != null && !param.trim().isEmpty()) {
            try { userId = Integer.parseInt(param.trim()); } catch (NumberFormatException ignore) {}
        }
    }

    String errorMessage = null;
    String successMessage = null;
    boolean accountDeleted = false;

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String action = request.getParameter("action");
        if ("delete".equals(action) && userId != null) {

            Connection con = null;
            PreparedStatement psDel = null;

            try {
                con = ApplicationDB.getConnection();

                String sqlDel = "DELETE FROM `User` WHERE user_id = ?";
                psDel = con.prepareStatement(sqlDel);
                psDel.setInt(1, userId);

                int rows = psDel.executeUpdate();
                if (rows > 0) {
                    successMessage = "Your account has been deleted.";
                    accountDeleted = true;
                    session.invalidate();
                } else {
                    errorMessage = "Could not delete account (no rows affected).";
                }
            } catch (Exception e) {
                errorMessage = "Error deleting account: " + e.getMessage();
            } finally {
                try { if (psDel != null) psDel.close(); } catch (Exception ignore) {}
                try { if (con  != null) con.close(); } catch (Exception ignore) {}
            }
        }
    }

    String username = null;
    String firstName = null;
    String lastName  = null;
    String email     = null;
    String phone     = null;
    String address   = null;
    String role      = null;

    if (!accountDeleted) {
        if (userId == null) {
            errorMessage = (errorMessage == null)
                    ? "No user is logged in. Please log in first."
                    : errorMessage;
        } else {
            Connection con = null;
            PreparedStatement ps = null;
            ResultSet rs = null;

            try {
                con = ApplicationDB.getConnection();

                String sql =
                    "SELECT user_id, username, first_name, last_name, email, phone_no, first_name, last_name " +
                    "FROM `User` WHERE user_id = ?";

                ps = con.prepareStatement(sql);
                ps.setInt(1, userId);
                rs = ps.executeQuery();

                if (rs.next()) {
                    username  = rs.getString("username");
                    firstName = rs.getString("first_name");
                    lastName  = rs.getString("last_name");
                    email     = rs.getString("email");
                    phone     = rs.getString("phone_no");
                } else {
                    errorMessage = "No account found for user ID " + userId;
                }

            } catch (Exception e) {
                errorMessage = "Error loading account info: " + e.getMessage();
            } finally {
                try { if (rs != null) rs.close(); } catch (Exception ignore) {}
                try { if (ps != null) ps.close(); } catch (Exception ignore) {}
                try { if (con != null) con.close(); } catch (Exception ignore) {}
            }
        }
    }
%>

<div class="card">
  <h1>My Account</h1>
  <p class="subtitle">View your buyer/seller information and manage your account.</p>

  <% if (errorMessage != null) { %>
    <div class="message error"><%= errorMessage %></div>
  <% } %>

  <% if (successMessage != null) { %>
    <div class="message success"><%= successMessage %></div>
  <% } %>

  <% if (!accountDeleted && errorMessage == null && username != null) { %>

    <div class="section-title">Profile</div>
    <div class="info-grid">
      <div>
        <div class="info-label">Username</div>
        <div class="info-value"><%= username %></div>
      </div>
      <div>
        <div class="info-label">Full Name</div>
        <div class="info-value">
          <%= (firstName != null ? firstName : "") %>
          <%= (lastName  != null ? lastName  : "") %>
        </div>
      </div>
      <div>
        <div class="info-label">Email</div>
        <div class="info-value"><%= email %></div>
      </div>
      <div>
        <div class="info-label">Phone</div>
        <div class="info-value"><%= phone != null ? phone : "N/A" %></div>
      </div>
    </div>

    <div class="section-title">Account Type</div>
    <div>
      <span class="tag tag-buyer">User</span>
      <p class="small-muted">
        This page is a self-view: you are only seeing your own account details.
      </p>
    </div>

    <%
      // Check for pending payments (won auctions without transactions)
      java.util.List<java.util.Map<String, Object>> pendingPayments = new java.util.ArrayList<>();
      
      try {
          Connection conPending = null;
          PreparedStatement psPending = null;
          ResultSet rsPending = null;
          
          try {
              conPending = ApplicationDB.getConnection();
              
              String sqlPending = 
                  "SELECT a.auction_id, a.end_time, i.title, i.brand, " +
                  "       (SELECT b2.amount FROM Bid b2 WHERE b2.auction_id = a.auction_id " +
                  "        ORDER BY b2.amount DESC, b2.bid_time ASC LIMIT 1) as winning_bid " +
                  "FROM Auction a " +
                  "JOIN Item i ON a.item_id = i.item_id " +
                  "LEFT JOIN `Transaction` t ON a.auction_id = t.auction_id " +
                  "WHERE (a.status = 'CLOSED_SOLD' OR a.status = 'CLOSED') " +
                  "AND t.trans_id IS NULL " +
                  "AND ? = (SELECT b3.buyer_id FROM Bid b3 WHERE b3.auction_id = a.auction_id " +
                  "         ORDER BY b3.amount DESC, b3.bid_time ASC LIMIT 1) " +
                  "ORDER BY a.end_time DESC";
              
              psPending = conPending.prepareStatement(sqlPending);
              psPending.setInt(1, userId);
              rsPending = psPending.executeQuery();
              
              while (rsPending.next()) {
                  java.util.Map<String, Object> payment = new java.util.HashMap<>();
                  payment.put("auction_id", rsPending.getInt("auction_id"));
                  payment.put("end_time", rsPending.getTimestamp("end_time"));
                  payment.put("title", rsPending.getString("title"));
                  payment.put("brand", rsPending.getString("brand"));
                  payment.put("winning_bid", rsPending.getBigDecimal("winning_bid"));
                  pendingPayments.add(payment);
              }
          } finally {
              try { if (rsPending != null) rsPending.close(); } catch (Exception ignore) {}
              try { if (psPending != null) psPending.close(); } catch (Exception ignore) {}
              try { if (conPending != null) conPending.close(); } catch (Exception ignore) {}
          }
      } catch (Exception e) {
          // Silently fail - don't break the page
      }
      
      if (!pendingPayments.isEmpty()) {
    %>
    
    <div class="section-title" style="color: #dc2626;">Pending Payments (<%= pendingPayments.size() %>)</div>
    <div style="background: #fef2f2; border: 2px solid #fecaca; border-radius: 12px; padding: 1.5rem; margin-bottom: 1rem;">
      <p style="color: #991b1b; margin-bottom: 1rem; font-weight: 500;">
        You have won the following auctions and need to complete payment:
      </p>
      
      <div class="scrollable-section">
      <% for (java.util.Map<String, Object> payment : pendingPayments) { %>
        <div style="background: white; border-radius: 8px; padding: 1rem; margin-bottom: 0.75rem; border-left: 4px solid #dc2626;">
          <div style="display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 0.5rem;">
            <div>
              <div style="font-weight: 600; color: #111827; margin-bottom: 0.25rem;">
                <%= payment.get("title") %> (<%= payment.get("brand") %>)
              </div>
              <div style="font-size: 0.85rem; color: #6b7280;">
                Auction #<%= payment.get("auction_id") %> · Ended: <%= payment.get("end_time") %>
              </div>
            </div>
            <div style="text-align: right;">
              <div style="font-size: 1.1rem; font-weight: 700; color: #dc2626; margin-bottom: 0.5rem;">
                $<%= payment.get("winning_bid") %>
              </div>
              <a href="Auction_End_Page.jsp?auctionId=<%= payment.get("auction_id") %>" 
                 style="display: inline-block; padding: 8px 16px; background: linear-gradient(135deg, #dc2626, #b91c1c); 
                        color: white; text-decoration: none; border-radius: 8px; font-size: 0.85rem; font-weight: 600;
                        box-shadow: 0 2px 8px rgba(220, 38, 38, 0.3); transition: all 0.2s ease;">
                View & Pay
              </a>
            </div>
          </div>
        </div>
      <% } %>
      </div>
    </div>
    
    <% } %>
    
    <%
      // Check for completed transactions (won and paid auctions)
      java.util.List<java.util.Map<String, Object>> completedAuctions = new java.util.ArrayList<>();
      
      try {
          Connection conCompleted = null;
          PreparedStatement psCompleted = null;
          ResultSet rsCompleted = null;
          
          try {
              conCompleted = ApplicationDB.getConnection();
              
              String sqlCompleted = 
                  "SELECT a.auction_id, t.trans_time, i.title, i.brand, b.amount as winning_bid, t.status as trans_status " +
                  "FROM `Transaction` t " +
                  "JOIN Auction a ON t.auction_id = a.auction_id " +
                  "JOIN Item i ON a.item_id = i.item_id " +
                  "JOIN (" +
                  "    SELECT auction_id, MAX(amount) as amount " +
                  "    FROM Bid " +
                  "    GROUP BY auction_id " +
                  ") b ON a.auction_id = b.auction_id " +
                  "WHERE t.buyer_id = ? " +
                  "ORDER BY t.trans_time DESC";
              
              psCompleted = conCompleted.prepareStatement(sqlCompleted);
              psCompleted.setInt(1, userId);
              rsCompleted = psCompleted.executeQuery();
              
              while (rsCompleted.next()) {
                  java.util.Map<String, Object> transaction = new java.util.HashMap<>();
                  transaction.put("auction_id", rsCompleted.getInt("auction_id"));
                  transaction.put("trans_time", rsCompleted.getTimestamp("trans_time"));
                  transaction.put("title", rsCompleted.getString("title"));
                  transaction.put("brand", rsCompleted.getString("brand"));
                  transaction.put("winning_bid", rsCompleted.getBigDecimal("winning_bid"));
                  transaction.put("trans_status", rsCompleted.getString("trans_status"));
                  completedAuctions.add(transaction);
              }
          } finally {
              try { if (rsCompleted != null) rsCompleted.close(); } catch (Exception ignore) {}
              try { if (psCompleted != null) psCompleted.close(); } catch (Exception ignore) {}
              try { if (conCompleted != null) conCompleted.close(); } catch (Exception ignore) {}
          }
      } catch (Exception e) {
          // Silently fail
      }
      
      if (!completedAuctions.isEmpty()) {
    %>
    
    <div class="section-title" style="color: #059669;">Completed Purchases (<%= completedAuctions.size() %>)</div>
    <div style="background: #f0fdf4; border: 2px solid #86efac; border-radius: 12px; padding: 1.5rem; margin-bottom: 1rem;">
      <p style="color: #047857; margin-bottom: 1rem; font-weight: 500;">
        Auctions you've won and successfully paid for:
      </p>
      
      <div class="scrollable-section">
      <% for (java.util.Map<String, Object> transaction : completedAuctions) { %>
        <div style="background: white; border-radius: 8px; padding: 1rem; margin-bottom: 0.75rem; border-left: 4px solid #059669;">
          <div style="display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 0.5rem;">
            <div>
              <div style="font-weight: 600; color: #111827; margin-bottom: 0.25rem;">
                <%= transaction.get("title") %> (<%= transaction.get("brand") %>)
              </div>
              <div style="font-size: 0.85rem; color: #6b7280;">
                Auction #<%= transaction.get("auction_id") %> · Paid: <%= transaction.get("trans_time") %>
              </div>
            </div>
            <div style="text-align: right;">
              <div style="font-size: 1.1rem; font-weight: 700; color: #059669; margin-bottom: 0.25rem;">
                $<%= transaction.get("winning_bid") %>
              </div>
              <div style="font-size: 0.75rem; color: #047857; font-weight: 600;">
                <%= transaction.get("trans_status") %>
              </div>
            </div>
          </div>
        </div>
      <% } %>
      </div>
    </div>
    
    <% } %>
    
    <%
      // Check for active bids (auctions you're currently bidding on)
      java.util.List<java.util.Map<String, Object>> activeBids = new java.util.ArrayList<>();
      
      try {
          Connection conBids = null;
          PreparedStatement psBids = null;
          ResultSet rsBids = null;
          
          try {
              conBids = ApplicationDB.getConnection();
              
              String sqlBids = 
                  "SELECT DISTINCT a.auction_id, a.end_time, a.status, i.title, i.brand, " +
                  "       (SELECT MAX(amount) FROM Bid WHERE auction_id = a.auction_id) as current_high_bid, " +
                  "       (SELECT MAX(amount) FROM Bid WHERE auction_id = a.auction_id AND buyer_id = ?) as my_high_bid " +
                  "FROM Bid b " +
                  "JOIN Auction a ON b.auction_id = a.auction_id " +
                  "JOIN Item i ON a.item_id = i.item_id " +
                  "WHERE b.buyer_id = ? " +
                  "AND a.status = 'ACTIVE' " +
                  "ORDER BY a.end_time ASC";
              
              psBids = conBids.prepareStatement(sqlBids);
              psBids.setInt(1, userId);
              psBids.setInt(2, userId);
              rsBids = psBids.executeQuery();
              
              while (rsBids.next()) {
                  java.util.Map<String, Object> bid = new java.util.HashMap<>();
                  bid.put("auction_id", rsBids.getInt("auction_id"));
                  bid.put("end_time", rsBids.getTimestamp("end_time"));
                  bid.put("title", rsBids.getString("title"));
                  bid.put("brand", rsBids.getString("brand"));
                  bid.put("current_high_bid", rsBids.getBigDecimal("current_high_bid"));
                  bid.put("my_high_bid", rsBids.getBigDecimal("my_high_bid"));
                  
                  // Check if I'm winning
                  boolean isWinning = rsBids.getBigDecimal("my_high_bid").compareTo(rsBids.getBigDecimal("current_high_bid")) == 0;
                  bid.put("is_winning", isWinning);
                  
                  activeBids.add(bid);
              }
          } finally {
              try { if (rsBids != null) rsBids.close(); } catch (Exception ignore) {}
              try { if (psBids != null) psBids.close(); } catch (Exception ignore) {}
              try { if (conBids != null) conBids.close(); } catch (Exception ignore) {}
          }
      } catch (Exception e) {
          // Silently fail
      }
      
      if (!activeBids.isEmpty()) {
    %>
    
    <div class="section-title" style="color: #2563eb;">Active Bids (<%= activeBids.size() %>)</div>
    <div style="background: #eff6ff; border: 2px solid #93c5fd; border-radius: 12px; padding: 1.5rem; margin-bottom: 1rem;">
      <p style="color: #1e40af; margin-bottom: 1rem; font-weight: 500;">
        Auctions you're currently bidding on:
      </p>
      
      <div class="scrollable-section">
      <% 
        for (java.util.Map<String, Object> bid : activeBids) { 
          boolean isWinning = (Boolean)bid.get("is_winning");
          String cardClass = isWinning ? "bid-card winning" : "bid-card losing";
          String priceClass = isWinning ? "bid-price-winning" : "bid-price-losing";
      %>
        <div class="<%=cardClass%>">
          <div style="display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 0.5rem;">
            <div>
              <div style="font-weight: 600; color: #111827; margin-bottom: 0.25rem;">
                <%= bid.get("title") %> (<%= bid.get("brand") %>)
                <% if (isWinning) { %>
                  <span style="background: #d1fae5; color: #047857; padding: 2px 8px; border-radius: 12px; font-size: 0.75rem; margin-left: 8px;">WINNING</span>
                <% } else { %>
                  <span style="background: #fef3c7; color: #92400e; padding: 2px 8px; border-radius: 12px; font-size: 0.75rem; margin-left: 8px;">OUTBID</span>
                <% } %>
              </div>
              <div style="font-size: 0.85rem; color: #6b7280;">
                Auction #<%= bid.get("auction_id") %> · Ends: <%= bid.get("end_time") %>
              </div>
            </div>
            <div style="text-align: right;">
              <div style="font-size: 0.85rem; color: #6b7280;">
                Your bid: <span style="font-weight: 600; color: #111827;">$<%= bid.get("my_high_bid") %></span>
              </div>
              <div style="font-size: 0.85rem; color: #6b7280;">
                Current high: <span class="<%=priceClass%>">$<%= bid.get("current_high_bid") %></span>
              </div>
              <a href="Buyer_View_Auction_Page.jsp?auctionId=<%= bid.get("auction_id") %>" 
                 style="display: inline-block; margin-top: 0.5rem; padding: 6px 12px; background: #2563eb; 
                        color: white; text-decoration: none; border-radius: 6px; font-size: 0.8rem; font-weight: 500;">
                View Auction
              </a>
            </div>
          </div>
        </div>
      <% } %>
      </div>
    </div>
    
    <% } %>

    <div class="actions">
      <form method="post" action="User_Account_Info_Page.jsp"
            onsubmit="return confirm('Are you sure you want to delete your account? This cannot be undone.');">
        <input type="hidden" name="action" value="delete" />
        <button type="submit" class="danger-button">Delete My Account</button>
      </form>

      <a href="welcome.jsp" class="back-link">Back to Home</a>
    </div>

  <% } else if (accountDeleted) { %>
    <div class="message info">
      Your account has been removed from the system.
    </div>
    <div class="actions">
      <a href="welcome.jsp" class="back-link">Back to Home</a>
    </div>
  <% } %>
</div>

</body>
</html>
