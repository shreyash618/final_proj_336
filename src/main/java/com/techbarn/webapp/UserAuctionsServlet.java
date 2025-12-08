package com.techbarn.webapp;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.*;
import java.util.*;

@WebServlet(
        name = "UserAuctionsServlet",
        urlPatterns = {"/userAuctions", "/UserAuctionsServlet"}
)
public class UserAuctionsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get user ID from parameter or session
        String userIdParam = request.getParameter("viewUserId");
        Integer userId = null;
        
        if (userIdParam != null && !userIdParam.trim().isEmpty()) {
            try {
                userId = Integer.parseInt(userIdParam.trim());
            } catch (NumberFormatException ignored) { }
        } else {
            HttpSession session = request.getSession(false);
            if (session != null) {
                Object obj = session.getAttribute("user_id");
                if (obj instanceof Integer) {
                    userId = (Integer) obj;
                } else if (obj instanceof String) {
                    try {
                        userId = Integer.parseInt((String) obj);
                    } catch (NumberFormatException ignored) { }
                }
            }
        }
        
        if (userId == null) {
            request.setAttribute("errorMessage", "User ID required.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        Connection con = null;
        List<Map<String, Object>> auctions = new ArrayList<>();

        try {
            con = ApplicationDB.getConnection();
            
            // Get username
            String usernameSql = "SELECT username FROM `User` WHERE user_id = ?";
            PreparedStatement psUser = con.prepareStatement(usernameSql);
            psUser.setInt(1, userId);
            ResultSet rsUser = psUser.executeQuery();
            String username = null;
            if (rsUser.next()) {
                username = rsUser.getString("username");
            }
            rsUser.close();
            psUser.close();
            
            // Get all auctions: ones they started (as seller) + ones they bid on (as buyer)
            String sql = 
                "SELECT DISTINCT a.auction_id, a.start_time, a.end_time, a.status, " +
                "       a.starting_price, a.minimum_price, " +
                "       i.item_id, i.title, i.brand, i.image_path, i.category_id, " +
                "       (SELECT MAX(amount) FROM Bid WHERE auction_id = a.auction_id) as current_price, " +
                "       CASE WHEN a.seller_id = ? THEN 'seller' ELSE 'buyer' END as role " +
                "FROM Auction a " +
                "JOIN Item i ON a.item_id = i.item_id " +
                "WHERE a.seller_id = ? " +
                "   OR EXISTS (SELECT 1 FROM Bid b WHERE b.auction_id = a.auction_id AND b.buyer_id = ?) " +
                "ORDER BY a.end_time DESC, a.start_time DESC";
            
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, userId);
            ps.setInt(2, userId);
            ps.setInt(3, userId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Map<String, Object> auction = new HashMap<>();
                auction.put("auction_id", rs.getInt("auction_id"));
                auction.put("start_time", rs.getTimestamp("start_time"));
                auction.put("end_time", rs.getTimestamp("end_time"));
                auction.put("status", rs.getString("status"));
                auction.put("starting_price", rs.getBigDecimal("starting_price"));
                auction.put("minimum_price", rs.getBigDecimal("minimum_price"));
                auction.put("item_id", rs.getInt("item_id"));
                auction.put("title", rs.getString("title"));
                auction.put("brand", rs.getString("brand"));
                auction.put("image_path", rs.getString("image_path"));
                auction.put("category_id", rs.getInt("category_id"));
                auction.put("current_price", rs.getBigDecimal("current_price"));
                auction.put("role", rs.getString("role"));
                auctions.add(auction);
            }
            
            rs.close();
            ps.close();
            
            request.setAttribute("auctions", auctions);
            request.setAttribute("username", username);
            request.setAttribute("userId", userId);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error loading auctions: " + e.getMessage());
        } finally {
            try { if (con != null) ApplicationDB.closeConnection(con); } catch (Exception ignored) {}
        }
        
        request.getRequestDispatcher("user_auctions.jsp").forward(request, response);
    }
}

