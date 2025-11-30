package com.techbarn.webapp;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet ("/item")
public class ItemServlet extends HttpServlet{
    @Override
    protected void doGet (HttpServletRequest request, HttpServletResponse response)
        throws IOException, ServletException{
            request.getRequestDispatcher("item.jsp").forward(request, response);
        };
    
}
