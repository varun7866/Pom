package com.vh.ui.tests;

import org.openqa.selenium.TimeoutException;
import org.openqa.selenium.WebDriver;
import org.testng.Assert;
import org.testng.annotations.AfterClass;
import org.testng.annotations.BeforeClass;
import org.testng.annotations.Test;

import com.vh.test.base.TestBase;
import com.vh.ui.actions.ApplicationFunctions;
import com.vh.ui.actions.WebActions;
import com.vh.ui.exceptions.URLNavigationException;
import com.vh.ui.exceptions.WaitException;
import com.vh.ui.page.base.WebPage;
import com.vh.ui.pages.CurrentLabsPage;

import ru.yandex.qatools.allure.annotations.Step;

/*
 * @author Harvy Ackermans
 * @date   June 14, 2017
 * @class  CurrentLabsTest.java
 * 
 * Before running this test suite:
 * 1. Change the "username" and "password" parameters in the "resources\application.properties" file to your own
 * 2. Clear your browser's cache
 * 3. Change the Patient name to a Patient under your ID in the call to the selectPatientFromMyPatients() method in the buildUp() method
 * 4. It's not required, but it would be a good idea to delete all existing Labs
 */

public class CurrentLabsTest extends TestBase
{	
	// Class objects
	WebPage pageBase;
	WebActions webActions;
	ApplicationFunctions appFunctions;
	CurrentLabsPage currentLabsPage;
	
	@BeforeClass
	public void buildUp() throws TimeoutException, WaitException, URLNavigationException, InterruptedException {
		WebDriver driver = getWebDriver();
		pageBase = new WebPage(driver);
		webActions = new WebActions(driver);
		appFunctions = new ApplicationFunctions(driver);
		currentLabsPage = new CurrentLabsPage(driver);

		appFunctions.capellaLogin();
		appFunctions.selectPatientFromMyPatients("Waliy Al D Holroyd");
		appFunctions.navigateToMenu("Patient Experience->Labs->Current Labs");
	}

	@Test(priority = 1)
	@Step("Verify the Current Labs page")
	public void verify_CurrentLabsPage() throws WaitException, URLNavigationException, InterruptedException
	{
		Assert.assertTrue(currentLabsPage.viewPageHeaderLabel(), "Failed to identify the Current Labs page header label");
		Assert.assertTrue(currentLabsPage.viewAddLabButton(), "Failed to identify the ADD LAB button");
	}

	@Test(priority = 2)
	@Step("Verify Add Lab Results popup")
	public void verify_AddAddLabResultsPopup() throws WaitException, URLNavigationException, InterruptedException
	{
		currentLabsPage.clickAddLabButton();

		Assert.assertTrue(currentLabsPage.viewAddLabResultsPopup(), "Failed to identify the Add Labs Results popup header label");

		Assert.assertTrue(currentLabsPage.viewAddPopupCancelButton(), "Failed to identify the Add Lab Results popup CANCEL button");
		Assert.assertTrue(currentLabsPage.viewAddPopupSaveButton(), "Failed to identify the Add Lab Results popup SAVE button");

		Assert.assertTrue(currentLabsPage.viewAddPopupApplyThisDateToAllValuesLabel(), "Failed to identify the Add Lab Results popup APPLY THIS DATE TO ALL VALUES label");
		Assert.assertTrue(currentLabsPage.viewAddPopupDatePicker(), "Failed to identify the Add Lab Results popup APPLY THIS DATE TO ALL VALUES picker");
		Assert.assertTrue(currentLabsPage.viewAddPopupDatePickerButtons(), "Failed to identify all of the Add Lab Results popup date picker buttons");
		Assert.assertTrue(currentLabsPage.isAddPopupDateAplliedToAllDates(0), "The Add Lab Results popup dates did not all default to current date");
		Assert.assertTrue(currentLabsPage.isAddPopupDateAplliedToAllDates(-1), "The Add Lab Results popup APPLY THIS DATE TO ALL VALUES was not applied to all dates");

		Assert.assertTrue(currentLabsPage.viewAddpopupHeightLabel(), "Failed to identify the Add Lab Results popup HEIGHT label");
		Assert.assertTrue(currentLabsPage.viewAddpopupHeightTextBox(), "Failed to identify the Add Lab Results popup HEIGHT text box");
	}

	@AfterClass
	public void tearDown() throws TimeoutException, WaitException
	{
		// appFunctions.capellaLogout();
		// pageBase.quit();
	}
}
