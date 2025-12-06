<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="com.techbarn.webapp.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%!     //used in the html to transform the name
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
%>
<%!
public String transformBoolean (String booleanInt){
    if (booleanInt == null) return booleanInt;
    String trimmed = booleanInt.trim();
    if (trimmed.equals("1") || trimmed.equalsIgnoreCase("true")){
        return "Yes";
    }
    else if (trimmed.equals("0") || trimmed.equalsIgnoreCase("false")){
        return "No";
    }
    return booleanInt;
}
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tech Barn — SearchPage </title>
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@24,400,0,0&icon_names=search" />
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;700&display=swap" rel="stylesheet">
    <style>
        * { 
            margin: 0; 
            padding: 0; 
            box-sizing: border-box; 
            font-family: 'Roboto', sans-serif; 
        }
        
        body, html {
            height: 100%;
            width: 100%;
            overflow-x: hidden;
        }
        .category-hero {
            width: 100%;
            height: 260px;
            /*background: #334b31*/
            background-image: url('./Images/backgrounds/search_page2.avif'); 
            background-size: cover;
            background-position: center;
            display: flex;
            justify-content: left;
            align-items: center;
            position: relative;
        }

        .category-hero::before {
            content: "";
            position: absolute;
            inset: 0;
            /*background: linear-gradient(135deg, rgba(0,0,0,0.45), rgba(0,0,0,0.15));*/
        }



        /* CSS for search bar */
        .search {
            width: 100%;
            display: flex;
            /*justify-content: center;*/
            padding: 0 40px;
            z-index: 1;
            
            --padding: 14px;
            margin-left: 370px; /*filter + filter-margin + 10px*/
            width: 100%;
            max-width: 800px;
            display: flex;
            align-items: center;
            padding: var(--padding);
            border-radius: 999px;
            background: rgba(255,255,255,0.9);
            box-shadow: 0 10px 30px rgba(0,0,0,0.15);
        }
        .search:focus-within{
            box-shadow: 0 0 2px rgba(0,0,0,0.75);

        }
        .search-input {
            font-size: 20px;
            font-family: inherit;
            margin-left: var(--padding);
            outline: none;
            border: none;
            flex: 1;
            background: transparent;
        }

        .search-input::placeholder,
        .search-icon {
            color: rgba(0, 0, 0, 0.45);
        }

        .search-layout {
            display: grid;
            grid-template-columns: 260px 1fr;
            gap: 24px;
            padding: 24px 40px 40px;
            background: #f5f7fb;
        }

        /* CSS for the filters sidebar */
        .filter-container {
            display: block;
            width: 250px;
            margin: 12px 0 0 20px; /* top right bottom left */
        }

        .filters {
            background: linear-gradient(145deg, #ffffff, #f3f4f8);
            border-radius: 16px;
            padding: 18px 18px 20px;
            box-shadow: 0 10px 30px rgba(15, 23, 42, 0.08);
            font-size: 14px;
            border: 1px solid #e5e7eb;
            position: sticky;
            top: 96px;
            max-height: calc(100vh - 120px);
            overflow-y: auto;
        }

        .filters::-webkit-scrollbar {
            width: 6px;
        }

        .filters::-webkit-scrollbar-track {
            background: transparent;
        }

        .filters::-webkit-scrollbar-thumb {
            background: rgba(148, 163, 184, 0.7);
            border-radius: 999px;
        }

        .filters-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 14px;
        }

        .filters-header-title {
            font-size: 16px;
            font-weight: 600;
            letter-spacing: 0.01em;
            color: #111827;
        }
        
        .filters-header-subtitle {
            font-size: 12px;
            letter-spacing: 0.01em;
            color: #6b7280;
        }

        .filter-group {
            margin-bottom: 18px;
            padding-top: 10px;
            border-top: 1px solid #e5e7eb;
        }

        .filter-title {
            display: block;
            font-weight: 600;
            margin-bottom: 10px;
            color: #111827;
            font-size: 14px;
            letter-spacing: 0.01em;
        }

        /* “Pill” style checkboxes */
        .filter-pill {
            display: flex;
            align-items: center;
            gap: 6px;
            margin: 4px 6px 4px 0;
            padding: 6px 10px;
            border-radius: 999px;
            border: 1px solid #d1d5db;
            cursor: pointer;
            user-select: none;
            font-size: 13px;
            background: #ffffff;
            transition: background 0.15s, border-color 0.15s, box-shadow 0.15s, transform 0.1s;
        }

        .filter-pill:hover {
            background: #eef2ff;
            border-color: #818cf8;
            box-shadow: 0 1px 4px rgba(15, 23, 42, 0.16);
            transform: translateY(-1px);
        }

        .filter-pill input[type="checkbox"] {
            accent-color: #4f46e5;
        }

        .filter-pill input[type="checkbox"]:checked ~ span {
            color: #111827;
            font-weight: 600;
        }

        .filter-pill-active {
            background: #eef2ff;
            border-color: #4f46e5;
        }

        .apply-button {
            margin-top: 10px;
            width: 100%;
            padding: 9px 0;
            border: none;
            border-radius: 999px;
            background: linear-gradient(135deg, #6b46e5, #6366f1);
            color: #fff;
            font-weight: 600;
            cursor: pointer;
            font-size: 13px;
            letter-spacing: 0.04em;
            text-transform: uppercase;
            box-shadow: 0 8px 20px rgba(79, 70, 229, 0.35);
            transition: transform 0.1s ease, box-shadow 0.1s ease, filter 0.1s ease;
        }

        .apply-button:hover {
            filter: brightness(1.05);
            transform: translateY(-1px);
            box-shadow: 0 12px 28px rgba(79, 70, 229, 0.45);
        }

        .apply-button:active {
            transform: translateY(0);
            box-shadow: 0 6px 18px rgba(79, 70, 229, 0.35);
        }

        /* CSS for the search results grid (same as category.jsp) */
        .item-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            padding: 30px;
        }

        .item-card {
            background: #fff;
            padding: 15px;
            border-radius: 10px;
            text-align: center;
            box-shadow: 0px 0px 10px rgba(0,0,0,0.1);
        }

        .item-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 14px 35px rgba(15,23,42,0.14);
        }

        .item-card img {
            width: 100%;
            height: auto;
            aspect-ratio: 1 / 1;
            object-fit: cover;
            border-radius: 8px;
            margin-bottom: 10px;
        }
        
        .item-card a {
            text-decoration: none;
            color: inherit;
        }
        
        .item-card p {
            margin: 5px 0;
            font-weight: 500;
        }
        /*For the results line*/
        .results {
            min-height: 300px;
        }

        .results-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-end;
            margin-bottom: 16px;
        }

        .results-header h2 {
            font-size: 22px;
            margin-bottom: 4px;
        }

        .results-subtitle {
            font-size: 13px;
            color: #6b7280;
        }

        .sort {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 13px;
        }

        .sort select {
            padding: 5px 8px;
            border-radius: 999px;
            border: 1px solid #d1d5db;
        }
    </style>
