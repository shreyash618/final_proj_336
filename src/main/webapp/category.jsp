<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="com.techbarn.webapp.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tech Barn - Phones</title>
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
            background-image: url('Images/phone-banner.png'); 
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
        }

        .item-card img {
            width: 100%;
            height: 600px;
            object-fit: cover;
            border-radius: 8px;
        }

        
    </style>
</head>
<body>
    <%@ include file="navbar.jsp" %>
    <!-- Main Content Area -->
    <div class="category-hero">
        <h1>Phones</h1>
    </div>
    <div class="item-grid">
        <div class="item-card">
            <a href="item.jsp">
                <img src="Images/item_photos/phones/iphone_pink.jpg"></img>
                <p>iPhone 15 Pro</p>
            </a>
        </div>

        <div class="item-card">
            <a href="item.jsp">
                <img src="Images/item_photos/phones/samsung_phantom_black.jpeg"></img>
                <p>Galaxy S24 Ultra</p>
            </a>
        </div>

        <div class="item-card">
            <a href="item.jsp">
                <img src="Images/item_photos/phones/google_obsidian.jpeg"></img>
                <p>Google Pixel</p>
            </a>
        </div>
    
        <!-- add more dynamically later -->
    </div>
    

</body>
</html>