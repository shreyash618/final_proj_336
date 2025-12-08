package com.techbarn.webapp;

import com.techbarn.webapp.dao.CustRepDAO;
import com.techbarn.webapp.dao.ReportDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/admin")
public class AdminServlet extends HttpServlet {

    // show admin home / reports
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if ("reports".equals(action)) {
            req.setAttribute("totalEarnings", ReportDAO.totalEarnings());
            req.setAttribute("byItem", ReportDAO.earningsByItem());
            req.setAttribute("byItemType", ReportDAO.earningsByItemType());
            req.setAttribute("bySeller", ReportDAO.earningsBySeller());
            req.setAttribute("bestItems", ReportDAO.bestSellingItems());
            req.setAttribute("bestBuyers", ReportDAO.bestBuyers());
            req.getRequestDispatcher("/admin_reports.jsp").forward(req, resp);
            return;
        }
        req.getRequestDispatcher("/admin_home.jsp").forward(req, resp);
    }

    // create cust rep
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession s = req.getSession(false);
        String role = (s!=null) ? (String) s.getAttribute("role") : null;
        if (!"admin".equals(role)) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Only admin can create customer reps.");
            return;
        }
        String firstName = req.getParameter("first_name");
        String lastName = req.getParameter("last_name");
        String username = req.getParameter("username");
        String password = req.getParameter("password");
        String email = req.getParameter("email");
        Integer adminId = (Integer) s.getAttribute("admin_id");
        if (adminId == null) adminId = -1;

        boolean ok = CustRepDAO.createRep(firstName, lastName, username, password, email, adminId);
        if (!ok) {
            req.setAttribute("errorMessage", "Could not create rep (username may already exist).");
        } else {
            req.setAttribute("successMessage", "Customer Rep created.");
        }
        req.getRequestDispatcher("/admin_home.jsp").forward(req, resp);
    }
}
