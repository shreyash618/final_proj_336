<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Tech Barn - My Account</title>
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
      background: #f3f4f6;
      display: flex;
      justify-content: center;
      align-items: center;
    }

    .card {
      width: 100%;
      max-width: 700px;
      background: #ffffff;
      border-radius: 20px;
      padding: 2.5rem;
      box-shadow: 0 20px 50px rgba(15, 23, 42, 0.15);
    }

    h1 {
      margin-bottom: 0.4rem;
      color: #111827;
      font-weight: 700;
      font-size: 1.9rem;
      letter-spacing: -0.4px;
    }

    .subtitle {
      font-size: 0.9rem;
      color: #6b7280;
      margin-bottom: 1.3rem;
    }

    .section-title {
      margin-top: 1rem;
      margin-bottom: 0.4rem;
      font-size: 0.95rem;
      font-weight: 600;
      color: #111827;
    }

    .info-grid {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 10px 18px;
      margin-bottom: 0.6rem;
    }

    .info-label {
      font-size: 0.8rem;
      text-transform: uppercase;
      letter-spacing: 0.03em;
      color: #9ca3af;
    }

    .info-value {
      font-size: 0.95rem;
      color: #111827;
      font-weight: 500;
    }

    .tag {
      display: inline-flex;
      align-items: center;
      border-radius: 999px;
      padding: 3px 10px;
      font-size: 0.8rem;
      font-weight: 500;
      margin-right: 6px;
    }

    .tag-buyer {
      background: #eff6ff;
      color: #1d4ed8;
    }

    .tag-seller {
      background: #ecfdf5;
      color: #047857;
    }

    .message {
      margin-top: 12px;
      padding: 10px 12px;
      border-radius: 9px;
      font-size: 0.9rem;
      font-weight: 500;
    }

    .message.error {
      background: #fee2e2;
      border: 1px solid #fecaca;
      color: #b91c1c;
    }

    .message.success {
      background: #dcfce7;
      border: 1px solid #bbf7d0;
      color: #166534;
    }

    .message.info {
      background: #eff6ff;
      border: 1px solid #bfdbfe;
      color: #1d4ed8;
    }

    .actions {
      margin-top: 1.4rem;
      display: flex;
      justify-content: space-between;
      align-items: center;
      gap: 12px;
      flex-wrap: wrap;
    }

    .danger-button {
      padding: 10px 14px;
      border-radius: 10px;
      border: none;
      cursor: pointer;
      font-size: 0.9rem;
      font-weight: 600;
      background: #ef4444;
      color: #ffffff;
      box-shadow: 0 6px 16px rgba(239, 68, 68, 0.45);
      transition: all 0.15s ease;
    }

    .danger-button:hover {
      background: #dc2626;
      transform: translateY(-1px);
      box-shadow: 0 8px 20px rgba(220, 38, 38, 0.55);
    }

    .back-link {
      font-size: 0.9rem;
      color: #6366f1;
      text-decoration: none;
    }

    .back-link:hover {
      text-decoration: underline;
      color: #4f46e5;
    }

    .small-muted {
      font-size: 0.8rem;
      color: #9ca3af;
      margin-top: 4px;
    }

    .inline-form {
      margin-top: 0.75rem;
      display: flex;
      flex-direction: column;
      gap: 8px;
    }

    .inline-form label {
      font-size: 0.85rem;
      color: #4b5563;
      font-weight: 600;
    }

    .inline-form input[type="text"],
    .inline-form input[type="password"] {
      padding: 8px 10px;
      border-radius: 8px;
      border: 1px solid #e5e7eb;
      font-size: 0.9rem;
    }

    .inline-form button {
      align-self: flex-start;
      padding: 8px 14px;
      border-radius: 8px;
      border: none;
      cursor: pointer;
      font-size: 0.9rem;
      font-weight: 600;
      background: #6366f1;
      color: #ffffff;
      margin-top: 4px;
    }

    .inline-form button:hover {
      background: #4f46e5;
    }

    @media (max-width: 640px) {
      .card {
        margin: 1rem;
        padding: 1.8rem;
      }
      .info-grid {
        grid-template-columns: 1fr;
      }
    }
  </style>
</head>
<body>

