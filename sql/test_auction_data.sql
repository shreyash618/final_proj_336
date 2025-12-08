-- Test data for auction, bidding, and payment functionality
-- This creates a complete scenario to test the entire auction flow

USE tech_barn;

-- Disable safe update mode temporarily
SET SQL_SAFE_UPDATES = 0;

-- Clear existing test data (optional - comment out if you want to keep existing data)
DELETE FROM `Transaction`;
DELETE FROM Bid;
DELETE FROM Auction;
DELETE FROM Alert WHERE item_id IN (201, 202, 203, 204, 205, 206, 207);
DELETE FROM Phone;
DELETE FROM TV;
DELETE FROM Headphones;
DELETE FROM Item WHERE item_id IN (201, 202, 203, 204, 205, 206, 207);
DELETE FROM `User` WHERE user_id IN (101, 102, 103, 104);

-- Insert test users
-- Password for all users: "password123" (you should hash these in production)
INSERT INTO `User` (user_id, first_name, last_name, created_at, email, phone_no, username, password, dob, address_id, isBuyer, isSeller, rating) VALUES
(101, 'John', 'Buyer', '2024-01-15', 'john.buyer@test.com', '5551234567', 'johnbuyer', 'password123', '1990-05-15', NULL, 1, 0, 4.5),
(102, 'Sarah', 'Seller', '2024-02-20', 'sarah.seller@test.com', '5559876543', 'sarahseller', 'password123', '1988-08-22', NULL, 0, 1, 4.8),
(103, 'Mike', 'Bidder', '2024-03-10', 'mike.bidder@test.com', '5555555555', 'mikebidder', 'password123', '1995-12-01', NULL, 1, 0, NULL),
(104, 'Lisa', 'Winner', '2024-04-05', 'lisa.winner@test.com', '5552223333', 'lisawinner', 'password123', '1992-03-18', NULL, 1, 0, 4.2);

-- Insert test items (Phones)
INSERT INTO Item (item_id, brand, `condition`, title, category_id, color, in_stock, image_path, description) VALUES
(201, 'Apple', 'New', 'iPhone 15 Pro Max', 1, 'Blue Titanium', 1, 'Images/item_photos/phones/iphone_pink.jpg', 'Brand new iPhone 15 Pro Max with 256GB storage'),
(202, 'Samsung', 'Like New', 'Galaxy S24 Ultra', 1, 'Titanium Gray', 1, 'Images/item_photos/phones/samsung_titanium_gray.jpg', 'Barely used Samsung Galaxy S24 Ultra, 512GB'),
(203, 'Google', 'New', 'Pixel 8 Pro', 1, 'Obsidian', 1, 'Images/item_photos/phones/google_pixel_8_pro.jpg', 'Latest Google Pixel 8 Pro with AI features');

-- Insert phone specifications
INSERT INTO Phone (item_id, os, storage_gb, ram_gb, phone_screen_size, rear_camera_mp, front_camera_mp, isUnlocked, phone_battery_life, is5G) VALUES
(201, 'iOS', 256, 8, 6.7, 48, 12, 1, 29, 1),
(202, 'Android', 512, 12, 6.8, 200, 12, 1, 30, 1),
(203, 'Android', 256, 12, 6.7, 50, 10, 1, 24, 1);

-- Insert test items (TVs)
INSERT INTO Item (item_id, brand, `condition`, title, category_id, color, in_stock, image_path, description) VALUES
(204, 'Samsung', 'New', '65" QLED 4K TV', 2, 'Black', 1, 'Images/item_photos/tvs/samsung_qled.jpg', 'Stunning QLED display with quantum HDR'),
(205, 'LG', 'Excellent', '55" OLED TV', 2, 'Silver', 1, 'Images/item_photos/tvs/lg_oled.jpg', 'Perfect blacks with OLED technology');

-- Insert TV specifications
INSERT INTO TV (item_id, resolution, isHdr, refresh_rate, isSmartTv, tv_screen_size, panel_type) VALUES
(204, '4K', 1, 120, 1, 65, 'QLED'),
(205, '4K', 1, 120, 1, 55, 'OLED');

-- Insert test items (Headphones)
INSERT INTO Item (item_id, brand, `condition`, title, category_id, color, in_stock, image_path, description) VALUES
(206, 'Sony', 'New', 'WH-1000XM5', 3, 'Black', 1, 'Images/item_photos/headphones/sony_wh1000xm5.jpg', 'Industry-leading noise cancellation'),
(207, 'Apple', 'Like New', 'AirPods Max', 3, 'Silver', 1, 'Images/item_photos/headphones/airpods_max.jpg', 'Premium over-ear headphones');

