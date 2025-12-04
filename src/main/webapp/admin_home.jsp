<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Check if user is logged in as admin
    if (session.getAttribute("username") == null || !"admin".equals(session.getAttribute("role"))) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Dashboard - Tech Barn</title>
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
        .form-card { background: linear-gradient(135deg, #e8f5e9 0%, #c8e6c9 100%); padding: 30px; border-radius: 12px; box-shadow: 0 2px 8px rgba(0,0,0,0.05); }
        .form-card h2 { color: #2e7d32; margin-bottom: 25px; font-size: 1.5rem; font-weight: 700; }
        .form-group { margin-bottom: 20px; }
        .form-group label { display: block; margin-bottom: 8px; color: #333; font-weight: 600; }
        .form-input { width: 100%; padding: 14px 18px; border: 2px solid #a5d6a7; border-radius: 8px; font-size: 1rem; background: white; color: #333; transition: all 0.3s; }
        .form-input:focus { outline: none; border-color: #4caf50; background: white; box-shadow: 0 0 0 4px rgba(76, 175, 80, 0.1); }
        .submit-btn { width: 100%; padding: 14px; background: #4caf50; color: white; border: none; border-radius: 8px; font-weight: 600; font-size: 1rem; cursor: pointer; transition: all 0.3s; }
        .submit-btn:hover { transform: translateY(-2px); box-shadow: 0 4px 12px rgba(76, 175, 80, 0.3); background: #43a047; }
        .message { padding: 15px; border-radius: 8px; margin-top: 20px; font-weight: 600; }
        .message.success { background: #c6f6d5; color: #22543d; border: 2px solid #9ae6b4; }
        .message.error { background: #fed7d7; color: #742a2a; border: 2px solid #fc8181; }
    </style>
</head>
<body>
    <!-- Admin Navbar -->
    <header class="header">
        <nav class="navbar">
            <a href="admin_home.jsp" class="company-logo">
                <img src="Images/Tech_Barn_Logo.png" alt="Tech Barn Logo">
                <span>Admin Dashboard</span>
            </a>

            <ul class="nav-links">
                <li><a href="<%=request.getContextPath()%>/admin?action=reports">Sales Reports</a></li>
                <li><a href="<%=request.getContextPath()%>/faq">FAQ Management</a></li>
            </ul>

            <a href="<%=request.getContextPath()%>/logout" class="logout-btn">Logout</a>
        </nav>
    </header>

    <div class="container">

        <div class="form-card">
            <h2>Create Customer Representative</h2>
            <form method="post" action="<%=request.getContextPath()%>/admin">
                <div class="form-group">
                    <label for="first_name">First Name</label>
                    <input type="text" id="first_name" name="first_name" class="form-input" required placeholder="Enter first name">
                </div>
                <div class="form-group">
                    <label for="last_name">Last Name</label>
                    <input type="text" id="last_name" name="last_name" class="form-input" required placeholder="Enter last name">
                </div>
                <div class="form-group">
                    <label for="username">Username</label>
                    <input type="text" id="username" name="username" class="form-input" required placeholder="Choose a username">
                </div>
                <div class="form-group">
                    <label for="password">Password</label>
                    <input type="password" id="password" name="password" class="form-input" required placeholder="Create a password">
                </div>
                <div class="form-group">
                    <label for="email">Email</label>
                    <input type="email" id="email" name="email" class="form-input" required placeholder="rep@techbarn.com">
                </div>
                <button type="submit" class="submit-btn">Create Representative</button>
            </form>

            <% if (request.getAttribute("errorMessage") != null) { %>
                <div class="message error"><%=request.getAttribute("errorMessage")%></div>
            <% } %>
            <% if (request.getAttribute("successMessage") != null) { %>
                <div class="message success"><%=request.getAttribute("successMessage")%></div>
            <% } %>
        </div>
    </div>
</body>
</html>
