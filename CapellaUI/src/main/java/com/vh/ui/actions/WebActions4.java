package com.vh.ui.actions;

import org.apache.log4j.Logger;
import org.openqa.selenium.By;
import org.openqa.selenium.TimeoutException;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;

import com.vh.ui.comparator.Comparator;
import com.vh.ui.exceptions.WaitException;
import com.vh.ui.utilities.Logg;
import com.vh.ui.utilities.Utilities;
import com.vh.ui.waits.WebDriverWaits;

/*
 * @author Harvy Ackermans
 * @date   August 23, 2017
 * @class  WebActions4.java
 */
public class WebActions4 {
	
	protected WebDriver driver;
	protected WebActions webActions;
	protected final Comparator compare = new Comparator();
	protected static final Logger LOGGER = Logg.createLogger();
	protected final WebDriverWaits wait = new WebDriverWaits();

	public WebActions4(WebDriver driver) {
		this.driver = driver;
		webActions = new WebActions(driver);
	}

	public void selectFromDropDown(String expectedCondition, By locator, String itemToSelect) throws TimeoutException, WaitException
	{
		LOGGER.info(Utilities.getCurrentThreadId() + "Selecting " + itemToSelect + " from drop-down with locator:" + locator);

		WebElement element;

		if ("notrequired".equals(expectedCondition))
		{
			element = driver.findElement(locator);
		} else
		{
			element = wait.syncLocatorUsing(expectedCondition, driver, locator);
		}

		webActions.javascriptClick(locator);

		String optionXPath = ".//md-option[contains(., '" + itemToSelect + "')]";

		try
		{
			Thread.sleep(2000);
		} catch (InterruptedException e)
		{
			e.printStackTrace();
		}

		webActions.javascriptClick(By.xpath(optionXPath));

		try
		{
			Thread.sleep(2000);
		} catch (InterruptedException e)
		{
			e.printStackTrace();
		}

		LOGGER.info(Utilities.getCurrentThreadId() + "Selected:" + itemToSelect + " from drop-down with locator:" + element);
	}
}