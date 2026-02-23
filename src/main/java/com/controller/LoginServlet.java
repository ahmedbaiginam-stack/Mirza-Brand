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

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String pass = request.getParameter("password");

        try (Connection conn = DBConnection.getConnection()) {

        	// 1. Change your SQL string to include the missing columns
        	String sql = "SELECT USER_ID, NAME, EMAIL, ROLE, PHONE, ADDRESS FROM USERS_MIRZA WHERE EMAIL=? AND PASSWORD=?";
        	PreparedStatement ps = conn.prepareStatement(sql);

        	ps.setString(1, email);
        	ps.setString(2, pass);

        	ResultSet rs = ps.executeQuery();

        	if (rs.next()) {
        	    User user = new User();
        	    user.setUserId(rs.getInt("USER_ID"));
        	    user.setName(rs.getString("NAME"));
        	    user.setEmail(rs.getString("EMAIL"));
        	    user.setRole(rs.getString("ROLE"));
        	    
        	    
        	    // Now these will work because the columns are in the SELECT statement
        	    user.setPhone(rs.getString("PHONE"));      
        	    user.setAddress(rs.getString("ADDRESS"));  
        	    
        	    // ... rest of your session logic ...
        	
                HttpSession session = request.getSession();
                session.setAttribute("user", user);
                session.setMaxInactiveInterval(60 * 60); // 1 hour

                /* ROLE BASED REDIRECT */
                if ("ADMIN".equalsIgnoreCase(user.getRole()))
                	response.sendRedirect(request.getContextPath() + "/index.jsp");

                else if ("WORKER".equalsIgnoreCase(user.getRole()))
                    response.sendRedirect("worker/home.jsp");

                else
                    response.sendRedirect("index.jsp");

            } else {
                response.sendRedirect("login.jsp?error=invalid");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("login.jsp?error=server");
        }
    }
  }
