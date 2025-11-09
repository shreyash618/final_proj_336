package com.buyme.webapp;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet ("/welcome")
public class WelcomeServlet extends HttpServlet {
    @Override
    protected void doGet (HttpServletRequest request, HttpServletResponse response) 
        throws ServletException, IOException {

            HttpSession session = request.getSession(false);                            // use existing session

            // check if user is logged in
            if (session != null && session.getAttribute("username") != null) {          // if the user is logged in, show welcome page
                request.getRequestDispatcher("welcome.jsp").forward(request, response);
            } else {                                                                        // if the user not logged in, send them back to login page
                response.sendRedirect("login.jsp");
            }
        }
}
