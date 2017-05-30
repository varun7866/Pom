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
		appFunctions.openPatient("Waliy Al D Holroyd");
		appFunctions.navigateToMenu("Patient Admin->Medical Equipment");
	}

	@Test(priority = 1)
	@Step("Verify the Medical Equipment page")
	public void verify_MedicalEquipmentPage() throws WaitException, URLNavigationException, InterruptedException
	{
		Assert.assertTrue(medicalEquipmentPage.viewPageHeaderLabel(), "Failed to identify the Medical Equipment page header label");
		Assert.assertTrue(medicalEquipmentPage.viewAddMedicalEquipmentButton(), "Failed to identify the ADD MEDICAL EQUIPMENT button");
		Assert.assertTrue(medicalEquipmentPage.viewEquipmentDescriptionColumnHeaderLabel(), "Failed to identify the Equipment Description colummn header label");
		Assert.assertTrue(medicalEquipmentPage.viewSourceColumnHeaderLabel(), "Failed to identify the Source colummn header label");
		Assert.assertTrue(medicalEquipmentPage.viewModifiedColumnHeaderLabel(), "Failed to identify the Modified colummn header label");
		Assert.assertTrue(medicalEquipmentPage.viewStatusColumnHeaderLabel(), "Failed to identify the Status colummn header label");
		Assert.assertTrue(medicalEquipmentPage.viewInUseColumnHeaderLabel(), "Failed to identify the In Use colummn header label");
	}

	@Test(priority = 2)
	@Step("Verify Add Medical Equipment popup")
	public void verify_AddMedicalEquipmentPopup() throws WaitException, URLNavigationException, InterruptedException
	{
		medicalEquipmentPage.clickAddMedicalEquipmentButton();

		Assert.assertTrue(medicalEquipmentPage.viewAddMedicalEquipmentPopup(), "Failed to identify the Add Medical Equipment popup header label");

		Assert.assertTrue(medicalEquipmentPage.viewAddPopupCancelButton(), "Failed to identify the Add Medical Equipment popup CANCEL button");
		Assert.assertTrue(medicalEquipmentPage.viewAddPopupAddButton(), "Failed to identify the Add Medical Equipment popup ADD button");

		Assert.assertTrue(medicalEquipmentPage.viewAddPopupDateLabel(), "Failed to identify the Add Medical Equipment popup DATE label");
		Assert.assertTrue(medicalEquipmentPage.viewAddPopupDatePicker(), "Failed to identify the Add Medical Equipment popup DATE picker");
		Assert.assertTrue(medicalEquipmentPage.viewAddPopupDatePickerButton(), "Failed to identify the Add Medical Equipment popup DATE picker button");

		Assert.assertTrue(medicalEquipmentPage.viewAddPopupSourceLabel(), "Failed to identify the Add Medical Equipment popup SOURCE label");
		Assert.assertTrue(medicalEquipmentPage.viewAddPopupSourceComboBox(), "Failed to identify the Add Medical Equipment popup SOURCE combo box");

		Assert.assertTrue(medicalEquipmentPage.viewAddPopupEquipmentIsInUseLabel(), "Failed to identify the Add Medical Equipment popup Equipment is in Use label");
		Assert.assertTrue(medicalEquipmentPage.viewAddPopupEquipmentIsInUseCheckBox(), "Failed to identify the Add Medical Equipment popup Equipment is in Use check box");

		Assert.assertTrue(medicalEquipmentPage.viewAddPopupEquipmentTypeLabel(), "Failed to identify the Add Medical Equipment popup EQUIPMENT TYPE label");
		Assert.assertTrue(medicalEquipmentPage.viewAddPopupEquipmentTypeComboBox(), "Failed to identify the Add Medical Equipment popup EQUIPMENT TYPE combo box");

		Assert.assertTrue(medicalEquipmentPage.viewAddPopupStatusLabel(), "Failed to identify the Add Medical Equipment popup STATUS label");
		Assert.assertTrue(medicalEquipmentPage.viewAddPopupStatusComboBox(), "Failed to identify the Add Medical Equipment popup STATUS combo box");

		Assert.assertFalse(medicalEquipmentPage.isAddPopupAddButtonEnabled(), "The Add Medical Equipment popup ADD button should not be enabled at this point (1)");

		medicalEquipmentPage.selectAddPopupSourceComboBox("VH Provided");
		Assert.assertFalse(medicalEquipmentPage.isAddPopupAddButtonEnabled(), "The Add Medical Equipment popup ADD button should not be enabled at this point (2)");

		medicalEquipmentPage.selectAddPopupEquipmentTypeComboBox("Bed Trapeze");
		Assert.assertFalse(medicalEquipmentPage.isAddPopupAddButtonEnabled(), "The Add Medical Equipment popup ADD button should not be enabled at this point (3)");

		medicalEquipmentPage.selectAddPopupStatusComboBox("Delivered");
		Assert.assertTrue(medicalEquipmentPage.isAddPopupAddButtonEnabled(), "The Add Medical Equipment popup ADD button should not be disabled at this point");
		
		Assert.assertTrue(medicalEquipmentPage.isAddPopupDefaultDateCurrentDate(), "The Add Medical Equipment popup default DATE does not match the current date");

		// medicalEquipmentPage.clickAddPopupDatePickerButton();
		// Assert.assertTrue(medicalEquipmentPage.isAddPopupDateRangeValid(), "The Add Medical Equipment popup DATE range is invalid");

		// Need to add a test to verify a date cannot be older than 7 days

		// Need to add a test to verify a date cannot be greater than current date
	}

	@Test(priority = 3)
	@Step("Verify adding Medical Equipment")
	public void AddMedicalEquipment() throws WaitException, URLNavigationException, InterruptedException
	{
		medicalEquipmentPage.checkAddPopupEquipmentIsInUseCheckBox();

		medicalEquipmentPage.clickAddPopupAddButton();

		Thread.sleep(2000);

		Assert.assertFalse(medicalEquipmentPage.viewAddMedicalEquipmentPopup(), "The Add Medical Equipment popup did not close");

		// Assert.assertTrue(medicalEquipmentPage.isMedicalEquipmentInTable(), "The Medical Equipment is not in the table");
	}

	@AfterClass
	public void tearDown() throws TimeoutException, WaitException
	{
		appFunctions.capellaLogout();
		pageBase.quit();
	}
}
