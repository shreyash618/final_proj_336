package com.techbarn.webapp;
import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.util.*;


@WebServlet("/search")
public class SearchServlet extends HttpServlet{
    @Override
    protected void doGet (HttpServletRequest request, HttpServletResponse response)
        throws IOException, ServletException {
            try{
                //Get the database connection
                Connection con = ApplicationDB.getConnection();

                /* code below used to initialize the sidebar filter  */
                /* get the list of filter categories */
                ArrayList<String> categories = getFilterCategories();

                /* get the list of values per category */
                /* Realized I would need a dictionary */
                HashMap<String, ArrayList<String>> categoryValues = new HashMap<>();

                for (String category: categories){
                    //gets all the data per category
                    category = "`" + category + '`'; //because some of the column names are mysql keywords (would like to change that later)
                    String query2 = "SELECT DISTINCT " + category + " FROM Item i " +
                    "LEFT JOIN Phone p ON p.item_id = i.item_id " +
                    "LEFT JOIN TV t ON t.item_id = i.item_id " +
                    "LEFT JOIN Headphones h ON h.item_id = i.item_id " +
                    "WHERE " + category + " IS NOT NULL;";

                    PreparedStatement ps2 = con.prepareStatement(query2);
                    ResultSet rs2 = ps2.executeQuery();
                    ArrayList <String> values = new ArrayList<>();
                    while (rs2.next()){
                        values.add(rs2.getString(1));
                    }
                    //categoryValues.put (category, values);
                    categoryValues.put (category, values);
                    rs2.close();
                    ps2.close();
                }

                ApplicationDB.closeConnection(con);
                request.setAttribute("categories", categories);
                request.setAttribute("categoryValues", categoryValues);
                request.getRequestDispatcher("search.jsp").forward(request, response);

            }
            catch(Exception e) {
                e.printStackTrace();
                request.setAttribute("errorMessage", "Error loading category: " + e.getMessage());
                request.getRequestDispatcher("search.jsp").forward(request, response);
            }
    }

    public String transformName (String category){
        if (category == null || category.isEmpty()) return category;
        category = category.replaceAll("`","").replaceAll("_", " ");
        category = category.substring(0,1).toUpperCase() + category.substring(1);

        String[] prefixes = {"is ", "has ", "Is", "Has"};
        for (String p : prefixes) {
            if (category.startsWith(p)) {
                category = category.substring(p.length());
                break;
            }
        }
        category = category.replaceAll("([a-z])([A-Z])", "$1 $2");
        String[] words_list = category.split(" "); //split into words based on capital letters, underscores and spaces
        String tmp ="";
        for (String word: words_list){
            if (word.isEmpty()){
                continue;
            }
            if (word.length() <= 3) {
                // Fully uppercase if <= 3 letters
                tmp = tmp + word.toUpperCase() + " ";
            }
            else{
                tmp = tmp + word.substring(0,1).toUpperCase() + word.substring(1) + " "; //capitalize each word
            }
        }
        category = tmp;
        //category = category.replaceAll("is", "").replaceAll("has","");
        //Pattern pattern1 = Pattern.compile("^is|^has|^Is|^Has"); //remove and maybe even add question mark?
        //Matcher matcher1 = pattern.matcher(category);
        //capitalize words that 3 characters or shorter

        return category.trim(); //or should i use .strip()
    }
    