</head>
<body>
    <%@ include file="navbar.jsp" %>
    <%
        String errorMessage = (String) request.getAttribute("errorMessage");
        if (errorMessage != null) {
    %>
    <div style="padding: 20px; background-color: #ffebee; color: #c62828; margin: 20px; border-radius: 5px; border-left: 4px solid #c62828;">
        <strong>Error:</strong> <%= errorMessage %>
    </div>
    <%
        }
    %>
    <form method="post" action="search"> 
    <div class="category-hero">
            <div class="search">
                <span class="search-icon material-symbols-outlined">search</span>
                <input class = "search-input" type="search" placeholder="Search our inventory..." name="searchbar"></input>
            </div>
    </div>
    <div class ="search-layout">
        <!-- Sidebar (left)-->
        <aside class="filter-container">
                <div class="filters">
                    <div class="filters-header">
                        <span class="filters-header-title">Filters</span>
                        <span class="filters-header-subtitle">Refine results</span>
                    </div>
                    <% 
                        ArrayList<String> categories =  (ArrayList<String>) request.getAttribute("categories");
                        System.out.println("Categories: " + categories);

                        
                        HashMap<String, ArrayList<String>> categoryValues= (HashMap<String, ArrayList<String>>) request.getAttribute("categoryValues");
                        
                        if (categories != null) {
                            for (String category: categoryValues.keySet()){
                    %>
                            <!--for each category, create a filter group -->
                            <!--dynamically loop through and render the properties -->
                        <div class="filter-group">
                            <!--for each value in category, create a span and label-->
                            <span class="filter-title" name="${category}"><%= transformName(category) %></span>
                            <%for (String categoryValue: categoryValues.get(category)){%>
                            <!--dynamically render the possible values for each property -->
                            <label class="filter-pill">
                                <input type="checkbox" name="<%= category %>" value="<%= categoryValue %>">
                                <span><%= transformBoolean(categoryValue) %></span>
                            </label>
                            <%
                                }
                            %>
                        </div>
                    <%
                            }
                        }
                    %>
                    <button type="submit" class="apply-button">Apply Filters</button>
                </div>
            </form>
        </aside>
        <!-- Results Grid (right)-->
        <div class="results">
        <div class="results-header">
            <div>
                <h2>Search results</h2>
                <p class="results-subtitle">
                    <% 
                        String q = request.getParameter("q");
                        ArrayList<ItemBean> items = (ArrayList<ItemBean>) request.getAttribute("items");
                        int count = (items != null) ? items.size() : 0;
                    %>
                    <%= count %> item(s) found
                    <% if (q != null && !q.isEmpty()) { %>
                        for "<%= q %>"
                    <% } %>
                </p>
            </div>

            <div class="sort">
                <label for="sortBy">Sort by</label>
                <select id="sortBy" name="sortBy" form="sortForm">
                    <option value="relevance">Relevance</option>
                    <option value="priceAsc">Price: Low to High</option>
                    <option value="priceDesc">Price: High to Low</option>
                    <option value="newest">Newest</option>
                </select>
            </div>
        </div>

        <div class="item-grid">
            <%
                if (items != null && !items.isEmpty()) {
                    for (ItemBean item : items) {
            %>
            <div class="item-card">
                <a href="item?itemId=<%= item.getId() %>">
                    <img src="<%= item.getImagePath() %>" alt="<%= item.getName() %>">
                    <p><%= item.getName() %></p>
                    <p style="color: #666; font-size: 14px;"><%= item.getBrand() %> - <%= item.getColor() %></p>
                </a>
            </div>
            <%
                    }
                } else {
            %>
            <div style="grid-column: 1 / -1; text-align: center; padding: 40px; color: #6b7280;">
                <p>No items found matching the search criteria.</p>
            </div>
            <%
                }
            %>
    </div>
    </div>
</div>
</body>
</html>