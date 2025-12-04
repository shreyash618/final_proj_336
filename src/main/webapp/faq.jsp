<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, com.techbarn.webapp.model.Question" %>
<html>
<head>
    <title>FAQ - Tech Barn</title>
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
            /*background: #ffffff;*/
        }
        .page-container::before{
            content:'';
            display: block;
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background-image: url('Images/gradient-question-banner.png');
            background-size: cover;
            background-position: center;
            opacity: 0.8;
            z-index: -1;
        }

        .faq-container { 
            max-width: 1200px; 
            margin: 0 auto; 
            padding: 40px 20px; 
            position: relative;
            background-color: hwb(0 100% 0% / 0.9);
            border-radius: 10px ;
        }
        
        .header { 
            display: flex; 
            justify-content: space-between; 
            align-items: center; 
            margin-bottom: 40px;
            padding-bottom: 20px;
            border-bottom: 2px solid #f0f0f0;
        }
        
        h1 { 
            color: #333; 
            font-size: 2.5rem;
            font-weight: 700;
        }
        
        .dashboard-btn { 
            padding: 12px 24px; 
            background: #6b9080; 
            color: white; 
            text-decoration: none; 
            border-radius: 8px; 
            font-weight: 600; 
            transition: all 0.3s ease;
        }
        
        .dashboard-btn:hover { 
            background: #5a7a6a;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(107, 144, 128, 0.3);
        }
        
        .search-section { 
            margin: 30px 0; 
            padding: 25px; 
            background: #f8f9fa; 
            border-radius: 12px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.05);
        }
        
        .search-form { 
            display: flex; 
            gap: 12px; 
        }
        
        .search-input { 
            flex: 1; 
            padding: 14px 20px; 
            border: 2px solid #e0e0e0; 
            border-radius: 8px; 
            font-size: 1rem; 
            outline: none; 
            transition: all 0.3s;
            background: white;
        }
        
        .search-input:focus { 
            border-color: #6b9080;
            box-shadow: 0 0 0 4px rgba(107, 144, 128, 0.1);
        }
        
        .search-btn { 
            padding: 14px 30px; 
            background: #6b9080; 
            color: white; 
            border: none; 
            border-radius: 8px; 
            font-weight: 600; 
            cursor: pointer; 
            transition: all 0.3s;
        }
        
        .search-btn:hover { 
            background: #5a7a6a;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(107, 144, 128, 0.3);
        }
        
        .clear-btn { 
            padding: 14px 24px; 
            background: #6c757d; 
            color: white; 
            border: none; 
            border-radius: 8px; 
            font-weight: 600; 
            cursor: pointer;
            transition: all 0.3s;
        }
        
        .clear-btn:hover { 
            background: #5a6268;
            transform: translateY(-2px);
        }
        
        .ask-section { 
            margin: 30px 0; 
            padding: 30px; 
            background: linear-gradient(135deg, #e8f5e9 0%, #c8e6c9 100%);
            border-radius: 12px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.05);
        }
        
        .ask-section h2 { 
            color: #2e7d32; 
            margin-bottom: 20px; 
            font-size: 1.5rem;
            font-weight: 700;
        }
        
        .form-group { 
            margin-bottom: 20px; 
        }
        
        .form-group label { 
            display: block; 
            margin-bottom: 8px; 
            font-weight: 600; 
            color: #333; 
        }
        
        .form-input { 
            width: 100%; 
            padding: 12px 16px; 
            border: 2px solid #a5d6a7; 
            border-radius: 8px; 
            font-size: 1rem;
            background: white;
            transition: all 0.3s;
        }
        
        .form-input:focus {
            outline: none;
            border-color: #4caf50;
            box-shadow: 0 0 0 4px rgba(76, 175, 80, 0.1);
        }
        
        .form-textarea { 
            width: 100%; 
            padding: 12px 16px; 
            border: 2px solid #a5d6a7; 
            border-radius: 8px; 
            font-size: 1rem; 
            min-height: 120px; 
            resize: vertical;
            background: white;
            transition: all 0.3s;
        }
        
        .form-textarea:focus {
            outline: none;
            border-color: #4caf50;
            box-shadow: 0 0 0 4px rgba(76, 175, 80, 0.1);
        }
        
        .submit-btn { 
            padding: 12px 30px; 
            background: #4caf50; 
            color: white; 
            border: none; 
            border-radius: 8px; 
            font-weight: 600; 
            cursor: pointer;
            transition: all 0.3s;
        }
        
        .submit-btn:hover { 
            background: #43a047;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(76, 175, 80, 0.3);
        }
        
        .questions-section { 
            margin-top: 40px; 
        }
        
        .questions-section h2 { 
            color: #333; 
            margin-bottom: 25px; 
            border-bottom: 3px solid #6b9080; 
            padding-bottom: 12px;
            font-size: 1.8rem;
            font-weight: 700;
        }
        
        .questions-list { 
            max-height: 600px; 
            overflow-y: auto; 
            padding-right: 10px; 
        }
        
        .questions-list::-webkit-scrollbar { 
            width: 10px; 
        }
        
        .questions-list::-webkit-scrollbar-track { 
            background: #f1f1f1; 
            border-radius: 10px; 
        }
        
        .questions-list::-webkit-scrollbar-thumb { 
            background: #6b9080; 
            border-radius: 10px; 
        }
        
        .questions-list::-webkit-scrollbar-thumb:hover { 
            background: #5a7a6a; 
        }
        
        .question-card { 
            border: 2px solid #e0e0e0; 
            padding: 25px; 
            margin-bottom: 20px; 
            border-radius: 12px; 
            transition: all 0.3s;
            background: white;
        }
        
        .question-card:hover { 
            box-shadow: 0 6px 20px rgba(0,0,0,0.1); 
            transform: translateY(-3px);
            border-color: #6b9080;
        }
        
        .question-card.answered { 
            background: linear-gradient(135deg, #f1f8f4 0%, #e8f5e9 100%);
            border-color: #81c784; 
        }
        
        .question-card.unanswered { 
            background: linear-gradient(135deg, #fffef7 0%, #fff9e6 100%);
            border-color: #ffb74d; 
        }
        
        .question-title { 
            font-size: 1.3rem; 
            color: #333; 
            font-weight: 700; 
            margin-bottom: 12px; 
            text-decoration: none;
            display: block;
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
            margin-left: 12px; 
        }
        
        .status-answered { 
            background: #4caf50; 
            color: white; 
        }
        
        .status-open { 
            background: #ff9800; 
            color: white; 
        }
        
        .question-content { 
            color: #666; 
            margin-bottom: 18px; 
            line-height: 1.7;
            font-size: 1rem;
        }
        
        .question-answer { 
            margin-top: 15px; 
            padding: 18px; 
            background: rgba(107, 144, 128, 0.05);
            border-left: 4px solid #6b9080; 
            border-radius: 6px; 
        }
        
        .answer-label { 
            font-weight: 700; 
            color: #6b9080; 
            margin-bottom: 10px;
            font-size: 1rem;
        }
        
        .answer-text { 
            color: #555; 
            line-height: 1.7;
            font-size: 0.95rem;
        }
        
        .no-answer { 
            color: #999; 
            font-style: italic; 
        }
        
        .empty-state { 
            text-align: center; 
            padding: 60px 20px; 
            color: #999;
            font-size: 1.1rem;
        }
        
        .login-prompt { 
            background: #fff3cd; 
            padding: 18px; 
            border-radius: 8px; 
            border-left: 4px solid #ffc107; 
            margin-bottom: 20px;
            color: #333;
        }
        
        .login-link { 
            color: #6b9080; 
            font-weight: 700; 
            text-decoration: none; 
        }
        
        .login-link:hover { 
            text-decoration: underline; 
        }
        
        .filter-section {
            margin: 30px 0;
            padding: 20px 25px;
            background: #f8f9fa;
            border-radius: 12px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.05);
        }
        
        .filter-label {
            color: #333;
            font-weight: 600;
            margin-bottom: 12px;
            font-size: 1rem;
        }
        
        .filter-buttons {
            display: flex;
            gap: 12px;
        }
        
        .filter-btn {
            padding: 10px 20px;
            background: white;
            color: #333;
            text-decoration: none;
            border-radius: 8px;
            font-weight: 600;
            border: 2px solid #e0e0e0;
            transition: all 0.3s;
            cursor: pointer;
        }
        
        .filter-btn:hover {
            background: #6b9080;
            color: white;
            border-color: #6b9080;
            transform: translateY(-2px);
        }
        
        .filter-btn.active {
            background: #6b9080;
            color: white;
            border-color: #6b9080;
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
<div class ="page-container">
<div class="faq-container">
    <div class="header">
        <h1>FAQ / Customer Questions</h1>
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
    
    <!-- Search Section -->
    <div class="search-section">
        <form method="get" action="<%=request.getContextPath()%>/faq" class="search-form">
            <input type="text" name="q" class="search-input" placeholder="Search questions by keywords..." value="<%=request.getParameter("q") != null ? request.getParameter("q") : ""%>" />
            <button type="submit" class="search-btn">Search</button>
            <% if (request.getParameter("q") != null && !request.getParameter("q").isEmpty()) { %>
                <a href="<%=request.getContextPath()%>/faq" class="clear-btn" style="text-decoration:none; display:inline-flex; align-items:center;">Clear</a>
            <% } %>
        </form>
    </div>

    <% if (isRepOrAdmin) { %>
    <!-- Filter Section for Reps/Admins -->
    <div class="filter-section">
        <div class="filter-label">Filter by Status:</div>
        <div class="filter-buttons">
            <a href="<%=request.getContextPath()%>/faq" class="filter-btn <%=request.getParameter("status") == null ? "active" : ""%>">All Questions</a>
            <a href="<%=request.getContextPath()%>/faq?status=answered" class="filter-btn <%="answered".equals(request.getParameter("status")) ? "active" : ""%>">Answered</a>
            <a href="<%=request.getContextPath()%>/faq?status=open" class="filter-btn <%="open".equals(request.getParameter("status")) ? "active" : ""%>">Open</a>
        </div>
    </div>
    <% } %>

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
        <h2><%=isRepOrAdmin ? "All Questions" : "Answered Questions"%></h2>
        
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
