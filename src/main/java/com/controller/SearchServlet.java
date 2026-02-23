package com.controller;

import com.mirza.util.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.*;
import java.sql.*;

@WebServlet("/searchProducts")
public class SearchServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        String query = request.getParameter("q");
        PrintWriter out = response.getWriter();

        try (Connection conn = DBConnection.getConnection()) {
            // Searches across Name, Brand, and Description
            String sql = "SELECT * FROM PRODUCTS WHERE LOWER(NAME) LIKE ? OR LOWER(BRAND) LIKE ? OR LOWER(DESCRIPTION) LIKE ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            String searchPattern = "%" + query.toLowerCase() + "%";
            ps.setString(1, searchPattern);
            ps.setString(2, searchPattern);
            ps.setString(3, searchPattern);

            ResultSet rs = ps.executeQuery();
            StringBuilder json = new StringBuilder("[");
            while (rs.next()) {
                json.append(String.format(
                    "{\"id\":%d, \"name\":\"%s\", \"price\":%.2f, \"img\":\"%s\"},",
                    rs.getInt("PRODUCT_ID"), rs.getString("NAME"), 
                    rs.getDouble("PRICE"), rs.getString("IMAGE")
                ));
            }
            if (json.length() > 1) json.setLength(json.length() - 1);
            json.append("]");
            out.print(json.toString());
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(500);
        }
    }
}