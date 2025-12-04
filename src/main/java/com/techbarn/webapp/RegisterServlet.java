package com.techbarn.webapp;

import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.regex.Pattern;

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
                // Get form parameters - note: JSP uses firstName, lastName, tel (not first_name, last_name, phone)
                String firstName = request.getParameter("firstName");
                String lastName = request.getParameter("lastName");
                String email = request.getParameter("email");
                String username = request.getParameter("username");
                String password = request.getParameter("password");
                String phone = request.getParameter("tel");  // JSP uses "tel" as name
                String dob = request.getParameter("dob");

                String errorMessage = null;

                // Validate required fields
                if (firstName == null || firstName.trim().isEmpty() ||
                    lastName == null || lastName.trim().isEmpty() ||
                    email == null || email.trim().isEmpty() ||
                    username == null || username.trim().isEmpty() ||
                    password == null || password.trim().isEmpty()) {
                    errorMessage = "All required fields must be filled.";
                    request.setAttribute("errorMessage", errorMessage);
                    request.getRequestDispatcher("register.jsp").forward(request, response);
                    return;
                }

                // Validate password strength
                if (!isPasswordStrong(password)) {
                    errorMessage = "Password must be at least 8 characters long and contain at least one uppercase letter, one lowercase letter, one number, and one special character.";
                    request.setAttribute("errorMessage", errorMessage);
                    request.getRequestDispatcher("register.jsp").forward(request, response);
                    return;
                }

                // Validate phone number if provided
                if (phone != null && !phone.trim().isEmpty() && !isValidPhone(phone)) {
                    errorMessage = "Phone number must be exactly 10 digits.";
                    request.setAttribute("errorMessage", errorMessage);
                    request.getRequestDispatcher("register.jsp").forward(request, response);
                    return;
                }

                // Validate date of birth if provided
                if (dob != null && !dob.trim().isEmpty() && !isValidAge(dob)) {
                    errorMessage = "You must be at least 18 years old to register.";
                    request.setAttribute("errorMessage", errorMessage);
                    request.getRequestDispatcher("register.jsp").forward(request, response);
                    return;
                }

                //Get the database connection
                Connection con = ApplicationDB.getConnection();

                // Check if email already exists
                String query = "Select * from user WHERE email = ?";
                PreparedStatement ps = con.prepareStatement(query);
                ps.setString(1, email);
                ResultSet rs = ps.executeQuery();

                if (rs.next()){
                    rs.close();
                    ps.close();
                    ApplicationDB.closeConnection(con);
                    errorMessage = "This email is already registered to an account. Please login with that account.";
                    request.setAttribute("errorMessage", errorMessage);
                    request.getRequestDispatcher("register.jsp").forward(request, response);
                    return;
                }
                rs.close();
                ps.close();

                // Check if username already exists
                query = "Select * from user WHERE username = ?";
                ps = con.prepareStatement(query);
                ps.setString(1, username);
                rs = ps.executeQuery();

                if (rs.next()){
                    rs.close();
                    ps.close();
                    ApplicationDB.closeConnection(con);
                    errorMessage = "This username is already taken. Please try a different username.";
                    request.setAttribute("errorMessage", errorMessage);
                    request.getRequestDispatcher("register.jsp").forward(request, response);
                    return;
                }
                rs.close();
                ps.close();

                // Create the user
                LocalDate currentDate = LocalDate.now();
                java.sql.Date sqlDate = java.sql.Date.valueOf(currentDate);
                
                query = "INSERT INTO `User` (first_name, last_name, created_at, email, phone_no, username, password, dob, address_id, isBuyer, isSeller, rating) VALUES (?,?,?,?,?,?,?,?,NULL,1,0,NULL)";
                
                ps = con.prepareStatement(query);
                ps.setString(1, firstName.trim());
                ps.setString(2, lastName.trim());
                ps.setDate(3, sqlDate);
                ps.setString(4, email.trim());
                ps.setString(5, (phone != null && !phone.trim().isEmpty()) ? phone.trim() : null);
                ps.setString(6, username.trim());
                ps.setString(7, password); // TODO: Hash password before storing
                
                // Parse and set date of birth
                if (dob != null && !dob.trim().isEmpty()) {
                    try {
                        LocalDate dobDate = LocalDate.parse(dob);
                        ps.setDate(8, java.sql.Date.valueOf(dobDate));
                    } catch (DateTimeParseException e) {
                        ps.setDate(8, null);
                    }
                } else {
                    ps.setDate(8, null);
                }
                
                int rowsAffected = ps.executeUpdate(); // Use executeUpdate for INSERT

                if (rowsAffected > 0) {
                    ps.close();
                    ApplicationDB.closeConnection(con);
                    response.sendRedirect("login.jsp");
                    return;
                } else {
                    ps.close();
                    ApplicationDB.closeConnection(con);
                    errorMessage = "Registration failed. Please try again.";
                    request.setAttribute("errorMessage", errorMessage);
                    request.getRequestDispatcher("register.jsp").forward(request, response);
                    return;
                }

            }
            catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("errorMessage", "Registration failed: " + e.getMessage());
                request.getRequestDispatcher("register.jsp").forward(request, response);
        }
    }

    /**
     * Validates password strength: at least 8 characters, one uppercase, 
     * one lowercase, one number, one special character
     */
    private boolean isPasswordStrong(String password) {
        if (password == null || password.length() < 8) {
            return false;
        }
        boolean hasUpper = Pattern.compile("[A-Z]").matcher(password).find();
        boolean hasLower = Pattern.compile("[a-z]").matcher(password).find();
        boolean hasDigit = Pattern.compile("[0-9]").matcher(password).find();
        boolean hasSpecial = Pattern.compile("[^a-zA-Z0-9]").matcher(password).find();
        return hasUpper && hasLower && hasDigit && hasSpecial;
    }

    /**
     * Validates phone number: exactly 10 digits
     */
    private boolean isValidPhone(String phone) {
        if (phone == null) return false;
        String digitsOnly = phone.replaceAll("[^0-9]", "");
        return digitsOnly.length() == 10;
    }

    /**
     * Validates age: must be at least 18 years old
     */
    private boolean isValidAge(String dob) {
        if (dob == null || dob.trim().isEmpty()) {
            return true; // Optional field, so return true if not provided
        }
        try {
            LocalDate birthDate = LocalDate.parse(dob);
            LocalDate todayDate = LocalDate.now();
            LocalDate minAgeDate = todayDate.minusYears(18);
            return birthDate.isBefore(minAgeDate) || birthDate.isEqual(minAgeDate);
        } catch (DateTimeParseException e) {
            return false;
        }
    }
}