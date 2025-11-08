package com.buyme.webapp;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/main")
public class MainServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        out.println("<html>");
        out.println("<head><title>Welcome</title></head>");
        out.println("<body>");
        out.println("<h1>Welcome to the Web Application</h1>");
        out.println("<p>This is the main servlet handling GET requests.</p>");
        out.println("<a href='index.html'>Go to Index</a>");
        out.println("</body>");
        out.println("</html>");
    }
}