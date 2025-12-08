<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.techbarn.webapp.ApplicationDB" %>
<%
    // Check if user is logged in and is a seller
    if (session.getAttribute("user_id") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    Object isSellerObj = session.getAttribute("isSeller");
    boolean isSeller = false;
    
    if (isSellerObj != null) {
        if (isSellerObj instanceof Boolean) {
            isSeller = (Boolean) isSellerObj;
        } else if (isSellerObj instanceof Integer) {
            isSeller = ((Integer) isSellerObj) == 1;
        }
    }
    
    if (!isSeller) {
        response.sendRedirect("welcome.jsp");
        return;
    }
    
    int userId = (Integer) session.getAttribute("user_id");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Tech Barn - Create New Auction</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: Arial, sans-serif;
            background: #f5f5f5;
        }
        
        .header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 20px 40px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        
        .header h1 {
            font-size: 24px;
        }
        
        .back-btn {
            background: rgba(255,255,255,0.2);
            color: white;
            padding: 8px 16px;
            border: 1px solid white;
            border-radius: 5px;
            text-decoration: none;
            transition: background 0.3s;
        }
        
        .back-btn:hover {
            background: rgba(255,255,255,0.3);
        }
        
        .container {
            max-width: 900px;
            margin: 40px auto;
            padding: 0 20px;
        }
        
        .form-card {
            background: white;
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        
        h2 {
            color: #333;
            margin-bottom: 10px;
        }
        
        .subtitle {
            color: #666;
            margin-bottom: 30px;
        }
        
        .form-section {
            margin-bottom: 30px;
            padding-bottom: 30px;
            border-bottom: 1px solid #eee;
        }
        
        .form-section:last-child {
            border-bottom: none;
        }
        
        .form-section h3 {
            color: #667eea;
            margin-bottom: 20px;
            font-size: 18px;
        }
        
        .form-row {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 20px;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        label {
            display: block;
            margin-bottom: 5px;
            color: #333;
            font-weight: 500;
        }
        
        input[type="text"],
        input[type="number"],
        input[type="datetime-local"],
        input[type="file"],
        select,
        textarea {
            width: 100%;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 14px;
            font-family: Arial, sans-serif;
        }
        
        input:focus,
        select:focus,
        textarea:focus {
            outline: none;
            border-color: #667eea;
        }
        
        textarea {
            resize: vertical;
            min-height: 100px;
        }
        
        .required {
            color: red;
        }
        
        .checkbox-group {
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .checkbox-group input[type="checkbox"] {
            width: 18px;
            height: 18px;
            cursor: pointer;
        }
        
        .category-specific {
            display: none;
            background: #f8f9fa;
            padding: 20px;
            border-radius: 5px;
            margin-top: 20px;
        }
        
        .category-specific.active {
            display: block;
        }
        
        .btn-group {
            display: flex;
            gap: 15px;
            margin-top: 30px;
        }
        
        .btn {
            padding: 12px 30px;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: transform 0.2s;
        }
        
        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            flex: 1;
        }
        
        .btn-secondary {
            background: #e9ecef;
            color: #333;
        }
        
        .btn:hover {
            transform: translateY(-2px);
        }
        
        .message {
            padding: 12px;
            border-radius: 5px;
            margin-bottom: 20px;
            text-align: center;
        }
        
        .error {
            background-color: #fee;
            color: #c33;
            border: 1px solid #fcc;
        }
        
        .success {
            background-color: #efe;
            color: #3c3;
            border: 1px solid #cfc;
        }
        
        .help-text {
            font-size: 12px;
            color: #999;
            margin-top: 5px;
        }
        
        .photo-preview {
            margin-top: 10px;
            max-width: 200px;
        }
        
        .photo-preview img {
            width: 100%;
            border-radius: 5px;
            border: 1px solid #ddd;
        }
    </style>
    <script>
        function showCategoryFields() {
            // Hide all category-specific sections and remove required from hidden fields
            document.querySelectorAll('.category-specific').forEach(el => {
                el.classList.remove('active');
                // Remove required attribute from all fields in hidden sections
                el.querySelectorAll('input, select, textarea').forEach(field => {
                    field.removeAttribute('required');
                });
            });
            
            // Show selected category section and add required back to visible fields
            const category = document.getElementById('category').value;
            if (category) {
                const section = document.getElementById(category + '-fields');
                if (section) {
                    section.classList.add('active');
                    // Add required attribute back to fields in visible section
                    section.querySelectorAll('input, select, textarea').forEach(field => {
                        // Only add required if the field originally had it (check data attribute or other marker)
                        field.setAttribute('required', 'required');
                    });
                }
            }
        }
        
        function previewImage(input) {
            const preview = document.getElementById('photo-preview');
            if (input.files && input.files[0]) {
                const reader = new FileReader();
                reader.onload = function(e) {
                    preview.innerHTML = '<img src="' + e.target.result + '" alt="Preview">';
                }
                reader.readAsDataURL(input.files[0]);
            }
        }
    </script>
</head>
<body>
    <div class="header">
        <h1>📦 Create New Auction</h1>
        <a href="sellerhomepage.jsp" class="back-btn">← Back to Dashboard</a>
    </div>
    
    <div class="container">
        <div class="form-card">
            <h2>List Your Tech Item</h2>
            <p class="subtitle">Fill out the details below to create your auction listing</p>
            
            <%
                String message = "";
                String messageType = "";
                
                // Debug: Check if form was submitted
                System.out.println("==== Request Method: " + request.getMethod() + " ====");
                
                if ("POST".equalsIgnoreCase(request.getMethod())) {
                    System.out.println("==== POST request received! ====");
                    // Get form parameters
                    String title = request.getParameter("title");
                    String brand = request.getParameter("brand");
                    String condition = request.getParameter("condition");
                    String category = request.getParameter("category");
                    String color = request.getParameter("color");
                    String startingPrice = request.getParameter("startingPrice");
                    String minimumPrice = request.getParameter("minimumPrice");
                    String increment = request.getParameter("increment");
                    String startTime = request.getParameter("startTime");
                    String endTime = request.getParameter("endTime");
                    
                    System.out.println("Category: " + category);
                    System.out.println("Title: " + title);
                    System.out.println("Brand: " + brand);
                    
                    // Validation
                    if (title == null || title.trim().isEmpty() ||
                        brand == null || brand.trim().isEmpty() ||
                        condition == null || condition.trim().isEmpty() ||
                        category == null || category.trim().isEmpty() ||
                        startingPrice == null || startingPrice.trim().isEmpty() ||
                        minimumPrice == null || minimumPrice.trim().isEmpty() ||
                        increment == null || increment.trim().isEmpty() ||
                        startTime == null || startTime.trim().isEmpty() ||
                        endTime == null || endTime.trim().isEmpty()) {
                        
                        System.out.println("==== VALIDATION FAILED: Basic fields ====");
                        message = "Please fill in all required fields!";
                        messageType = "error";
                    }
                    // Validate category-specific required fields
                    else if ("P".equals(category)) {
                        System.out.println("==== Validating Phone category ====");
                        String os = request.getParameter("os");
                        String storage = request.getParameter("storage");
                        String ram = request.getParameter("ram");
                        String screenSize = request.getParameter("screenSize");
                        String rearCamera = request.getParameter("rearCamera");
                        String frontCamera = request.getParameter("frontCamera");
                        String batteryLife = request.getParameter("batteryLife");
                        
                        System.out.println("Phone - OS: " + os + ", Storage: " + storage + ", RAM: " + ram);
                        System.out.println("Phone - ScreenSize: " + screenSize + ", Battery: " + batteryLife);
                        
                        if (os == null || os.trim().isEmpty() ||
                            storage == null || storage.trim().isEmpty() ||
                            ram == null || ram.trim().isEmpty() ||
                            screenSize == null || screenSize.trim().isEmpty() ||
                            rearCamera == null || rearCamera.trim().isEmpty() ||
                            frontCamera == null || frontCamera.trim().isEmpty() ||
                            batteryLife == null || batteryLife.trim().isEmpty()) {
                            System.out.println("==== VALIDATION FAILED: Phone specs ====");
                            message = "Please fill in all required phone specifications!";
                            messageType = "error";
                        }
                    }
                    else if ("T".equals(category)) {
                        String resolution = request.getParameter("resolution");
                        String refreshRate = request.getParameter("refreshRate");
                        String screenSize = request.getParameter("tvScreenSize");
                        String panelType = request.getParameter("panelType");
                        
                        if (resolution == null || resolution.trim().isEmpty() ||
                            refreshRate == null || refreshRate.trim().isEmpty() ||
                            screenSize == null || screenSize.trim().isEmpty() ||
                            panelType == null || panelType.trim().isEmpty()) {
                            message = "Please fill in all required TV specifications!";
                            messageType = "error";
                        }
                    }
                    else if ("H".equals(category)) {
                        String cableType = request.getParameter("cableType");
                        String batteryLife = request.getParameter("headphoneBatteryLife");
                        
                        if (cableType == null || cableType.trim().isEmpty() ||
                            batteryLife == null || batteryLife.trim().isEmpty()) {
                            message = "Please fill in all required headphone specifications!";
                            messageType = "error";
                        }
                    }
                    
                    System.out.println("==== Validation complete. MessageType: " + messageType + " ====");
                    
                    if (messageType.isEmpty()) {
                        System.out.println("==== Starting database insert ====");
                        Connection conn = null;
                        PreparedStatement itemStmt = null;
                        PreparedStatement categoryStmt = null;
                        PreparedStatement auctionStmt = null;
                        ResultSet rs = null;
                        
                        try {
                            conn = ApplicationDB.getConnection();
                            conn.setAutoCommit(false); // Start transaction
                            
                            // Insert Item
                            // Convert category letter to category_id: P->1, T->2, H->3
                            int categoryId = 1; // default to Phone
                            if ("P".equals(category)) categoryId = 1;
                            else if ("T".equals(category)) categoryId = 2;
                            else if ("H".equals(category)) categoryId = 3;
                            
                            // Set default image path based on category
                            String imagePath = "Images/item_photos/default.jpg";
                            if (categoryId == 1) imagePath = "Images/item_photos/phones/default_phone.jpg";
                            else if (categoryId == 2) imagePath = "Images/item_photos/tvs/default_tv.jpg";
                            else if (categoryId == 3) imagePath = "Images/item_photos/headphones/default_headphones.jpg";
                            
                            String description = request.getParameter("description");
                            
                            String itemQuery = "INSERT INTO Item (brand, `condition`, title, category_id, color, in_stock, image_path, `description`) VALUES (?, ?, ?, ?, ?, 1, ?, ?)";
                            itemStmt = conn.prepareStatement(itemQuery, Statement.RETURN_GENERATED_KEYS);
                            itemStmt.setString(1, brand);
                            itemStmt.setString(2, condition);
                            itemStmt.setString(3, title);
                            itemStmt.setInt(4, categoryId);
                            itemStmt.setString(5, color != null && !color.trim().isEmpty() ? color : null);
                            itemStmt.setString(6, imagePath);
                            itemStmt.setString(7, description != null && !description.trim().isEmpty() ? description : null);
                            itemStmt.executeUpdate();
                            
                            rs = itemStmt.getGeneratedKeys();
                            int itemId = 0;
                            if (rs.next()) {
                                itemId = rs.getInt(1);
                            }
                            
                            // Insert category-specific data
                            if ("P".equals(category)) {
                                // Phone
                                String phoneQuery = "INSERT INTO Phone (item_id, os, storage_gb, ram_gb, phone_screen_size, rear_camera_mp, front_camera_mp, isUnlocked, phone_battery_life, is5G) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
                                categoryStmt = conn.prepareStatement(phoneQuery);
                                categoryStmt.setInt(1, itemId);
                                categoryStmt.setString(2, request.getParameter("os"));
                                categoryStmt.setInt(3, Integer.parseInt(request.getParameter("storage")));
                                categoryStmt.setInt(4, Integer.parseInt(request.getParameter("ram")));
                                categoryStmt.setDouble(5, Double.parseDouble(request.getParameter("screenSize")));
                                categoryStmt.setInt(6, Integer.parseInt(request.getParameter("rearCamera")));
                                categoryStmt.setInt(7, Integer.parseInt(request.getParameter("frontCamera")));
                                categoryStmt.setBoolean(8, request.getParameter("isUnlocked") != null);
                                categoryStmt.setInt(9, Integer.parseInt(request.getParameter("batteryLife")));
                                categoryStmt.setBoolean(10, request.getParameter("is5G") != null);
                                categoryStmt.executeUpdate();
                                
                            } else if ("T".equals(category)) {
                                // TV
                                String tvQuery = "INSERT INTO TV (item_id, resolution, isHdr, refresh_rate, isSmartTv, tv_screen_size, panel_type) VALUES (?, ?, ?, ?, ?, ?, ?)";
                                categoryStmt = conn.prepareStatement(tvQuery);
                                categoryStmt.setInt(1, itemId);
                                categoryStmt.setString(2, request.getParameter("resolution"));
                                categoryStmt.setBoolean(3, request.getParameter("isHdr") != null);
                                categoryStmt.setInt(4, Integer.parseInt(request.getParameter("refreshRate")));
                                categoryStmt.setBoolean(5, request.getParameter("isSmartTv") != null);
                                categoryStmt.setInt(6, Integer.parseInt(request.getParameter("tvScreenSize")));
                                categoryStmt.setString(7, request.getParameter("panelType"));
                                categoryStmt.executeUpdate();
                                
                            } else if ("H".equals(category)) {
                                // Headphones
                                String headphonesQuery = "INSERT INTO Headphones (item_id, isWireless, hasMicrophone, hasNoiseCancellation, cable_type, headphone_battery_life) VALUES (?, ?, ?, ?, ?, ?)";
                                categoryStmt = conn.prepareStatement(headphonesQuery);
                                categoryStmt.setInt(1, itemId);
                                categoryStmt.setBoolean(2, request.getParameter("isWireless") != null);
                                categoryStmt.setBoolean(3, request.getParameter("hasMicrophone") != null);
                                categoryStmt.setBoolean(4, request.getParameter("hasNoiseCancellation") != null);
                                categoryStmt.setString(5, request.getParameter("cableType"));
                                categoryStmt.setInt(6, Integer.parseInt(request.getParameter("headphoneBatteryLife")));
                                categoryStmt.executeUpdate();
                            }
                            
                            // Insert Auction
                            String auctionQuery = "INSERT INTO Auction (start_time, end_time, increment, status, minimum_price, starting_price, seller_id, item_id) VALUES (?, ?, ?, 'active', ?, ?, ?, ?)";
                            auctionStmt = conn.prepareStatement(auctionQuery);
                            auctionStmt.setTimestamp(1, Timestamp.valueOf(startTime.replace("T", " ") + ":00"));
                            auctionStmt.setTimestamp(2, Timestamp.valueOf(endTime.replace("T", " ") + ":00"));
                            auctionStmt.setDouble(3, Double.parseDouble(increment));
                            auctionStmt.setDouble(4, Double.parseDouble(minimumPrice));
                            auctionStmt.setDouble(5, Double.parseDouble(startingPrice));
                            auctionStmt.setInt(6, userId);
                            auctionStmt.setInt(7, itemId);
                            auctionStmt.executeUpdate();
                            
                            conn.commit();
                            
                            message = "Auction created successfully! Redirecting...";
                            messageType = "success";
                            response.setHeader("Refresh", "2; URL=sellerhomepage.jsp");
                            
                        } catch (Exception e) {
                            if (conn != null) try { conn.rollback(); } catch (SQLException ex) {}
                            message = "Error creating auction: " + e.getMessage();
                            messageType = "error";
                            System.out.println("==== ERROR CREATING AUCTION ====");
                            e.printStackTrace();
                            e.printStackTrace();
                        } finally {
                            if (rs != null) try { rs.close(); } catch (SQLException e) {}
                            if (itemStmt != null) try { itemStmt.close(); } catch (SQLException e) {}
                            if (categoryStmt != null) try { categoryStmt.close(); } catch (SQLException e) {}
                            if (auctionStmt != null) try { auctionStmt.close(); } catch (SQLException e) {}
                            if (conn != null) try { conn.setAutoCommit(true); conn.close(); } catch (SQLException e) {}
                        }
                    }
                }
            %>
            
            <% if (!message.isEmpty()) { %>
                <div class="message <%= messageType %>">
                    <%= message %>
                </div>
            <% } %>
            
            <form method="POST" action="createauction.jsp">
                <!-- Basic Item Information -->
                <div class="form-section">
                    <h3>📱 Item Information</h3>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label for="title">Item Title <span class="required">*</span></label>
                            <input type="text" id="title" name="title" required maxlength="20">
                        </div>
                        
                        <div class="form-group">
                            <label for="brand">Brand <span class="required">*</span></label>
                            <input type="text" id="brand" name="brand" required maxlength="20">
                        </div>
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label for="condition">Condition <span class="required">*</span></label>
                            <select id="condition" name="condition" required>
                                <option value="">Select condition...</option>
                                <option value="New">New</option>
                                <option value="Like New">Like New</option>
                                <option value="Excellent">Excellent</option>
                                <option value="Good">Good</option>
                                <option value="Fair">Fair</option>
                                <option value="Poor">Poor</option>
                            </select>
                        </div>
                        
                        <div class="form-group">
                            <label for="category">Category <span class="required">*</span></label>
                            <select id="category" name="category" required onchange="showCategoryFields()">
                                <option value="">Select category...</option>
                                <option value="P">📱 Phone</option>
                                <option value="T">📺 TV</option>
                                <option value="H">🎧 Headphones</option>
                            </select>
                        </div>
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label for="color">Color</label>
                            <input type="text" id="color" name="color" maxlength="20">
                        </div>
                        
                        <div class="form-group">
                            <label for="photo">Upload Photo</label>
                            <input type="file" id="photo" name="photo" accept="image/*" onchange="previewImage(this)">
                            <div class="help-text">Note: Photo upload is for display only (not saved in database)</div>
                            <div id="photo-preview" class="photo-preview"></div>
                        </div>
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group" style="grid-column: 1 / -1;">
                            <label for="description">Description</label>
                            <textarea id="description" name="description" maxlength="300" rows="3" placeholder="Describe your item..."></textarea>
                            <div class="help-text">Optional - up to 300 characters</div>
                        </div>
                    </div>
                </div>
                
                <!-- Phone-specific fields -->
                <div id="P-fields" class="category-specific">
                    <h3>📱 Phone Specifications</h3>
                    <div class="form-row">
                        <div class="form-group">
                            <label for="os">Operating System <span class="required">*</span></label>
                            <select id="os" name="os" required>
                                <option value="Android">Android</option>
                                <option value="iOS">iOS</option>
                                <option value="Other">Other</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="storage">Storage (GB) <span class="required">*</span></label>
                            <input type="number" id="storage" name="storage" min="1" max="2048" required>
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="form-group">
                            <label for="ram">RAM (GB) <span class="required">*</span></label>
                            <input type="number" id="ram" name="ram" min="1" max="64" required>
                        </div>
                        <div class="form-group">
                            <label for="screenSize">Screen Size (inches) <span class="required">*</span></label>
                            <input type="number" id="screenSize" name="screenSize" step="0.01" min="4.0" max="9.99" required>
                            <div class="help-text">Between 4.0 and 9.99 inches</div>
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="form-group">
                            <label for="rearCamera">Rear Camera (MP) <span class="required">*</span></label>
                            <input type="number" id="rearCamera" name="rearCamera" min="0" max="500" required>
                        </div>
                        <div class="form-group">
                            <label for="frontCamera">Front Camera (MP) <span class="required">*</span></label>
                            <input type="number" id="frontCamera" name="frontCamera" min="0" max="100" required>
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="form-group">
                            <label for="batteryLife">Battery Life (mAh) <span class="required">*</span></label>
                            <input type="number" id="batteryLife" name="batteryLife" min="1000" max="10000" required>
                        </div>
                        <div class="form-group">
                            <div class="checkbox-group">
                                <input type="checkbox" id="isUnlocked" name="isUnlocked" value="1">
                                <label for="isUnlocked">Unlocked</label>
                            </div>
                            <div class="checkbox-group">
                                <input type="checkbox" id="is5G" name="is5G" value="1">
                                <label for="is5G">5G Support</label>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- TV-specific fields -->
                <div id="T-fields" class="category-specific">
                    <h3>📺 TV Specifications</h3>
                    <div class="form-row">
                        <div class="form-group">
                            <label for="resolution">Resolution <span class="required">*</span></label>
                            <select id="resolution" name="resolution">
                                <option value="720p">720p HD</option>
                                <option value="1080p">1080p Full HD</option>
                                <option value="4K">4K Ultra HD</option>
                                <option value="8K">8K</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="tvScreenSize">Screen Size (inches) <span class="required">*</span></label>
                            <input type="number" id="tvScreenSize" name="tvScreenSize" min="1">
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="form-group">
                            <label for="refreshRate">Refresh Rate (Hz) <span class="required">*</span></label>
                            <input type="number" id="refreshRate" name="refreshRate" min="30">
                        </div>
                        <div class="form-group">
                            <label for="panelType">Panel Type <span class="required">*</span></label>
                            <select id="panelType" name="panelType">
                                <option value="LED">LED</option>
                                <option value="OLED">OLED</option>
                                <option value="QLED">QLED</option>
                                <option value="LCD">LCD</option>
                            </select>
                        </div>
                    </div>
                    <div class="form-group">
                        <div class="checkbox-group">
                            <input type="checkbox" id="isHdr" name="isHdr" value="1">
                            <label for="isHdr">HDR Support</label>
                        </div>
                        <div class="checkbox-group">
                            <input type="checkbox" id="isSmartTv" name="isSmartTv" value="1">
                            <label for="isSmartTv">Smart TV</label>
                        </div>
                    </div>
                </div>
                
                <!-- Headphones-specific fields -->
                <div id="H-fields" class="category-specific">
                    <h3>🎧 Headphones Specifications</h3>
                    <div class="form-row">
                        <div class="form-group">
                            <label for="cableType">Cable Type <span class="required">*</span></label>
                            <select id="cableType" name="cableType">
                                <option value="3.5mm">3.5mm Jack</option>
                                <option value="USB-C">USB-C</option>
                                <option value="Lightning">Lightning</option>
                                <option value="Wireless">Wireless Only</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="headphoneBatteryLife">Battery Life (hours) <span class="required">*</span></label>
                            <input type="number" id="headphoneBatteryLife" name="headphoneBatteryLife" min="0" required>
                            <div class="help-text">For wired headphones, enter 0</div>
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="form-group">
                            <div class="checkbox-group">
                                <input type="checkbox" id="isWireless" name="isWireless" value="1">
                                <label for="isWireless">Wireless</label>
                            </div>
                            <div class="checkbox-group">
                                <input type="checkbox" id="hasMicrophone" name="hasMicrophone" value="1">
                                <label for="hasMicrophone">Has Microphone</label>
                            </div>
                            <div class="checkbox-group">
                                <input type="checkbox" id="hasNoiseCancellation" name="hasNoiseCancellation" value="1">
                                <label for="hasNoiseCancellation">Noise Cancellation</label>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Auction Details -->
                <div class="form-section">
                    <h3>💰 Auction Details</h3>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label for="startingPrice">Starting Price ($) <span class="required">*</span></label>
                            <input type="number" id="startingPrice" name="startingPrice" step="0.01" min="0.01" required>
                        </div>
                        
                        <div class="form-group">
                            <label for="minimumPrice">Minimum/Reserve Price ($) <span class="required">*</span></label>
                            <input type="number" id="minimumPrice" name="minimumPrice" step="0.01" min="0.01" required>
                            <div class="help-text">Secret - won't sell below this price</div>
                        </div>
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label for="increment">Bid Increment ($) <span class="required">*</span></label>
                            <input type="number" id="increment" name="increment" step="0.01" min="0.01" required>
                            <div class="help-text">Minimum amount to increase each bid</div>
                        </div>
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label for="startTime">Auction Start Time <span class="required">*</span></label>
                            <input type="datetime-local" id="startTime" name="startTime" required>
                        </div>
                        
                        <div class="form-group">
                            <label for="endTime">Auction End Time <span class="required">*</span></label>
                            <input type="datetime-local" id="endTime" name="endTime" required>
                        </div>
                    </div>
                </div>
                
                <div class="btn-group">
                    <button type="submit" class="btn btn-primary">Create Auction</button>
                    <a href="sellerhomepage.jsp" class="btn btn-secondary" style="text-align: center; line-height: 1.5;">Cancel</a>
                </div>
            </form>
        </div>
    </div>
</body>
</html>