package com.techbarn.webapp;

import com.techbarn.webapp.dao.QuestionDAO;
import com.techbarn.webapp.model.Question;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/faq")
public class FaqServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession s = req.getSession(false);
        String role = (s != null) ? (String) s.getAttribute("role") : null;
        boolean isRepOrAdmin = "rep".equals(role) || "admin".equals(role);
        
        String q = req.getParameter("q");
        String statusFilter = req.getParameter("status"); // "all", "answered", "open"
        
        List<Question> list;
        if (q != null && !q.trim().isEmpty()) {
            list = QuestionDAO.searchByKeyword(q.trim());
            if (statusFilter != null) {
                list = filterByStatus(list, statusFilter);
            }
        } else {
            // Everyone sees all questions; filter by status when selected
            if ("answered".equals(statusFilter)) {
                list = QuestionDAO.getAnswered();
            } else if ("open".equals(statusFilter)) {
                list = QuestionDAO.getOpen();
            } else {
                list = QuestionDAO.getAllQuestions();
            }
        }
        req.setAttribute("questions", list);
        req.getRequestDispatcher("/faq.jsp").forward(req, resp);
    }
    
    private List<Question> filterByStatus(List<Question> questions, String status) {
        if ("answered".equals(status)) {
            List<Question> filtered = new java.util.ArrayList<>();
            for (Question q : questions) {
                if (q.getReply() != null && !q.getReply().isEmpty()) {
                    filtered.add(q);
                }
            }
            return filtered;
        } else if ("open".equals(status)) {
            return getOpenQuestions(questions);
        }
        return questions; // all
    }
    
    private List<Question> getOpenQuestions(List<Question> questions) {
        List<Question> open = new java.util.ArrayList<>();
        for (Question q : questions) {
            if (q.getReply() == null || q.getReply().isEmpty()) {
                open.add(q);
            }
        }
        return open;
    }

    // create a new question
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession s = req.getSession(false);
        Integer userId = (s != null && s.getAttribute("user_id") != null) ? (Integer) s.getAttribute("user_id") : null;
        if (userId == null) {
            req.setAttribute("errorMessage", "You must be logged in to ask a question.");
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
            return;
        }
        String title = req.getParameter("title");
        String contents = req.getParameter("contents");
        if (title == null || title.trim().isEmpty()) {
            req.setAttribute("errorMessage", "Title required");
            doGet(req, resp);
            return;
        }
        try {
            QuestionDAO.askQuestion(userId, title.trim(), contents != null ? contents.trim() : "");
            resp.sendRedirect(req.getContextPath() + "/faq");
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("errorMessage", "Failed to save question. Try a shorter title. If it persists, the database may need the column fix in sql/alter_question_columns.sql.");
            try {
                doGet(req, resp);
            } catch (Exception ex) {
                throw new ServletException(ex);
            }
        }
    }
}
