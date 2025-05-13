<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.taskmanagement.model.Task" %>
<%@ page import="java.util.List" %>
<%@ page import="java.time.LocalDate" %>

<%
    List<Task> tasks = (List<Task>) request.getAttribute("tasks");
    java.time.LocalDate today = java.time.LocalDate.now();
    request.setAttribute("todayStr", today.toString()); // Used in JSTL date comparison
%>

<html>
<head>
    <title>Task Manager</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Inter', sans-serif;
            background-color: #f5f6fa;
            margin: 0;
            padding: 20px;
        }

        h1 {
            text-align: center;
            color: #333;
        }

        .container {
            max-width: 1000px;
            margin: auto;
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
        }

        form {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            margin-bottom: 20px;
            align-items: center;
        }

        input, select {
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 6px;
            font-size: 14px;
            flex: 1;
            min-width: 150px;
        }

        button {
            background-color: #007bff;
            color: white;
            border: none;
            padding: 10px 15px;
            border-radius: 6px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        button:hover {
            background-color: #0056b3;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th, td {
            padding: 10px;
            border: 1px solid #ddd;
            text-align: left;
        }

        tr:nth-child(even):not(.overdue):not(.completed) {
            background-color: #f9f9f9;
        }

        tr.overdue {
            background-color: #ffe6e6 !important;
            color: #b30000;
            font-weight: bold;
        }

        tr.completed {
            background-color: #e6ffe6 !important;
            color: #006600;
            font-weight: bold;
        }

        .no-tasks {
            text-align: center;
            font-style: italic;
            color: #888;
        }

        label {
            font-weight: bold;
        }

        .back-link {
            display: inline-block;
            margin-bottom: 15px;
            color: #007bff;
            text-decoration: none;
            font-weight: bold;
        }

        .back-link:hover {
            text-decoration: underline;
        }

    </style>
</head>

<body>
<div class="container">
    <a href="landing.jsp" class="back-link">← Back to Home</a>
    <h1>Task List</h1>

    <!-- Add Task Form -->
    <form method="post" action="tasks">
        <input name="title" placeholder="Title" required />
        <input name="description" placeholder="Description" required />
        <input name="dueDate" type="date" required />
        <select name="status">
            <option>Pending</option>
            <option>Completed</option>
        </select>
        <button type="submit">Add Task</button>
    </form>

    <!-- Feedback -->
    <c:if test="${not empty param.search}">
        <p>Showing results for "<b>${param.search}</b>"</p>
    </c:if>

    <!-- Task Table -->
    <div id="taskTableContainer">
        <c:choose>
            <c:when test="${empty tasks}">
                <p class="no-tasks">No tasks to display.</p>
            </c:when>
            <c:otherwise>
                <table>
                    <tr>
                        <th>ID</th>
                        <th>Title</th>
                        <th>Description</th>
                        <th>Due Date</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                    <c:forEach var="task" items="${tasks}">
                        <c:set var="rowClass" value="" />
                        <c:if test="${task.status == 'Completed'}">
                            <c:set var="rowClass" value="completed" />
                        </c:if>
                        <c:if test="${task.dueDate lt todayStr and task.status != 'Completed'}">
                            <c:set var="rowClass" value="overdue" />
                        </c:if>

                        <tr class="${rowClass}">
                            <td>${task.id}</td>
                            <td>${task.title}</td>
                            <td>${task.description}</td>
                            <td>${task.dueDate}</td>
                            <td>${task.status}</td>
                            <td>
                                <a href="edittask?id=${task.id}">Edit</a> |
                                <a href="deletetask?id=${task.id}">Delete</a>
                            </td>
                        </tr>
                    </c:forEach>
                </table>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- Search / Filter / Sort -->
    <form action="tasks" method="get">
        <label>Search:</label>
        <input type="text" id="searchInput" name="search" placeholder="Search..." value="${param.search}" />

        <label>Status:</label>
        <select name="status">
            <option value="">All</option>
            <option value="Pending" <c:if test="${param.status == 'Pending'}">selected</c:if>>Pending</option>
            <option value="Completed" <c:if test="${param.status == 'Completed'}">selected</c:if>>Completed</option>
        </select>

        <label>Sort By:</label>
        <select name="sort">
            <option value="">None</option>
            <option value="dueDateAsc" <c:if test="${param.sort == 'dueDateAsc'}">selected</c:if>>Due Date ↑</option>
            <option value="dueDateDesc" <c:if test="${param.sort == 'dueDateDesc'}">selected</c:if>>Due Date ↓</option>
        </select>

        <button type="submit">Apply</button>
    </form>

    <!-- Debounced AJAX Search -->
    <script>
        function debounce(func, delay) {
            let timer;
            return function () {
                clearTimeout(timer);
                timer = setTimeout(func.bind(this), delay);
            };
        }

        const searchInput = document.getElementById("searchInput");

        searchInput.addEventListener("input", debounce(function () {
            const search = this.value;
            const xhr = new XMLHttpRequest();
            xhr.open("GET", "tasks?search=" + encodeURIComponent(search), true);

            xhr.onload = function () {
                if (xhr.status === 200) {
                    const parser = new DOMParser();
                    const doc = parser.parseFromString(xhr.responseText, "text/html");
                    const newTable = doc.querySelector("#taskTableContainer").innerHTML;
                    document.querySelector("#taskTableContainer").innerHTML = newTable;
                }
            };

            xhr.send();
        }, 300));
    </script>
</div>
</body>
</html>
