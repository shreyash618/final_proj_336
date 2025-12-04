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
                Connection con = ApplicationDB.getConnection();

                //get the categoryId
                //Integer categoryId = Integer.parseInt(request.getParameter("categoryId"));
                //replaced with:
                Integer categoryId;
                try {
                    String categoryIdParam = request.getParameter("categoryId");
                    if (categoryIdParam == null || categoryIdParam.isEmpty()) {
                        categoryId = 1; // Default to Phones
                    } else {
                        categoryId = Integer.parseInt(categoryIdParam);
                    }
                } catch (NumberFormatException e) {
                    categoryId = 1; // Default to Phones if invalid
                }

                String pageTitle;
                String bannerImage;
                String cardStyle;

                switch (categoryId) {
                    case 1:
                        pageTitle = "Phones";
                        bannerImage = "Images/phone_banner.png";
                        cardStyle = "card-phone";
                        break;
                    case 2:
                        pageTitle = "TVs";
                        bannerImage = "Images/tv_banner.jpg";
                        cardStyle = "card-tv";
                        break;
                    case 3:
                        pageTitle = "Headphones";
                        bannerImage = "Images/headphones_banner.jpeg";
                        cardStyle = "card-headphones";
                        break;
                    default:
                        pageTitle = "Phones";
                        bannerImage = "Images/phone_banner.png";
                        cardStyle = "card-phone";
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
                ApplicationDB.closeConnection(con);
                request.setAttribute("pageTitle", pageTitle);
                request.setAttribute("bannerImage", bannerImage);
                request.setAttribute("items", items);
                request.setAttribute ("cardStyle", cardStyle);
                request.getRequestDispatcher("category.jsp").forward(request, response);
            }
            catch(Exception e) {
                e.printStackTrace();
                request.setAttribute("errorMessage", "Error loading category: " + e.getMessage());
                request.getRequestDispatcher("category.jsp").forward(request, response);
            }
    }
}