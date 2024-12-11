<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%
    String todoId = request.getParameter("id");

    if (todoId != null) {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/ex2?useUnicode=true&characterEncoding=UTF-8",
                "root",
                "sumin81"
            );

            String sql = "UPDATE todos SET is_done = TRUE WHERE id = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, Integer.parseInt(todoId));
            stmt.executeUpdate();

            stmt.close();
            conn.close();

            response.sendRedirect("todos.jsp");
        } catch (Exception e) {
            out.println("Error: " + e.getMessage());
        }
    } else {
        response.sendRedirect("todos.jsp");
    }
%>
