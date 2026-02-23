package com.controller;
import com.mirza.util.DBConnection;
//REMOVED jakarta imports
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;

/**
 * Servlet implementation class UpdateStatusServlet
 */
@WebServlet("/updateStatus")
public class UpdateStatusServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String orderId = request.getParameter("orderId");
        String newStatus = request.getParameter("newStatus");

        try (Connection conn = DBConnection.getConnection()) {
            String sql = "UPDATE ORDERS_MIRZA SET STATUS = ? WHERE ORDER_ID = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, newStatus);
            ps.setInt(2, Integer.parseInt(orderId));
            ps.executeUpdate();
            
            response.sendRedirect("admin.jsp?update=success");
        } catch (Exception e) {
            response.sendRedirect("admin.jsp?update=error");
        }
    }
}