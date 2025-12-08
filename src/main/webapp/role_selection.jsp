<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Check if user is logged in
    if (session.getAttribute("username") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    // Handle both Boolean and Integer types for buyer/seller flags
    Object isBuyerObj = session.getAttribute("isBuyer");
    Object isSellerObj = session.getAttribute("isSeller");
    
    boolean isBuyer = false;
    boolean isSeller = false;
    
    if (isBuyerObj != null) {
        if (isBuyerObj instanceof Boolean) {
            isBuyer = (Boolean) isBuyerObj;
        } else if (isBuyerObj instanceof Integer) {
            isBuyer = ((Integer) isBuyerObj) == 1;
        }
    }
    
    if (isSellerObj != null) {
        if (isSellerObj instanceof Boolean) {
            isSeller = (Boolean) isSellerObj;
        } else if (isSellerObj instanceof Integer) {
            isSeller = ((Integer) isSellerObj) == 1;
        }
    }
    
    // If not both roles, redirect appropriately
    if (!(isBuyer && isSeller)) {
        if (isSeller) {
            response.sendRedirect("sellerhomepage.jsp");
        } else {
            response.sendRedirect("welcome.jsp");
        }
        return;
    }
    
    String firstName = (String) session.getAttribute("first_name");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tech Barn - Choose Your Mode</title>
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
            background: url('Images/backgrounds/login_screen_background.jpg') no-repeat center center/cover;
            background-attachment: fixed;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .selection-container {
            background: #ffffff;
            border-radius: 20px;
            padding: 3rem 2.5rem;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
            text-align: center;
            max-width: 700px;
            width: 90%;
        }

        h1 {
            margin-bottom: 0.5rem;
            color: #2d3748;
            font-weight: 700;
            font-size: 2rem;
            letter-spacing: -0.5px;
        }

        .subtitle {
            font-size: 1rem;
            color: #718096;
            margin-bottom: 2rem;
        }

        .role-cards {
            display: flex;
            gap: 2rem;
            margin-top: 2rem;
            justify-content: center;
        }

        .role-card {
            flex: 1;
            max-width: 280px;
            background: linear-gradient(135deg, #f7fafc 0%, #edf2f7 100%);
            border: 3px solid #e2e8f0;
            border-radius: 15px;
            padding: 2rem 1.5rem;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 1rem;
        }

        .role-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.15);
            border-color: #667eea;
        }

        .role-card.buyer:hover {
            background: linear-gradient(135deg, #e6fffa 0%, #b2f5ea 100%);
            border-color: #38b2ac;
        }

        .role-card.seller:hover {
            background: linear-gradient(135deg, #fef5e7 0%, #fad7a0 100%);
            border-color: #f39c12;
        }

        .role-icon {
            font-size: 4rem;
            margin-bottom: 0.5rem;
        }

        .role-title {
            font-size: 1.5rem;
            font-weight: 700;
            color: #2d3748;
            margin-bottom: 0.5rem;
        }

        .role-description {
            font-size: 0.9rem;
            color: #4a5568;
            line-height: 1.5;
        }

        .logout-link {
            margin-top: 2rem;
            display: inline-block;
            color: #667eea;
            text-decoration: none;
            font-size: 0.9rem;
            font-weight: 500;
            transition: color 0.2s ease;
        }

        .logout-link:hover {
            color: #764ba2;
            text-decoration: underline;
        }

        @media(max-width: 600px) {
            .role-cards {
                flex-direction: column;
            }

            .role-card {
                max-width: 100%;
            }
        }
    </style>
</head>
<body>
    <div class="selection-container">
        <h1>Welcome back, <%= firstName %>!</h1>
        <p class="subtitle">You have both Buyer and Seller accounts. Choose your mode to continue:</p>

        <div class="role-cards">
            <a href="welcome.jsp" class="role-card buyer">
                <div class="role-icon">🛒</div>
                <div class="role-title">Buyer Mode</div>
                <div class="role-description">
                    Browse auctions, place bids, and purchase items
                </div>
            </a>

            <a href="sellerhomepage.jsp" class="role-card seller">
                <div class="role-icon">💼</div>
                <div class="role-title">Seller Mode</div>
                <div class="role-description">
                    Create auctions, manage listings, and track sales
                </div>
            </a>
        </div>

        <a href="logout" class="logout-link">Logout</a>
    </div>
</body>
</html>
