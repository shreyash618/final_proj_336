package com.techbarn.webapp;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class ApplicationDB {
	
	public ApplicationDB(){
		
	}

	public static Connection getConnection() throws SQLException {
		
		//Create a connection string with proper encoding
		String connectionUrl = "jdbc:mysql://localhost:3306/tech_barn"
				+ "?useUnicode=true"
				+ "&useSSL=false";
		Connection connection = null;
		
		try {
			//Load JDBC driver - the interface standardizing the connection procedure. Look at WEB-INF\lib for a mysql connector jar file, otherwise it fails.
			Class.forName("com.mysql.jdbc.Driver");
		} catch (ClassNotFoundException e) {
			throw new SQLException("MySQL Driver not found.", e);
		}
		
		try {
			//Create a connection to your DB - use your own credentials
			connection = DriverManager.getConnection(connectionUrl, "root", "your_password_here");
			if (connection == null) {
				throw new SQLException("Failed to make connection!");
			}
		} catch (SQLException e) {
			throw new SQLException("Failed to connect to database.", e);
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
