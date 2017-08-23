package com.vh.ui.actions;

import java.util.ArrayList;
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

	public ApplicationFunctions4(WebDriver driver) throws WaitException
	{
		super(driver);
		webActions = new WebActions(driver);
	}

	/**
	 * DO NOT USE. NOT FINISHED YET. Verifies if the options in the passed in drop down match the option in the passed in list
	 * 
	 * @param dropDownLocator
	 *            The <select> tag locator of the drop down
	 * @param dropDownOptions
	 *            The list of drop down options to verify against
	 * @return True if the options match, false if they don't
	 * @throws TimeoutException
	 * @throws WaitException
	 */
	public boolean verifyDropDownOptions(By dropDownLocator, List<String> dropDownOptions) throws TimeoutException, WaitException
	{
		List<String> dropDownOptionsTextFromUI = new ArrayList<String>();
		List<WebElement> dropDownOptionsFromUI = driver.findElements(By.xpath(dropDownLocator.toString().substring(10) + "/option"));

		for (WebElement webElement : dropDownOptionsFromUI)
		{
			dropDownOptionsTextFromUI.add(webElement.getText());
		}

		if (dropDownOptionsTextFromUI.equals(dropDownOptions))
		{
			return true;
		} else
		{
			return false;
		}
	}
}
