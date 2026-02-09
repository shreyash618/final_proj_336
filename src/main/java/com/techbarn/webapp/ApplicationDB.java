package com.techbarn.webapp;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class ApplicationDB {
	
	public ApplicationDB(){
		
	}

	private static String firstNonEmpty(String... values) {
		for (String v : values) {
			if (v != null && !v.isEmpty()) return v;
		}
		return values.length > 0 ? values[values.length - 1] : null;
	}

	public static Connection getConnection() throws SQLException {
		// Railway uses MYSQLHOST, MYSQLPORT, MYSQLUSER, MYSQLPASSWORD, MYSQLDATABASE
		// Also support MYSQL_HOST, MYSQL_DATABASE, MYSQL_USER, MYSQL_PASSWORD (Render/etc)
		String host = firstNonEmpty(System.getenv("MYSQLHOST"), System.getenv("MYSQL_HOST"), "localhost");
		String port = firstNonEmpty(System.getenv("MYSQLPORT"), System.getenv("MYSQL_PORT"), "3306");
		String dbName = firstNonEmpty(System.getenv("MYSQLDATABASE"), System.getenv("MYSQL_DATABASE"), "tech_barn");
		String user = firstNonEmpty(System.getenv("MYSQLUSER"), System.getenv("MYSQL_USER"), "root");
		String password = firstNonEmpty(System.getenv("MYSQLPASSWORD"), System.getenv("MYSQL_PASSWORD"), "password123");

		String connectionUrl = "jdbc:mysql://" + host + ":" + port + "/" + dbName
				+ "?useUnicode=true"
				+ "&useSSL=false"
				+ "&allowPublicKeyRetrieval=true";
		Connection connection = null;

		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
		} catch (ClassNotFoundException e) {
			throw new SQLException("MySQL Driver not found.", e);
		}

		try {
			connection = DriverManager.getConnection(connectionUrl, user, password);
			if (connection == null) {
				throw new SQLException("Failed to make connection!");
			}
		} catch (SQLException e) {
			// Preserve the original error message to help diagnose the issue
			throw new SQLException("Failed to connect to database: " + e.getMessage(), e);
		}
		
		return connection;
		
	}
	
	public static void closeConnection(Connection connection) throws SQLException {
		if (connection != null) {
			try {
				connection.close();
			} catch (SQLException e) {
				throw new SQLException("Error closing database connection", e);
			}
		}
	}
	
	
	
	
	
	public static void main(String[] args) {
		try {
			Connection connection = ApplicationDB.getConnection();
			System.out.println(connection);		
			ApplicationDB.closeConnection(connection);
		} catch (SQLException e) {
			System.err.println("Database connection error: " + e.getMessage());
			e.printStackTrace();
		}
	}
	
	

}