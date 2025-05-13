package com.taskmanagement.dao;

import com.taskmanagement.model.Task;

import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class TaskDAO {
    private static final String URL = "jdbc:mysql://localhost:3306/taskmanagementdb";
    private static final String USER = "root";
    private static final String PASS = "103030496";

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver"); // Load MySQL JDBC Driver
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
    }

    // Fetch all tasks from the database
    public static List<Task> getAllTasks() {
        List<Task> tasks = new ArrayList<>();

        try (Connection conn = DriverManager.getConnection(URL, USER, PASS);
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery("SELECT * FROM tasks ORDER BY due_date ASC")) {

            while (rs.next()) {
                Task task = new Task();
                task.setId(rs.getInt("id"));
                task.setTitle(rs.getString("title"));
                task.setDescription(rs.getString("description"));
                task.setDueDate(rs.getDate("due_date").toLocalDate());
                task.setStatus(rs.getString("status"));
                tasks.add(task);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return tasks;
    }

    // Fetch a single task by ID
    public Task getTask(int id) {
        Task task = null;

        try (Connection conn = DriverManager.getConnection(URL, USER, PASS);
             PreparedStatement stmt = conn.prepareStatement("SELECT * FROM tasks WHERE id = ?")) {

            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                task = new Task();
                task.setId(rs.getInt("id"));
                task.setTitle(rs.getString("title"));
                task.setDescription(rs.getString("description"));
                task.setDueDate(rs.getDate("due_date").toLocalDate());
                task.setStatus(rs.getString("status"));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return task;
    }

    // Add a new task to the database
    public void addTask(String title, String description, LocalDate dueDate, String status) {
        System.out.println("Inserting task: " + title + ", " + description + ", " + dueDate + ", " + status);
        try (Connection conn = DriverManager.getConnection(URL, USER, PASS);
             PreparedStatement stmt = conn.prepareStatement(
                     "INSERT INTO tasks (title, description, due_date, status) VALUES (?, ?, ?, ?)")) {

            stmt.setString(1, title);
            stmt.setString(2, description);
            stmt.setDate(3, Date.valueOf(dueDate));
            stmt.setString(4, status);

            int rows = stmt.executeUpdate();
            System.out.println("Inserted rows: " + rows);

        } catch (SQLException e) {
            System.out.println("Insert FAILED:");
            e.printStackTrace();
        }
    }


    // Update an existing task by ID
    public void updateTask(int id, String title, String description, LocalDate dueDate, String status) {
        try (Connection conn = DriverManager.getConnection(URL, USER, PASS);
             PreparedStatement stmt = conn.prepareStatement(
                     "UPDATE tasks SET title = ?, description = ?, due_date = ?, status = ? WHERE id = ?")) {

            stmt.setString(1, title);
            stmt.setString(2, description);
            stmt.setDate(3, Date.valueOf(dueDate));
            stmt.setString(4, status);
            stmt.setInt(5, id);

            stmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Delete a task by ID
    public void deleteTask(int id) {
        try (Connection conn = DriverManager.getConnection(URL, USER, PASS);
             PreparedStatement stmt = conn.prepareStatement("DELETE FROM tasks WHERE id = ?")) {

            stmt.setInt(1, id);
            stmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
