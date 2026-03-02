package com.mirza.util;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {
    public static Connection getConnection() {
        try {
            Class.forName("org.postgresql.Driver");
            
            // This pulls the URL you just set in the Render Dashboard
            String dbUrl = System.getenv("DATABASE_URL");
            
            if (dbUrl != null && dbUrl.startsWith("postgresql://")) {
                // Fixed: JDBC requires the 'jdbc:' prefix
                dbUrl = dbUrl.replace("postgresql://", "jdbc:postgresql://");
            }

            return DriverManager.getConnection(dbUrl);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
}