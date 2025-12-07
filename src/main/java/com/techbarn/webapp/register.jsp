<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="util.DBConnection" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Tech Barn - Create Account</title>
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
            max-width: 500px;
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
        input[type="email"],
        input[type="password"],
        input[type="date"],
        input[type="tel"] {
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
        
        .checkbox-group {
            display: flex;
            gap: 30px;
            margin-top: 10px;
        }
        
        .checkbox-item {
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .checkbox-item input[type="checkbox"] {
            width: 18px;
            height: 18px;
            cursor: pointer;
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
        
        .login-link {
            text-align: center;
            margin-top: 20px;
            color: #666;
        }
        
        .login-link a {
            color: #667eea;
            text-decoration: none;
            font-weight: 600;
        }
        
        .login-link a:hover {
            text-decoration: underline;
        }
        
        .required {
            color: red;
        }
        
        .optional {
            color: #999;
            font-size: 12px;
            font-weight: normal;
        }
        
        .user-type-section {
            background: #f8f9fa;
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 20px;
        }
        
        .user-type-section h3 {
            font-size: 14px;
            color: #333;
            margin-bottom: 10px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Create Your Account</h1>
        <p class="subtitle">Join Tech Barn and start buying or selling tech today!</p>
        
        <%
            String message = "";
            String messageType = "";
            
            // Check if form was submitted
            if ("POST".equalsIgnoreCase(request.getMethod())) {
                String username = request.getParameter("username");
                String email = request.getParameter("email");
                String password = request.getParameter("password");
                String confirmPassword = request.getParameter("confirmPassword");
                String firstName = request.getParameter("firstName");
                String lastName = request.getParameter("lastName");
                String phoneNo = request.getParameter("phoneNo");
                String dob = request.getParameter("dob");
                String isBuyer = request.getParameter("isBuyer");
                String isSeller = request.getParameter("isSeller");
                
                // Validation
                if (username == null || username.trim().isEmpty() ||
                    email == null || email.trim().isEmpty() ||
                    password == null || password.trim().isEmpty() ||
                    confirmPassword == null || confirmPassword.trim().isEmpty() ||
                    firstName == null || firstName.trim().isEmpty() ||
                    lastName == null || lastName.trim().isEmpty()) {
                    
                    message = "All required fields must be filled!";
                    messageType = "error";
                    
                } else if (!password.equals(confirmPassword)) {
                    message = "Passwords do not match!";
                    messageType = "error";
                    
                } else if (password.length() < 6) {
                    message = "Password must be at least 6 characters long!";
                    messageType = "error";
                    
                } else if (isBuyer == null && isSeller == null) {
                    message = "Please select at least one account type (Buyer or Seller)!";
                    messageType = "error";
                    
                } else {
                    // Try to insert into database
                    Connection conn = null;
                    PreparedStatement checkStmt = null;
                    PreparedStatement insertStmt = null;
                    ResultSet rs = null;
                    
                    try {
                        conn = DBConnection.getConnection();
                        
                        // Check if username or email already exists
                        String checkQuery = "SELECT username, email FROM User WHERE username = ? OR email = ?";
                        checkStmt = conn.prepareStatement(checkQuery);
                        checkStmt.setString(1, username);
                        checkStmt.setString(2, email);
                        rs = checkStmt.executeQuery();
                        
                        if (rs.next()) {
                            String existingUsername = rs.getString("username");
                            String existingEmail = rs.getString("email");
                            
                            if (existingUsername.equals(username)) {
                                message = "Username already exists! Please choose a different username.";
                            } else {
                                message = "Email already registered! Please use a different email.";
                            }
                            messageType = "error";
                            
                        } else {
                            // Insert new user
                            String insertQuery = "INSERT INTO User (first_name, last_name, username, email, password, phone_no, dob, created_at, isBuyer, isSeller, rating) " +
                                               "VALUES (?, ?, ?, ?, ?, ?, ?, CURDATE(), ?, ?, 0.0)";
                            insertStmt = conn.prepareStatement(insertQuery);
                            insertStmt.setString(1, firstName);
                            insertStmt.setString(2, lastName);
                            insertStmt.setString(3, username);
                            insertStmt.setString(4, email);
                            insertStmt.setString(5, password); // In production, hash this password!
                            
                            // Handle optional phone number
                            if (phoneNo != null && !phoneNo.trim().isEmpty()) {
                                insertStmt.setString(6, phoneNo);
                            } else {
                                insertStmt.setNull(6, Types.VARCHAR);
                            }
                            
                            // Handle optional date of birth
                            if (dob != null && !dob.trim().isEmpty()) {
                                insertStmt.setDate(7, Date.valueOf(dob));
                            } else {
                                insertStmt.setNull(7, Types.DATE);
                            }
                            
                            // Set isBuyer and isSeller
                            insertStmt.setBoolean(8, isBuyer != null);
                            insertStmt.setBoolean(9, isSeller != null);
                            
                            int rowsAffected = insertStmt.executeUpdate();
                            
                            if (rowsAffected > 0) {
                                message = "Account created successfully! Redirecting to login...";
                                messageType = "success";
                                
                                // Redirect to login page after 2 seconds
                                response.setHeader("Refresh", "2; URL=login.jsp");
                            } else {
                                message = "Registration failed. Please try again.";
                                messageType = "error";
                            }
                        }
                        
                    } catch (SQLException e) {
                        message = "Database error: " + e.getMessage();
                        messageType = "error";
                        e.printStackTrace();
                        
                    } finally {
                        if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
                        if (checkStmt != null) try { checkStmt.close(); } catch (SQLException e) { e.printStackTrace(); }
                        if (insertStmt != null) try { insertStmt.close(); } catch (SQLException e) { e.printStackTrace(); }
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
        
        <form method="POST" action="register.jsp">
            <div class="form-group">
                <label for="firstName">First Name <span class="required">*</span></label>
                <input type="text" id="firstName" name="firstName" required maxlength="20"
                       value="<%= request.getParameter("firstName") != null ? request.getParameter("firstName") : "" %>">
            </div>
            
            <div class="form-group">
                <label for="lastName">Last Name <span class="required">*</span></label>
                <input type="text" id="lastName" name="lastName" required maxlength="20"
                       value="<%= request.getParameter("lastName") != null ? request.getParameter("lastName") : "" %>">
            </div>
            
            <div class="form-group">
                <label for="username">Username <span class="required">*</span></label>
                <input type="text" id="username" name="username" required maxlength="50"
                       value="<%= request.getParameter("username") != null ? request.getParameter("username") : "" %>">
            </div>
            
            <div class="form-group">
                <label for="email">Email <span class="required">*</span></label>
                <input type="email" id="email" name="email" required maxlength="50"
                       value="<%= request.getParameter("email") != null ? request.getParameter("email") : "" %>">
            </div>
            
            <div class="form-group">
                <label for="phoneNo">Phone Number <span class="optional">(Optional)</span></label>
                <input type="tel" id="phoneNo" name="phoneNo" maxlength="10" placeholder="1234567890"
                       value="<%= request.getParameter("phoneNo") != null ? request.getParameter("phoneNo") : "" %>">
            </div>
            
            <div class="form-group">
                <label for="dob">Date of Birth <span class="optional">(Optional)</span></label>
                <input type="date" id="dob" name="dob"
                       value="<%= request.getParameter("dob") != null ? request.getParameter("dob") : "" %>">
            </div>
            
            <div class="form-group">
                <label for="password">Password <span class="required">*</span></label>
                <input type="password" id="password" name="password" required minlength="6" maxlength="20">
            </div>
            
            <div class="form-group">
                <label for="confirmPassword">Confirm Password <span class="required">*</span></label>
                <input type="password" id="confirmPassword" name="confirmPassword" required minlength="6" maxlength="20">
            </div>
            
            <div class="user-type-section">
                <h3>Account Type <span class="required">*</span></h3>
                <div class="checkbox-group">
                    <div class="checkbox-item">
                        <input type="checkbox" id="isBuyer" name="isBuyer" value="1"
                               <%= request.getParameter("isBuyer") != null ? "checked" : "" %>>
                        <label for="isBuyer">I want to buy items</label>
                    </div>
                    <div class="checkbox-item">
                        <input type="checkbox" id="isSeller" name="isSeller" value="1"
                               <%= request.getParameter("isSeller") != null ? "checked" : "" %>>
                        <label for="isSeller">I want to sell items</label>
                    </div>
                </div>
            </div>
            
            <button type="submit" class="btn">Create Account</button>
        </form>
        
        <div class="login-link">
            Already have an account? <a href="login.jsp">Login here</a>
        </div>
    </div>
</body>
</html>