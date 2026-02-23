package com.controller;

import com.mirza.util.DBConnection;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;

@WebServlet("/getProducts")
public class ProductServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {

        response.setContentType("application/json");
        PrintWriter out = response.getWriter();

        String category = request.getParameter("category");

        String sql = "SELECT PRODUCT_ID, NAME, PRICE, IMAGE FROM PRODUCTS";
        if (category != null && !category.equals("all"))
            sql += " WHERE CATEGORY = ?";

        try (Connection conn = DBConnection.getConnection()) {

            PreparedStatement ps = conn.prepareStatement(sql);

            if (category != null && !category.equals("all"))
                ps.setString(1, category);

            ResultSet rs = ps.executeQuery();

            StringBuilder json = new StringBuilder("[");
            boolean first = true;

            while (rs.next()) {
                if (!first) json.append(",");
                first = false;

                json.append("{")
                        .append("\"id\":").append(rs.getInt("PRODUCT_ID")).append(",")
                        .append("\"name\":\"").append(rs.getString("NAME")).append("\",")
                        .append("\"price\":").append(rs.getDouble("PRICE")).append(",")
                        .append("\"img\":\"").append(rs.getString("IMAGE")).append("\"")
                        .append("}");
            }

            json.append("]");
            out.print(json);

        } catch (Exception e) {
            e.printStackTrace();
            out.print("[]");
        }
    }
}
