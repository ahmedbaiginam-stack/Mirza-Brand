package com.controller;

import com.model.User;
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

@WebServlet("/getCartDetails")
public class GetCartDetailsServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) { response.setStatus(401); return; }

        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        try (Connection conn = DBConnection.getConnection()) {
            // 1. Use an Inner Join to ensure we only get valid cart items with products
            String sql = "SELECT p.NAME, p.PRICE, p.IMAGE, c.QUANTITY " +
                         "FROM CART c INNER JOIN PRODUCTS p ON c.PRODUCT_ID = p.PRODUCT_ID " +
                         "WHERE c.USER_ID = ?";
            
            PreparedStatement ps = conn.prepareStatement(sql);
            // Use the appropriate getter for your ID type (int vs string)
            ps.setInt(1, user.getUserId()); 
            ResultSet rs = ps.executeQuery();

            double total = 0;
            int count = 0;
            StringBuilder itemsJson = new StringBuilder();

            while (rs.next()) {
                String name = rs.getString("NAME");
                double price = rs.getDouble("PRICE");
                int qty = rs.getInt("QUANTITY");
                // Fallback for missing images to prevent broken JSON
                String img = rs.getString("IMAGE") != null ? rs.getString("IMAGE") : "default.jpg";
                
                total += (price * qty);
                count += qty;
                
                itemsJson.append("{")
                        .append("\"name\":\"").append(name).append("\",")
                        .append("\"price\":").append(price).append(",")
                        .append("\"img\":\"").append(img).append("\",")
                        .append("\"qty\":").append(qty)
                        .append("},");
            }

            // Remove trailing comma safely
            String finalItems = "";
            if (itemsJson.length() > 0) {
                finalItems = itemsJson.substring(0, itemsJson.length() - 1);
            }

            // Send complete JSON
            out.print("{\"count\":" + count + ", \"total\":" + total + ", \"items\":[" + finalItems + "]}");

        } catch (SQLException e) {
            e.printStackTrace(); // This will show the EXACT SQL error in your IDE console
            response.setStatus(500);
        }
    }
}