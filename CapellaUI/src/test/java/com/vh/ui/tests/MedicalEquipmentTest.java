package com.vh.ui.tests;

import org.openqa.selenium.TimeoutException;
import org.openqa.selenium.WebDriver;
import org.testng.Assert;
import org.testng.annotations.AfterClass;
import org.testng.annotations.BeforeClass;
import org.testng.annotations.Test;

import com.vh.test.base.TestBase;
import com.vh.ui.actions.ApplicationFunctions;
import com.vh.ui.exceptions.URLNavigationException;
import com.vh.ui.exceptions.WaitException;
import com.vh.ui.page.base.WebPage;
import com.vh.ui.pages.MedicalEquipmentPage;

import ru.yandex.qatools.allure.annotations.Step;

/*
 * @author Harvy Ackermans
 * @date   May 12, 2017
 * @class  MedicalEquipmentTest.java
 * 
 * Before running this test suite:
 * 1. Change the "username" and "password" parameters in the "resources\application.properties" file to your own
 * 2. Clear your browser's cache
 */

public class MedicalEquipmentTest extends TestBase
{	
	// Class objects
	WebPage pageBase;
	ApplicationFunctions appFunctions;
	MedicalEquipmentPage medicalEquipmentPage;
	
	@BeforeClass
	public void buildUp() throws TimeoutException, WaitException, URLNavigationException, InterruptedException {
		WebDriver driver = getWebDriver();
		pageBase = new WebPage(driver);
		appFunctions = new ApplicationFunctions(driver);
		medicalEquipmentPage = new MedicalEquipmentPage(driver);

		appFunctions.capellaLogin();
		appFunctions.navigateToMenu("Medical Equipment");
	}

	@Test(priority = 1)
	@Step("Verify the Medical Equipment page is displayed")
	public void verify_PageDisplayed() throws WaitException, URLNavigationException, InterruptedException
	{
		Assert.assertTrue(medicalEquipmentPage.viewPageHeaderLabel(), "Failed to identify the Medical Equipment page header label");
	}

	@Test(priority = 2)
	@Step("Verify the column headers are displayed")
	public void verify_ColumnHeadersDisplayed() throws WaitException, URLNavigationException, InterruptedException
	{
		Assert.assertTrue(medicalEquipmentPage.viewEquipmentDescriptionColumnHeaderLabel(), "Failed to identify the Equipment Description colummn header label");
		Assert.assertTrue(medicalEquipmentPage.viewSourceColumnHeaderLabel(), "Failed to identify the Source colummn header label");
		Assert.assertTrue(medicalEquipmentPage.viewDateColumnHeaderLabel(), "Failed to identify the Date colummn header label");
		Assert.assertTrue(medicalEquipmentPage.viewStatusColumnHeaderLabel(), "Failed to identify the Status colummn header label");
		Assert.assertTrue(medicalEquipmentPage.viewInUseColumnHeaderLabel(), "Failed to identify the In Use colummn header label");
	}

	@Test(priority = 3)
	@Step("Verify medical equipment can be added")
	public void verify_AddMedicalEquipment() throws WaitException, URLNavigationException, InterruptedException
	{
		Assert.assertTrue(medicalEquipmentPage.viewAddMedicalEquipmentButton(), "Failed to identify the ADD MEDICAL EQUIPMENT button");
		medicalEquipmentPage.clickAddMedicalEquipment();

		Assert.assertTrue(medicalEquipmentPage.viewAddMedicalEquipmentPopup(), "Failed to identify the Add Medical Equipment popup");

		Assert.assertTrue(medicalEquipmentPage.viewAddPopupCancelButton(), "Failed to identify the Add Medical Equipment popup CANCEL button");
		Assert.assertTrue(medicalEquipmentPage.viewAddPopupAddButton(), "Failed to identify the Add Medical Equipment popup ADD button");

		Assert.assertTrue(medicalEquipmentPage.viewAddPopupDateLabel(), "Failed to identify the Add Medical Equipment popup DATE label");
		Assert.assertTrue(medicalEquipmentPage.viewAddPopupDateCalendar(), "Failed to identify the Add Medical Equipment popup DATE control");

		Assert.assertTrue(medicalEquipmentPage.viewAddPopupSourceLabel(), "Failed to identify the Add Medical Equipment popup SOURCE label");
		Assert.assertTrue(medicalEquipmentPage.viewAddPopupSourceComboBox(), "Failed to identify the Add Medical Equipment popup SOURCE combo box");

		Assert.assertTrue(medicalEquipmentPage.viewAddPopupEquipmentIsInUseLabel(), "Failed to identify the Add Medical Equipment popup Equipment is in Use label");
		Assert.assertTrue(medicalEquipmentPage.viewAddPopupEquipmentIsInUseCheckBox(), "Failed to identify the Add Medical Equipment popup Equipment is in Use check box");

		Assert.assertTrue(medicalEquipmentPage.viewAddPopupEquipmentTypeLabel(), "Failed to identify the Add Medical Equipment popup EQUIPMENT TYPE label");
		Assert.assertTrue(medicalEquipmentPage.viewAddPopupEquipmentTypeComboBox(), "Failed to identify the Add Medical Equipment popup EQUIPMENT TYPE combo box");

		Assert.assertTrue(medicalEquipmentPage.viewAddPopupStatusLabel(), "Failed to identify the Add Medical Equipment popup STATUS label");
		Assert.assertTrue(medicalEquipmentPage.viewAddPopupStatusComboBox(), "Failed to identify the Add Medical Equipment popup STATUS combo box");

		Assert.assertFalse(medicalEquipmentPage.isAddPopupAddButtonEnabled(), "The Add popup ADD button should not be enabled at this point (1)");

		medicalEquipmentPage.selectAddPopupSourceComboBox("VH Provided");
		Assert.assertFalse(medicalEquipmentPage.isAddPopupAddButtonEnabled(), "The Add popup ADD button should not be enabled at this point (2)");

		medicalEquipmentPage.selectAddPopupEquipmentTypeComboBox("Bed Trapeze");
		Assert.assertFalse(medicalEquipmentPage.isAddPopupAddButtonEnabled(), "The Add popup ADD button should not be enabled at this point (3)");

		medicalEquipmentPage.selectAddPopupStatusComboBox("Delivered");
		Assert.assertTrue(medicalEquipmentPage.isAddPopupAddButtonEnabled(), "The Add popup ADD button should not be disabled at this point");
	}

	@AfterClass
	public void tearDown() throws TimeoutException, WaitException
	{
		// appFunctions.capellaLogout();
		pageBase.quit();
	}
}
