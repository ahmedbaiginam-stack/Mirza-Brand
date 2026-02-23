package com.controller;

import com.mirza.util.DBConnection;
//REMOVED jakarta imports
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import com.model.User;

@WebServlet("/completeOrder")
public class CompleteOrderServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null) { 
            response.sendRedirect("login.jsp"); 
            return; 
        }

        try (Connection conn = DBConnection.getConnection()) {
            // Start Transactional Integrity
            conn.setAutoCommit(false); 

            // 1. Get current cart items
            String getCartSql = "SELECT p.NAME, p.PRICE, c.QUANTITY FROM CART c " +
                                "JOIN PRODUCTS p ON c.PRODUCT_ID = p.PRODUCT_ID WHERE c.USER_ID = ?";
            PreparedStatement psGet = conn.prepareStatement(getCartSql);
            psGet.setInt(1, user.getUserId());
            ResultSet rs = psGet.executeQuery();

            // 2. Archive items into Order History (Default status: 'Processing')
            String insertOrder = "INSERT INTO ORDERS_MIRZA (ORDER_ID, USER_ID, PRODUCT_NAME, PRICE, QUANTITY, STATUS) " + 
                                 "VALUES (ORDER_SEQ.NEXTVAL, ?, ?, ?, ?, 'Processing')";
            PreparedStatement psOrder = conn.prepareStatement(insertOrder);

            while (rs.next()) {
                psOrder.setInt(1, user.getUserId());
                psOrder.setString(2, rs.getString("NAME"));
                psOrder.setDouble(3, rs.getDouble("PRICE"));
                psOrder.setInt(4, rs.getInt("QUANTITY"));
                psOrder.executeUpdate();
            }

            // 3. Increment the User's Order Count in DB
            String updateCount = "UPDATE USERS_MIRZA SET ORDER_COUNT = ORDER_COUNT + 1 WHERE USER_ID = ?";
            PreparedStatement psCount = conn.prepareStatement(updateCount);
            psCount.setInt(1, user.getUserId());
            psCount.executeUpdate();

            // 4. Clear the Cart
            String clearCart = "DELETE FROM CART WHERE USER_ID = ?";
            PreparedStatement psClear = conn.prepareStatement(clearCart);
            psClear.setInt(1, user.getUserId());
            psClear.executeUpdate();

            // 5. Alert the Atelier Admin
            String notifSql = "INSERT INTO ADMIN_NOTIFICATIONS (NOTIF_ID, MESSAGE) VALUES (NOTIF_SEQ.NEXTVAL, ?)";
            PreparedStatement psNotif = conn.prepareStatement(notifSql);
            psNotif.setString(1, "New Acquisition: " + user.getName() + " (#MZ-00" + user.getUserId() + ") has placed an order.");
            psNotif.executeUpdate();

            // COMMIT EVERYTHING TOGETHER
            conn.commit(); 
            
            // Sync the session object so the Dashboard UI updates immediately
            user.setOrderCount(user.getOrderCount() + 1);
            session.setAttribute("user", user);

            response.sendRedirect("account.jsp?status=success");

        } catch (Exception e) {
            e.printStackTrace();
            // Optional: conn.rollback() here if you want to be extra safe
            response.sendRedirect("checkout.jsp?error=system");
        }
    }
}