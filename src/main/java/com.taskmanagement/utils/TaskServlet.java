package com.taskmanagement.utils;

import com.taskmanagement.dao.TaskDAO;
import com.taskmanagement.model.Task;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.time.LocalDate;
import java.util.Comparator;
import java.util.List;
import java.util.stream.Collectors;


public class TaskServlet extends HttpServlet {
    private TaskDAO taskDAO = new TaskDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<Task> tasks = taskDAO.getAllTasks();

// Keyword Search
        String keyword = req.getParameter("search");
        if (keyword != null && !keyword.trim().isEmpty()) {
            String searchLower = keyword.toLowerCase();
            tasks = tasks.stream()
                    .filter(t -> t.getTitle().toLowerCase().contains(searchLower) ||
                            t.getDescription().toLowerCase().contains(searchLower))
                    .collect(Collectors.toList());
        }

// Filtering by Status
        String statusFilter = req.getParameter("status");
        if (statusFilter != null && !statusFilter.isEmpty()) {
            tasks = tasks.stream()
                    .filter(t -> t.getStatus().equalsIgnoreCase(statusFilter))
                    .collect(Collectors.toList());
        }

// Sorting
        String sort = req.getParameter("sort");
        if ("dueDateAsc".equals(sort)) {
            tasks.sort(Comparator.comparing(Task::getDueDate));
        } else if ("dueDateDesc".equals(sort)) {
            tasks.sort(Comparator.comparing(Task::getDueDate).reversed());
        }


        req.setAttribute("tasks", tasks);
        req.getRequestDispatcher("tasklist.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String title = req.getParameter("title");
        String description = req.getParameter("description");
        String dueDate = req.getParameter("dueDate");
        String status = req.getParameter("status");

        taskDAO.addTask(title, description, LocalDate.parse(dueDate), status);
        resp.sendRedirect("tasks");
    }
}
