package com.techbarn.webapp;
import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;


@WebServlet ("/item")
public class ItemServlet extends HttpServlet{
    @Override
    protected void doGet (HttpServletRequest request, HttpServletResponse response)
        throws IOException, ServletException{
            try{
                //Get the database connection
                Connection con = ApplicationDB.getConnection();

                //get the itemId
                //Integer itemId = Integer.parseInt(request.getParameter("itemId"));
                //replaced with
                String itemIdParam = request.getParameter("itemId");
                if (itemIdParam == null || itemIdParam.isEmpty()) {
                    request.setAttribute("errorMessage", "Item ID is required.");
                    request.getRequestDispatcher("category.jsp").forward(request, response);
                    return;
                }
                Integer itemId;
                try {
                    itemId = Integer.parseInt(itemIdParam);
                } catch (NumberFormatException e) {
                    request.setAttribute("errorMessage", "Invalid item ID format.");
                    request.getRequestDispatcher("category.jsp").forward(request, response);
                    return;
                }
                
                String query = "SELECT * FROM Item i " +
                "LEFT JOIN Phone p ON p.item_id = i.item_id " +
                "LEFT JOIN TV t ON t.item_id = i.item_id " +
                "LEFT JOIN Headphones h ON h.item_id = i.item_id " +
                "WHERE i.item_id = ?";

                PreparedStatement ps = con.prepareStatement(query);
                ps.setInt(1, itemId);
                ResultSet rs = ps.executeQuery();

                ItemBean item = null;
                if (rs.next()){
                    // Determine item type by checking which table has data
                    // or by checking category_id
                    int categoryId = rs.getInt("category_id");
                    
                    // Create appropriate subclass based on category_id
                    if (categoryId == 1) {
                        // Phone
                        Phone phone = new Phone();
                        item = phone;
                        
                        // Set Phone-specific attributes
                        phone.setOs(rs.getString("os"));
                        phone.setStorageGb(rs.getInt("storage_gb"));
                        phone.setRamGb(rs.getInt("ram_gb"));
                        phone.setScreenSize(rs.getFloat("screen_size"));
                        phone.setRearCameraMp(rs.getInt("rear_camera_mp"));
                        phone.setFrontCameraMp(rs.getInt("front_camera_mp"));
                        phone.setIsUnlocked(rs.getBoolean("isUnlocked"));
                        phone.setBatteryLife(rs.getInt("battery_life"));
                        phone.setIs5G(rs.getBoolean("is5G"));
                    } else if (categoryId == 2) {
                        // TV
                        TV tv = new TV();
                        item = tv;
                        
                        // Set TV-specific attributes
                        tv.setResolution(rs.getString("resolution"));
                        tv.setIsHdr(rs.getBoolean("isHdr"));
                        tv.setRefreshRate(rs.getInt("refresh_rate"));
                        tv.setIsSmartTv(rs.getBoolean("isSmartTv"));
                        tv.setScreenSize(rs.getInt("screen_size"));
                        tv.setPanelType(rs.getString("panel_type"));
                    } else if (categoryId == 3) {
                        // Headphones
                        Headphones headphones = new Headphones();
                        item = headphones;
                        
                        // Set Headphones-specific attributes
                        headphones.setIsWireless(rs.getBoolean("isWireless"));
                        headphones.setHasMicrophone(rs.getBoolean("hasMicrophone"));
                        headphones.setHasNoiseCancellation(rs.getBoolean("hasNoiseCancellation"));
                        headphones.setCableType(rs.getString("cable_type"));
                    } else {
                        item = new ItemBean(); //Fallback to base ItemBean (category can't be null so this is unneccessary but we will keep it just in case)
                    }

                    
                    // Set common ItemBean attributes
                    item.setId(rs.getInt("item_id"));
                    item.setName(rs.getString("title"));
                    item.setBrand(rs.getString("brand"));
                    item.setColor(rs.getString("color"));
                    item.setCondition(rs.getString("condition"));
                    item.setStock(rs.getBoolean("in_stock"));
                    
                    // Set description - if not in DB, use a default or empty string
                    String description = rs.getString("description");
                    if (description == null) {
                        description = "N/A";
                    }
                    item.setDescription(description);

                    // Get image path from database
                    String imagePath = rs.getString("image_path");
                    if (imagePath == null || imagePath.isEmpty()) {
                        // Fallback to default image based on category
                        if (categoryId == 1) {
                            imagePath = "Images/item_photos/z_stock/stock_phone.jpg";
                        } else if (categoryId == 2) {
                            imagePath = "Images/item_photos/z_stock/stock_tv.png";
                        } else { // categoryId == 3
                            imagePath = "Images/item_photos/z_stock/stock_headphones.jpg";
                        }
                    }
                    item.setImagePath(imagePath);
                }
                rs.close();
                ps.close();
                ApplicationDB.closeConnection(con);
                
                if (item == null) {
                    request.setAttribute("errorMessage", "Item not found.");
                    request.getRequestDispatcher("category.jsp").forward(request, response);
                    return;
                }
                
                request.setAttribute("item", item);
                request.getRequestDispatcher("item.jsp").forward(request, response);
            }

            catch(Exception e) {
                e.printStackTrace();
                request.setAttribute("errorMessage", "Error loading item: " + e.getMessage());
                request.getRequestDispatcher("item.jsp").forward(request, response);
            }
        };
}