-- Insert headphone specifications
INSERT INTO Headphones (item_id, isWireless, hasMicrophone, hasNoiseCancellation, cable_type) VALUES
(206, 1, 1, 1, 'USB-C'),
(207, 1, 1, 1, 'Lightning');

-- ========================================
-- ACTIVE AUCTIONS (These are ongoing - you can bid on them)
-- ========================================

-- Auction 1: iPhone 15 Pro Max (ACTIVE - ends in future)
INSERT INTO Auction (auction_id, start_time, end_time, increment, status, minimum_price, starting_price, seller_id, item_id) VALUES
(301, '2024-12-01 10:00:00', '2025-12-31 18:00:00', 50.00, 'ACTIVE', 800.00, 850.00, 102, 201);

-- Some bids on the iPhone (current highest: $950 by Mike)
INSERT INTO Bid (bid_no, auction_id, status, amount, bid_time, auto_bid, max_bid, buyer_id, rep_id, reason, remove_date) VALUES
(1, 301, 'ACTIVE', 850.00, '2024-12-02 11:00:00', 0, NULL, 101, NULL, NULL, NULL),
(2, 301, 'ACTIVE', 900.00, '2024-12-02 14:30:00', 0, NULL, 103, NULL, NULL, NULL),
(3, 301, 'ACTIVE', 950.00, '2024-12-03 09:15:00', 0, NULL, 103, NULL, NULL, NULL);

-- Auction 2: Galaxy S24 Ultra (ACTIVE - ends in future)
INSERT INTO Auction (auction_id, start_time, end_time, increment, status, minimum_price, starting_price, seller_id, item_id) VALUES
(302, '2024-12-05 09:00:00', '2025-12-30 20:00:00', 25.00, 'ACTIVE', 900.00, 950.00, 102, 202);

-- One bid on Samsung
INSERT INTO Bid (bid_no, auction_id, status, amount, bid_time, auto_bid, max_bid, buyer_id, rep_id, reason, remove_date) VALUES
(1, 302, 'ACTIVE', 950.00, '2024-12-05 10:30:00', 0, NULL, 101, NULL, NULL, NULL);

-- Auction 3: 65" Samsung QLED TV (ACTIVE - ends soon)
INSERT INTO Auction (auction_id, start_time, end_time, increment, status, minimum_price, starting_price, seller_id, item_id) VALUES
(303, '2024-12-01 12:00:00', '2025-12-25 18:00:00', 100.00, 'ACTIVE', 600.00, 700.00, 102, 204);

-- Multiple bids on TV
INSERT INTO Bid (bid_no, auction_id, status, amount, bid_time, auto_bid, max_bid, buyer_id, rep_id, reason, remove_date) VALUES
(1, 303, 'ACTIVE', 700.00, '2024-12-01 13:00:00', 0, NULL, 101, NULL, NULL, NULL),
(2, 303, 'ACTIVE', 800.00, '2024-12-02 15:00:00', 0, NULL, 104, NULL, NULL, NULL),
(3, 303, 'ACTIVE', 900.00, '2024-12-03 16:00:00', 0, NULL, 101, NULL, NULL, NULL);

-- ========================================
-- CLOSED AUCTIONS (For testing payment flow)
-- ========================================

-- Auction 4: Google Pixel 8 Pro (CLOSED - Lisa won, needs to pay)
INSERT INTO Auction (auction_id, start_time, end_time, increment, status, minimum_price, starting_price, seller_id, item_id) VALUES
(304, '2024-11-20 10:00:00', '2024-12-01 18:00:00', 25.00, 'CLOSED_SOLD', 500.00, 550.00, 102, 203);

-- Bids on Pixel (Lisa won with $625)
INSERT INTO Bid (bid_no, auction_id, status, amount, bid_time, auto_bid, max_bid, buyer_id, rep_id, reason, remove_date) VALUES
(1, 304, 'ACTIVE', 550.00, '2024-11-20 11:00:00', 0, NULL, 101, NULL, NULL, NULL),
(2, 304, 'ACTIVE', 575.00, '2024-11-21 14:00:00', 0, NULL, 103, NULL, NULL, NULL),
(3, 304, 'ACTIVE', 600.00, '2024-11-22 10:00:00', 0, NULL, 104, NULL, NULL, NULL),
(4, 304, 'ACTIVE', 625.00, '2024-11-25 16:30:00', 0, NULL, 104, NULL, NULL, NULL);
-- NO TRANSACTION YET - Lisa (user_id 104) needs to complete payment!

-- Auction 5: Sony Headphones (CLOSED - John won and PAID)
INSERT INTO Auction (auction_id, start_time, end_time, increment, status, minimum_price, starting_price, seller_id, item_id) VALUES
(305, '2024-11-15 09:00:00', '2024-11-28 20:00:00', 10.00, 'CLOSED_SOLD', 200.00, 220.00, 102, 206);

