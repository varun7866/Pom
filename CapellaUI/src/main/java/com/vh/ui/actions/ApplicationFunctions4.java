package com.vh.ui.actions;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import org.apache.log4j.Logger;
import org.openqa.selenium.By;
import org.openqa.selenium.TimeoutException;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;

import com.vh.ui.exceptions.WaitException;
import com.vh.ui.page.base.WebPage;
import com.vh.ui.utilities.Logg;
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

	ApplicationFunctions appFunctions;

	public ApplicationFunctions4(WebDriver driver) throws WaitException
	{
		super(driver);
		appFunctions = new ApplicationFunctions(driver);
		webActions = new WebActions(driver);
	}

	/**
	 * Verifies if the options in the passed in drop down match the option in the passed in list
	 * 
	 * @param dropDownLocator
	 *            The <select> tag locator of the drop down
	 * @param dropDownOptions
	 *            The list of drop down options to verify against
	 * @return True if the options match, false if they don't
	 * @throws TimeoutException
	 * @throws WaitException
	 */
	public boolean verifyDropDownOptionsByPassedInList(By dropDownLocator, List<String> dropDownOptions) throws TimeoutException, WaitException
	{
		List<String> dropDownOptionsTextFromUI = new ArrayList<String>();

		webActions.click(VISIBILITY, dropDownLocator); // Open drop down

		List<WebElement> dropDownOptionsFromUI = driver.findElements(By.xpath("//div[@class='mat-select-content ng-trigger ng-trigger-fadeInContent']/md-option"));

		for (WebElement webElement : dropDownOptionsFromUI)
		{
			dropDownOptionsTextFromUI.add(webElement.getText());
		}

		dropDownOptionsTextFromUI.remove("Select a value");

		Collections.sort(dropDownOptionsTextFromUI);

		webActions.click(VISIBILITY, dropDownLocator); // Close drop down

		if (dropDownOptionsTextFromUI.equals(dropDownOptions))
		{
			return true;
		} else
		{
			return false;
		}
	}

	/**
	 * Verifies the options for the passed in drop down locator by comparing the values from the UI with the values retrieved from the LOOKUP_VALUES table using the passed in Lookup Value Type.
	 * 
	 * @param dropDownLocator
	 *            The <span> tag locator of the drop down that contains the drop down label
	 * @param lookUpValueTypeUID
	 *            The value from the LOOKUP_VALUE_TYPE_UID column for your drop down in the LOOKUP_VALUES table
	 * @return True if the options match, false if they don't
	 * @throws TimeoutException
	 * @throws WaitException
	 * @throws SQLException
	 */
	public boolean verifyDropDownOptionsByLookUpValueType(By dropDownLocator, String lookUpValueTypeUID) throws TimeoutException, WaitException, SQLException
	{
		List<String> dropDownOptionsTextFromUI = new ArrayList<String>();
		List<String> dropDownOptionsTextFromDB = new ArrayList<String>();

		// Database processing
		final String SQL_SELECT_LOOKUP_VALUES = "SELECT LOOKUP_VALUE_TEXT FROM LOOKUP_VALUES WHERE LOOKUP_VALUE_TYPE_UID = '" + lookUpValueTypeUID
		        + "' AND LOOKUP_VALUE_SHOWNUI_YN = 'Y' ORDER BY LOOKUP_VALUE_TEXT";
		ResultSet queryResultSet = appFunctions.queryDatabase(SQL_SELECT_LOOKUP_VALUES);

		while (queryResultSet.next())
		{
			dropDownOptionsTextFromDB.add(queryResultSet.getString("LOOKUP_VALUE_TEXT"));
		}

		appFunctions.closeDatabaseConnection();

		// UI processing
		webActions.click(VISIBILITY, dropDownLocator);

		List<WebElement> dropDownOptionsFromUI = driver.findElements(By.xpath("//div[@class='mat-select-content ng-trigger ng-trigger-fadeInContent']/md-option"));

		for (WebElement webElement : dropDownOptionsFromUI)
		{
			dropDownOptionsTextFromUI.add(webElement.getText());
		}

		if (dropDownOptionsTextFromUI.equals(dropDownOptionsTextFromDB))
		{
			return true;
		} else
		{
			return false;
		}
	}

	/**
	 * Retrieves the drop down options from the LOOKUP_VALUES table using the passed in Lookup Value Type.
	 * 
	 * @param lookUpValueTypeUID
	 *            The value from the LOOKUP_VALUE_TYPE_UID column for your drop down in the LOOKUP_VALUES table
	 * @return True if the options match, false if they don't
	 * @throws TimeoutException
	 * @throws WaitException
	 * @throws SQLException
	 */
	public List<String> getDropDownOptionsByLookUpValueType(String lookUpValueTypeUID) throws TimeoutException, WaitException, SQLException
	{
		List<String> dropDownOptionsTextFromDB = new ArrayList<String>();

		final String SQL_SELECT_LOOKUP_VALUES = "SELECT LOOKUP_VALUE_TEXT FROM LOOKUP_VALUES WHERE LOOKUP_VALUE_TYPE_UID = '" + lookUpValueTypeUID
		        + "' AND LOOKUP_VALUE_SHOWNUI_YN = 'Y' ORDER BY LOOKUP_VALUE_TEXT";
		ResultSet queryResultSet = appFunctions.queryDatabase(SQL_SELECT_LOOKUP_VALUES);

		while (queryResultSet.next())
		{
			dropDownOptionsTextFromDB.add(queryResultSet.getString("LOOKUP_VALUE_TEXT"));
		}

		appFunctions.closeDatabaseConnection();

		return dropDownOptionsTextFromDB;
	}
}
