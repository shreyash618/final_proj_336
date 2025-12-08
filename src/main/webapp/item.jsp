<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="com.techbarn.webapp.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>

<%
    // Check if user is logged in
    if (session.getAttribute("username") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Tech Barn - Item</title>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;700&display=swap" rel="stylesheet">
    <style>
        *   { 
            margin: 0; 
            padding: 0; 
            box-sizing: border-box; 
            font-family: 'Roboto', sans-serif; 
        }
        
        body, html {
            height: 100%;
            width: 100%;
            overflow-x: hidden;
            background: #f4f4f4;
        }
        .item-page {
            max-width: 1100px;
            margin: 40px auto;
            padding: 24px 32px;
            background: #ffffff;
            border-radius: 12px;
            box-shadow: 0 8px 20px rgba(0,0,0,0.08);
        }

        .item-container {
            display: flex;
            gap: 200px;
            padding: 40px;
            align-items: center;
            width: 100%;
        }

        .item-image img {
            width: 300px;
            height: 250px;
            object-fit: scale-down;
            border-radius: 12px;
        }

        .item-info h2 {
            margin-bottom: 10px;
            font-size: 32px;
            text-align: left;
        }

        .item-info h4 {
            margin-bottom: 10px;
            margin-top: 0;
            font-weight: 400;
            color: #444;
            line-height: 1.2;
        }
        /* more specific selectors so they override .item-info h4 */
        .item-info h4.in-stock {
            color: #2d9d32; /* green */
            font-style: italic;
        }
        .item-info h4.out-of-stock {
            color: #c62828; /* red */
            font-style: italic;
        }
        .item-info h4.in-stock,
        .item-info h4.out-of-stock {
            font-family: "Roboto", system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
            font-weight: 700;          /* bolder */
            letter-spacing: 0.03em;    /* slightly spaced letters */
            text-transform: uppercase; /* optional, for a tag-like feel */
        }
        .item-info p {
            max-width: 500px;
            line-height: 1.2;
            color: #444;
            margin: 0;
            margin-top: 0;
            margin-bottom: 10px;
            font-weight: 400;
            font-size: inherit;
        }
        
        .item-specs {
           text-align: left;
        }/*
        .item-additional-specs{
            padding-left: 24px;
        }*/
        
        .auctions-section {
            margin-top: 40px;
            padding-top: 40px;
            border-top: 2px solid #e0e0e0;
        }
        
        .auctions-section h3 {
            font-size: 24px;
            margin-bottom: 24px;
            color: #2d3748;
            font-weight: 700;
        }
        
        .auctions-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 20px;
            margin-top: 20px;
        }
        
        .auction-card {
            background: #ffffff;
            border: 2px solid #e2e8f0;
            border-radius: 12px;
            padding: 20px;
            transition: all 0.3s ease;
            cursor: pointer;
            text-decoration: none;
            color: inherit;
            display: block;
        }
        
        .auction-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 8px 24px rgba(0,0,0,0.12);
            border-color: #667eea;
        }
        
        .auction-card-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 12px;
        }
        
        .auction-id {
            font-size: 18px;
            font-weight: 700;
            color: #2d3748;
        }
        
        .auction-status {
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            text-transform: uppercase;
        }
        
        .auction-status.ACTIVE {
            background: #c6f6d5;
            color: #22543d;
        }
        
        .auction-status.ENDED {
            background: #fed7d7;
            color: #742a2a;
        }
        
        .auction-status.SCHEDULED {
            background: #bee3f8;
            color: #2c5282;
        }
        
        .auction-price {
            font-size: 20px;
            font-weight: 700;
            color: #667eea;
            margin: 12px 0;
        }
        
        .auction-dates {
            font-size: 14px;
            color: #718096;
            line-height: 1.6;
        }
        
        .auction-dates strong {
            color: #4a5568;
        }
        
        .no-auctions {
            text-align: center;
            padding: 40px;
            color: #718096;
            font-size: 16px;
        }
    </style>
