<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="com.taskmanagement.model.Task" %>
<%
    Task task = (Task) request.getAttribute("task");
%>
<html>
<head><title>Edit Task</title></head>
<body>
<h1>Edit Task</h1>

<form method="post" action="edittask">
    <input type="hidden" name="id" value="<%= task.getId() %>" />

    <label>Title:</label><br>
    <input name="title" value="<%= task.getTitle() %>" required /><br><br>

    <label>Description:</label><br>
    <input name="description" value="<%= task.getDescription() %>" required /><br><br>

    <label>Due Date:</label><br>
    <input name="dueDate" type="date" value="<%= task.getDueDate() %>" required /><br><br>

    <label>Status:</label><br>
    <select name="status">
        <option value="Pending" <%= "Pending".equals(task.getStatus()) ? "selected" : "" %>>Pending</option>
        <option value="Completed" <%= "Completed".equals(task.getStatus()) ? "selected" : "" %>>Completed</option>
    </select><br><br>

    <button type="submit">Update</button>
</form>

<br>
<a href="tasks">⬅ Back to Task List</a>
</body>
</html>
