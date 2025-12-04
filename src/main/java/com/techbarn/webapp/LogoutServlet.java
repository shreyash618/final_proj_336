package com.techbarn.webapp;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet ("/logout")
public class LogoutServlet extends HttpServlet {
    @Override
    protected void doGet (HttpServletRequest request, HttpServletResponse response) 
        throws ServletException, IOException {
            //Check if the session is active; if it is, invalidate it
            HttpSession session = request.getSession(false); // retrieve session object
            if (session != null) {
                session.invalidate(); 
            }
            request.getRequestDispatcher("logout.jsp").forward(request, response);
        }
}