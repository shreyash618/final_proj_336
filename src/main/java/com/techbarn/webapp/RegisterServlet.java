package com.techbarn.webapp;

import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import java.time.LocalDate;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    @Override
    protected void doGet (HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
        // Forward to register.jsp for GET requests
        request.getRequestDispatcher("register.jsp").forward(request, response);
    }

    @Override
    protected void doPost (HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
            try{
                // Try to create the new user in the database
                // we need the name email username password(phone dob opt address not asked for now)
                String firstName = request.getParameter("first_name");
                String lastName = request.getParameter("last_name");
                String email = request.getParameter("email");
                String username = request.getParameter("username");
                String password = request.getParameter("password");
                String phone = request.getParameter("phone");
                String dob = request.getParameter("dob");

                String errorMessage = null;

                if (firstName != null && lastName != null && email != null && username != null
                    && password != null)
                    {   
                        //Get the database connection
                        ApplicationDB db = new ApplicationDB();	
                        Connection con = db.getConnection();

                        String query = "Select * from user WHERE email = ?";
                        PreparedStatement ps = con.prepareStatement(query);

                        ps.setString(1, email);
                        ResultSet rs = ps.executeQuery();

                        // What should we check to see if the user is already registered?
                        // maybe if the email already exists in the database, we should not allow the user to register
                        if (rs.next()){
                            rs.close();
                            ps.close();
                            db.closeConnection(con);
                            errorMessage = "This email is already registered to an account. Please login with that account.";
                            request.setAttribute("errorMessage", errorMessage);
                            request.getRequestDispatcher("register.jsp").forward(request, response);
                            return;
                        }
                        else{
                            //continue with account registration
                            // we should also check if the username already exists in the database

                            query = "Select * from user WHERE username = ?";
                            ps = con.prepareStatement(query);
    
                            ps.setString(1, username);
                            rs = ps.executeQuery();

                            if (rs.next()){
                                rs.close();
                                ps.close();
                                db.closeConnection(con);
                                errorMessage = "This username is already taken. Please try a different username.";
                                request.setAttribute("errorMessage", errorMessage);
                                request.getRequestDispatcher("register.jsp").forward(request, response);
                                return;
                            }
                            else{
                                //create the user
                                LocalDate currentDate = LocalDate.now();
                                //or should I do Date currentDate = Date.now(); to make it irrelevant of timezone

                                query = "INSERT INTO `User` (first_name, last_name, created_at, email, phone_no, username, password, dob, address_id, isBuyer, isSeller, rating) VALUE
                                (?,?,?,?,?,?,?,?,Null,1,0,Null);"
                                
                                ps = con.prepareStatement(query);
        
                                ps.setString(1, firstName);
                                ps.setString(2, lastName);
                                ps.setString(3, currentDate);
                                ps.setString(4, email);
                                ps.setString(5, phone);
                                ps.setString(6, username);
                                ps.setString(7, password);
                                ps.setString(8, dob);                                
                                ps.executeQuery();

                                rs.close();
                                ps.close();
                                db.closeConnection(con);
                                
                                response.sendRedirect("login.jsp");
                                return;
                            }

                        }
                    }

                //in register.jsp    
                // we should also check if the password is strong enough (at least 8 characters, one uppercase, one lowercase, one number, one special character)
                // we should also check if the phone number is valid (10 digits, only numbers)
                // we should also check if the date of birth is valid (must be at least 18 years old)

            }
            catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("errorMessage", "Connection failed: " + e.getMessage());
                request.getRequestDispatcher("register.jsp").forward(request, response);
        }
    }
}
