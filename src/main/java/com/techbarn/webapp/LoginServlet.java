package com.techbarn.webapp;

import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doGet (HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("login.jsp").forward(request, response);
    }


    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {

            HttpSession session = request.getSession();
            
            // Invalidate existing session to allow re-login
            if (session.getAttribute("username") != null) {
                session.invalidate();
                session = request.getSession(true);
            }

            String username = request.getParameter("username");
            String password = request.getParameter("password");

            if (username == null || password == null) {
                request.setAttribute("errorMessage", "Missing username or password.");
                request.getRequestDispatcher("login.jsp").forward(request, response);
                return;
            }

            Connection con = ApplicationDB.getConnection();


            // 1) ADMIN LOGIN
        
            String sqlAdmin = "SELECT * FROM Admin WHERE username=? AND password=?";
            PreparedStatement psAdmin = con.prepareStatement(sqlAdmin);
            psAdmin.setString(1, username);
            psAdmin.setString(2, password);
            ResultSet rsAdmin = psAdmin.executeQuery();

            if (rsAdmin.next()) {
                session.setAttribute("username", username);
                session.setAttribute("role", "admin");
                session.setAttribute("admin_id", rsAdmin.getInt("admin_id"));
                session.setAttribute("first_name", rsAdmin.getString("first_name"));
                session.setAttribute("last_name", rsAdmin.getString("last_name"));

                rsAdmin.close();
                psAdmin.close();
                ApplicationDB.closeConnection(con);

                response.sendRedirect("admin_home.jsp");
                return;
            }

            // 2) CUSTOMER REP LOGIN
            String sqlRep = "SELECT * FROM Cust_Rep WHERE username=? AND password=?";
            PreparedStatement psRep = con.prepareStatement(sqlRep);
            psRep.setString(1, username);
            psRep.setString(2, password);
            ResultSet rsRep = psRep.executeQuery();

            if (rsRep.next()) {
                session.setAttribute("username", username);
                session.setAttribute("role", "rep");
                session.setAttribute("rep_id", rsRep.getInt("rep_id"));
                session.setAttribute("first_name", rsRep.getString("first_name"));
                session.setAttribute("last_name", rsRep.getString("last_name"));

                rsRep.close();
                psRep.close();
                ApplicationDB.closeConnection(con);

                response.sendRedirect("custrep_home.jsp");
                return;
            }

            // 3) NORMAL USER LOGIN
            String sqlUser = "SELECT * FROM `User` WHERE username=? AND password=?";
            PreparedStatement psUser = con.prepareStatement(sqlUser);
            psUser.setString(1, username);
            psUser.setString(2, password);
            ResultSet rsUser = psUser.executeQuery();

            if (rsUser.next()) {
                session.setAttribute("username", username);
                session.setAttribute("role", "user");
                session.setAttribute("user_id", rsUser.getInt("user_id"));
                session.setAttribute("first_name", rsUser.getString("first_name"));
                session.setAttribute("last_name", rsUser.getString("last_name"));

                rsUser.close();
                psUser.close();
                ApplicationDB.closeConnection(con);

                response.sendRedirect("welcome.jsp");
                return;
            }

            
            // LOGIN FAILED
            
            rsUser.close();
            psUser.close();
            ApplicationDB.closeConnection(con);

            request.setAttribute("errorMessage", "Invalid username or password");
            request.getRequestDispatcher("login.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Connection failed: " + e.getMessage());
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}
