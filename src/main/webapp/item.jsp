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
        }

        .item-container {
            display: flex;
            gap: 30px;
            padding: 40px;
            align-items: flex-start;
            width: 100%;
        }

        .item-image img {
            width: 300px;
            height: 250px;
            object-fit: cover;
            border-radius: 10px;
        }

        .item-info h2 {
            margin-bottom: 10px;
        }

        .item-info h4 {
            margin-bottom: 10px;
            font-weight: 400;
        }

        .item-info p {
            max-width: 500px;
            line-height: 1.4;
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
            <h2>Item Name: <%= item.getName() %></h2>
            <h4>Brand: <%= item.getBrand() %></h4>
            <h4>Color: <%= item.getColor() %></h4>
            <h4>Condition: <%= item.getCondition() %></h4>
            <% if (item.getStock()) { %>
                <h4>In-Stock</h4>
            <% } else { %>
                <h4>Out-Of-Stock</h4>
            <% } %>  
            <p>Description: <%= item.getDescription() %></p>
            
            <h4 style="margin-top: 20px; margin-bottom: 10px;">Additional Specifications:</h4>
            <%
                if (item instanceof Phone) {
                    Phone phone = (Phone) item;
            %>
                <h4>OS: <%= phone.getOs() %></h4>
                <h4>Storage: <%= phone.getStorageGb() %> GB</h4>
                <h4>RAM: <%= phone.getRamGb() %> GB</h4>
                <h4>Screen Size: <%= phone.getScreenSize() %> inches</h4>
                <h4>Rear Camera: <%= phone.getRearCameraMp() %> MP</h4>
                <h4>Front Camera: <%= phone.getFrontCameraMp() %> MP</h4>
                <h4>Unlocked: <%= phone.getIsUnlocked() ? "Yes" : "No" %></h4>
                <h4>Battery Life: <%= phone.getBatteryLife() %> hours</h4>
                <h4>5G Support: <%= phone.getIs5G() ? "Yes" : "No" %></h4>
            <%
                } else if (item instanceof TV) {
                    TV tv = (TV) item;
            %>
                <h4>Resolution: <%= tv.getResolution() %></h4>
                <h4>HDR: <%= tv.getIsHdr() ? "Yes" : "No" %></h4>
                <h4>Refresh Rate: <%= tv.getRefreshRate() %> Hz</h4>
                <h4>Smart TV: <%= tv.getIsSmartTv() ? "Yes" : "No" %></h4>
                <h4>Screen Size: <%= tv.getScreenSize() %> inches</h4>
                <h4>Panel Type: <%= tv.getPanelType() %></h4>
            <%
                } else if (item instanceof Headphones) {
                    Headphones headphones = (Headphones) item;
            %>
                <h4>Wireless: <%= headphones.getIsWireless() ? "Yes" : "No" %></h4>
                <h4>Microphone: <%= headphones.getHasMicrophone() ? "Yes" : "No" %></h4>
                <h4>Noise Cancellation: <%= headphones.getHasNoiseCancellation() ? "Yes" : "No" %></h4>
                <h4>Cable Type: <%= headphones.getCableType() != null ? headphones.getCableType() : "N/A" %></h4>
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
