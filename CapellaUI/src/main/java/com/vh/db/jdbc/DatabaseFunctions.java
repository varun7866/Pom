package com.vh.db.jdbc;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.Properties;

import com.vh.security.EncryptDecrypt;
import com.vh.ui.utilities.PropertyManager;

import ru.yandex.qatools.allure.annotations.Step;

/*
 * @author Harvy Ackermans
 * @date   August 9, 2017
 * @class  DatabaseFunctions.java
 */

public class DatabaseFunctions
{
	private Connection dbConnection = null;

	protected final static Properties applicationProperty = PropertyManager.loadApplicationPropertyFile("resources/application.properties");

	@Step("Loads the JDBC driver Class and connects to the Capella database")
	public void connectToDatabase()
	{
		try
		{
			Class.forName("oracle.jdbc.driver.OracleDriver");

			String connectionString = "jdbc:oracle:thin:@" + applicationProperty.getProperty("hostName") + ":" + applicationProperty.getProperty("port") + ":"
			        + applicationProperty.getProperty("SID");
			
			String decryptedPassword = EncryptDecrypt.decrypt(applicationProperty.getProperty("dbPassword"));
			
			dbConnection = DriverManager.getConnection(connectionString, applicationProperty.getProperty("daUsername"), decryptedPassword);
		} catch (Exception e)
		{
			System.out.println("Error connecting to database: " + e.getMessage());
		}
	}

	@Step("Executes the passed in SQL query and returns the results")
	public ResultSet runQuery(String sqlquery)
	{
		ResultSet queryResultSet = null;

		try
		{
			Statement sqlStatement = dbConnection.createStatement();
			queryResultSet = sqlStatement.executeQuery(sqlquery);

		} catch (Exception e)
		{
			System.out.println("Error querying database: " + e.getMessage());
		}

		return queryResultSet;
	}
}
