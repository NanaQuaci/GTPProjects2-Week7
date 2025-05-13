package com.taskmanagement.utils;

import com.taskmanagement.dao.TaskDAO;
import com.taskmanagement.model.Task;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.time.LocalDate;

@WebServlet("/edittask")
public class EditTaskServlet extends HttpServlet {
    private TaskDAO taskDAO = new TaskDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int id = Integer.parseInt(req.getParameter("id"));
        Task task = taskDAO.getTask(id);
        req.setAttribute("task", task);
        req.getRequestDispatcher("edittask.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int id = Integer.parseInt(req.getParameter("id"));
        String title = req.getParameter("title");
        String description = req.getParameter("description");
        LocalDate dueDate = LocalDate.parse(req.getParameter("dueDate"));
        String status = req.getParameter("status");

        taskDAO.updateTask(id, title, description, dueDate, status);
        resp.sendRedirect("tasks");
    }
}
