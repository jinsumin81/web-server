<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%
    request.setCharacterEncoding("UTF-8");

    String userId = (String) session.getAttribute("user_id");
    if (userId == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String content = request.getParameter("content");

    if ("POST".equalsIgnoreCase(request.getMethod()) && content != null && !content.trim().isEmpty()) {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/ex2?useUnicode=true&characterEncoding=UTF-8", 
                "root", 
                "sumin81"
            );

            String sql = "INSERT INTO todos (user_id, content) VALUES (?, ?)";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, Integer.parseInt(userId));
            stmt.setString(2, content);
            stmt.executeUpdate();

            stmt.close();
            conn.close();

            response.sendRedirect("todos.jsp");
            return;
        } catch (Exception e) {
            out.println("<p>Error: " + e.getMessage() + "</p>");
        }
    }
%>
<h1>Add a New To-Do</h1>
<form method="POST" action="add_todo.jsp">
    <label for="content">Task:</label>
    <input type="text" id="content" name="content" placeholder="Enter your task" required />
    <button type="submit">Add</button>
</form>

<a href="todos.jsp">Back to To-Do List</a>
