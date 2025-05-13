package com.taskmanagement;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;

public class SampleServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.getWriter().println("This is a sample servlet response.");
    }
}
