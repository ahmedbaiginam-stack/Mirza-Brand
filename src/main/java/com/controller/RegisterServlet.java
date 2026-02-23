package com.controller;

import com.mirza.util.DBConnection;
import com.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String role = request.getParameter("role");
        if (role == null || role.isEmpty()) {
            role = "User";
        }

        try (Connection conn = DBConnection.getConnection()) {

          
            PreparedStatement check = conn.prepareStatement("SELECT EMAIL FROM USERS_MIRZA WHERE EMAIL=?");
            check.setString(1, email);
            ResultSet rsCheck = check.executeQuery();

            if (rsCheck.next()) {
                response.sendRedirect("signup.jsp?error=exists");
                return;
            }

            
            String sql = "INSERT INTO USERS_MIRZA (NAME, EMAIL, PASSWORD, PHONE, ADDRESS, ROLE) VALUES (?, ?, ?, ?, ?, User)";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, name);
            ps.setString(2, email);
            ps.setString(3, password);
            ps.setString(4, phone);
            ps.setString(5, address);
            ps.executeUpdate();

           
            PreparedStatement getUser = conn.prepareStatement("SELECT * FROM USERS_MIRZA WHERE EMAIL=?");
            getUser.setString(1, email);
            ResultSet rsUser = getUser.executeQuery();

            if (rsUser.next()) {
                User user = new User();
                user.setUserId(rsUser.getInt("USER_ID")); 
                user.setName(rsUser.getString("NAME"));
                user.setEmail(rsUser.getString("EMAIL"));
                user.setRole(rsUser.getString("ROLE"));
                user.setPhone(rsUser.getString("PHONE"));      
                user.setAddress(rsUser.getString("ADDRESS"));  
                
                HttpSession session = request.getSession();
                session.setAttribute("user", user);
                session.setMaxInactiveInterval(60 * 60); 

                // 4. ROLE-BASED REDIRECT
                if ("ADMIN".equalsIgnoreCase(user.getRole())) {
                    response.sendRedirect("index.jsp"); 
                }else {
                    response.sendRedirect("index.jsp");
                }
            } else {
                response.sendRedirect("login.jsp?error=invalid");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("signup.jsp?error=server");
        }
    }
}