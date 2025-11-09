<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="com.buyme.webapp.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Baes Couture - Home</title>
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
        
        /* Header Styles */
        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 1.5rem 3rem;
            background: rgba(255, 255, 255, 0.95);
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            position: sticky;
            top: 0;
            z-index: 100;
        }
        
        .company-name {
            font-size: 1.8rem;
            font-weight: 700;
            color: #6b9080;
            text-decoration: none;
        }
        
        .logout-btn {
            padding: 0.75rem 1.5rem;
            background: #6b9080;
            color: #fff;
            border: none;
            border-radius: 8px;
            font-size: 1rem;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            transition: background 0.3s ease, transform 0.2s;
        }
        
        .logout-btn:hover {
            background: #3e6b5c;
            transform: scale(1.05);
        }
        
        /* Main Content Area */
        .main-content {
            display: flex;
            align-items: center;
            min-height: calc(100vh - 80px);
            padding: 3rem;
            gap: 3rem;
        }
        
        /* Left Section */
        .left-section {
            flex: 1;
            max-width: 600px;
            padding: 2rem;
        }
        
        .main-title {
            font-size: 3.5rem;
            font-weight: 700;
            color: #333;
            margin-bottom: 1.5rem;
            line-height: 1.2;
        }
        
        .subtitle {
            font-size: 1.2rem;
            color: #6b9080;
            margin-bottom: 2rem;
            font-weight: 400;
        }
        
        .description {
            font-size: 1.1rem;
            color: #666;
            line-height: 1.8;
            margin-bottom: 2rem;
        }
        
        /* Right Section */
        .right-section {
            flex: 1;
            display: flex;
            justify-content: center;
            align-items: center;
        }
        
        .image-container {
            width: 100%;
            max-width: 600px;
            height: auto;
        }
        
        .image-container img {
            width: 100%;
            height: auto;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
        }
        
        /* Responsive Design */
        @media (max-width: 968px) {
            .main-content {
                flex-direction: column;
                padding: 2rem;
            }
            
            .main-title {
                font-size: 2.5rem;
            }
            
            .header {
                padding: 1rem 2rem;
            }
        }
        
        @media (max-width: 600px) {
            .main-title {
                font-size: 2rem;
            }
            
            .subtitle {
                font-size: 1rem;
            }
            
            .description {
                font-size: 1rem;
            }
            
            .header {
                padding: 1rem;
            }
            
            .company-name {
                font-size: 1.4rem;
            }
        }
    </style>
</head>
<body>
    <!-- Header with Company Name and Logout Button -->
    <header class="header">
        <a href="welcome.jsp" class="company-name">Baes Couture</a>
        <a href="logout" class="logout-btn">Logout</a>
    </header>
    
    <!-- Main Content Area -->
    <div class="main-content">
        <!-- Left Section: Title and Text -->
        <div class="left-section">
            <h1 class="main-title">
                Welcome to Baes Couture
            </h1>
            <p class="subtitle">Fashion Forward</p>
            <p class="description">
                <% 
                        out.println("Discover our latest collection of elegant fashion pieces. " +
                                   "From timeless classics to modern trends, Baes Couture offers the perfect style for every occasion. " +
                                   "Explore our curated selection and find your next favorite piece.");
                %>
            </p>
        </div>
        
        <!-- Right Section: Image -->
        <div class="right-section">
            <div class="image-container">
                <img src="elle-summer-bag-trends.jpg" alt="Baes Couture Fashion">
            </div>
        </div>
    </div>
</body>
</html>