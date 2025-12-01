package com.techbarn.webapp;
import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet ("/category")
public class CategoryServlet extends HttpServlet{
    //no need for post method, we only handle get request
    @Override
    protected void doGet (HttpServletRequest request, HttpServletResponse response)
        throws IOException, ServletException {
            try{
                //Get the database connection
                ApplicationDB db = new ApplicationDB();	
                Connection con = db.getConnection();

                //get the categoryId
                Integer categoryId = Integer.parseInt(request.getParameter("categoryId"));

                String pageTitle;
                String bannerImage;

                switch (categoryId) {
                    case 1:
                        pageTitle = "Phones";
                        bannerImage = "Images/phone-banner.png";
                        break;
                    case 2:
                        pageTitle = "TVs";
                        bannerImage = "Images/tv_banner.jpg";
                        break;
                    case 3:
                        pageTitle = "Headphones";
                        bannerImage = "Images/headphones_banner.jpeg";
                        break;
                    default:
                        pageTitle = "Products";
                        bannerImage = "Images/devices4.jpg";
                        break;
                }

                String query = "SELECT * FROM Item i " +
                "LEFT JOIN Phone p ON p.item_id = i.item_id " +
                "LEFT JOIN TV t ON t.item_id = i.item_id " +
                "LEFT JOIN Headphones h ON h.item_id = i.item_id " +
                "WHERE i.category_id = ?";

                PreparedStatement ps = con.prepareStatement(query);
                ps.setInt(1, categoryId);

                ResultSet rs = ps.executeQuery();
                ArrayList<ItemBean> items = new ArrayList<>(); //ItemBean defined in the same package

                while (rs.next()) {
                    ItemBean item = new ItemBean();
                    item.setId(rs.getInt("item_id"));
                    item.setName(rs.getString("title"));
                    item.setBrand(rs.getString("brand"));
                    item.setColor(rs.getString("color"));
                    item.setCondition(rs.getString("condition"));
                    item.setStock(rs.getBoolean("in_stock"));
                    
                    // Set description - if not in DB, use a default or empty string
                    String description = rs.getString("description");
                    if (description == null) {
                        description = "";
                    }
                    item.setDescription(description);
                    
                    // Get image path from database
                    String imagePath = rs.getString("image_path");
                    if (imagePath == null || imagePath.isEmpty()) {
                        // Fallback to default image if not set
                        imagePath = "Images/item_photos/z_stock/stock_phone.jpg";
                    }
                    item.setImagePath(imagePath);
                    
                    items.add(item);
                }
                
                rs.close();
                ps.close();
                con.close();
                request.setAttribute("pageTitle", pageTitle);
                request.setAttribute("bannerImage", bannerImage);
                request.setAttribute("items", items);
                request.getRequestDispatcher("category.jsp").forward(request, response);
            }
            catch(Exception e) {
                e.printStackTrace();
                request.setAttribute("errorMessage", "Connection failed: " + e.getMessage());
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }
    }
}