<%
    Integer userId = null;
    Object sessionUserIdObj = session.getAttribute("userId");

    if (sessionUserIdObj instanceof Integer) {
        userId = (Integer) sessionUserIdObj;
    } else if (sessionUserIdObj instanceof String) {
        try {
            userId = Integer.parseInt((String) sessionUserIdObj);
        } catch (NumberFormatException ignore) {}
    }

    if (userId == null) {
        String param = request.getParameter("userId");
        if (param != null && !param.trim().isEmpty()) {
            try { userId = Integer.parseInt(param.trim()); } catch (NumberFormatException ignore) {}
        }
    }

    String errorMessage = null;
    String successMessage = null;
    boolean accountDeleted = false;

    // ---------- inline login on this page ----------
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String action = request.getParameter("action");

        if ("login".equals(action) && userId == null) {
            String loginUsername = request.getParameter("loginUsername");
            String loginPassword = request.getParameter("loginPassword");

            if (loginUsername == null || loginUsername.trim().isEmpty()
             || loginPassword == null || loginPassword.trim().isEmpty()) {
                errorMessage = "Username and password are required.";
            } else {
                Connection conLogin = null;
                PreparedStatement psLogin = null;
                ResultSet rsLogin = null;
                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    String url  = "jdbc:mysql://localhost:3306/tech_barn?useUnicode=true&useSSL=false";
                    String user = "root";
                    String pass = "password123";

                    conLogin = DriverManager.getConnection(url, user, pass);

                    String sqlLogin =
                        "SELECT user_id FROM `User` WHERE username = ? AND password = ?";
                    psLogin = conLogin.prepareStatement(sqlLogin);
                    psLogin.setString(1, loginUsername.trim());
                    psLogin.setString(2, loginPassword.trim());
                    rsLogin = psLogin.executeQuery();

                    if (rsLogin.next()) {
                        userId = rsLogin.getInt("user_id");
                        session.setAttribute("userId", userId);
                        successMessage = "Logged in successfully.";
                        errorMessage = null;
                    } else {
                        errorMessage = "Invalid username or password.";
                    }
                } catch (Exception e) {
                    errorMessage = "Error during login: " + e.getMessage();
                } finally {
                    try { if (rsLogin != null) rsLogin.close(); } catch (Exception ignore) {}
                    try { if (psLogin != null) psLogin.close(); } catch (Exception ignore) {}
                    try { if (conLogin != null) conLogin.close(); } catch (Exception ignore) {}
                }
            }
        }

        // delete account
        if ("delete".equals(action) && userId != null) {
            Connection con = null;
            PreparedStatement psDel = null;

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                String url  = "jdbc:mysql://localhost:3306/tech_barn?useUnicode=true&useSSL=false";
                String user = "root";
                String pass = "password123";

                con = DriverManager.getConnection(url, user, pass);

                String sqlDel = "DELETE FROM `User` WHERE user_id = ?";
                psDel = con.prepareStatement(sqlDel);
                psDel.setInt(1, userId);

                int rows = psDel.executeUpdate();
                if (rows > 0) {
                    successMessage = "Your account has been deleted.";
                    accountDeleted = true;
                    session.invalidate();
                } else {
                    errorMessage = "Could not delete account (no rows affected).";
                }
            } catch (Exception e) {
                errorMessage = "Error deleting account: " + e.getMessage();
            } finally {
                try { if (psDel != null) psDel.close(); } catch (Exception ignore) {}
                try { if (con  != null) con.close(); } catch (Exception ignore) {}
            }
        }
    }

    String username = null;
    String firstName = null;
    String lastName  = null;
    String email     = null;
    String phone     = null;
    String address   = null;
    String role      = null;

    if (!accountDeleted) {
        if (userId == null) {
            if (errorMessage == null) {
                errorMessage = "No user is logged in. Please log in first.";
            }
        } else {
            Connection con = null;
            PreparedStatement ps = null;
            ResultSet rs = null;

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                String url  = "jdbc:mysql://localhost:3306/tech_barn?useUnicode=true&useSSL=false";
                String user = "root";
                String pass = "password123";

                con = DriverManager.getConnection(url, user, pass);

                String sql =
                    "SELECT u.user_id, u.username, u.first_name, u.last_name, " +
                    "       u.email, u.phone_no, " +
                    "       a.street_name, a.apt_no, a.city, a.state, a.zip, " +
                    "       u.isBuyer, u.isSeller " +
                    "FROM `User` u " +
                    "LEFT JOIN Address a ON u.address_id = a.address_id " +
                    "WHERE u.user_id = ?";

                ps = con.prepareStatement(sql);
                ps.setInt(1, userId);
                rs = ps.executeQuery();

                if (rs.next()) {
                    username  = rs.getString("username");
                    firstName = rs.getString("first_name");
                    lastName  = rs.getString("last_name");
                    email     = rs.getString("email");
                    phone     = rs.getString("phone_no");

                    String street = rs.getString("street_name");
                    String apt    = rs.getString("apt_no");
                    String city   = rs.getString("city");
                    String state  = rs.getString("state");
                    String zip    = rs.getString("zip");

                    StringBuilder addr = new StringBuilder();
                    if (street != null) addr.append(street);
                    if (apt != null && !apt.isEmpty()) addr.append(", ").append(apt);
                    if (city != null) addr.append(", ").append(city);
                    if (state != null) addr.append(", ").append(state);
                    if (zip != null) addr.append(" ").append(zip);
                    address = addr.toString();

                    boolean isBuyer  = rs.getBoolean("isBuyer");
                    boolean isSeller = rs.getBoolean("isSeller");

                    if (isBuyer && isSeller) {
                        role = "buyer,seller";
                    } else if (isBuyer) {
                        role = "buyer";
                    } else if (isSeller) {
                        role = "seller";
                    } else {
                        role = "user";
                    }
                } else {
                    errorMessage = "No account found for user ID " + userId;
                }

            } catch (Exception e) {
                errorMessage = "Error loading account info: " + e.getMessage();
            } finally {
                try { if (rs != null) rs.close(); } catch (Exception ignore) {}
                try { if (ps != null) ps.close(); } catch (Exception ignore) {}
                try { if (con != null) con.close(); } catch (Exception ignore) {}
            }
        }
    }
