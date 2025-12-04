package com.techbarn.webapp;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.*;

@WebServlet(
        name = "BuyerCreateBidServlet",
        urlPatterns = {"/buyerCreateBid", "/BuyerCreateBidServlet"}
)
public class BuyerCreateBidServlet extends HttpServlet {

    private static final String DB_URL  =
            "jdbc:mysql://localhost:3306/tech_barn?useUnicode=true&useSSL=false";
    private static final String DB_USER = "root";
    private static final String DB_PASS = "saad2012";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String auctionIdStr = request.getParameter("auctionId");
        String bidAmountStr = request.getParameter("bidAmount");

        if (auctionIdStr == null || auctionIdStr.isBlank()
                || bidAmountStr == null || bidAmountStr.isBlank()) {

            request.setAttribute("errorMessage",
                    "Auction ID and Bid Amount are required.");
            request.getRequestDispatcher("Buyer_Create_Bid_Page.jsp")
                   .forward(request, response);
            return;
        }

        int auctionId;
        BigDecimal bidAmount;
        try {
            auctionId = Integer.parseInt(auctionIdStr.trim());
            bidAmount = new BigDecimal(bidAmountStr.trim());
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage",
                    "Invalid number format for auction ID or bid amount.");
            request.getRequestDispatcher("Buyer_Create_Bid_Page.jsp")
                   .forward(request, response);
            return;
        }

        // try to get buyer id from session; fall back to 1 for testing
        HttpSession session = request.getSession(false);
        Integer buyerId = null;
        if (session != null) {
            Object obj = session.getAttribute("userId");
            if (obj instanceof Integer) {
                buyerId = (Integer) obj;
            } else if (obj instanceof String) {
                try {
                    buyerId = Integer.parseInt((String) obj);
                } catch (NumberFormatException ignored) { }
            }
        }
        if (buyerId == null) {
            buyerId = 1;   // TEMP for testing if you’re not wired to login yet
        }

        Connection con = null;
        PreparedStatement psCheck = null;
        PreparedStatement psInsert = null;
        ResultSet rs = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);

            String checkSql =
                    "SELECT a.minimum_price, a.starting_price, a.increment, " +
                    "       COALESCE(MAX(b.amount), a.starting_price) AS current_price " +
                    "FROM Auction a " +
                    "LEFT JOIN Bid b ON a.auction_id = b.auction_id " +
                    "WHERE a.auction_id = ? " +
                    "GROUP BY a.minimum_price, a.starting_price, a.increment";

            psCheck = con.prepareStatement(checkSql);
            psCheck.setInt(1, auctionId);
            rs = psCheck.executeQuery();

            if (!rs.next()) {
                request.setAttribute("errorMessage",
                        "Auction " + auctionId + " was not found.");
                request.getRequestDispatcher("Buyer_Create_Bid_Page.jsp")
                       .forward(request, response);
                return;
            }

            BigDecimal minimumPrice = rs.getBigDecimal("minimum_price");
            BigDecimal currentPrice = rs.getBigDecimal("current_price");
            BigDecimal increment    = rs.getBigDecimal("increment");

            if (minimumPrice != null && bidAmount.compareTo(minimumPrice) < 0) {
                request.setAttribute("errorMessage",
                        "Your bid must be at least the minimum price ($"
                                + minimumPrice + ").");
                request.getRequestDispatcher("Buyer_Create_Bid_Page.jsp?auctionId=" + auctionId)
                       .forward(request, response);
                return;
            }

            if (increment != null && increment.compareTo(BigDecimal.ZERO) > 0) {
                BigDecimal minAllowed = currentPrice.add(increment);
                if (bidAmount.compareTo(minAllowed) < 0) {
                    request.setAttribute("errorMessage",
                            "Your bid must be at least current price + increment (>= $"
                                    + minAllowed + ").");
                    request.getRequestDispatcher("Buyer_Create_Bid_Page.jsp?auctionId=" + auctionId)
                           .forward(request, response);
                    return;
                }
            }

            String insertSql =
                    "INSERT INTO Bid (auction_id, buyer_id, amount, bid_time, status) " +
                    "VALUES (?, ?, ?, ?, ?)";

            psInsert = con.prepareStatement(insertSql);
            psInsert.setInt(1, auctionId);
            psInsert.setInt(2, buyerId);
            psInsert.setBigDecimal(3, bidAmount);
            psInsert.setTimestamp(4, new Timestamp(System.currentTimeMillis()));
            psInsert.setString(5, "ACTIVE");
            psInsert.executeUpdate();

            request.setAttribute("successMessage",
                    "Your bid of $" + bidAmount + " has been placed.");
            request.getRequestDispatcher("Buyer_Create_Bid_Page.jsp?auctionId=" + auctionId)
                   .forward(request, response);

        } catch (Exception e) {
            request.setAttribute("errorMessage",
                    "Error placing bid: " + e.getMessage());
            request.getRequestDispatcher("Buyer_Create_Bid_Page.jsp")
                   .forward(request, response);
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception ignored) {}
            try { if (psCheck != null) psCheck.close(); } catch (Exception ignored) {}
            try { if (psInsert != null) psInsert.close(); } catch (Exception ignored) {}
            try { if (con != null) con.close(); } catch (Exception ignored) {}
        }
    }
}