    private ArrayList<String> getFilterCategories(){
        ArrayList<String> categories = new ArrayList<>();
        try{
            //Get the database connection
            Connection con = ApplicationDB.getConnection();

            /* code below used to initialize the sidebar filter  */
            /* get the list of filter categories */
            String query ="SELECT COLUMN_NAME "+
            "FROM INFORMATION_SCHEMA.COLUMNS "+
            "WHERE TABLE_SCHEMA='tech_barn' AND TABLE_NAME IN ('Item', 'Phone', 'TV', 'Headphones') "+
            "AND COLUMN_NAME NOT IN ('item_id', 'image_path', 'title', 'description', 'in_stock') "+
            "ORDER BY ORDINAL_POSITION";
            PreparedStatement ps = con.prepareStatement(query);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                categories.add (rs.getString(1)); // gets the category name from column index 1 (of each row)
            }
            //categories.remove ("item_id");
            rs.close();
            ps.close();
            ApplicationDB.closeConnection(con);
            return(categories);
            
        }
        catch(Exception e) {
            e.printStackTrace();
            return(categories);
        }
    }
    // @Override
    protected void doPost (HttpServletRequest request, HttpServletResponse response)
        throws IOException, ServletException {
            try{
                //Get the database connection
                Connection con = ApplicationDB.getConnection();

                /* gets all the checkboxes that are selected per category from the form, as well as any search input */
                /* returns values based on that search */
                String searchValue = request.getParameter("searchbar");
                //String [] keywords = searchValue.split ("");
                String[] keywords = new String[0];
                if (searchValue != null && !searchValue.trim().isEmpty()) {
                    keywords = searchValue.trim().split("\\s+"); // split into words
                }

                //the input in the search bar should search against all the string categories no? and be like input string like category?
                /* code below used to initialize the sidebar filter  */
                /* get the list of filter categories */
                String query ="SELECT COLUMN_NAME "+
                "FROM INFORMATION_SCHEMA.COLUMNS "+
                "WHERE TABLE_SCHEMA='tech_barn' AND TABLE_NAME IN ('Item', 'Phone', 'TV', 'Headphones') "+
                "AND COLUMN_NAME NOT IN ('item_id', 'image_path', 'in_stock') "+
                "AND DATA_TYPE IN ('varchar', 'char');";
                //??"ORDER BY ORDINAL_POSITION";

                PreparedStatement ps = con.prepareStatement(query);
                ResultSet rs = ps.executeQuery();
                ArrayList<String> stringCategories = new ArrayList<>();
                while (rs.next()) {
                    stringCategories.add (rs.getString(1)); // gets the category name from column index 1 (of each row)
                }

                rs.close();
                ps.close();
                //match keywords to string categories
                String query2 = "SELECT * FROM Item i " +
                "LEFT JOIN Phone p ON p.item_id = i.item_id " +
                "LEFT JOIN TV t ON t.item_id = i.item_id " +
                "LEFT JOIN Headphones h ON h.item_id = i.item_id " +
                "WHERE ";
                //for each keyword
                for (int i = 0; i< keywords.length; i++){
                    String keyword = keywords[i];
                    query2 = query2 + "CONCAT_WS(' ',";
                    //check against each category
                    for (int j = 0; j< stringCategories.size(); j++){
                        String strCat = stringCategories.get(j);
                        query2 = query2 + " `" + strCat + "` ";
                        if (j != (stringCategories.size()-1)){
                            query2 = query2 + " , ";
                        }
                    }
                    query2 = query2 + ") LIKE '%" + keyword + "%'";
                    if (i != (keywords.length -1)){
                        query2 = query2 + " AND ";
                    }

                }
                //match keyword to boolean categories
                //match keyword to numerical categories

                //logic just to get the selected filter categories
                ArrayList<String> categories = getFilterCategories();
                Map<String, List<String>> selectedCategories = new HashMap<>();

                for (String category : categories) {
                    String[] vals = request.getParameterValues(category);

                    if (vals != null) {
                        selectedCategories.put(category, Arrays.asList(vals));
                    }
                }

                //this is turning into a really long where statment, should i use a subquery or something?
                for (String selectedCat : selectedCategories.keySet()){
                    query2 = query2 + " AND `" + selectedCat + "` IN ( ";
                    for (int i = 0; i< selectedCategories.get(selectedCat).size(); i++){
                        String selectedValue = selectedCategories.get(selectedCat).get(i);
                        query2 = query2 + selectedValue;
                        if (i != (selectedCategories.get(selectedCat).size() -1)){
                            query2 = query2 + " , ";
                        }
                        else{
                            query2 = query2 + ")";
                        }
                    }
                }


                //we could also add code to transform searchInputs to booleans (ie, if it contains "wireless", remove it and transform to boolean; we could get the boolean keywords using the transformName method)
                //we could also add code to transform strings with numerical inptus followed by units of measure (120 Hz) and match it to numerical columns
                //----> another way to do this would be to remove all units of measure, and add a query to select the numerical data type (int, float) columns like query2, and compare all numbers against those columns

                query2 = query2 + ";";
                System.out.println ("SEARCH POST QUERY: " + query2);
                //how to do fuzzy matching? should we even bother?
                //it should also use these to be exact matches for each selected category name = selectedcategoryvalue1 or selectedcategoryvalue2 
                
                /* get the list of values per category */
                PreparedStatement ps2 = con.prepareStatement(query2);
                ResultSet rs2 = ps2.executeQuery();
                ArrayList<ItemBean> items = new ArrayList<>(); //ItemBean defined in the same package
                
                while (rs2.next()) {
                    ItemBean item = new ItemBean();
                    item.setId(rs2.getInt("item_id"));
                    item.setName(rs2.getString("title"));
                    item.setBrand(rs2.getString("brand"));
                    item.setColor(rs2.getString("color"));

                    // Get image path from database
                    String imagePath = rs2.getString("image_path");
                    if (imagePath == null || imagePath.isEmpty()) {
                        // Fallback to default image if not set
                        imagePath = "Images/item_photos/z_stock/stock_phone.jpg";
                    }
                    item.setImagePath(imagePath);
                    
                    items.add(item);
                }
                
                rs2.close();
                ps2.close();
                ApplicationDB.closeConnection(con);
                System.out.println ("query2: " + query2);
                //request.setAttribute("pageTitle", pageTitle);
                request.setAttribute("items", items);
                //request.setAttribute ("cardStyle", cardStyle);
                //request.setAttribute("categories", categories);
                request.getRequestDispatcher("search.jsp").forward(request, response);

            }
            catch(Exception e) {
                e.printStackTrace();
                request.setAttribute("errorMessage", "Error loading category: " + e.getMessage());
                request.getRequestDispatcher("search.jsp").forward(request, response);
            }
    }


    
}
