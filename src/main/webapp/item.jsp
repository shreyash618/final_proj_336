<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="com.techbarn.webapp.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
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
        </div>
        <%
            }
        %>
    </div>
    </div>
</body>
</html>
