package com.mirza.util;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {
    public static Connection getConnection() {
        try {
            // Load Postgres driver
            Class.forName("org.postgresql.Driver");
            
            // This reads the internal URL shown in your screenshot (image_1847fe.png)
            String dbUrl = System.getenv("DATABASE_URL");
            
            if (dbUrl == null || dbUrl.isEmpty()) {
                // Fallback for local testing - use your private host from image_1847fe.png
                dbUrl = "jdbc:postgresql://postgres.railway.internal:5432/railway";
            }
            
            // Important: Railway's DATABASE_URL starts with 'postgres://'
            // JDBC requires 'jdbc:postgresql://'
            if (dbUrl.startsWith("postgres://")) {
                dbUrl = dbUrl.replace("postgres://", "jdbc:postgresql://");
            }

            return DriverManager.getConnection(dbUrl, "postgres", "KUDXIfyrhHiLtxiuGoJyeUzdiLRRmbcn");
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
}