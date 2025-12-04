<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Check if user is logged in as customer rep or admin
    String userRole = (String) session.getAttribute("role");
    if (session.getAttribute("username") == null || 
        (userRole != null && !"rep".equals(userRole) && !"admin".equals(userRole))) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Customer Rep Dashboard - Tech Barn</title>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;700&display=swap" rel="stylesheet">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Roboto', sans-serif; }
        body { background: #ffffff; min-height: 100vh; }
        
        /* Navbar Styles */
        .header {
            background: rgba(255, 255, 255, 0.95);
            padding: 1rem 2rem;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            position: sticky;
            top: 0;
            z-index: 100;
        }
        .navbar {
            display: flex;
            align-items: center;
            justify-content: space-between;
        }
        .company-logo {
            display: flex;
            align-items: center;
            font-size: 1.6rem;
            font-weight: 700;
            color: #6b9080;
            text-decoration: none;
        }
        .company-logo img {
            height: 40px;
            width: auto;
            margin-right: 10px;
        }
        .nav-links {
            list-style: none;
            display: flex;
            gap: 1.5rem;
            margin: 0;
            padding: 0;
        }
        .nav-links a {
            color: #6b9080;
            text-decoration: none;
            font-weight: 500;
            padding: 0.5rem 0.75rem;
            border-radius: 6px;
            transition: background 0.3s ease;
        }
        .nav-links a:hover {
            background-color: #6b9080;
            color: #fff;
        }
        .logout-btn {
            padding: 0.6rem 1.2rem;
            background: #6b9080;
            color: #fff;
            border-radius: 8px;
            font-size: 1rem;
            text-decoration: none;
            transition: background 0.3s ease, transform 0.2s ease;
        }
        .logout-btn:hover {
            background: #3e6b5c;
            transform: scale(1.05);
        }
        
        /* Content Styles */
        .container { max-width: 1000px; margin: 40px auto; padding: 0 20px; }
        .forms-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(450px, 1fr)); gap: 25px; }
        .form-card { background: #f8f9fa; padding: 30px; border-radius: 12px; box-shadow: 0 2px 8px rgba(0,0,0,0.05); border: 2px solid #e0e0e0; }
        .form-card h2 { color: #333; margin-bottom: 20px; font-size: 1.3rem; font-weight: 700; }
        .form-group { margin-bottom: 18px; }
        .form-group label { display: block; margin-bottom: 8px; color: #333; font-weight: 600; }
        .form-input { width: 100%; padding: 12px 16px; border: 2px solid #e0e0e0; border-radius: 8px; font-size: 1rem; background: white; color: #333; transition: all 0.3s; }
        .form-input:focus { outline: none; border-color: #6b9080; background: white; box-shadow: 0 0 0 4px rgba(107, 144, 128, 0.1); }
        .submit-btn { width: 100%; padding: 12px; background: #6b9080; color: white; border: none; border-radius: 8px; font-weight: 600; font-size: 1rem; cursor: pointer; transition: all 0.3s; }
        .submit-btn:hover { transform: translateY(-2px); box-shadow: 0 4px 12px rgba(107, 144, 128, 0.3); background: #5a7a6a; }
        .submit-btn.danger { background: #e74c3c; }
        .submit-btn.danger:hover { box-shadow: 0 4px 12px rgba(231, 76, 60, 0.3); background: #c0392b; }
        .message-card { background: white; padding: 20px; border-radius: 12px; box-shadow: 0 2px 8px rgba(0,0,0,0.05); margin-bottom: 30px; }
        .message { padding: 15px; border-radius: 8px; font-weight: 600; }
        .message.success { background: #c6f6d5; color: #22543d; border: 2px solid #9ae6b4; }
        .message.error { background: #fed7d7; color: #742a2a; border: 2px solid #fc8181; }
    </style>
</head>
<body>
    <!-- Customer Rep Navbar -->
    <header class="header">
        <nav class="navbar">
            <a href="custrep_home.jsp" class="company-logo">
                <img src="Images/Tech_Barn_Logo.png" alt="Tech Barn Logo">
                <span>Rep Dashboard</span>
            </a>

            <ul class="nav-links">
                <li><a href="<%=request.getContextPath()%>/faq">FAQ Management</a></li>
            </ul>

            <a href="<%=request.getContextPath()%>/logout" class="logout-btn">Logout</a>
        </nav>
    </header>

    <div class="container">
        <% if (request.getAttribute("errorMessage") != null) { %>
            <div class="message-card">
                <div class="message error"><%=request.getAttribute("errorMessage")%></div>
            </div>
        <% } %>
        <% if (request.getAttribute("successMessage") != null) { %>
            <div class="message-card">
                <div class="message success"><%=request.getAttribute("successMessage")%></div>
            </div>
        <% } %>

        <div class="forms-grid">
            <div class="form-card">
                <h2>Remove Bid</h2>
                <form method="post" action="<%=request.getContextPath()%>/custrep">
                    <input type="hidden" name="action" value="removeBid"/>
                    <div class="form-group">
                        <label for="bid_no">Bid Number</label>
                        <input type="number" id="bid_no" name="bid_no" class="form-input" required placeholder="Enter bid number">
                    </div>
                    <div class="form-group">
                        <label for="auction_id_bid">Auction ID</label>
                        <input type="number" id="auction_id_bid" name="auction_id" class="form-input" required placeholder="Enter auction ID">
                    </div>
                    <button type="submit" class="submit-btn danger">Remove Bid</button>
                </form>
            </div>

            <div class="form-card">
                <h2>Remove Illegal Auction</h2>
                <form method="post" action="<%=request.getContextPath()%>/custrep">
                    <input type="hidden" name="action" value="removeAuction"/>
                    <div class="form-group">
                        <label for="auction_id">Auction ID</label>
                        <input type="number" id="auction_id" name="auction_id" class="form-input" required placeholder="Enter auction ID">
                    </div>
                    <button type="submit" class="submit-btn danger">Remove Auction</button>
                </form>
            </div>

            <div class="form-card">
                <h2>Update User Account</h2>
                <form method="post" action="<%=request.getContextPath()%>/custrep">
                    <input type="hidden" name="action" value="updateUser"/>
                    <div class="form-group">
                        <label for="user_id_update">User ID</label>
                        <input type="number" id="user_id_update" name="user_id" class="form-input" required placeholder="Enter user ID">
                    </div>
                    <div class="form-group">
                        <label for="email">New Email</label>
                        <input type="email" id="email" name="email" class="form-input" required placeholder="newemail@example.com">
                    </div>
                    <button type="submit" class="submit-btn">Update Email</button>
                </form>
            </div>

            <div class="form-card">
                <h2>Delete User Account</h2>
                <form method="post" action="<%=request.getContextPath()%>/custrep">
                    <input type="hidden" name="action" value="deleteUser"/>
                    <div class="form-group">
                        <label for="user_id_delete">User ID</label>
                        <input type="number" id="user_id_delete" name="user_id" class="form-input" required placeholder="Enter user ID">
                    </div>
                    <button type="submit" class="submit-btn danger">Delete User</button>
                </form>
            </div>
        </div>
    </div>
</body>
</html>