%>

<div class="card">
  <h1>My Account</h1>
  <p class="subtitle">View your buyer/seller information and manage your account.</p>

  <% if (errorMessage != null) { %>
    <div class="message error"><%= errorMessage %></div>
  <% } %>

  <% if (successMessage != null) { %>
    <div class="message success"><%= successMessage %></div>
  <% } %>

  <!-- inline login form when not logged in -->
  <% if (!accountDeleted && username == null) { %>
    <form method="post" action="User_Account_Info_Page.jsp" class="inline-form">
      <input type="hidden" name="action" value="login" />
      <label for="loginUsername">Username</label>
      <input type="text" id="loginUsername" name="loginUsername" required />

      <label for="loginPassword">Password</label>
      <input type="password" id="loginPassword" name="loginPassword" required />

      <button type="submit">Log In</button>
      <p class="small-muted">
        Log in here to view and manage your account information.
      </p>
    </form>
  <% } %>

  <% if (!accountDeleted && errorMessage == null && username != null) { %>

    <div class="section-title">Profile</div>
    <div class="info-grid">
      <div>
        <div class="info-label">Username</div>
        <div class="info-value"><%= username %></div>
      </div>
      <div>
        <div class="info-label">Full Name</div>
        <div class="info-value">
          <%= (firstName != null ? firstName : "") %>
          <%= (lastName  != null ? lastName  : "") %>
        </div>
      </div>
      <div>
        <div class="info-label">Email</div>
        <div class="info-value"><%= email %></div>
      </div>
      <div>
        <div class="info-label">Phone</div>
        <div class="info-value"><%= phone %></div>
      </div>
      <div style="grid-column: 1 / -1;">
        <div class="info-label">Address</div>
        <div class="info-value"><%= address %></div>
      </div>
    </div>

    <div class="section-title">Account Type</div>
    <div>
      <%
         String roleLower = (role == null) ? "" : role.toLowerCase(Locale.ROOT);
      %>
      <% if (roleLower.contains("buyer")) { %>
        <span class="tag tag-buyer">Buyer</span>
      <% } %>
      <% if (roleLower.contains("seller")) { %>
        <span class="tag tag-seller">Seller</span>
      <% } %>
      <% if (!roleLower.contains("buyer") && !roleLower.contains("seller")) { %>
        <span class="tag tag-buyer">Standard User</span>
      <% } %>
      <p class="small-muted">
        This page is a self-view: you are only seeing your own account details.
      </p>
    </div>

    <div class="actions">
	  <form method="post" action="User_Account_Info_Page.jsp"
	        onsubmit="return confirm('Are you sure you want to delete your account? This cannot be undone.');">
	    <input type="hidden" name="action" value="delete" />
	    <button type="submit" class="danger-button">Delete My Account</button>
	  </form>
		
	  <div style="display: flex; gap: 12px; flex-wrap: wrap;">
	    <a href="welcome.jsp" class="back-link">Back to Home</a>
	    <a href="login.jsp" class="back-link">Back to Login</a>
	  </div>
	</div>


      <a href="welcome.jsp" class="back-link">Back to Home</a>
    </div>

  <% } else if (accountDeleted) { %>
    <div class="message info">
      Your account has been removed from the system.
    </div>
    <div class="actions">
      <a href="welcome.jsp" class="back-link">Back to Home</a>
    </div>
  <% } %>
</div>

</body>
</html>
