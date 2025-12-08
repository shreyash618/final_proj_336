<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="com.techbarn.webapp.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>

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
    <title>Tech Barn - Payment</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet">
    <style>
        * { 
            margin: 0; 
            padding: 0; 
            box-sizing: border-box; 
            font-family: 'Inter', sans-serif; 
        }
        
        body, html {
            min-height: 100%;
            width: 100%;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }

        body {
            display: flex;
            justify-content: center;
            padding: 2rem;
            overflow-y: auto;
        }

        .payment-container {
            width: 100%;
            max-width: 800px;
            background: #ffffff;
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
            overflow: hidden;
            display: flex;
            flex-direction: column;
            margin: auto;
        }

        .payment-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 2rem;
        }

        .payment-header h1 {
            font-size: 1.8rem;
            margin-bottom: 0.5rem;
            font-weight: 700;
        }

        .payment-header p {
            font-size: 0.95rem;
            opacity: 0.9;
        }

        .payment-body {
            padding: 2rem;
        }

        .order-summary {
            background: #f7fafc;
            border-radius: 12px;
            padding: 1.5rem;
            margin-bottom: 2rem;
            border: 2px solid #e2e8f0;
        }

        .order-summary h3 {
            font-size: 1rem;
            color: #2d3748;
            margin-bottom: 1rem;
            font-weight: 600;
        }

        .order-item {
            display: flex;
            justify-content: space-between;
            margin-bottom: 0.5rem;
            font-size: 0.95rem;
        }

        .order-item .label {
            color: #718096;
        }

        .order-item .value {
            color: #2d3748;
            font-weight: 500;
        }

        .order-total {
            display: flex;
            justify-content: space-between;
            margin-top: 1rem;
            padding-top: 1rem;
            border-top: 2px solid #e2e8f0;
            font-size: 1.2rem;
            font-weight: 700;
        }

        .order-total .amount {
            color: #667eea;
        }

        .form-section {
            margin-bottom: 1.5rem;
        }

        .form-section h3 {
            font-size: 1rem;
            color: #2d3748;
            margin-bottom: 1rem;
            font-weight: 600;
        }

        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1rem;
            margin-bottom: 1rem;
        }

        .form-row.full {
            grid-template-columns: 1fr;
        }

        .form-group {
            display: flex;
            flex-direction: column;
        }

        label {
            font-size: 0.85rem;
            font-weight: 600;
            color: #4a5568;
            margin-bottom: 0.4rem;
        }

        .form-input {
            width: 100%;
            padding: 12px 16px;
            border: 2px solid #e2e8f0;
            border-radius: 10px;
            font-size: 1rem;
            outline: none;
            transition: all 0.3s ease;
            background: #f7fafc;
        }

        .form-input:focus {
            border-color: #667eea;
            background: #ffffff;
            box-shadow: 0 0 0 4px rgba(102, 126, 234, 0.1);
        }

        .form-input.small {
            max-width: 120px;
        }

        .card-input-group {
            display: flex;
            gap: 1rem;
        }

        .message {
            padding: 12px 16px;
            border-radius: 10px;
            margin-bottom: 1.5rem;
            font-size: 0.9rem;
        }

        .message.error {
            background: #fed7d7;
            color: #742a2a;
            border: 2px solid #fc8181;
        }

        .message.success {
            background: #c6f6d5;
            color: #22543d;
            border: 2px solid #9ae6b4;
        }

        .button-group {
            display: flex;
            gap: 1rem;
            margin-top: 2rem;
        }

        .submit-button {
            flex: 1;
            padding: 14px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: #fff;
            font-size: 1rem;
            font-weight: 600;
            border: none;
            border-radius: 10px;
            cursor: pointer;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(102, 126, 234, 0.4);
        }

        .submit-button:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(102, 126, 234, 0.5);
        }

        .submit-button:active {
            transform: translateY(0);
        }

        .cancel-button {
            padding: 14px 2rem;
            background: #e2e8f0;
            color: #4a5568;
            font-size: 1rem;
            font-weight: 600;
            border: none;
            border-radius: 10px;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-block;
            text-align: center;
        }

        .cancel-button:hover {
            background: #cbd5e0;
        }

        .security-note {
            background: #eff6ff;
            border: 1px solid #bfdbfe;
            border-radius: 8px;
            padding: 1rem;
            margin-top: 1.5rem;
            font-size: 0.85rem;
            color: #1e40af;
        }

        .security-note strong {
            display: block;
            margin-bottom: 0.3rem;
        }

        @media (max-width: 768px) {
            .form-row {
                grid-template-columns: 1fr;
            }
            
            .card-input-group {
                flex-direction: column;
            }
            
            .button-group {
                flex-direction: column;
            }
        }
    </style>
