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
            //Forwards to login.jsp for GET requests
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }


    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Java logic activates once the user clicks the login button
        try{

            HttpSession session = request.getSession(); //create a session object
            
            //Check if the user is already logged in
            if (session.getAttribute("username") != null) {
                response.sendRedirect ("welcome.jsp"); //Redirect to welcome page if already logged in
                return;
            }

            String errorMessage = null;

                String username = request.getParameter("username");
                String password = request.getParameter("password");

                // Check if the username and password exist in the database
                if (username != null && password != null){

                    //Get the database connection
                    ApplicationDB db = new ApplicationDB();	
                    Connection con = db.getConnection();

                    String query = "Select * from user WHERE username = ? AND password = ?";
                    PreparedStatement ps = con.prepareStatement(query);

                    ps.setString(1, username);
                    ps.setString(2, password);
                    ResultSet rs = ps.executeQuery();

                    if (rs.next()){
                        session.setAttribute ("username", username);
                        //session.setAttribute ("password", password);
                        session.setAttribute ("first_name", rs.getString ("first_name"));
                        session.setAttribute ("last_name", rs.getString ("last_name"));
                        
                        rs.close();
                        ps.close();
                        db.closeConnection(con);
                        
                        response.sendRedirect("welcome.jsp");
                        return;

                    }
                    else{
                        rs.close();
                        ps.close();
                        db.closeConnection(con);
                        errorMessage = "Invalid username or password";
                        request.setAttribute("errorMessage", errorMessage);
                        request.getRequestDispatcher("login.jsp").forward(request, response);
                        return;
                    }
                }
        }   catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("errorMessage", "Connection failed: " + e.getMessage());
                request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}
