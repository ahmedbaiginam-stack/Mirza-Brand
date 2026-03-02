package com.mirza.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {

	private static final String URL =
			"jdbc:postgresql://containers-us-west-45.railway.app:6543/railway";

    private static final String USER = "postgres";
    private static final String PASS = "KUDXIfyrhHiLtxiuGoJyeUzdiLRRmbcn";

    public static Connection getConnection() {
        try {
            Class.forName("org.postgresql.Driver");
            return DriverManager.getConnection(URL, USER, PASS);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
}