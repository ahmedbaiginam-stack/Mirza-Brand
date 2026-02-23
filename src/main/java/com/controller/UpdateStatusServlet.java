package com.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import com.mirza.util.DBConnection;

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