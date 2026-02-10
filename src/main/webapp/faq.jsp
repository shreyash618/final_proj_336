<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, com.techbarn.webapp.model.Question" %>
<html>
<head>
    <title>FAQ - Tech Barn</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&family=Roboto:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        * { 
            margin: 0; 
            padding: 0; 
            box-sizing: border-box; 
            font-family: 'Inter', 'Roboto', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif; 
        }
        
        body, html {
            height: 100%;
            width: 100%;
            overflow-x: hidden;
        }
        
        .category-hero {
            width: 100%;
            height: 300px;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            position: relative;
            padding: 40px 20px;
            overflow: hidden;
        }

        .category-hero::after {
            content: "";
            position: absolute;
            inset: 0;
            background-image: url('Images/backgrounds/questions_banner.jpeg');
            background-size: cover;
            background-position: center;
            filter: brightness(0.85) contrast(1.0);
            z-index: 0;
        }

        .category-hero::before {
            content: "";
            position: absolute;
            inset: 0;
            background: linear-gradient(135deg, rgba(0,0,0,0.05), rgba(0,0,0,0.02));
            z-index: 1;
        }

        .category-hero-content {
            position: relative;
            z-index: 2;
            width: 100%;
            max-width: 1200px;
            display: flex;
            flex-direction: column;
            gap: 30px;
            align-items: center;
        }

        .category-hero-header {
            position: absolute;
            top: 20px;
            right: 40px;
            z-index: 2;
        }

        .category-hero h1 {
            color: white;
            font-size: 3rem;
            font-weight: 700;
            letter-spacing: -0.02em;
            text-shadow: 2px 2px 10px rgba(0, 0, 0, 0.5);
            background: none;
            -webkit-background-clip: unset;
            -webkit-text-fill-color: white;
            background-clip: unset;
            margin: 0;
        }
        
        .page-container {
            min-height: calc(100vh - 80px);
            position: relative;
            padding: 30px 20px;
            background: #f5f7fb;
        }

        .faq-container { 
            max-width: 1200px; 
            margin: 0 auto; 
            padding: 30px; 
            position: relative;
            z-index: 1;
            background: rgba(245, 247, 251, 0.95);
            border-radius: 16px;
        }
        
        .faq-container .faq-header { 
            display: none;
        }
        
        .dashboard-btn { 
            padding: 12px 24px; 
            background: rgba(250, 250, 250, 0.95);
            color: #6b9080; 
            text-decoration: none; 
            border-radius: 8px; 
            font-weight: 600; 
            font-size: 0.99rem;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
            border: 2px solid rgba(240, 240, 240, 0.8);
        }
        
        .dashboard-btn:hover { 
            background: rgba(245, 245, 245, 1);
            color: #5a7a6a;
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.2);
        }
        
        .dashboard-btn:active {
            transform: translateY(0);
        }
        
        .search-section { 
            width: 100%;
            max-width: 800px;
            margin: 0;
            padding: 0;
            background: transparent;
            border-radius: 0;
            box-shadow: none;
            border: none;
        }
        
        .search-form { 
            display: flex; 
            gap: 12px; 
            align-items: stretch;
            width: 100%;
            background: rgba(250, 250, 250, 0.95);
            padding: 14px;
            border-radius: 999px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.12);
        }
        
        .search-input { 
            flex: 1; 
            padding: 14px 20px; 
            border: 2px solid rgba(240, 240, 240, 0.5); 
            border-radius: 999px; 
            font-size: 1rem; 
            outline: none; 
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            background: rgba(255, 255, 255, 0.98);
            color: #2d3748;
            font-weight: 400;
        }
        
        .search-input::placeholder {
            color: #a0aec0;
        }
        
        .search-input:focus { 
            border-color: rgba(240, 240, 240, 0.9);
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.15);
            transform: translateY(-1px);
        }
        
        .search-btn { 
            padding: 14px 30px; 
            background: linear-gradient(135deg, #6b9080 0%, #5a7a6a 100%); 
            color: white; 
            border: none; 
            border-radius: 999px; 
            font-weight: 600; 
            font-size: 1rem;
            cursor: pointer; 
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            box-shadow: 0 4px 12px rgba(107, 144, 128, 0.4);
        }
        
        .search-btn:hover { 
            background: linear-gradient(135deg, #5a7a6a 0%, #4a6b5f 100%);
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(107, 144, 128, 0.35);
        }
        
        .search-btn:active {
            transform: translateY(0);
        }
        
        .clear-btn { 
            padding: 14px 24px; 
            background: linear-gradient(135deg, #718096 0%, #4a5568 100%); 
            color: white; 
            border: none; 
            border-radius: 999px; 
            font-weight: 600; 
            font-size: 1rem;
            cursor: pointer;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            box-shadow: 0 4px 12px rgba(113, 128, 150, 0.4);
        }
        
        .clear-btn:hover { 
            background: linear-gradient(135deg, #4a5568 0%, #2d3748 100%);
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(113, 128, 150, 0.35);
        }
        
        .ask-section { 
            margin: 30px 0; 
            padding: 30px; 
            background: linear-gradient(135deg, rgba(220, 235, 223, 0.95) 0%, rgba(190, 210, 191, 0.95) 100%);
            border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.06), 0 1px 3px rgba(0, 0, 0, 0.04);
            border: 1px solid rgba(255, 255, 255, 0.6);
        }
        
        .ask-section h2 { 
            color: #4a6b4f; 
            margin-bottom: 20px; 
            font-size: 1.5rem;
            font-weight: 700;
            letter-spacing: -0.01em;
        }
        
        .form-group { 
            margin-bottom: 20px; 
        }
        
        .form-group label { 
            display: block; 
            margin-bottom: 8px; 
            font-weight: 600; 
            color: #2d3748; 
            font-size: 1rem;
        }
        
        .form-input { 
            width: 100%; 
            padding: 12px 16px; 
            border: 2px solid #c8e6c9; 
            border-radius: 8px; 
            font-size: 1rem;
            background: #ffffff;
            color: #2d3748;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        }
        
        .form-input:focus {
            outline: none;
            border-color: #66bb6a;
            box-shadow: 0 0 0 4px rgba(102, 187, 106, 0.12), 0 2px 8px rgba(102, 187, 106, 0.1);
            transform: translateY(-1px);
        }
        
        .form-textarea { 
            width: 100%; 
            padding: 12px 16px; 
            border: 2px solid #c8e6c9; 
            border-radius: 8px; 
            font-size: 1rem; 
            min-height: 120px; 
            resize: vertical;
            background: #ffffff;
            color: #2d3748;
            font-family: inherit;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            line-height: 1.6;
        }
        
        .form-textarea:focus {
            outline: none;
            border-color: #66bb6a;
            box-shadow: 0 0 0 4px rgba(102, 187, 106, 0.12), 0 2px 8px rgba(102, 187, 106, 0.1);
            transform: translateY(-1px);
        }
        
        .submit-btn { 
            padding: 12px 30px; 
            background: linear-gradient(135deg, #5a8a5f 0%, #4a7a4f 100%); 
            color: white; 
            border: none; 
            border-radius: 8px; 
            font-weight: 600; 
            font-size: 1rem;
            cursor: pointer;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            box-shadow: 0 4px 12px rgba(90, 138, 95, 0.25);
        }
        
        .submit-btn:hover { 
            background: linear-gradient(135deg, #4a7a4f 0%, #3a6a3f 100%);
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(90, 138, 95, 0.35);
        }
        
        .submit-btn:active {
            transform: translateY(0);
        }
        
        .questions-section { 
            margin-top: 40px; 
        }
        
        .questions-section h2 { 
            color: #2d3748; 
            margin-bottom: 25px; 
            padding: 18px 24px;
            background: rgba(250, 250, 250, 0.95);
            border-radius: 12px;
            font-size: 1.8rem;
            font-weight: 700;
            letter-spacing: -0.01em;
            box-shadow: 0 4px 16px rgba(0, 0, 0, 0.08), inset 0 1px 0 rgba(255, 255, 255, 0.9);
            border: 2px solid rgba(240, 240, 240, 0.9);
            display: inline-block;
            width: 100%;
            box-sizing: border-box;
        }
        
        .questions-list { 
            padding-right: 10px; 
        }
        
        .question-card { 
            border: 2px solid #e2e8f0; 
            padding: 25px; 
            margin-bottom: 20px; 
            border-radius: 12px; 
            transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
            background: rgba(250, 250, 250, 0.95);
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.04);
        }
        
        .question-card:hover { 
            box-shadow: 0 8px 30px rgba(0, 0, 0, 0.12), 0 2px 8px rgba(0, 0, 0, 0.08); 
            transform: translateY(-4px);
            border-color: #6b9080;
        }
        
        .question-card.answered { 
            background: linear-gradient(135deg, rgba(235, 242, 238, 0.95) 0%, rgba(225, 238, 228, 0.95) 100%);
            box-shadow: 0 2px 8px rgba(100, 150, 110, 0.12);
        }
        
        .question-card.answered:hover {
            box-shadow: 0 8px 30px rgba(80, 120, 90, 0.2), 0 2px 8px rgba(100, 150, 110, 0.12);
            border-color: #5a7a5f;
        }
        
        .question-card.unanswered { 
            background: linear-gradient(135deg, rgba(250, 248, 242, 0.95) 0%, rgba(245, 240, 225, 0.95) 100%);
            box-shadow: 0 2px 8px rgba(200, 170, 120, 0.12);
        }
        
        .question-card.unanswered:hover {
            box-shadow: 0 8px 30px rgba(200, 170, 120, 0.2), 0 2px 8px rgba(200, 170, 120, 0.12);
        }
        
        .question-title { 
            font-size: 1.3rem; 
            color: #2d3748; 
            font-weight: 700; 
            margin-bottom: 12px; 
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            flex-wrap: wrap;
            gap: 12px;
            transition: color 0.3s ease;
        }
        
        .question-title:hover { 
            color: #6b9080; 
        }
        
        .question-status { 
            display: inline-block; 
            padding: 5px 14px; 
            border-radius: 20px; 
            font-size: 0.85rem; 
            font-weight: 600; 
            letter-spacing: 0.02em;
            text-transform: uppercase;
            box-shadow: 0 2px 6px rgba(0, 0, 0, 0.1);
        }
        
        .status-answered { 
            background: linear-gradient(135deg, #5a8a5f 0%, #4a7a4f 100%); 
            color: white; 
        }
        
        .status-open { 
            background: linear-gradient(135deg, #d68910 0%, #c67a0f 100%); 
            color: white; 
        }
        
        .question-content { 
            color: #4a5568; 
            margin-bottom: 18px; 
            line-height: 1.7;
            font-size: 1rem;
            font-weight: 400;
        }
        
        .question-answer { 
            margin-top: 15px; 
            padding: 18px; 
            background: rgba(245, 245, 245, 0.8);
            border-left: 4px solid #6b9080; 
            border-radius: 6px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
        }
        
        .answer-label { 
            font-weight: 700; 
            color: #6b9080; 
            margin-bottom: 10px;
            font-size: 1rem;
        }
        
        .answer-text { 
            color: #2d3748; 
            line-height: 1.7;
            font-size: 0.99rem;
            font-weight: 400;
        }
        
        .no-answer { 
            color: #718096; 
            font-style: italic; 
            font-weight: 400;
        }
        
        .empty-state { 
            text-align: center; 
            padding: 60px 20px; 
            color: #718096;
            font-size: 1.1rem;
            background: rgba(250, 250, 250, 0.95);
            border-radius: 12px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.04);
        }
        
        .login-prompt { 
            background: linear-gradient(135deg, rgba(245, 235, 200, 0.95) 0%, rgba(240, 225, 170, 0.95) 100%);
            padding: 18px; 
            border-radius: 8px; 
            border-left: 4px solid #d4a017; 
            margin-bottom: 20px;
            color: #2d3748;
            box-shadow: 0 2px 8px rgba(212, 160, 23, 0.12);
        }
        
        .login-link { 
            color: #6b9080; 
            font-weight: 700; 
            text-decoration: none;
            transition: all 0.3s ease;
        }
        
        .login-link:hover { 
            text-decoration: underline; 
            color: #5a7a6a;
        }
        
        .filter-section {
            margin: 30px 0;
            padding: 20px 25px;
            background: rgba(250, 250, 250, 0.95);
            border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.06), 0 1px 3px rgba(0, 0, 0, 0.04);
            border: 1px solid rgba(240, 240, 240, 0.8);
        }
        
        .filter-label {
            color: #2d3748;
            font-weight: 600;
            margin-bottom: 12px;
            font-size: 1rem;
            letter-spacing: -0.01em;
        }
        
        .filter-buttons {
            display: flex;
            gap: 12px;
            flex-wrap: wrap;
        }
        
        .filter-btn {
            padding: 10px 20px;
            background: white;
            color: #2d3748;
            text-decoration: none;
            border-radius: 8px;
            font-weight: 600;
            font-size: 1rem;
            border: 2px solid #e2e8f0;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            cursor: pointer;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.04);
        }
        
        .filter-btn:hover {
            background: linear-gradient(135deg, #6b9080 0%, #5a7a6a 100%);
            color: white;
            border-color: #6b9080;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(107, 144, 128, 0.3);
        }
        
        .filter-btn.active {
            background: linear-gradient(135deg, #6b9080 0%, #5a7a6a 100%);
            color: white;
            border-color: #6b9080;
            box-shadow: 0 4px 12px rgba(107, 144, 128, 0.3);
        }
        
        @media (max-width: 768px) {
            .category-hero {
                height: 250px;
                padding: 20px;
            }

            .category-hero h1 {
                font-size: 2rem;
            }

            .category-hero-header {
                top: 15px;
                right: 15px;
            }

            .dashboard-btn {
                padding: 10px 18px;
                font-size: 0.9rem;
            }
            
            .search-form {
                flex-direction: column;
            }
            
            .filter-buttons {
                flex-direction: column;
            }
            
            .filter-btn {
                width: 100%;
                text-align: center;
            }
        }
    </style>
</head>
<body>

<%@ include file="navbar.jsp" %>
<% 
    // Declare role once at the top
    String role = (String) session.getAttribute("role");
    boolean isRepOrAdmin = "rep".equals(role) || "admin".equals(role);
%>
<div class="category-hero">
    <div class="category-hero-header">
        <% if (isRepOrAdmin) { %>
            <a href="<%=request.getContextPath()%>/<%="rep".equals(role) ? "custrep" : "admin"%>" class="dashboard-btn">
                Back to Dashboard
            </a>
        <% } else { %>
            <a href="welcome" class="dashboard-btn">
                Back to Home
            </a>
        <% } %>
    </div>
    <div class="category-hero-content">
        <h1>FAQ / Customer Questions</h1>
        <!-- Search Section -->
        <div class="search-section">
            <form method="get" action="<%=request.getContextPath()%>/faq" class="search-form">
                <input type="text" name="q" class="search-input" placeholder="Search questions by keywords..." value="<%=request.getParameter("q") != null ? request.getParameter("q") : ""%>" />
                <button type="submit" class="search-btn">Search</button>
                <% if (request.getParameter("q") != null && !request.getParameter("q").isEmpty()) { %>
                    <a href="<%=request.getContextPath()%>/faq" class="clear-btn">Clear</a>
                <% } %>
            </form>
        </div>
    </div>
</div>
<div class ="page-container">
<div class="faq-container">
    <% if (request.getAttribute("errorMessage") != null) { %>
    <div style="padding:12px;margin-bottom:16px;background:#fef2f2;color:#b91c1c;border-radius:8px;border:1px solid #fecaca;">
        <%= request.getAttribute("errorMessage") %>
    </div>
    <% } %>
    <!-- Filter by status - everyone can use -->
    <div class="filter-section">
        <div class="filter-label">Filter by Status:</div>
        <div class="filter-buttons">
            <a href="<%=request.getContextPath()%>/faq" class="filter-btn <%=request.getParameter("status") == null ? "active" : ""%>">All</a>
            <a href="<%=request.getContextPath()%>/faq?status=answered" class="filter-btn <%="answered".equals(request.getParameter("status")) ? "active" : ""%>">Answered</a>
            <a href="<%=request.getContextPath()%>/faq?status=open" class="filter-btn <%="open".equals(request.getParameter("status")) ? "active" : ""%>">Unanswered</a>
        </div>
    </div>

    <!-- Ask a Question Section - Only for regular users -->
    <% if (!isRepOrAdmin) { %>
    <div class="ask-section">
        <h2>Ask a Question</h2>
        <% if (session.getAttribute("user_id") != null) { %>
            <form method="post" action="<%=request.getContextPath()%>/faq">
                <div class="form-group">
                    <label for="title">Question Title *</label>
                    <input type="text" id="title" name="title" class="form-input" required placeholder="Brief summary of your question" />
                </div>
                <div class="form-group">
                    <label for="contents">Details</label>
                    <textarea id="contents" name="contents" class="form-textarea" placeholder="Provide more details about your question..."></textarea>
                </div>
                <button type="submit" class="submit-btn">Submit Question</button>
            </form>
        <% } else { %>
            <div class="login-prompt">
                Please <a href="login" class="login-link">login</a> to ask a question.
            </div>
        <% } %>
    </div>
    <% } %>
    
    <!-- Questions List Section -->
    <div class="questions-section">
        <h2>Questions</h2>
        
        <div class="questions-list">
            <% 
                List<Question> questions = (List<Question>) request.getAttribute("questions");
                if (questions != null && questions.size() > 0) {
                    for (Question q : questions) {
                        boolean hasReply = q.getReply() != null && !q.getReply().isEmpty();
                        String cardClass = hasReply ? "answered" : "unanswered";
                        String statusClass = hasReply ? "status-answered" : "status-open";
            %>
            <div class="question-card <%=cardClass%>">
                <a href="<%=request.getContextPath()%>/question?id=<%=q.getQuestionId()%>" class="question-title">
                    <%=q.getTitle()%>
                    <span class="question-status <%=statusClass%>"><%=q.getStatus()%></span>
                </a>
                <div class="question-content"><%=q.getContents()%></div>
                <div class="question-answer">
                    <div class="answer-label">Answer:</div>
                    <div class="answer-text <%=hasReply ? "" : "no-answer"%>">
                        <%=hasReply ? q.getReply() : "(Not answered yet" + (isRepOrAdmin ? " - click to answer" : "") + ")"%>
                    </div>
                </div>
            </div>
            <% 
                    }
                } else {
            %>
            <div class="empty-state">
                <p>No questions found.</p>
                <% if (request.getParameter("q") != null) { %>
                    <p>Try a different search term or <a href="<%=request.getContextPath()%>/faq" class="login-link">view all questions</a>.</p>
                <% } %>
            </div>
            <% } %>
        </div>
    </div>
    
</div>
</div>
</body>
</html>
