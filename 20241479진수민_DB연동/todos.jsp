<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%
    String userId = (String) session.getAttribute("user_id");
    if (userId == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String searchDate = request.getParameter("searchDate");

    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/ex2?useUnicode=true&characterEncoding=UTF-8",
            "root",
            "sumin81"
        );

        String sql = "SELECT * FROM todos WHERE user_id = ?";
        if (searchDate != null && !searchDate.isEmpty()) {
            sql += " AND DATE(created_at) = ?";
        }
        sql += " ORDER BY created_at DESC";

        stmt = conn.prepareStatement(sql);
        stmt.setInt(1, Integer.parseInt(userId));
        if (searchDate != null && !searchDate.isEmpty()) {
            stmt.setString(2, searchDate);
        }
        rs = stmt.executeQuery();
%>
<h1>Your To-Do List</h1>

<!-- 날짜 검색 폼 -->
<form method="GET" action="todos.jsp">
    <label for="searchDate">Search by Date:</label>
    <input type="date" name="searchDate" id="searchDate" value="<%= searchDate != null ? searchDate : "" %>" />
    <button type="submit">Search</button>
</form>

<a href="add_todo.jsp">Add New To-Do</a>

<table border="1">
    <tr>
        <th>Content</th>
        <th>Status</th>
        <th>Created At</th>
        <th>Actions</th>
    </tr>
    <% while (rs.next()) { %>
    <tr>
        <td><%= rs.getString("content") %></td>
        <td><%= rs.getBoolean("is_done") ? "Done" : "Pending" %></td>
        <td><%= rs.getTimestamp("created_at") %></td>
        <td>
            <a href="update_todo.jsp?id=<%= rs.getInt("id") %>">Mark as Done</a> |
            <a href="delete_todo.jsp?id=<%= rs.getInt("id") %>">Delete</a>
        </td>
    </tr>
    <% } %>
</table>
<%
    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
    } finally {
        if (rs != null) try { rs.close(); } catch (Exception ignore) {}
        if (stmt != null) try { stmt.close(); } catch (Exception ignore) {}
        if (conn != null) try { conn.close(); } catch (Exception ignore) {}
    }
%>
