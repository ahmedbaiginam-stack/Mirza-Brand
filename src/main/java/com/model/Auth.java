package com.model;

import com.mirza.util.DBConnection;
import java.sql.*;

public class Auth {
    public boolean register(String name, String email, String password) {
        try (Connection conn = DBConnection.getConnection()) {
            String sql = "INSERT INTO USERS (NAME, EMAIL, PASSWORD, ROLE) VALUES (?, ?, ?, 'USER')";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, name);
            ps.setString(2, email);
            ps.setString(3, password);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}