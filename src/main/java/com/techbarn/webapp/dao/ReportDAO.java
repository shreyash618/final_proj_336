package com.techbarn.webapp.dao;

import com.techbarn.webapp.ApplicationDB;

import java.sql.*;
import java.util.*;

public class ReportDAO {

    public static double totalEarnings() {
        String sql = "SELECT COALESCE(SUM(t.amount),0) as total FROM `Transaction` t";
        // Note: your Transaction table doesn't have amount column in the schema. Try to sum winning bids as fallback.
        try (Connection c = ApplicationDB.getConnection();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getDouble("total");
        } catch (SQLException e) { /* ignore */ }

        // fallback: sum highest bid per closed auction
        String sql2 = "SELECT COALESCE(SUM(x.max_bid),0) AS total FROM ( " +
                "SELECT a.auction_id, MAX(b.amount) AS max_bid " +
                "FROM Auction a JOIN Bid b ON a.auction_id = b.auction_id " +
                "WHERE a.status = 'closed' GROUP BY a.auction_id) x";
        try (Connection c = ApplicationDB.getConnection();
             PreparedStatement ps = c.prepareStatement(sql2);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getDouble("total");
        } catch (SQLException e) { e.printStackTrace(); }
        return 0.0;
    }

    public static List<Map<String,Object>> earningsByItem() {
        // Only count the winning bid (max bid) per closed auction
        String sql = "SELECT i.item_id, i.title, COALESCE(SUM(winning_bid.max_bid),0) AS earnings " +
                "FROM Auction a " +
                "JOIN Item i ON a.item_id = i.item_id " +
                "LEFT JOIN ( " +
                "    SELECT auction_id, MAX(amount) AS max_bid " +
                "    FROM Bid " +
                "    WHERE status = 'ACTIVE' " +
                "    GROUP BY auction_id " +
                ") winning_bid ON a.auction_id = winning_bid.auction_id " +
                "WHERE a.status = 'closed' " +
                "GROUP BY i.item_id, i.title " +
                "ORDER BY earnings DESC";
        return runList(sql);
    }

    public static List<Map<String,Object>> earningsBySeller() {
        // Only count the winning bid (max bid) per closed auction
        String sql = "SELECT u.user_id, CONCAT(u.first_name,' ',u.last_name) AS seller, COALESCE(SUM(winning_bid.max_bid),0) AS earnings " +
                "FROM Auction a " +
                "JOIN `User` u ON a.seller_id = u.user_id " +
                "LEFT JOIN ( " +
                "    SELECT auction_id, MAX(amount) AS max_bid " +
                "    FROM Bid " +
                "    WHERE status = 'ACTIVE' " +
                "    GROUP BY auction_id " +
                ") winning_bid ON a.auction_id = winning_bid.auction_id " +
                "WHERE a.status = 'closed' " +
                "GROUP BY u.user_id, seller " +
                "ORDER BY earnings DESC";
        return runList(sql);
    }

    public static List<Map<String,Object>> earningsByItemType() {
        // Group earnings by category_id (1=Phone, 2=TV, 3=Headphones)
        String sql = "SELECT " +
                "    CASE i.category_id " +
                "        WHEN 1 THEN 'Phone' " +
                "        WHEN 2 THEN 'TV' " +
                "        WHEN 3 THEN 'Headphones' " +
                "        ELSE 'Unknown' " +
                "    END AS item_type, " +
                "    COALESCE(SUM(winning_bid.max_bid),0) AS earnings " +
                "FROM Auction a " +
                "JOIN Item i ON a.item_id = i.item_id " +
                "LEFT JOIN ( " +
                "    SELECT auction_id, MAX(amount) AS max_bid " +
                "    FROM Bid " +
                "    WHERE status = 'ACTIVE' " +
                "    GROUP BY auction_id " +
                ") winning_bid ON a.auction_id = winning_bid.auction_id " +
                "WHERE a.status = 'closed' " +
                "GROUP BY i.category_id " +
                "ORDER BY earnings DESC";
        return runList(sql);
    }

    public static List<Map<String,Object>> bestSellingItems() {
        String sql = "SELECT i.item_id, i.title, COUNT(t.trans_id) AS sold_count " +
                "FROM `Transaction` t JOIN Auction a ON t.auction_id = a.auction_id JOIN Item i ON a.item_id = i.item_id " +
                "GROUP BY i.item_id, i.title ORDER BY sold_count DESC";
        return runList(sql);
    }

    public static List<Map<String,Object>> bestBuyers() {
        // Find buyers who have spent the most (using Transaction table and winning bid amounts)
        String sql = "SELECT " +
                "    u.user_id, " +
                "    CONCAT(u.first_name,' ',u.last_name) AS buyer, " +
                "    COALESCE(SUM(winning_bid.max_bid),0) AS total_spent, " +
                "    COUNT(DISTINCT t.auction_id) AS auctions_won " +
                "FROM `User` u " +
                "INNER JOIN `Transaction` t ON u.user_id = t.buyer_id " +
                "LEFT JOIN ( " +
                "    SELECT auction_id, MAX(amount) AS max_bid " +
                "    FROM Bid " +
                "    WHERE status = 'ACTIVE' " +
                "    GROUP BY auction_id " +
                ") winning_bid ON t.auction_id = winning_bid.auction_id " +
                "WHERE u.isBuyer = 1 " +
                "GROUP BY u.user_id, buyer " +
                "ORDER BY total_spent DESC";
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

