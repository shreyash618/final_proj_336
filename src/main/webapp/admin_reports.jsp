<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, java.text.DecimalFormat" %>
<!DOCTYPE html>
<html>
<head>
    <title>Sales Reports - Tech Barn</title>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;700&display=swap" rel="stylesheet">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Roboto', sans-serif; }
        body { background: #ffffff; min-height: 100vh; padding: 40px 20px; }
        .container { max-width: 1200px; margin: 0 auto; }
        .header { background: white; padding: 30px; border-radius: 12px; box-shadow: 0 2px 8px rgba(0,0,0,0.05); margin-bottom: 30px; display: flex; justify-content: space-between; align-items: center; border-bottom: 3px solid #6b9080; }
        h1 { color: #333; font-size: 2rem; font-weight: 700; }
        .back-btn { padding: 12px 24px; background: #6b9080; color: white; text-decoration: none; border-radius: 8px; font-weight: 600; transition: all 0.3s; }
        .back-btn:hover { transform: translateY(-2px); box-shadow: 0 4px 12px rgba(107, 144, 128, 0.3); background: #5a7a6a; }
        .summary-card { background: linear-gradient(135deg, #e8f5e9 0%, #c8e6c9 100%); padding: 40px; border-radius: 12px; box-shadow: 0 2px 8px rgba(0,0,0,0.05); margin-bottom: 30px; text-align: center; }
        .summary-card h2 { color: #2e7d32; font-size: 1rem; margin-bottom: 10px; text-transform: uppercase; letter-spacing: 1px; font-weight: 700; }
        .summary-card .amount { font-size: 3rem; font-weight: 700; color: #2e7d32; }
        .report-section { background: #f8f9fa; padding: 30px; border-radius: 12px; box-shadow: 0 2px 8px rgba(0,0,0,0.05); margin-bottom: 30px; border: 2px solid #e0e0e0; }
        .report-section h2 { color: #333; margin-bottom: 20px; font-size: 1.5rem; font-weight: 700; }
        .table-wrapper { overflow-x: auto; background: white; border-radius: 8px; }
        table { width: 100%; border-collapse: collapse; }
        th { background: #6b9080; color: white; padding: 15px; text-align: left; font-weight: 600; }
        th:first-child { border-radius: 8px 0 0 0; }
        th:last-child { border-radius: 0 8px 0 0; }
        td { padding: 15px; border-bottom: 1px solid #e0e0e0; color: #333; background: white; }
        tr:hover td { background: #f8f9fa; }
        tr:last-child td { border-bottom: none; }
        .no-data { text-align: center; padding: 40px; color: #999; font-style: italic; }
        .earnings { font-weight: 600; color: #2e7d32; }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>Sales Reports</h1>
            <a href="<%=request.getContextPath()%>/admin" class="back-btn">← Back to Dashboard</a>
        </div>

        <div class="summary-card">
            <h2>Total Earnings</h2>
            <div class="amount">$<%
                Object te = request.getAttribute("totalEarnings");
                if (te != null) {
                    double total = (te instanceof Double) ? (Double)te : Double.parseDouble(te.toString());
                    out.print(new DecimalFormat("#,##0.00").format(total));
                } else {
                    out.print("0.00");
                }
            %></div>
        </div>

        <div class="report-section">
            <h2>Earnings by Item</h2>
            <div class="table-wrapper">
                <table>
                    <thead>
                        <tr>
                            <th>Item</th>
                            <th>Earnings</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% 
                            List<Map<String,Object>> byItem = (List<Map<String,Object>>) request.getAttribute("byItem");
                            if (byItem != null && !byItem.isEmpty()) {
                                DecimalFormat df = new DecimalFormat("#,##0.00");
                                for (Map<String,Object> r : byItem) {
                        %>
                        <tr>
                            <td><%=r.get("title")%></td>
                            <td class="earnings">$<%=df.format(r.get("earnings"))%></td>
                        </tr>
                        <% 
                                }
                            } else {
                        %>
                        <tr><td colspan="2" class="no-data">No data available</td></tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>

        <div class="report-section">
            <h2>Earnings by Item Type</h2>
            <div class="table-wrapper">
                <table>
                    <thead>
                        <tr>
                            <th>Item Type</th>
                            <th>Earnings</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% 
                            List<Map<String,Object>> byItemType = (List<Map<String,Object>>) request.getAttribute("byItemType");
                            if (byItemType != null && !byItemType.isEmpty()) {
                                DecimalFormat df = new DecimalFormat("#,##0.00");
                                for (Map<String,Object> r : byItemType) {
                        %>
                        <tr>
                            <td><%=r.get("item_type")%></td>
                            <td class="earnings">$<%=df.format(r.get("earnings"))%></td>
                        </tr>
                        <% 
                                }
                            } else {
                        %>
                        <tr><td colspan="2" class="no-data">No data available</td></tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>

        <div class="report-section">
            <h2>Earnings by Seller</h2>
            <div class="table-wrapper">
                <table>
                    <thead>
                        <tr>
                            <th>Seller</th>
                            <th>Earnings</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% 
                            List<Map<String,Object>> bySeller = (List<Map<String,Object>>) request.getAttribute("bySeller");
                            if (bySeller != null && !bySeller.isEmpty()) {
                                DecimalFormat df = new DecimalFormat("#,##0.00");
                                for (Map<String,Object> r : bySeller) {
                        %>
                        <tr>
                            <td><%=r.get("seller")%></td>
                            <td class="earnings">$<%=df.format(r.get("earnings"))%></td>
                        </tr>
                        <% 
                                }
                            } else {
                        %>
                        <tr><td colspan="2" class="no-data">No data available</td></tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>

        <div class="report-section">
            <h2>Best Selling Items</h2>
            <div class="table-wrapper">
                <table>
                    <thead>
                        <tr>
                            <th>Item</th>
                            <th>Units Sold</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% 
                            List<Map<String,Object>> bestItems = (List<Map<String,Object>>) request.getAttribute("bestItems");
                            if (bestItems != null && !bestItems.isEmpty()) {
                                for (Map<String,Object> r : bestItems) {
                        %>
                        <tr>
                            <td><%=r.get("title")%></td>
                            <td class="earnings"><%=r.get("sold_count")%></td>
                        </tr>
                        <% 
                                }
                            } else {
                        %>
                        <tr><td colspan="2" class="no-data">No data available</td></tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>

        <div class="report-section">
            <h2>Best Buyers</h2>
            <div class="table-wrapper">
                <table>
                    <thead>
                        <tr>
                            <th>Buyer</th>
                            <th>Total Spent</th>
                            <th>Auctions Won</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% 
                            List<Map<String,Object>> bestBuyers = (List<Map<String,Object>>) request.getAttribute("bestBuyers");
                            if (bestBuyers != null && !bestBuyers.isEmpty()) {
                                DecimalFormat df = new DecimalFormat("#,##0.00");
                                for (Map<String,Object> r : bestBuyers) {
                        %>
                        <tr>
                            <td><%=r.get("buyer")%></td>
                            <td class="earnings">$<%=df.format(r.get("total_spent"))%></td>
                            <td><%=r.get("auctions_won")%></td>
                        </tr>
                        <% 
                                }
                            } else {
                        %>
                        <tr><td colspan="3" class="no-data">No data available</td></tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</body>
</html>
