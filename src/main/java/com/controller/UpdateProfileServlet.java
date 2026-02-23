package com.controller;

import com.model.User;
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

@WebServlet("/updateProfile") // Check: Does this match your form action="updateProfile"?
public class UpdateProfileServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        System.out.println("--- Update Trace Started ---");
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            System.out.println("Error: Session user is null");
            response.sendRedirect("login.jsp");
            return;
        }

        // 1. Get Parameters
        String newName = request.getParameter("name");
        String newEmail = request.getParameter("email");
        String newPhone = request.getParameter("phone");
        String newAddress = request.getParameter("address");
        int userId = user.getUserId();

        System.out.println("Processing Update for ID: " + userId);

        // 2. Database Connection
        try (Connection conn = DBConnection.getConnection()) {
            
            // IMPORTANT: Check your table name. Is it USERS or USERS_MIRZA? 
            // Check column names: NAME, EMAIL, PHONE, ADDRESS, USER_ID.
            String sql = "UPDATE USERS_MIRZA SET NAME=?, EMAIL=?, PHONE=?, ADDRESS=? WHERE USER_ID=?";
            
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, newName);
            ps.setString(2, newEmail);
            ps.setString(3, newPhone);
            ps.setString(4, newAddress);
            ps.setInt(5, userId);
            
            int rowsAffected = ps.executeUpdate();
            System.out.println("Rows affected in DB: " + rowsAffected);

            if (rowsAffected > 0) {
                // 3. Update the Session Object (This is why the JSP changes)
                user.setName(newName);
                user.setEmail(newEmail);
                user.setPhone(newPhone);
                user.setAddress(newAddress);
                session.setAttribute("user", user);
                
                System.out.println("Update Successful. Redirecting...");
                response.sendRedirect("account.jsp?status=success");
            } else {
                System.out.println("Update failed: No rows matched that ID.");
                response.sendRedirect("account.jsp?status=not_found");
            }

        } catch (Exception e) {
            System.out.println("CRITICAL ERROR:");
            e.printStackTrace(); // This prints the red error in Eclipse console
            response.sendRedirect("account.jsp?status=error");
        }
    }
}