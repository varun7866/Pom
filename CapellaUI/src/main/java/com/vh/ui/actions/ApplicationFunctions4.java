package com.vh.ui.actions;

import java.util.Properties;

import org.apache.log4j.Logger;
import org.openqa.selenium.WebDriver;

import com.vh.db.jdbc.DatabaseFunctions;
import com.vh.ui.exceptions.WaitException;
import com.vh.ui.page.base.WebPage;
import com.vh.ui.pages.LoginPage;
import com.vh.ui.utilities.Logg;
import com.vh.ui.utilities.PropertyManager;
import com.vh.ui.waits.WebDriverWaits;

/*
 * @author Harvy Ackermans
 * @date   August 23, 2017
 * @class  ApplicationFunctions4.java
 */
public class ApplicationFunctions4 extends WebPage
{
	protected static final Logger LOGGER = Logg.createLogger();
	protected final WebDriverWaits wait = new WebDriverWaits();
	private WebActions webActions = null;
	private WebPage pageBase;
	private LoginPage loginPage;
	private DatabaseFunctions databaseFunctions;
	
	private final static Properties applicationProperty = PropertyManager
			.loadApplicationPropertyFile("resources/application.properties");

	public ApplicationFunctions4(WebDriver driver) throws WaitException
	{
		super(driver);
		webActions = new WebActions(driver);
		pageBase = new WebPage(driver);
		databaseFunctions = new DatabaseFunctions();
	}
}
