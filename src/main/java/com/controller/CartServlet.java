package com.controller;

import com.model.User;
import com.mirza.util.DBConnection;
import javax.servlet.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/cartAction")
public class CartServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            response.setStatus(401); // Unauthorized
            return;
        }

        String action = request.getParameter("action");
        String productId = request.getParameter("productId");

        if ("add".equals(action)) {
            try (Connection conn = DBConnection.getConnection()) {
                // 1. Check if this product is already in this user's cart
                String checkSql = "SELECT QUANTITY FROM CART WHERE USER_ID = ? AND PRODUCT_ID = ?";
                PreparedStatement checkPs = conn.prepareStatement(checkSql);
                checkPs.setInt(1, user.getUserId());
                checkPs.setInt(2, Integer.parseInt(productId));
                ResultSet rs = checkPs.executeQuery();

                if (rs.next()) {
                    // 2. Already exists? UPDATE the quantity
                    String updateSql = "UPDATE CART SET QUANTITY = QUANTITY + 1 WHERE USER_ID = ? AND PRODUCT_ID = ?";
                    PreparedStatement upPs = conn.prepareStatement(updateSql);
                    upPs.setInt(1, user.getUserId());
                    upPs.setInt(2, Integer.parseInt(productId));
                    upPs.executeUpdate();
                    System.out.println("Cart Updated: Incremented quantity.");
                } else {
                    String insertSql = "INSERT INTO CART (USER_ID, PRODUCT_ID, QUANTITY) VALUES (?, ?, 1)";
                    PreparedStatement inPs = conn.prepareStatement(insertSql);
                    inPs.setInt(1, user.getUserId());
                    inPs.setInt(2, Integer.parseInt(productId));
                    inPs.executeUpdate();
                    System.out.println("Cart Updated: Inserted new item.");
                }
                response.setStatus(200);
            } catch (Exception e) {
                e.printStackTrace();
                response.setStatus(500);
            }
        
        }
    }
}