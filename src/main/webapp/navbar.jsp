<style>
    /* Header Styles */
    .header {
        background: rgba(255, 255, 255, 0.95);
        padding: 1rem 2rem;
        box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        position: sticky;
        top: 0;
        z-index: 100;
    }

    .navbar {
        display: flex;
        align-items: center;
        justify-content: space-between;
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
    }

    .nav-links {
        list-style: none;
        display: flex;
        gap: 1.5rem;
        margin: 0;
        padding: 0;
    }

    .nav-links a {
        color: #6b9080;
        text-decoration: none;
        font-weight: 500;
        padding: 0.5rem 0.75rem;
        border-radius: 6px;
        transition: background 0.3s ease;
    }

    .nav-links a:hover {
        background-color: #6b9080;
        color: #fff;
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
        <a href="welcome.jsp" class="company-logo">
            <img src="Images/Tech_Barn_Logo.png" alt="Tech Barn Logo">
            <span>Homepage</span>
        </a>

        <ul class="nav-links">
            <li><a href="category?categoryId=1">Phones</a></li>
            <li><a href="category?categoryId=2">TVs</a></li>
            <li><a href="category?categoryId=3">Headphones</a></li>
            <li><a href="search.jsp">Search</a></li>
            <li><a href="faq.jsp">FAQs</a></li>
            <li><a href="alert.jsp">Alerts</a></li>
            <li><a href="account.jsp">My Account</a></li>
        </ul>

        <a href="logout" class="logout-btn">Logout</a>
    </nav>
</header>