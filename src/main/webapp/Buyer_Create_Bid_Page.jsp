<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*" %>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Tech Barn - Place a Bid</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
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
    background: url('Images/devices4.jpg') no-repeat center center/cover;
    background-attachment: fixed;
    display: flex;
    justify-content: center;
    align-items: center;
    position: relative;
    overflow: hidden;
  }

  .form-box {
    position: relative;
    z-index: 1;
    width: 100%;
    max-width: 500px;
    background: #ffffff;
    border-radius: 20px;
    padding: 3rem 2.5rem;
    box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
    text-align: center;
    transition: all 0.3s ease;
  }

  .form-box:hover {
    box-shadow: 0 25px 70px rgba(0, 0, 0, 0.35);
  }

  h1 {
    margin-bottom: 0.5rem;
    color: #2d3748;
    font-weight: 700;
    font-size: 2rem;
    letter-spacing: -0.5px;
  }

  .subtitle {
    font-size: 0.9rem;
    color: #718096;
    margin-bottom: 1.2rem;
  }

  .form-container {
    width: 100%;
    text-align: left;
  }

  label {
    display: block;
    font-size: 0.9rem;
    font-weight: 600;
    color: #4a5568;
    margin-top: 6px;
  }

  .form-input {
    width: 100%;
    padding: 14px 18px;
    margin: 6px 0 12px 0;
    border: 2px solid #e2e8f0;
    border-radius: 10px;
    font-size: 1rem;
    outline: none;
    transition: all 0.3s ease;
    background: #f7fafc;
    color: #2d3748;
  }

  .form-input::placeholder {
    color: #a0aec0;
  }

  .form-input:focus {
    border-color: #667eea;
    background: #ffffff;
    box-shadow: 0 0 0 4px rgba(102, 126, 234, 0.1);
    transform: translateY(-1px);
  }

  .submit-button {
    width: 100%;
    padding: 14px;
    margin-top: 10px;
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

  .message {
    margin-top: 15px;
    padding: 12px;
    border-radius: 8px;
    font-size: 0.9rem;
    font-weight: 500;
  }

  .message.success {
    background: #c6f6d5;
    color: #22543d;
    border: 1px solid #9ae6b4;
  }

  .message.error {
    background: #fed7d7;
    color: #742a2a;
    border: 1px solid #fc8181;
  }

  .helper-text {
    font-size: 0.85rem;
    color: #718096;
    margin-top: 6px;
  }

  .footer-link {
    margin-top: 18px;
    font-size: 0.9rem;
    color: #667eea;
    text-decoration: none;
    display: inline-block;
  }

  .footer-link:hover {
    color: #764ba2;
    text-decoration: underline;
  }

  .price-box {
    background: #f7fafc;
    border-radius: 12px;
    padding: 12px 16px;
    margin-bottom: 1rem;
    border: 1px solid #e2e8f0;
    font-size: 0.9rem;
    color: #2d3748;
  }

  .price-box p {
    margin: 4px 0;
  }

  @media(max-width: 480px){
    .form-box {
      padding: 2rem 1.5rem;
      margin: 1rem;
      border-radius: 15px;
    }
    h1 {
      font-size: 1.75rem;
    }
    .form-input, .submit-button {
      font-size: 0.95rem;
      padding: 12px 16px;
    }
  }
</style>
</head>
<body>

<%
    String minPrice = null;
    String startingPriceVal = null;
    String currentPriceVal = null;
    String auctionIdStr = request.getParameter("auctionId");

    if (auctionIdStr != null && !auctionIdStr.trim().isEmpty()) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            String dbUrl  = "jdbc:mysql://localhost:3306/tech_barn?useUnicode=true&useSSL=false";
            String dbUser = "root";
            String dbPass = "saad2012";

            con = DriverManager.getConnection(dbUrl, dbUser, dbPass);

            String sql =
                "SELECT a.minimum_price, a.starting_price, " +
                "       COALESCE(MAX(b.amount), a.starting_price) AS current_price " +
                "FROM Auction a " +
                "LEFT JOIN Bid b ON a.auction_id = b.auction_id " +
                "WHERE a.auction_id = ? " +
                "GROUP BY a.minimum_price, a.starting_price";

            ps = con.prepareStatement(sql);
            ps.setInt(1, Integer.parseInt(auctionIdStr.trim()));
            rs = ps.executeQuery();

            if (rs.next()) {
                minPrice         = rs.getString("minimum_price");
                startingPriceVal = rs.getString("starting_price");
                currentPriceVal  = rs.getString("current_price");
            }
        } catch (Exception e) {
            out.println("<!-- DB ERROR: " + e.getMessage() + " -->");
            e.printStackTrace(new java.io.PrintWriter(out));
        } finally {
            if (rs != null) try { rs.close(); } catch (Exception ignore) {}
            if (ps != null) try { ps.close(); } catch (Exception ignore) {}
            if (con != null) try { con.close(); } catch (Exception ignore) {}
        }
    }
%>

<div class="form-box">
  <div class="form-container">
    <h1>Place a Bid</h1>
    <p class="subtitle">Enter the auction ID and your bid amount.</p>

    <% if (auctionIdStr != null && minPrice != null) { %>
      <div class="price-box">
        <p><strong>Auction ID:</strong> <%= auctionIdStr %></p>
        <p><strong>Minimum Price:</strong> $<%= minPrice %></p>
        <p><strong>Starting Price:</strong> $<%= startingPriceVal %></p>
        <p><strong>Current Price:</strong> $<%= currentPriceVal %></p>
      </div>
    <% } else if (auctionIdStr != null && minPrice == null) { %>
      <div class="message error">
        No auction found with ID <%= auctionIdStr %>.
      </div>
    <% } %>

    <form action="buyerCreateBid" method="post">
      <label for="auctionId">Auction ID</label>
      <input type="number" id="auctionId" name="auctionId"
             value="<%= (auctionIdStr != null ? auctionIdStr : "") %>"
             placeholder="e.g. 1" required class="form-input">

      <label for="bidAmount">Bid Amount ($)</label>
      <input type="number" step="0.01" id="bidAmount" name="bidAmount"
             placeholder="e.g. 650.00" required class="form-input">

      <button type="submit" class="submit-button">Submit Bid</button>
      <p class="helper-text">
        Your bid must satisfy the auction's minimum price and increment rules.
      </p>
    </form>

    <% if (request.getAttribute("successMessage") != null) { %>
      <div class="message success"><%= request.getAttribute("successMessage") %></div>
    <% } else if (request.getAttribute("errorMessage") != null) { %>
      <div class="message error"><%= request.getAttribute("errorMessage") %></div>
    <% } %>

    <a class="footer-link" href="welcome.jsp">Back to Home</a>
  </div>
</div>

</body>
</html>
