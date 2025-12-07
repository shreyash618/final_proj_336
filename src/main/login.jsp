<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="util.DBConnection" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Tech Barn - Login</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: Arial, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 20px;
        }
        
        .container {
            background: white;
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.2);
            width: 100%;
            max-width: 450px;
        }
        
        h1 {
            color: #333;
            margin-bottom: 10px;
            text-align: center;
        }
        
        .subtitle {
            color: #666;
            text-align: center;
            margin-bottom: 30px;
            font-size: 14px;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        label {
            display: block;
            margin-bottom: 5px;
            color: #333;
            font-weight: 500;
        }
        
        input[type="text"],
        input[type="password"] {
            width: 100%;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 14px;
            transition: border-color 0.3s;
        }
        
        input:focus {
            outline: none;
            border-color: #667eea;
        }
        
        .btn {
            width: 100%;
            padding: 12px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: transform 0.2s;
        }
        
        .btn:hover {
            transform: translateY(-2px);
        }
        
        .message {
            padding: 12px;
            border-radius: 5px;
            margin-bottom: 20px;
            text-align: center;
        }
        
        .error {
            background-color: #fee;
            color: #c33;
            border: 1px solid #fcc;
        }
        
        .success {
            background-color: #efe;
            color: #3c3;
            border: 1px solid #cfc;
        }
        
        .register-link {
            text-align: center;
            margin-top: 20px;
            color: #666;
        }
        
        .register-link a {
            color: #667eea;
            text-decoration: none;
            font-weight: 600;
        }
        
        .register-link a:hover {
            text-decoration: underline;
        }
        
        .remember-me {
            display: flex;
            align-items: center;
            gap: 8px;
            margin-bottom: 20px;
        }
        
        .remember-me input[type="checkbox"] {
            width: 18px;
            height: 18px;
            cursor: pointer;
        }
        
        .user-type-badge {
            display: inline-block;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            margin: 5px 5px 0 0;
        }
        
        .badge-buyer {
            background-color: #e3f2fd;
            color: #1976d2;
        }
        
        .badge-seller {
            background-color: #f3e5f5;
            color: #7b1fa2;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Welcome Back!</h1>
        <p class="subtitle">Login to your Tech Barn account</p>
        
        <%
            String message = "";
            String messageType = "";
            
            // Check if user is already logged in
            if (session.getAttribute("user_id") != null) {
                // User is already logged in, redirect based on user type
                boolean isBuyer = (Boolean) session.getAttribute("isBuyer");
                boolean isSeller = (Boolean) session.getAttribute("isSeller");
                
                if (isSeller) {
                    response.sendRedirect("sellerhomepage.jsp");
                } else if (isBuyer) {
                    response.sendRedirect("buyerhomepage.jsp");
                }
                return;
            }
            
            // Check if form was submitted
            if ("POST".equalsIgnoreCase(request.getMethod())) {
                String username = request.getParameter("username");
                String password = request.getParameter("password");
                String rememberMe = request.getParameter("rememberMe");
                
                // Validation
                if (username == null || username.trim().isEmpty() ||
                    password == null || password.trim().isEmpty()) {
                    
                    message = "Please enter both username and password!";
                    messageType = "error";
                    
                } else {
                    // Try to authenticate user
                    Connection conn = null;
                    PreparedStatement stmt = null;
                    ResultSet rs = null;
                    
                    try {
                        conn = DBConnection.getConnection();
                        
                        String query = "SELECT user_id, first_name, last_name, email, isBuyer, isSeller FROM User WHERE username = ? AND password = ?";
                        stmt = conn.prepareStatement(query);
                        stmt.setString(1, username);
                        stmt.setString(2, password);
                        rs = stmt.executeQuery();
                        
                        if (rs.next()) {
                            // Login successful - create session
                            int userId = rs.getInt("user_id");
                            String firstName = rs.getString("first_name");
                            String lastName = rs.getString("last_name");
                            String email = rs.getString("email");
                            boolean isBuyer = rs.getBoolean("isBuyer");
                            boolean isSeller = rs.getBoolean("isSeller");
                            
                            // Store user info in session
                            session.setAttribute("user_id", userId);
                            session.setAttribute("username", username);
                            session.setAttribute("first_name", firstName);
                            session.setAttribute("last_name", lastName);
                            session.setAttribute("email", email);
                            session.setAttribute("isBuyer", isBuyer);
                            session.setAttribute("isSeller", isSeller);
                            
                            // Set session timeout (30 minutes)
                            session.setMaxInactiveInterval(1800);
                            
                            // Update last_login time (if you want to track this)
                            PreparedStatement updateStmt = null;
                            try {
                                String updateQuery = "UPDATE User SET last_login = NOW() WHERE user_id = ?";
                                updateStmt = conn.prepareStatement(updateQuery);
                                updateStmt.setInt(1, userId);
                                updateStmt.executeUpdate();
                            } catch (SQLException e) {
                                // last_login column might not exist, ignore error
                            } finally {
                                if (updateStmt != null) try { updateStmt.close(); } catch (SQLException e) {}
                            }
                            
                            // Redirect based on user type
                            if (isSeller) {
                                response.sendRedirect("sellerhomepage.jsp");
                            } else if (isBuyer) {
                                response.sendRedirect("buyerhomepage.jsp");
                            } else {
                                // User is neither buyer nor seller (shouldn't happen)
                                message = "Account configuration error. Please contact support.";
                                messageType = "error";
                            }
                            return;
                            
                        } else {
                            // Login failed
                            message = "Invalid username or password!";
                            messageType = "error";
                        }
                        
                    } catch (SQLException e) {
                        message = "Database error: " + e.getMessage();
                        messageType = "error";
                        e.printStackTrace();
                        
                    } finally {
                        if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
                        if (stmt != null) try { stmt.close(); } catch (SQLException e) { e.printStackTrace(); }
                        if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
                    }
                }
            }
        %>
        
        <% if (!message.isEmpty()) { %>
            <div class="message <%= messageType %>">
                <%= message %>
            </div>
        <% } %>
        
        <form method="POST" action="login.jsp">
            <div class="form-group">
                <label for="username">Username</label>
                <input type="text" id="username" name="username" required
                       value="<%= request.getParameter("username") != null ? request.getParameter("username") : "" %>">
            </div>
            
            <div class="form-group">
                <label for="password">Password</label>
                <input type="password" id="password" name="password" required>
            </div>
            
            <div class="remember-me">
                <input type="checkbox" id="rememberMe" name="rememberMe" value="1">
                <label for="rememberMe">Remember me</label>
            </div>
            
            <button type="submit" class="btn">Login</button>
        </form>
        
        <div class="register-link">
            Don't have an account? <a href="register.jsp">Sign up here</a>
        </div>
    </div>
</body>
</html>