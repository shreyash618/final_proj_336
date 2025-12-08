<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>

<%
    String username = (String) request.getAttribute("username");
    Integer userId = (Integer) request.getAttribute("userId");
    List<Map<String, Object>> auctions = (List<Map<String, Object>>) request.getAttribute("auctions");
    String errorMessage = (String) request.getAttribute("errorMessage");
%>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>User Auctions - Tech Barn</title>
  <style>
    body {
      font-family: Arial, sans-serif;
      max-width: 1000px;
      margin: 40px auto;
      padding: 20px;
    }
    h1 {
      margin-bottom: 10px;
    }
    .subtitle {
      color: #666;
      margin-bottom: 30px;
    }
    table {
      width: 100%;
      border-collapse: collapse;
      margin-top: 20px;
    }
    th, td {
      padding: 12px;
      text-align: left;
      border-bottom: 1px solid #ddd;
    }
    th {
      background-color: #f5f5f5;
      font-weight: bold;
    }
    tr:hover {
      background-color: #f9f9f9;
    }
    .role {
      padding: 4px 8px;
      border-radius: 4px;
      font-size: 0.85em;
    }
    .role-seller {
      background-color: #e3f2fd;
      color: #1976d2;
    }
    .role-buyer {
      background-color: #e8f5e9;
      color: #388e3c;
    }
    .status {
      padding: 4px 8px;
      border-radius: 4px;
      font-size: 0.85em;
    }
    .status-active {
      background-color: #e8f5e9;
      color: #2e7d32;
    }
    .status-closed {
      background-color: #ffebee;
      color: #c62828;
    }
    .error {
      background: #ffebee;
      border: 1px solid #ef5350;
      color: #c62828;
      padding: 15px;
      border-radius: 4px;
      margin-bottom: 20px;
    }
    .empty {
      text-align: center;
      padding: 40px;
      color: #999;
    }
    a {
      color: #1976d2;
      text-decoration: none;
    }
    a:hover {
      text-decoration: underline;
    }
  </style>
</head>
<body>
  <%@ include file="navbar.jsp" %>

  <h1><%= username != null ? username + "'s Auctions" : "User Auctions" %></h1>
  <p class="subtitle">List of auctions started and auctions bid on</p>

  <% if (errorMessage != null) { %>
    <div class="error"><%= errorMessage %></div>
  <% } %>

  <% if (auctions == null || auctions.isEmpty()) { %>
    <div class="empty">
      <p>No auctions found. This user hasn't started any auctions or placed any bids yet.</p>
    </div>
  <% } else { %>
    <table>
      <thead>
        <tr>
          <th>Auction ID</th>
          <th>Item</th>
          <th>Brand</th>
          <th>Role</th>
          <th>Status</th>
          <th>Current Price</th>
          <th>End Time</th>
          <th>Action</th>
        </tr>
      </thead>
      <tbody>
        <% for (Map<String, Object> auction : auctions) { 
            String role = (String) auction.get("role");
            String status = (String) auction.get("status");
        %>
          <tr>
            <td>#<%= auction.get("auction_id") %></td>
            <td><%= auction.get("title") %></td>
            <td><%= auction.get("brand") %></td>
            <td>
              <span class="role <%= "seller".equals(role) ? "role-seller" : "role-buyer" %>">
                <%= "seller".equals(role) ? "Started" : "Bid On" %>
              </span>
            </td>
            <td>
              <span class="status <%= "ACTIVE".equals(status) ? "status-active" : "status-closed" %>">
                <%= status != null ? status : "UNKNOWN" %>
              </span>
            </td>
            <td>
              <% if (auction.get("current_price") != null) { %>
                $<%= auction.get("current_price") %>
              <% } else { %>
                $<%= auction.get("starting_price") %>
              <% } %>
            </td>
            <td><%= auction.get("end_time") %></td>
            <td>
              <a href="Buyer_View_Auction_Page.jsp?auctionId=<%= auction.get("auction_id") %>">View</a>
            </td>
          </tr>
        <% } %>
      </tbody>
    </table>
  <% } %>
</body>
</html>
