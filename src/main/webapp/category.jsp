<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="com.techbarn.webapp.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tech Barn — ${pageTitle}</title>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;700&display=swap" rel="stylesheet">
    <style>
        * { 
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
        .category-hero {
            width: 100%;
            height: 300px;
            background-image: url(${bannerImage}); 
            background-size: cover;
            background-position: center;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .category-hero h1 {
            font-size: 60px;
            color: white;
            text-shadow: 2px 2px 10px black;
        }

        .item-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            padding: 30px;
        }

        .item-card {
            background: #fff;
            padding: 15px;
            border-radius: 10px;
            text-align: center;
            box-shadow: 0px 0px 10px rgba(0,0,0,0.1);
            max-width:1000px;
        }
        .card-phone img {
            width: 100%;
            height: 250px;
            object-fit: cover;
        }

        .card-tv img {
            width: 100%;
            height: 250px;
            object-fit: scale-down;
        }

        .card-headphones img {
            width: 100%;
            height: 250px;
            object-fit: scale-down;
        }

        .item-card img {
            border-radius: 8px;
            margin-bottom: 10px;
        }
        
        .item-card a {
            text-decoration: none;
            color: inherit;
        }
        
        .item-card p {
            margin: 5px 0;
            font-weight: 500;
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
    <div class="category-hero">
        <h1>${pageTitle}</h1>
    </div>
    <div class="item-grid">
        <%
            ArrayList<ItemBean> items = (ArrayList<ItemBean>) request.getAttribute("items");
            String cardStyle = (String) request.getAttribute("cardStyle");
            if (items != null && !items.isEmpty()) {
                for (ItemBean item : items) {
        %>
        <div class="item-card ${cardStyle}"> <!--${cardStyle}-->
            <a href="item?itemId=<%= item.getId() %>">
                <img src="<%= item.getImagePath() %>" alt="<%= item.getName() %>">
                <p><%= item.getName() %></p>
                <p style="color: #666; font-size: 14px;"><%= item.getBrand() %> - <%= item.getColor() %></p>
            </a>
        </div>
        <%
                }
            } else {
        %>
        <div style="grid-column: 1 / -1; text-align: center; padding: 40px;">
            <p>No items found in this category.</p>
        </div>
        <%
            }
        %>
    </div>
</body>
</html>