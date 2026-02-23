package com.controller;

import com.mirza.util.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;

@WebServlet("/adminAction")
public class AdminServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("authType");

        try (Connection conn = DBConnection.getConnection()) {

            /* ================= DELETE PRODUCT ================= */
            if ("deleteProduct".equals(action)) {

                int id = Integer.parseInt(request.getParameter("productId"));

                PreparedStatement ps = conn.prepareStatement(
                        "DELETE FROM PRODUCTS WHERE PRODUCT_ID = ?");
                ps.setInt(1, id);
                ps.executeUpdate();

                response.getWriter().println("Product Deleted Successfully");
            }

            /* ================= ADD PRODUCT ================= */
            else if ("addProduct".equals(action)) {

                String name = request.getParameter("name");
                String category = request.getParameter("category");
                String brand = request.getParameter("brand");
                double price = Double.parseDouble(request.getParameter("price"));
                String img = request.getParameter("image");
                int stock = Integer.parseInt(request.getParameter("stock"));
                String description = request.getParameter("description");

                String sql = "INSERT INTO PRODUCTS (NAME, CATEGORY, BRAND, PRICE, IMAGE, STOCK, DESCRIPTION) VALUES (?, ?, ?, ?, ?, ?, ?)";

                PreparedStatement ps = conn.prepareStatement(sql);
                ps.setString(1, name);
                ps.setString(2, category);
                ps.setString(3, brand);
                ps.setDouble(4, price);
                ps.setString(5, img);
                ps.setInt(6, stock);
                ps.setString(7, description);

                ps.executeUpdate();

                response.getWriter().println("Product Added Successfully");
            }

            /* ================= UPDATE PRODUCT ================= */
            else if ("updateProduct".equals(action)) {
                try {
                    int id = Integer.parseInt(request.getParameter("productId"));
                    String name = request.getParameter("name");
                    double price = Double.parseDouble(request.getParameter("price"));
                    int stock = Integer.parseInt(request.getParameter("stock"));

                    // FIXED: 4 placeholders for 4 parameters
                    String sql = "UPDATE PRODUCTS SET NAME=?, PRICE=?, STOCK=? WHERE PRODUCT_ID=?";

                    PreparedStatement ps = conn.prepareStatement(sql);
                    
                    // Parameter Indexing:
                    ps.setString(1, name);     // 1st ?
                    ps.setDouble(2, price);    // 2nd ?
                    ps.setInt(3, stock);       // 3rd ?
                    ps.setInt(4, id);          // 4th ? (The WHERE clause)

                    int rows = ps.executeUpdate();
                    
                    if (rows > 0) {
                        response.getWriter().println("Atelier Records Updated Successfully for ID: " + id);
                    } else {
                        response.getWriter().println("Update Failed: Product ID " + id + " not found.");
                    }
                } catch (NumberFormatException e) {
                    response.getWriter().println("Error: ID, Price, and Stock must be valid numbers.");
                }
            }

            /* ================= SEARCH PRODUCT ================= */
            else if ("searchProduct".equals(action)) {
                String keyword = request.getParameter("keyword");
                
                // 1. Use LIKE instead of = for partial name matching
                // 2. Wrap the search in UPPER() or LOWER() for case-insensitivity
                String sql = "SELECT * FROM PRODUCTS WHERE UPPER(NAME) LIKE UPPER(?) OR PRODUCT_ID = ?";
                
                PreparedStatement ps = conn.prepareStatement(sql);
                
                // Set the first parameter with wildcards for partial search
                ps.setString(1, "%" + keyword + "%");

                int id = 0;
                try {
                    id = Integer.parseInt(keyword);
                } catch (Exception ignored) {
                    // If keyword isn't a number, we set ID to something that won't match (like -1)
                    id = -1; 
                }
                ps.setInt(2, id);

                ResultSet rs = ps.executeQuery();
                PrintWriter out = response.getWriter();

                out.println("<h3 style='color: #c5a059; letter-spacing: 2px;'>SEARCH RESULTS</h3>");

                boolean found = false;
                while (rs.next()) {
                    found = true;
                    out.println("<div style='border: 1px solid #333; padding: 15px; margin-bottom: 10px; background: #111;'>");
                    out.println("<strong>ID:</strong> " + rs.getInt("PRODUCT_ID") + "<br>");
                    out.println("<strong>Name:</strong> " + rs.getString("NAME") + "<br>");
                    out.println("<strong>Brand:</strong> " + rs.getString("BRAND") + "<br>");
                    out.println("<strong>Price:</strong> $" + rs.getDouble("PRICE") + "<br>");
                    out.println("<strong>Stock:</strong> " + rs.getInt("STOCK") + "<br>");
                    out.println("</div>");
                }
                
                if (!found) {
                    out.println("<p style='color: #666;'>No objects found matching '" + keyword + "'</p>");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        }
    }
}
