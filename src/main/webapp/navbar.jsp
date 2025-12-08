<style>
    /* Header Styles */
    header.header {
        background: rgba(255, 255, 255, 0.95);
        padding: 1rem 2rem;
        box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        position: sticky;
        top: 0;
        z-index: 100;
        width: 100%;
        box-sizing: border-box;
    }

    .navbar {
        display: flex;
        align-items: center;
        justify-content: space-between;
        width: 100%;
        max-width: 100%;
    }
    .navbar span{
        margin-left: 5px;
    }

    .company-logo {
        display: flex;
        align-items: center;
        font-size: 1.6rem;
        font-weight: 700;
        color: #6b9080;
        text-decoration: none;
    }

    .company-logo img {
        height: 40px;
        width: auto;
        margin-right: 10px;
        border-radius: 5px;
    }

    .nav-links {
        list-style: none;
        display: flex;
        align-items: center;
        gap: 1.5rem;
        margin: 0;
        padding: 0;
    }
    
    .nav-links li {
        display: flex;
        align-items: center;
    }

    .nav-links a {
        color: #6b9080;
        text-decoration: none;
        font-weight: 500;
        padding: 0.5rem 1rem;
        border-radius: 6px;
        transition: background 0.3s ease, color 0.3s ease;
        display: flex;
        align-items: center;
        justify-content: center;
        line-height: 1.5;
        height: 100%;
        font-size: 0.95rem;
        letter-spacing: 0.01em;
    }

    .nav-links a:hover {
        background-color: #6b9080;
        color: #fff;
    }
    .nav-links img {
        height: 24px;
        width: auto;
        display: block;
        object-fit: contain;
        text-align: center;
        margin-bottom: 5px;
    }
    
    .nav-links a:hover img {
        filter: brightness(0) invert(1);
    }

    .logout-btn {
        padding: 0.6rem 1.2rem;
        background: #6b9080;
        color: #fff;
        border-radius: 8px;
        font-size: 1rem;
        text-decoration: none;
        transition: background 0.3s ease, transform 0.2s ease;
    }

    .logout-btn:hover {
        background: #3e6b5c;
        transform: scale(1.05);
    }
</style>

<!-- Header with Company Name and Logout Button -->
<header class="header">
    <nav class="navbar">
        <a href="welcome" class="company-logo">
            <img src="Images/Tech_Barn_Logo.png" alt="Tech Barn Logo">
            <span>Homepage</span>
        </a>

        <ul class="nav-links">
            <li><a href="category?categoryId=1">Phones</a></li>
            <li><a href="category?categoryId=2">TVs</a></li>
            <li><a href="category?categoryId=3">Headphones</a></li>
            <li><a href="search">Search</a></li>
            <li><a href="faq">FAQs</a></li>
            <li><a href="alert.jsp"><img src="Images/icons/notification_icon.png"/></a></li>
            <li><a href="User_Account_Info_Page.jsp">My Account</a></li>
            <% 
                Object isSellerObj = session.getAttribute("isSeller");
                boolean showSellerLinks = false;
                if (isSellerObj != null) {
                    if (isSellerObj instanceof Boolean) {
                        showSellerLinks = (Boolean) isSellerObj;
                    } else if (isSellerObj instanceof Integer) {
                        showSellerLinks = ((Integer) isSellerObj) == 1;
                    }
                }
                if (showSellerLinks) { 
            %>
            <li><a href="sellerhomepage.jsp">Seller Dashboard</a></li>
            <li><a href="createauction.jsp">Create Auction</a></li>
            <% } %>
        </ul>

        <a href="logout" class="logout-btn">Logout</a>
    </nav>
</header>