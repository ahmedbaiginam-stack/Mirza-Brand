package com.mirza.util;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {

    // Using the internal Railway host for better performance
    private static final String URL = "jdbc:postgresql://postgres.railway.internal:5432/railway";
    private static final String USER = "postgres";
    private static final String PASS = "KUDXIfyrhHiLtxiuGoJyeUzdiLRRmbcn";

    public static Connection getConnection() {
        try {
            Class.forName("org.postgresql.Driver");
            return DriverManager.getConnection(URL, USER, PASS);
        } catch (Exception e) {
            // This will show up in your 'Deploy Logs' if the connection fails
            System.err.println("DB Connection Error: " + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }
}