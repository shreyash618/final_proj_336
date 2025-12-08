package com.techbarn.webapp.dao;

import com.techbarn.webapp.ApplicationDB;

import java.sql.*;
import java.util.*;

public class ReportDAO {

    public static double totalEarnings() {
        // Sum winning bids for completed auctions (CLOSED or CLOSED_SOLD)
        String sql = "SELECT COALESCE(SUM(winning_bid), 0) AS total " +
                "FROM ( " +
                "    SELECT a.auction_id, " +
                "           (SELECT b.amount FROM Bid b " +
                "            WHERE b.auction_id = a.auction_id " +
                "            ORDER BY b.amount DESC, b.bid_time ASC LIMIT 1) AS winning_bid " +
                "    FROM Auction a " +
                "    WHERE (a.status = 'CLOSED' OR a.status = 'CLOSED_SOLD') " +
                "      AND a.auction_id IN (SELECT auction_id FROM Bid) " +
                ") AS sales";
        
        try (Connection c = ApplicationDB.getConnection();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getDouble("total");
        } catch (SQLException e) { 
            e.printStackTrace(); 
        }
        return 0.0;
    }

    public static List<Map<String,Object>> earningsByItem() {
        // Get winning bid amount per item for closed auctions only
        String sql = "SELECT i.item_id, i.title, i.brand, " +
                "       COALESCE(SUM( " +
                "           (SELECT b.amount FROM Bid b " +
                "            WHERE b.auction_id = a.auction_id " +
                "            ORDER BY b.amount DESC, b.bid_time ASC LIMIT 1) " +
                "       ), 0) AS earnings " +
                "FROM Item i " +
                "JOIN Auction a ON i.item_id = a.item_id " +
                "WHERE (a.status = 'CLOSED' OR a.status = 'CLOSED_SOLD') " +
                "  AND a.auction_id IN (SELECT auction_id FROM Bid) " +
                "GROUP BY i.item_id, i.title, i.brand " +
                "ORDER BY earnings DESC";
        return runList(sql);
    }

    public static List<Map<String,Object>> earningsBySeller() {
        // Get total winning bid amounts per seller for closed auctions only
        String sql = "SELECT u.user_id, CONCAT(u.first_name, ' ', u.last_name) AS seller, " +
                "       COALESCE(SUM( " +
                "           (SELECT b.amount FROM Bid b " +
                "            WHERE b.auction_id = a.auction_id " +
                "            ORDER BY b.amount DESC, b.bid_time ASC LIMIT 1) " +
                "       ), 0) AS earnings " +
                "FROM `User` u " +
                "JOIN Auction a ON u.user_id = a.seller_id " +
                "WHERE (a.status = 'CLOSED' OR a.status = 'CLOSED_SOLD') " +
                "  AND a.auction_id IN (SELECT auction_id FROM Bid) " +
                "GROUP BY u.user_id, u.first_name, u.last_name " +
                "ORDER BY earnings DESC";
        return runList(sql);
    }

    public static List<Map<String,Object>> bestSellingItems() {
        String sql = "SELECT i.item_id, i.title, COUNT(t.trans_id) AS sold_count " +
                "FROM `Transaction` t JOIN Auction a ON t.auction_id = a.auction_id JOIN Item i ON a.item_id = i.item_id " +
                "GROUP BY i.item_id, i.title ORDER BY sold_count DESC";
        return runList(sql);
    }

    private static List<Map<String,Object>> runList(String sql) {
        List<Map<String,Object>> out = new ArrayList<>();
        try (Connection c = ApplicationDB.getConnection();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            ResultSetMetaData md = rs.getMetaData();
            while (rs.next()) {
                Map<String,Object> row = new LinkedHashMap<>();
                for (int i=1;i<=md.getColumnCount();i++) row.put(md.getColumnName(i), rs.getObject(i));
                out.add(row);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return out;
    }
}

