<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
    // Check if user is logged in
    if (session.getAttribute("user_id") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Payment Successful - Tech Barn</title>
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
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 2rem;
        }

        .success-container {
            width: 100%;
            max-width: 600px;
            background: #ffffff;
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
            padding: 3rem 2.5rem;
            text-align: center;
        }

        .success-icon {
            width: 100px;
            height: 100px;
            background: linear-gradient(135deg, #48bb78, #38a169);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 1.5rem;
            animation: scaleIn 0.5s ease-out;
        }

        .success-icon::before {
            content: "✓";
            font-size: 3rem;
            color: white;
            font-weight: bold;
        }

        @keyframes scaleIn {
            from {
                transform: scale(0);
                opacity: 0;
            }
            to {
                transform: scale(1);
                opacity: 1;
            }
        }

        h1 {
            font-size: 2rem;
            color: #2d3748;
            margin-bottom: 0.5rem;
            font-weight: 700;
        }

        .subtitle {
            font-size: 1rem;
            color: #718096;
            margin-bottom: 2rem;
        }

        .info-box {
            background: #f7fafc;
            border-radius: 12px;
            padding: 1.5rem;
            margin: 2rem 0;
            border: 2px solid #e2e8f0;
            text-align: left;
        }

        .info-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 0.75rem;
            font-size: 0.95rem;
        }

        .info-row:last-child {
            margin-bottom: 0;
        }

        .info-row .label {
            color: #718096;
        }

        .info-row .value {
            color: #2d3748;
            font-weight: 600;
        }

        .message {
            background: #c6f6d5;
            border: 2px solid #9ae6b4;
            border-radius: 10px;
            padding: 1rem;
            margin: 1.5rem 0;
            color: #22543d;
            font-size: 0.95rem;
        }

        .button-group {
            display: flex;
            gap: 1rem;
            margin-top: 2rem;
            flex-wrap: wrap;
            justify-content: center;
        }

        .button {
            padding: 12px 24px;
            border-radius: 10px;
            font-size: 1rem;
            font-weight: 600;
            text-decoration: none;
            cursor: pointer;
            transition: all 0.3s ease;
            display: inline-block;
        }

        .button.primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            box-shadow: 0 4px 15px rgba(102, 126, 234, 0.4);
        }

        .button.primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(102, 126, 234, 0.5);
        }

        .button.secondary {
            background: #e2e8f0;
            color: #4a5568;
        }

        .button.secondary:hover {
            background: #cbd5e0;
        }

        .confirmation-id {
            display: inline-block;
            background: #edf2f7;
            padding: 0.5rem 1rem;
            border-radius: 8px;
            font-family: monospace;
            font-size: 1.1rem;
            color: #2d3748;
            margin: 1rem 0;
            font-weight: 600;
        }
    </style>
</head>
<body>
    <div class="success-container">
        <div class="success-icon"></div>
        
        <h1>Payment Successful!</h1>
        <p class="subtitle">Your transaction has been completed</p>
        
        <%
            String successMessage = (String) request.getAttribute("successMessage");
            Integer auctionId = (Integer) request.getAttribute("auctionId");
            
            if (successMessage != null) {
        %>
            <div class="message">
                <%= successMessage %>
            </div>
        <% } %>
        
        <% if (auctionId != null) { %>
            <div class="info-box">
                <div class="info-row">
                    <span class="label">Auction ID:</span>
                    <span class="value">#<%= auctionId %></span>
                </div>
                <div class="info-row">
                    <span class="label">Transaction Date:</span>
                    <span class="value"><%= new java.text.SimpleDateFormat("MMM dd, yyyy HH:mm").format(new java.util.Date()) %></span>
                </div>
                <div class="info-row">
                    <span class="label">Status:</span>
                    <span class="value" style="color: #48bb78;">✓ Completed</span>
                </div>
            </div>
        <% } %>
        
        <p style="font-size: 0.9rem; color: #718096; margin: 1.5rem 0;">
            A confirmation email will be sent to your registered email address shortly.
        </p>
        
        <div class="button-group">
            <a href="welcome.jsp" class="button primary">Back to Home</a>
            <a href="User_Account_Info_Page.jsp" class="button secondary">View My Account</a>
        </div>
        
        <p style="font-size: 0.85rem; color: #a0aec0; margin-top: 2rem;">
            Thank you for using Tech Barn! 🎉
        </p>
    </div>
</body>
</html>
