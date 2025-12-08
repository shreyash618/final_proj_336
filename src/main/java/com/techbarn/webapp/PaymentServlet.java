package com.techbarn.webapp;

import java.io.IOException;
import java.sql.*;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/payment")
public class PaymentServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        
        // Check if user is logged in
        Integer userId = (Integer) request.getSession().getAttribute("user_id");
        if (userId == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        String auctionIdParam = request.getParameter("auctionId");
        
        if (auctionIdParam == null || auctionIdParam.trim().isEmpty()) {
            request.setAttribute("errorMessage", "No auction ID provided.");
            request.getRequestDispatcher("payment.jsp").forward(request, response);
            return;
        }
        
        try {
            int auctionId = Integer.parseInt(auctionIdParam);
            Connection con = ApplicationDB.getConnection();
            
            // Get auction details and verify user is the winner
                String sql = "SELECT a.auction_id, a.status, a.end_time, i.title, i.brand, i.color, " +
                        "(SELECT b2.amount FROM Bid b2 WHERE b2.auction_id = a.auction_id " +
                        " ORDER BY b2.amount DESC, b2.bid_time ASC LIMIT 1) as winning_bid, " +
                        "(SELECT b3.buyer_id FROM Bid b3 WHERE b3.auction_id = a.auction_id " +
                        " ORDER BY b3.amount DESC, b3.bid_time ASC LIMIT 1) as buyer_id, " +
                        "(SELECT u.username FROM Bid b4 JOIN `User` u ON b4.buyer_id = u.user_id " +
                        " WHERE b4.auction_id = a.auction_id " +
                        " ORDER BY b4.amount DESC, b4.bid_time ASC LIMIT 1) as username " +
                        "FROM Auction a " +
                        "JOIN Item i ON a.item_id = i.item_id " +
                        "WHERE a.auction_id = ?";
            
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, auctionId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                int winnerId = rs.getInt("buyer_id");
                String status = rs.getString("status");
                Timestamp endTime = rs.getTimestamp("end_time");
                
                // Check if user is the winner
                if (winnerId != userId) {
                    request.setAttribute("errorMessage", "You are not the winner of this auction.");
                    rs.close();
                    ps.close();
                    ApplicationDB.closeConnection(con);
                    request.getRequestDispatcher("payment.jsp").forward(request, response);
                    return;
                }
                
                // Check if auction has ended (either by status OR by time)
                boolean hasEnded = "CLOSED_SOLD".equalsIgnoreCase(status) || 
                                  "CLOSED".equalsIgnoreCase(status) ||
                                  (endTime != null && endTime.before(new java.util.Date()));
                
                if (!hasEnded) {
                    request.setAttribute("errorMessage", "This auction has not ended yet.");
                    rs.close();
                    ps.close();
                    ApplicationDB.closeConnection(con);
                    request.getRequestDispatcher("payment.jsp").forward(request, response);
                    return;
                }
                
                // Check if payment already made
                String checkTransSql = "SELECT trans_id FROM `Transaction` WHERE auction_id = ?";
                PreparedStatement psCheck = con.prepareStatement(checkTransSql);
                psCheck.setInt(1, auctionId);
                ResultSet rsCheck = psCheck.executeQuery();
                
                if (rsCheck.next()) {
                    request.setAttribute("errorMessage", "Payment for this auction has already been completed.");
                    rsCheck.close();
                    psCheck.close();
                    rs.close();
                    ps.close();
                    ApplicationDB.closeConnection(con);
                    request.getRequestDispatcher("payment.jsp").forward(request, response);
                    return;
                }
                rsCheck.close();
                psCheck.close();
                
                // Set auction details for the form
                request.setAttribute("auctionId", rs.getInt("auction_id"));
                request.setAttribute("itemTitle", rs.getString("title"));
                request.setAttribute("itemBrand", rs.getString("brand"));
                request.setAttribute("itemColor", rs.getString("color"));
                request.setAttribute("winningBid", rs.getBigDecimal("winning_bid"));
                
                rs.close();
                ps.close();
            } else {
                request.setAttribute("errorMessage", "Auction not found.");
            }
            
            ApplicationDB.closeConnection(con);
            request.getRequestDispatcher("payment.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid auction ID format.");
            request.getRequestDispatcher("payment.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error loading payment page: " + e.getMessage());
            request.getRequestDispatcher("payment.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        
        // Check if user is logged in
        Integer userId = (Integer) request.getSession().getAttribute("user_id");
        if (userId == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        // Get form parameters
        String auctionIdParam = request.getParameter("auctionId");
        String cardName = request.getParameter("cardName");
        String cardNumber = request.getParameter("cardNumber");
        String expiryMonth = request.getParameter("expiryMonth");
        String expiryYear = request.getParameter("expiryYear");
        String cvc = request.getParameter("cvc");
        String street = request.getParameter("street");
        String city = request.getParameter("city");
        String state = request.getParameter("state");
        String zip = request.getParameter("zip");
        
        StringBuilder errors = new StringBuilder();
        
        // Validate card name
        if (cardName == null || cardName.trim().isEmpty()) {
            errors.append("Cardholder name is required. ");
        } else if (cardName.trim().length() < 3) {
            errors.append("Cardholder name must be at least 3 characters. ");
        } else if (!cardName.matches("^[a-zA-Z\\s]+$")) {
            errors.append("Cardholder name can only contain letters and spaces. ");
        }
        
        // Validate card number
        if (cardNumber == null || cardNumber.trim().isEmpty()) {
            errors.append("Card number is required. ");
        } else {
            String cleanCardNumber = cardNumber.replaceAll("\\s+", "");
            if (!cleanCardNumber.matches("^\\d{16}$")) {
                errors.append("Card number must be exactly 16 digits. ");
            } else if (!isValidLuhn(cleanCardNumber)) {
                errors.append("Card number is invalid (failed checksum validation). ");
            }
        }
        
        // Validate expiry date
        if (expiryMonth == null || expiryMonth.trim().isEmpty()) {
            errors.append("Expiry month is required. ");
        } else if (!expiryMonth.matches("^(0[1-9]|1[0-2])$")) {
            errors.append("Expiry month must be between 01 and 12. ");
        }
        
        if (expiryYear == null || expiryYear.trim().isEmpty()) {
            errors.append("Expiry year is required. ");
        } else if (!expiryYear.matches("^\\d{4}$")) {
            errors.append("Expiry year must be 4 digits. ");
        } else {
            // Check if card is not expired
            try {
                int month = Integer.parseInt(expiryMonth);
                int year = Integer.parseInt(expiryYear);
                Calendar cal = Calendar.getInstance();
                int currentYear = cal.get(Calendar.YEAR);
                int currentMonth = cal.get(Calendar.MONTH) + 1;
                
                if (year < currentYear || (year == currentYear && month < currentMonth)) {
                    errors.append("Card has expired. ");
                }
            } catch (NumberFormatException e) {
                errors.append("Invalid expiry date. ");
            }
        }
        
        // Validate CVC
        if (cvc == null || cvc.trim().isEmpty()) {
            errors.append("CVC is required. ");
        } else if (!cvc.matches("^\\d{3}$")) {
            errors.append("CVC must be exactly 3 digits. ");
        }
        
        // Validate billing address
        if (street == null || street.trim().isEmpty()) {
            errors.append("Street address is required. ");
        }
        if (city == null || city.trim().isEmpty()) {
            errors.append("City is required. ");
        }
        if (state == null || state.trim().isEmpty()) {
            errors.append("State is required. ");
        }
        if (zip == null || zip.trim().isEmpty()) {
            errors.append("ZIP code is required. ");
        } else if (!zip.matches("^\\d{5}(-\\d{4})?$")) {
            errors.append("ZIP code must be 5 digits or 5+4 format (e.g., 12345 or 12345-6789). ");
        }
        
        // If there are validation errors, return to form
        if (errors.length() > 0) {
            request.setAttribute("errorMessage", errors.toString());
            request.setAttribute("cardName", cardName);
            request.setAttribute("cardNumber", cardNumber);
            request.setAttribute("expiryMonth", expiryMonth);
            request.setAttribute("expiryYear", expiryYear);
            request.setAttribute("cvc", cvc);
            request.setAttribute("street", street);
            request.setAttribute("city", city);
            request.setAttribute("state", state);
            request.setAttribute("zip", zip);
            
            // Re-fetch auction details
            doGet(request, response);
            return;
        }
        
        // Process payment
        try {
            int auctionId = Integer.parseInt(auctionIdParam);
            Connection con = ApplicationDB.getConnection();
            con.setAutoCommit(false); // Start transaction
            
            try {
                // Verify user is still the winner and no transaction exists
                String checkSql = "SELECT b.buyer_id, b.amount " +
                                 "FROM Bid b " +
                                 "WHERE b.auction_id = ? " +
                                 "ORDER BY b.amount DESC, b.bid_time ASC " +
                                 "LIMIT 1";
                PreparedStatement psCheck = con.prepareStatement(checkSql);
                psCheck.setInt(1, auctionId);
                ResultSet rsCheck = psCheck.executeQuery();
                
                if (!rsCheck.next() || rsCheck.getInt("buyer_id") != userId) {
                    rsCheck.close();
                    psCheck.close();
                    throw new Exception("You are not the winner of this auction.");
                }
                rsCheck.close();
                psCheck.close();
                
                // Check if transaction already exists
                String transCheckSql = "SELECT trans_id FROM `Transaction` WHERE auction_id = ?";
                PreparedStatement psTransCheck = con.prepareStatement(transCheckSql);
                psTransCheck.setInt(1, auctionId);
                ResultSet rsTransCheck = psTransCheck.executeQuery();
                
                if (rsTransCheck.next()) {
                    rsTransCheck.close();
                    psTransCheck.close();
                    throw new Exception("Payment already processed for this auction.");
                }
                rsTransCheck.close();
                psTransCheck.close();
                
                // Insert transaction record
                String insertTransSql = "INSERT INTO `Transaction` (auction_id, buyer_id, trans_time, status) " +
                                       "VALUES (?, ?, NOW(), 'COMPLETED')";
                PreparedStatement psInsert = con.prepareStatement(insertTransSql);
                psInsert.setInt(1, auctionId);
                psInsert.setInt(2, userId);
                psInsert.executeUpdate();
                psInsert.close();
                
                // Update auction status to CLOSED_SOLD
                String updateAuctionSql = "UPDATE Auction SET status = 'CLOSED_SOLD' WHERE auction_id = ?";
                PreparedStatement psUpdate = con.prepareStatement(updateAuctionSql);
                psUpdate.setInt(1, auctionId);
                psUpdate.executeUpdate();
                psUpdate.close();
                
                con.commit(); // Commit transaction
                
                // Success - redirect to success page
                request.setAttribute("successMessage", "Payment successful! Transaction completed.");
                request.setAttribute("auctionId", auctionId);
                ApplicationDB.closeConnection(con);
                request.getRequestDispatcher("payment_success.jsp").forward(request, response);
                
            } catch (Exception e) {
                con.rollback(); // Rollback on error
                throw e;
            } finally {
                con.setAutoCommit(true);
                ApplicationDB.closeConnection(con);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Payment processing failed: " + e.getMessage());
            doGet(request, response);
        }
    }
    
    // Luhn algorithm to validate card number
    private boolean isValidLuhn(String cardNumber) {
        int sum = 0;
        boolean alternate = false;
        for (int i = cardNumber.length() - 1; i >= 0; i--) {
            int digit = Character.getNumericValue(cardNumber.charAt(i));
            if (alternate) {
                digit *= 2;
                if (digit > 9) {
                    digit = (digit % 10) + 1;
                }
            }
            sum += digit;
            alternate = !alternate;
        }
        return (sum % 10 == 0);
    }
}
