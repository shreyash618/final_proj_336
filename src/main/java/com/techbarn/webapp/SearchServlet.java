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
    
                // Initialize filter categories and values using helper method
                Map<String, Object> filterData = initializeFilterCategories(con);
                
                ApplicationDB.closeConnection(con);

                // Pass categories to jsp (general first, then item-type specific categories)
                request.setAttribute("generalCategories", filterData.get("generalCategories"));
                request.setAttribute("phoneCategories", filterData.get("phoneCategories"));
                request.setAttribute("tvCategories", filterData.get("tvCategories"));
                request.setAttribute("headphonesCategories", filterData.get("headphonesCategories"));
                request.setAttribute("categoryValues", filterData.get("categoryValues"));

                request.getRequestDispatcher("search.jsp").forward(request, response);
            }
            catch(Exception e) {
                e.printStackTrace();
                request.setAttribute("errorMessage", "Error loading category: " + e.getMessage());
                request.getRequestDispatcher("search.jsp").forward(request, response);
            }
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

    private Map<String, List<String>> getFilterColumnsByTable() {
        Map<String, List<String>> tableColumns = new HashMap<>();
    
        try {
            Connection con = ApplicationDB.getConnection();
    
            String query =
                "SELECT TABLE_NAME, COLUMN_NAME, ORDINAL_POSITION " +
                "FROM INFORMATION_SCHEMA.COLUMNS " +
                "WHERE TABLE_SCHEMA='tech_barn' " +
                "AND TABLE_NAME IN ('Item', 'Phone', 'TV', 'Headphones') " +
                "AND COLUMN_NAME NOT IN ('item_id', 'image_path', 'title', 'description', 'in_stock') " +
                "ORDER BY CASE TABLE_NAME " +
                "   WHEN 'Item' THEN 1 " +
                "   WHEN 'Phone' THEN 2 " +
                "   WHEN 'TV' THEN 3 " +
                "   WHEN 'Headphones' THEN 4 " +
                "   ELSE 5 END, ORDINAL_POSITION";
    
            PreparedStatement ps = con.prepareStatement(query);
            ResultSet rs = ps.executeQuery();
    
            while (rs.next()) {
                String table = rs.getString("TABLE_NAME");
                String col = rs.getString("COLUMN_NAME");
    
                tableColumns.computeIfAbsent(table, k -> new ArrayList<>()).add(col); //computeIfAbsent checks if table is already in tableColumns or it adds the key using the lambda expression
            }
    
            rs.close();
            ps.close();
            ApplicationDB.closeConnection(con);
    
        } catch (Exception e) {
            e.printStackTrace();
        }
    
        return tableColumns;
    }

    private Map<String, Object> initializeFilterCategories(Connection con) throws SQLException {
        Map<String, Object> result = new HashMap<>();
        
        // Get the list of filter categories grouped by item type
        Map<String, List<String>> tableColumns = getFilterColumnsByTable();

        // general filters (item table)
        List<String> generalCategories = tableColumns.getOrDefault("Item", new ArrayList<>());

        // item-type specific filters
        List<String> phoneCategories = tableColumns.getOrDefault("Phone", new ArrayList<>());
        List<String> tvCategories = tableColumns.getOrDefault("TV", new ArrayList<>());
        List<String> headphonesCategories = tableColumns.getOrDefault("Headphones", new ArrayList<>());

        // flatten
        List<String> allCategories = new ArrayList<>();
        allCategories.addAll(generalCategories);
        allCategories.addAll(phoneCategories);
        allCategories.addAll(tvCategories);
        allCategories.addAll(headphonesCategories);

        // Get the list of values per category
        HashMap<String, ArrayList<String>> categoryValues = new HashMap<>();

        for (String category : allCategories) {
            String column = "`" + category + "`";

            String query = "SELECT DISTINCT " + column + " FROM Item i " +
                    "LEFT JOIN Phone p ON p.item_id = i.item_id " +
                    "LEFT JOIN TV t ON t.item_id = i.item_id " +
                    "LEFT JOIN Headphones h ON h.item_id = i.item_id " +
                    "WHERE " + column + " IS NOT NULL;";

            PreparedStatement ps = con.prepareStatement(query);
            ResultSet rs = ps.executeQuery();

            ArrayList<String> values = new ArrayList<>();
            while (rs.next()) {
                values.add(rs.getString(1));
            }

            categoryValues.put(category, values);
            rs.close();
            ps.close();
        }

        // Store all results in the map
        result.put("generalCategories", generalCategories);
        result.put("phoneCategories", phoneCategories);
        result.put("tvCategories", tvCategories);
        result.put("headphonesCategories", headphonesCategories);
        result.put("categoryValues", categoryValues);
        
        return result;
    } //dont close the connection as we should do that in the original thread

    private Map<String, List<String>> getColumnsByType() {
        Map<String, List<String>> result = new HashMap<>();
        List<String> stringCols = new ArrayList<>();
        List<String> booleanCols = new ArrayList<>();
        List<String> numericCols = new ArrayList<>();
    
        try {
            Connection con = ApplicationDB.getConnection();
    
            String sql =
                "SELECT COLUMN_NAME, DATA_TYPE " +
                "FROM INFORMATION_SCHEMA.COLUMNS " +
                "WHERE TABLE_SCHEMA='tech_barn' " +
                "AND TABLE_NAME IN ('Item', 'Phone', 'TV', 'Headphones') " +
                "AND COLUMN_NAME NOT IN ('item_id', 'image_path', 'in_stock')";
    
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
    
            while (rs.next()) {
                String colName = rs.getString("COLUMN_NAME");
                String dataType = rs.getString("DATA_TYPE").toLowerCase();
    
                // You can tweak these sets if you add more types later
                if (dataType.equals("varchar") || dataType.equals("char") || dataType.contains("text")) {
                    stringCols.add(colName);
                } else if (dataType.equals("tinyint") || dataType.equals("bit") || dataType.equals("boolean")) {
                    booleanCols.add(colName);
                } else if (dataType.equals("int") || dataType.equals("bigint") ||
                           dataType.equals("decimal") || dataType.equals("double") ||
                           dataType.equals("float")) {
                    numericCols.add(colName);
                }
            }
    
            rs.close();
            ps.close();
            ApplicationDB.closeConnection(con);
    
        } catch (Exception e) {
            e.printStackTrace();
        }
    
        result.put("string", stringCols);
        result.put("boolean", booleanCols);
        result.put("numeric", numericCols);
        return result;
    }
    private String normalizeKeyword(String keyword) {
        if (keyword == null) return null;
    
        String k = keyword.trim().toLowerCase();
    
        k = k.replaceAll("(mp|hz|gb)$", "").trim();
    
        return k;
    }
    
    //transforms the names to display in the fitler only
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
    
    // @Override
    protected void doPost (HttpServletRequest request, HttpServletResponse response)
        throws IOException, ServletException {
            try{
                //Get the database connection
                Connection con = ApplicationDB.getConnection();

                /* gets all the checkboxes that are selected per category from the form, as well as any search input */
                /* returns values based on that search bar input */

                String searchValue = request.getParameter("searchbar");
                //String [] keywords = searchValue.split ("");
                String[] keywords = new String[0];
                
                //normalizes the keywords
                if (searchValue != null && !searchValue.trim().isEmpty()) {
                    String[] raw = searchValue.trim().split("\\s+");
                
                    List<String> cleaned = new ArrayList<>();
                    for (String w : raw) {
                        String norm = normalizeKeyword(w);
                        if (norm != null && !norm.isEmpty()) {
                            cleaned.add(norm);
                        }
                    }
                
                    keywords = cleaned.toArray(new String[0]);
                }
                
                // Get columns grouped by type for searching/filtering
                Map<String, List<String>> columnTypes = getColumnsByType();
                List<String> stringCategories = columnTypes.getOrDefault("string", new ArrayList<>());
                List<String> booleanCategories = columnTypes.getOrDefault("boolean", new ArrayList<>());
                List<String> numericCategories = columnTypes.getOrDefault("numeric", new ArrayList<>());

                StringBuilder queryBuilder = new StringBuilder(
                    "SELECT * FROM Item i " +
                    "LEFT JOIN Phone p ON p.item_id = i.item_id " +
                    "LEFT JOIN TV t ON t.item_id = i.item_id " +
                    "LEFT JOIN Headphones h ON h.item_id = i.item_id "
                );
                
                // Track if WHERE clause has been added (shared across all loops)
                boolean hasWhere = false;

                //match keyword to numerical categories
                List<Double> equalParams = new ArrayList<>(); //values can be int or float
                Set<String> numericKeywords = new HashSet<>(); // Track which keywords are numeric

                for (String kw : keywords) {
                    if (kw != null && kw.matches("\\d+(\\.\\d+)?")) {
                        equalParams.add(Double.parseDouble(kw));
                        numericKeywords.add(kw); // Track numeric keywords to exclude from string search
                    }
                }

                if (!equalParams.isEmpty() && !numericCategories.isEmpty()) {
                    // adds WHERE or AND clause
                    if (!hasWhere) {
                        queryBuilder.append("WHERE ");
                        hasWhere = true;
                    } else {
                        queryBuilder.append(" AND ");
                    }
                
                    queryBuilder.append("(");
                
                    boolean first = true;
                    for (String col : numericCategories) {
                        for (Double equalParam : equalParams) {
                            if (!first) queryBuilder.append(" OR ");
                            queryBuilder.append("`").append(col).append("` = ?");
                            first = false;
                        }
                    }
                
                    queryBuilder.append(")");
                }
                
                //match keyword to boolean categories (hard-coded)
                Set<String> boolTrueCols = new HashSet<>();
                Set<String> boolFalseCols = new HashSet<>(); // for "wired" meaning isWireless = 0
                Set<String> booleanKeywords = new HashSet<>(); // Track which keywords are boolean

                for (String kw : keywords) {
                    if (kw == null) continue;
                    String k = kw.toLowerCase().trim();
                    boolean isBooleanKeyword = false;

                    if (k.equals("5g") && booleanCategories.contains("is5G")) {
                        boolTrueCols.add("is5G");
                        isBooleanKeyword = true;
                    }

                    if ((k.contains("wireless") || k.contains("bluetooth")) &&
                        booleanCategories.contains("isWireless")) {
                        boolTrueCols.add("isWireless");
                        isBooleanKeyword = true;
                    }

                    if (k.equals("wired") && booleanCategories.contains("isWireless")) {
                        boolFalseCols.add("isWireless");  // we will add "isWireless = 0"
                        isBooleanKeyword = true;
                    }

                    if (k.equals("smart tv") && booleanCategories.contains("isSmartTv")) {
                        boolTrueCols.add("isSmartTv");
                        isBooleanKeyword = true;
                    }

                    if (k.equals("hdr") && booleanCategories.contains("isHdr")) {
                        boolTrueCols.add("isHdr");
                        isBooleanKeyword = true;
                    }

                    if (k.contains("microphone") && booleanCategories.contains("hasMicrophone")) {
                        boolTrueCols.add("hasMicrophone");
                        isBooleanKeyword = true;
                    }

                    if ((k.contains("noise cancelling") || k.contains("noise cancellation"))
                        && booleanCategories.contains("hasNoiseCancellation")) {
                        boolTrueCols.add("hasNoiseCancellation");
                        isBooleanKeyword = true;
                    }

                    if (k.contains("unlocked") && booleanCategories.contains("isUnlocked")) {
                        boolTrueCols.add("isUnlocked");
                        isBooleanKeyword = true;
                    }

                    if (isBooleanKeyword) {
                        booleanKeywords.add(kw); // Track boolean keywords to exclude from string search
                    }
                }

                // Add boolean conditions to query
                if (!boolTrueCols.isEmpty() || !boolFalseCols.isEmpty()) {
                    if (!hasWhere) {
                        queryBuilder.append("WHERE ");
                        hasWhere = true;
                    } else {
                        queryBuilder.append(" AND ");
                    }
                    
                    queryBuilder.append("(");
                    boolean firstBool = true;
                    
                    for (String col : boolTrueCols) {
                        if (!firstBool) queryBuilder.append(" OR ");
                        queryBuilder.append("`").append(col).append("` = 1");
                        firstBool = false;
                    }
                    
                    for (String col : boolFalseCols) {
                        if (!firstBool) queryBuilder.append(" OR ");
                        queryBuilder.append("`").append(col).append("` = 0");
                        firstBool = false;
                    }
                    
                    queryBuilder.append(")");
                }

                //match keyword to string categories
                // Filter out numeric and boolean keywords from string search
                List<String> stringKeywords = new ArrayList<>();
                for (String kw : keywords) {
                    if (kw != null && !numericKeywords.contains(kw) && !booleanKeywords.contains(kw)) {
                        stringKeywords.add(kw);
                    }
                }
                
                // store the String parameters for LIKE clauses
                List<String> likeParams = new ArrayList<>();
                
                // build keyword conditions only if there are string keywords left
                if (!stringKeywords.isEmpty()) {
                    if (!hasWhere) {
                        queryBuilder.append("WHERE ");
                        hasWhere = true;
                    } else {
                        queryBuilder.append(" AND ");
                    }

                    //for each keyword
                    for (int i = 0; i < stringKeywords.size(); i++) {
                        String keyword = stringKeywords.get(i);
                        queryBuilder.append("CONCAT_WS(' ',");
                        //check against each category
                        for (int j = 0; j < stringCategories.size(); j++) {
                            String strCat = stringCategories.get(j);
                            queryBuilder.append(" `").append(strCat).append("` ");
                            if (j != stringCategories.size() - 1) {
                                queryBuilder.append(" , ");
                            }
                        }
                        queryBuilder.append(") LIKE ?");
                
                        likeParams.add("%" + keyword + "%");
                
                        if (i != stringKeywords.size() - 1) {
                            queryBuilder.append(" AND ");
                        }
                    }
                }


                //logic just to get the selected filter categories
                ArrayList<String> categories = getFilterCategories();
                Map<String, List<String>> selectedCategories = new HashMap<>();

                for (String category : categories) {
                    String[] vals = request.getParameterValues(category);

                    if (vals != null) {
                        selectedCategories.put(category, Arrays.asList(vals));
                    }
                }

                // Store IN clause parameters separately to maintain correct order
                List<String> inParams = new ArrayList<>();
                
                // Add selected category filters to the query
                if (!selectedCategories.isEmpty()) {
                    for (String selectedCat : selectedCategories.keySet()) {
                        if (hasWhere) {
                            queryBuilder.append(" AND ");
                        } else {
                            queryBuilder.append(" WHERE ");
                            hasWhere = true;
                        }
                        
                        queryBuilder.append("`").append(selectedCat).append("` IN (");
                        List<String> values = selectedCategories.get(selectedCat);
                        for (int i = 0; i < values.size(); i++) {
                            if (i > 0) queryBuilder.append(", ");
                            queryBuilder.append("?");
                            inParams.add(values.get(i)); // Store IN clause parameters separately
                        }
                        queryBuilder.append(")");
                    }
                }

                String query2 = queryBuilder.toString();
                //how to do fuzzy matching? should we even bother?
                //it should also use these to be exact matches for each selected category name = selectedcategoryvalue1 or selectedcategoryvalue2 
                
                /* get the list of values per category */
                PreparedStatement ps2 = con.prepareStatement(query2);
                
                // Set parameters for the PreparedStatement in the order they appear in the query
                int paramIndex = 1;
                // 1. Set equal parameters for numeric search (appears first in query)
                // Must match the order: for each column, for each value
                if (!equalParams.isEmpty() && !numericCategories.isEmpty()) {
                    for (String col : numericCategories) {
                        for (Double equalParam : equalParams) {
                            ps2.setDouble(paramIndex++, equalParam);
                        }
                    }
                }
                // 2. Set LIKE parameters for keyword search (string categories)
                for (String likeParam : likeParams) {
                    ps2.setString(paramIndex++, likeParam);
                }
                // 3. Set IN clause parameters for selected categories
                for (String inParam : inParams) {
                    ps2.setString(paramIndex++, inParam);
                }
                
                System.out.println ("SEARCH POST QUERY: " + ps2.toString());
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
                
                // Initialize filter categories and values using helper method
                Map<String, Object> filterData = initializeFilterCategories(con);
                
                ApplicationDB.closeConnection(con);
                
                // Pass categories to jsp (general first, then item-type specific categories)
                request.setAttribute("generalCategories", filterData.get("generalCategories"));
                request.setAttribute("phoneCategories", filterData.get("phoneCategories"));
                request.setAttribute("tvCategories", filterData.get("tvCategories"));
                request.setAttribute("headphonesCategories", filterData.get("headphonesCategories"));
                request.setAttribute("categoryValues", filterData.get("categoryValues"));
                
                // Pass selected categories so JSP can check the checkboxes
                request.setAttribute("selectedCategories", selectedCategories);
                
                request.setAttribute("items", items);
                request.setAttribute("searched", true);
                request.getRequestDispatcher("search.jsp").forward(request, response);

            }
            catch(Exception e) {
                e.printStackTrace();
                request.setAttribute("errorMessage", "Error loading category: " + e.getMessage());
                request.getRequestDispatcher("search.jsp").forward(request, response);
            }
    }


    
}