</head>
<body>
    <div class="payment-container">
        <div class="payment-header">
            <h1>🔒 Secure Payment</h1>
            <p>Complete your purchase to finalize the auction</p>
        </div>
        
        <div class="payment-body">
            <% 
                String errorMessage = (String) request.getAttribute("errorMessage");
                if (errorMessage != null) { 
            %>
                <div class="message error"><strong>Error:</strong> <%= errorMessage %></div>
            <% 
                }
                
                Integer auctionId = (Integer) request.getAttribute("auctionId");
                String itemTitle = (String) request.getAttribute("itemTitle");
                String itemBrand = (String) request.getAttribute("itemBrand");
                String itemColor = (String) request.getAttribute("itemColor");
                java.math.BigDecimal winningBid = (java.math.BigDecimal) request.getAttribute("winningBid");
                
                if (auctionId != null && winningBid != null) {
            %>
            
            <div class="order-summary">
                <h3>Order Summary</h3>
                <div class="order-item">
                    <span class="label">Auction ID:</span>
                    <span class="value">#<%= auctionId %></span>
                </div>
                <div class="order-item">
                    <span class="label">Item:</span>
                    <span class="value"><%= itemTitle %></span>
                </div>
                <div class="order-item">
                    <span class="label">Brand:</span>
                    <span class="value"><%= itemBrand %></span>
                </div>
                <div class="order-item">
                    <span class="label">Color:</span>
                    <span class="value"><%= itemColor %></span>
                </div>
                <div class="order-total">
                    <span>Total Amount:</span>
                    <span class="amount">$<%= winningBid %></span>
                </div>
            </div>

            <form method="post" action="payment">
                <input type="hidden" name="auctionId" value="<%= auctionId %>">
                
                <div class="form-section">
                    <h3>💳 Card Information</h3>
                    
                    <div class="form-row full">
                        <div class="form-group">
                            <label for="cardName">Cardholder Name</label>
                            <input type="text" id="cardName" name="cardName" class="form-input" 
                                   placeholder="John Doe" required
                                   value="<%= request.getAttribute("cardName") != null ? request.getAttribute("cardName") : "" %>">
                        </div>
                    </div>
                    
                    <div class="form-row full">
                        <div class="form-group">
                            <label for="cardNumber">Card Number</label>
                            <input type="text" id="cardNumber" name="cardNumber" class="form-input" 
                                   placeholder="1234 5678 9012 3456" maxlength="19" required
                                   value="<%= request.getAttribute("cardNumber") != null ? request.getAttribute("cardNumber") : "" %>">
                        </div>
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label>Expiration Date</label>
                            <div class="card-input-group">
                                <input type="text" name="expiryMonth" class="form-input small" 
                                       placeholder="MM" maxlength="2" required pattern="[0-9]{2}"
                                       value="<%= request.getAttribute("expiryMonth") != null ? request.getAttribute("expiryMonth") : "" %>">
                                <input type="text" name="expiryYear" class="form-input small" 
                                       placeholder="YYYY" maxlength="4" required pattern="[0-9]{4}"
                                       value="<%= request.getAttribute("expiryYear") != null ? request.getAttribute("expiryYear") : "" %>">
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <label for="cvc">CVC</label>
                            <input type="text" id="cvc" name="cvc" class="form-input small" 
                                   placeholder="123" maxlength="3" required pattern="[0-9]{3}"
                                   value="<%= request.getAttribute("cvc") != null ? request.getAttribute("cvc") : "" %>">
                        </div>
                    </div>
                </div>
                
                <div class="form-section">
                    <h3>📍 Billing Address</h3>
                    
                    <div class="form-row full">
                        <div class="form-group">
                            <label for="street">Street Address</label>
                            <input type="text" id="street" name="street" class="form-input" 
                                   placeholder="123 Main St" required
                                   value="<%= request.getAttribute("street") != null ? request.getAttribute("street") : "" %>">
                        </div>
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label for="city">City</label>
                            <input type="text" id="city" name="city" class="form-input" 
                                   placeholder="New York" required
                                   value="<%= request.getAttribute("city") != null ? request.getAttribute("city") : "" %>">
                        </div>
                        
                        <div class="form-group">
                            <label for="state">State</label>
                            <input type="text" id="state" name="state" class="form-input" 
                                   placeholder="NY" required maxlength="2"
                                   value="<%= request.getAttribute("state") != null ? request.getAttribute("state") : "" %>">
                        </div>
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label for="zip">ZIP Code</label>
                            <input type="text" id="zip" name="zip" class="form-input" 
                                   placeholder="12345" required pattern="[0-9]{5}(-[0-9]{4})?"
                                   value="<%= request.getAttribute("zip") != null ? request.getAttribute("zip") : "" %>">
                        </div>
                    </div>
                </div>
                
                <div class="button-group">
                    <button type="submit" class="submit-button">Complete Payment - $<%= winningBid %></button>
                    <a href="welcome.jsp" class="cancel-button">Cancel</a>
                </div>
            </form>
            
            <div class="security-note">
                <strong>🔒 Secure Payment</strong>
                This is a simulated payment for educational purposes. Your card information is validated but not stored or processed.
            </div>
            
            <% } else { %>
                <div class="message error">
                    <strong>No auction information available.</strong> Please select an auction to pay for.
                </div>
                <a href="welcome.jsp" class="cancel-button" style="display: inline-block; margin-top: 1rem;">Go to Home</a>
            <% } %>
        </div>
    </div>

    <script>
        // Format card number with spaces
        document.getElementById('cardNumber')?.addEventListener('input', function(e) {
            let value = e.target.value.replace(/\s/g, '');
            let formattedValue = value.match(/.{1,4}/g)?.join(' ') || value;
            e.target.value = formattedValue;
        });
        
        // Only allow numbers in card number
        document.getElementById('cardNumber')?.addEventListener('keypress', function(e) {
            if (!/[0-9\s]/.test(e.key) && e.key !== 'Backspace') {
                e.preventDefault();
            }
        });
        
        // Only allow numbers in CVC
        document.getElementById('cvc')?.addEventListener('keypress', function(e) {
            if (!/[0-9]/.test(e.key) && e.key !== 'Backspace') {
                e.preventDefault();
            }
        });
    </script>
</body>
</html>