</head>
<body>
    <%@ include file="navbar.jsp" %>
    <%
        String errorMessage = (String) request.getAttribute("errorMessage");
        if (errorMessage != null) {
    %>
    <div style="padding: 20px; background-color: #ffebee; color: #c62828; margin: 20px; border-radius: 5px; border-left: 4px solid #c62828;">
        <strong>Error:</strong> <%= errorMessage %>
    </div>
    <%
        }
    %>
    <div class="item-page">
    <div class="item-container">
        <%
            ItemBean item = (ItemBean) request.getAttribute("item");
            if (item == null && errorMessage == null) {
        %>
        <div style="padding: 20px; background-color: #ffebee; color: #c62828; margin: 20px; border-radius: 5px;">
            <strong>Error:</strong> Item not found.
        </div>
        <%
            } else if (item != null) {
        %>
        <div class="item-image">
            <img src="<%= item.getImagePath() %>" alt="<%= item.getName() %>">
        </div>
        <div class="item-info">
            <h2><%= item.getName() %></h2>
            <div class="item-specs">
            <h4><strong>Brand:</strong> <%= item.getBrand() %></h4>
            <h4><strong>Color:</strong> <%= item.getColor() %></h4>
            <h4><strong>Condition:</strong> <%= item.getCondition() %></h4>
            <% if (item.getStock()) { %>
                <h4 class="in-stock">In-Stock</h4>
            <% } else { %>
                <h4 class="out-of-stock">Out-Of-Stock</h4>
            <% } %>  

            <h4 style="margin-top: 20px; margin-bottom: 10px;">Additional Specifications:</h4>
            <div class ="item-additional-specs">
            <%
                if (item instanceof Phone) {
                    Phone phone = (Phone) item;
            %>
                <h4><strong>OS:</strong> <%= phone.getOs() %></h4>
                <h4><strong>Storage:</strong> <%= phone.getStorageGb() %> GB</h4>
                <h4><strong>RAM:</strong> <%= phone.getRamGb() %> GB</h4>
                <h4><strong>Screen Size:</strong> <%= phone.getScreenSize() %> inches</h4>
                <h4><strong>Rear Camera:</strong> <%= phone.getRearCameraMp() %> MP</h4>
                <h4><strong>Front Camera:</strong> <%= phone.getFrontCameraMp() %> MP</h4>
                <h4><strong>Unlocked:</strong> <%= phone.getIsUnlocked() ? "Yes" : "No" %></h4>
                <h4><strong>Battery Life:</strong> <%= phone.getBatteryLife() %> hours</h4>
                <h4><strong>5G Support:</strong> <%= phone.getIs5G() ? "Yes" : "No" %></h4>
            <%
                } else if (item instanceof TV) {
                    TV tv = (TV) item;
            %>
                <h4><strong>Resolution:</strong> <%= tv.getResolution() %></h4>
                <h4><strong>HDR:</strong> <%= tv.getIsHdr() ? "Yes" : "No" %></h4>
                <h4><strong>Refresh Rate:</strong> <%= tv.getRefreshRate() %> Hz</h4>
                <h4><strong>Smart TV:</strong> <%= tv.getIsSmartTv() ? "Yes" : "No" %></h4>
                <h4><strong>Screen Size:</strong> <%= tv.getScreenSize() %> inches</h4>
                <h4><strong>Panel Type:</strong> <%= tv.getPanelType() %></h4>
            <%
                } else if (item instanceof Headphones) {
                    Headphones headphones = (Headphones) item;
            %>
                <h4><strong>Wireless:</strong> <%= headphones.getIsWireless() ? "Yes" : "No" %></h4>
                <h4><strong>Microphone:</strong> <%= headphones.getHasMicrophone() ? "Yes" : "No" %></h4>
                <h4><strong>Noise Cancellation:</strong> <%= headphones.getHasNoiseCancellation() ? "Yes" : "No" %></h4>
                <h4><strong>Cable Type:</strong> <%= headphones.getCableType() != null ? headphones.getCableType() : "N/A" %></h4>
            <%
                }
            %>
            <p><strong>Description:</strong> <%= item.getDescription() %></p>
            </div>
            </div>
            
            <%
                Integer auctionId = (Integer) request.getAttribute("auctionId");
                if (auctionId != null) {
            %>
            <div style="margin-top: 30px;">
                <a href="Buyer_View_Auction_Page.jsp?auctionId=<%= auctionId %>" 
                   style="display: inline-block; padding: 14px 32px; background: #6b9080; color: white; 
                          text-decoration: none; border-radius: 8px; font-weight: 600; font-size: 1.1rem;
                          transition: background 0.3s ease, transform 0.2s ease;"
                   onmouseover="this.style.background='#3e6b5c'; this.style.transform='scale(1.05)';"
                   onmouseout="this.style.background='#6b9080'; this.style.transform='scale(1)';">Place Bid</a>
            </div>
            <%
                }
            %>
        </div>
        <%
            }
        %>
    </div>
    
    <%
        // Display auctions section
        java.util.List<java.util.Map<String, Object>> auctions = (java.util.List<java.util.Map<String, Object>>) request.getAttribute("auctions");
        if (item != null && auctions != null) {
    %>
    <div class="auctions-section">
        <h3>Auctions for this Item</h3>
        <%
            if (auctions.isEmpty()) {
        %>
        <div class="no-auctions">
            <p>No auctions found for this item.</p>
        </div>
        <%
            } else {
        %>
        <div class="auctions-grid">
            <%
                for (java.util.Map<String, Object> auction : auctions) {
                    Integer auctionId = (Integer) auction.get("auction_id");
                    String status = (String) auction.get("status");
                    java.sql.Timestamp startTime = (java.sql.Timestamp) auction.get("start_time");
                    java.sql.Timestamp endTime = (java.sql.Timestamp) auction.get("end_time");
                    java.math.BigDecimal startingPrice = (java.math.BigDecimal) auction.get("starting_price");
                    
                    // Format dates
                    java.text.SimpleDateFormat dateFormat = new java.text.SimpleDateFormat("MMM dd, yyyy");
                    java.text.SimpleDateFormat timeFormat = new java.text.SimpleDateFormat("hh:mm a");
                    String startDateStr = dateFormat.format(startTime);
                    String startTimeStr = timeFormat.format(startTime);
                    String endDateStr = dateFormat.format(endTime);
                    String endTimeStr = timeFormat.format(endTime);
            %>
            <a href="Buyer_View_Auction_Page.jsp?auctionId=<%= auctionId %>" class="auction-card">
                <div class="auction-card-header">
                    <span class="auction-id">Auction #<%= auctionId %></span>
                    <span class="auction-status <%= status %>"><%= status %></span>
                </div>
                <div class="auction-price">$<%= startingPrice %></div>
                <div class="auction-dates">
                    <div><strong>Start:</strong> <%= startDateStr %> at <%= startTimeStr %></div>
                    <div><strong>End:</strong> <%= endDateStr %> at <%= endTimeStr %></div>
                </div>
            </a>
            <%
                }
            %>
        </div>
        <%
            }
        %>
    </div>
    <%
        }
    %>
    </div>
</body>
</html>