-- Bids on Sony Headphones (John won with $250)
INSERT INTO Bid (bid_no, auction_id, status, amount, bid_time, auto_bid, max_bid, buyer_id, rep_id, reason, remove_date) VALUES
(1, 305, 'ACTIVE', 220.00, '2024-11-15 10:00:00', 0, NULL, 103, NULL, NULL, NULL),
(2, 305, 'ACTIVE', 230.00, '2024-11-16 11:00:00', 0, NULL, 101, NULL, NULL, NULL),
(3, 305, 'ACTIVE', 240.00, '2024-11-17 13:00:00', 0, NULL, 103, NULL, NULL, NULL),
(4, 305, 'ACTIVE', 250.00, '2024-11-20 15:00:00', 0, NULL, 101, NULL, NULL, NULL);

-- Transaction for the paid auction
INSERT INTO `Transaction` (trans_id, auction_id, buyer_id, trans_time, status) VALUES
(1, 305, 101, '2024-11-28 21:30:00', 'COMPLETED');

-- Auction 6: LG OLED TV (ACTIVE - no bids yet)
INSERT INTO Auction (auction_id, start_time, end_time, increment, status, minimum_price, starting_price, seller_id, item_id) VALUES
(306, '2024-12-06 08:00:00', '2025-12-28 22:00:00', 75.00, 'ACTIVE', 700.00, 750.00, 102, 205);
-- No bids yet - good for testing first bid!

-- Auction 7: AirPods Max (ACTIVE - ends very soon for testing "just ended" scenario)
INSERT INTO Auction (auction_id, start_time, end_time, increment, status, minimum_price, starting_price, seller_id, item_id) VALUES
(307, '2024-12-01 10:00:00', '2024-12-07 23:59:59', 20.00, 'ACTIVE', 350.00, 380.00, 102, 207);

-- Bids on AirPods Max (Mike is winning with $420)
INSERT INTO Bid (bid_no, auction_id, status, amount, bid_time, auto_bid, max_bid, buyer_id, rep_id, reason, remove_date) VALUES
(1, 307, 'ACTIVE', 380.00, '2024-12-02 11:00:00', 0, NULL, 101, NULL, NULL, NULL),
(2, 307, 'ACTIVE', 400.00, '2024-12-03 14:00:00', 0, NULL, 103, NULL, NULL, NULL),
(3, 307, 'ACTIVE', 420.00, '2024-12-05 09:00:00', 0, NULL, 103, NULL, NULL, NULL);

-- ========================================
-- SUMMARY OF TEST SCENARIOS
-- ========================================
-- 
-- USERS:
-- - johnbuyer (user_id: 101) - Has bid on multiple items, won auction 305 and PAID
-- - sarahseller (user_id: 102) - Seller of all items
-- - mikebidder (user_id: 103) - Active bidder, currently winning auction 301 and 307
-- - lisawinner (user_id: 104) - Won auction 304, NEEDS TO PAY (test payment flow!)
--
-- AUCTIONS TO TEST:
-- 
-- 1. BIDDING FUNCTIONALITY:
--    - Login as johnbuyer, mikebidder, or lisawinner
--    - Go to Phones → Click "iPhone 15 Pro Max" (auction 301)
--    - You should see BID button and can place bid > $950
--
-- 2. PAYMENT FUNCTIONALITY:
--    - Login as lisawinner (username: lisawinner, password: password123)
--    - Go to "My Account" → Should see "Pending Payment" for Google Pixel 8 Pro
--    - OR visit Auction_End_Page.jsp?auctionId=304
--    - Click "Proceed to Payment" and complete payment form
--    - After payment, should show "Payment Completed"
--
-- 3. VIEW COMPLETED TRANSACTION:
--    - Login as johnbuyer (won auction 305 and already paid)
--    - Visit Auction_End_Page.jsp?auctionId=305
--    - Should show "Payment completed" message
--
-- 4. AUCTION WITH NO BIDS:
--    - Any user can view auction 306 (LG OLED TV)
--    - Be the first to bid!
--
-- 5. AUCTION ENDING SOON:
--    - Auction 307 (AirPods Max) ends on Dec 7, 2024 at 23:59:59
--    - Good for testing auction close and winner determination
--
-- ========================================

-- Re-enable safe update mode
SET SQL_SAFE_UPDATES = 1;

SELECT 'Test data inserted successfully!' AS Status;
SELECT 'Login with: lisawinner / password123 to test PAYMENT flow' AS TestTip1;
SELECT 'Login with: johnbuyer / password123 to test BIDDING flow' AS TestTip2;
SELECT 'Auction 304 (Google Pixel) is CLOSED and awaiting payment from lisawinner' AS TestTip3;
