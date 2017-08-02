package com.vh.ui.tests;

import java.util.Map;

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
 * 3. Change the Patient name to a Patient under your ID in the call to the selectPatientFromMyPatients() method in the buildUp() method
 * 4. It's not required, but it would be a good idea to delete all existing medical equipment from table PTME_PATIENT_MEDICAL_EQUIP
 */

public class MedicalEquipmentTest extends TestBase
{	
	// Class objects
	WebPage pageBase;
	WebActions webActions;
	ApplicationFunctions appFunctions;
	MedicalEquipmentPage medicalEquipmentPage;
	
	@BeforeClass
	public void buildUp() throws TimeoutException, WaitException, URLNavigationException, InterruptedException {
		WebDriver driver = getWebDriver();
		pageBase = new WebPage(driver);
		webActions = new WebActions(driver);
		appFunctions = new ApplicationFunctions(driver);
		medicalEquipmentPage = new MedicalEquipmentPage(driver);

		appFunctions.capellaLogin();
		appFunctions.selectPatientFromMyPatients("Waliy Al D Holroyd"); // QA
		// appFunctions.selectPatientFromMyPatients("Alim Clear"); // Stage
		appFunctions.navigateToMenu("Patient Admin->Medical Equipment");
	}

	@Test(priority = 1)
	@Step("Verify the Medical Equipment page")
	public void verify_MedicalEquipmentPage() throws WaitException, URLNavigationException, InterruptedException
	{
		Assert.assertTrue(medicalEquipmentPage.viewPageHeaderLabel(), "Failed to identify the MEDICAL EQUIPMENT page header label");
		Assert.assertTrue(medicalEquipmentPage.viewAddMedicalEquipmentButton(), "Failed to identify the ADD MEDICAL EQUIPMENT button");
		Assert.assertTrue(medicalEquipmentPage.viewEquipmentDescriptionColumnHeaderLabel(), "Failed to identify the EQUIPMENT DESCRIPTION colummn header label");
		Assert.assertTrue(medicalEquipmentPage.viewSourceColumnHeaderLabel(), "Failed to identify the SOURCE colummn header label");
		Assert.assertTrue(medicalEquipmentPage.viewDateColumnHeaderLabel(), "Failed to identify the DATE colummn header label");
		Assert.assertTrue(medicalEquipmentPage.viewStatusColumnHeaderLabel(), "Failed to identify the STATUS colummn header label");
		Assert.assertTrue(medicalEquipmentPage.viewInUseColumnHeaderLabel(), "Failed to identify the IN USE colummn header label");
	}

	@Test(priority = 2)
	@Step("Verify the Add Medical Equipment popup")
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
		Assert.assertTrue(medicalEquipmentPage.viewAddpopupSourcePlaceholder(), "Failed to identify the Add Medical Equipment popup SOURCE placeholder");
		Assert.assertTrue(medicalEquipmentPage.verifyAddPopupSourceComboBoxOptions(), "The Add Medical Equipment popup SOURCE drop down options are incorrect");

		Assert.assertTrue(medicalEquipmentPage.viewAddPopupEquipmentIsInUseLabel(), "Failed to identify the Add Medical Equipment popup Equipment is in Use label");
		Assert.assertTrue(medicalEquipmentPage.viewAddPopupEquipmentIsInUseCheckBox(), "Failed to identify the Add Medical Equipment popup Equipment is in Use check box");

		Assert.assertTrue(medicalEquipmentPage.viewAddPopupEquipmentTypeLabel(), "Failed to identify the Add Medical Equipment popup EQUIPMENT TYPE label");
		Assert.assertTrue(medicalEquipmentPage.viewAddPopupEquipmentTypeComboBox(), "Failed to identify the Add Medical Equipment popup EQUIPMENT TYPE combo box");
		Assert.assertTrue(medicalEquipmentPage.viewAddpopupEquipmentTypePlaceholder(), "Failed to identify the Add Medical Equipment popup EQUIPMENT TYPE placeholder");
		Assert.assertTrue(medicalEquipmentPage.verifyAddPopupEquipmentTypeComboBoxOptions(), "The Add Medical Equipment popup EQUIPMENT TYPE drop down options are incorrect");

		Assert.assertTrue(medicalEquipmentPage.viewAddPopupStatusLabel(), "Failed to identify the Add Medical Equipment popup STATUS label");
		Assert.assertTrue(medicalEquipmentPage.viewAddPopupStatusComboBox(), "Failed to identify the Add Medical Equipment popup STATUS combo box");
		Assert.assertTrue(medicalEquipmentPage.viewAddpopupStatusPlaceholder(), "Failed to identify the Add Medical Equipment popup STATUS placeholder");
		Assert.assertTrue(medicalEquipmentPage.verifyAddPopupStatusComboBoxOptions(), "The Add Medical Equipment popup STATUS drop down options are incorrect");

		Assert.assertFalse(medicalEquipmentPage.isAddPopupAddButtonEnabled(), "The Add Medical Equipment popup ADD button should not be enabled at this point (1)");

		medicalEquipmentPage.selectAddPopupSourceComboBox("VH Provided");
		Assert.assertFalse(medicalEquipmentPage.isAddPopupAddButtonEnabled(), "The Add Medical Equipment popup ADD button should not be enabled at this point (2)");

		medicalEquipmentPage.selectAddPopupEquipmentTypeComboBox("Bed Trapeze");
		Assert.assertFalse(medicalEquipmentPage.isAddPopupAddButtonEnabled(), "The Add Medical Equipment popup ADD button should not be enabled at this point (3)");

		medicalEquipmentPage.selectAddPopupStatusComboBox("Delivered");
		Assert.assertTrue(medicalEquipmentPage.isAddPopupAddButtonEnabled(), "The Add Medical Equipment popup ADD button should not be disabled at this point");
		
		Assert.assertTrue(medicalEquipmentPage.isAddPopupDefaultDateCurrentDate(), "The Add Medical Equipment popup default DATE does not match the current date");

		medicalEquipmentPage.clickAddPopupDatePickerButton();
		Assert.assertTrue(medicalEquipmentPage.isAddPopupEnabledDateRangeValid(), "The Add Medical Equipment popup enabled DATE range is invalid");

		medicalEquipmentPage.selectAddPopupCurrentDateFromCalendar();
	}

	@Test(priority = 3)
	@Step("Verify adding Medical Equipment")
	public void verify_AddMedicalEquipment() throws WaitException, URLNavigationException, InterruptedException
	{
		medicalEquipmentPage.checkAddPopupEquipmentIsInUseCheckBox();

		medicalEquipmentPage.clickAddPopupAddButton();

		Assert.assertTrue(medicalEquipmentPage.viewAddMedicalEquipmentPopupClosed(), "The Add Medical Equipment popup did not close");

		Assert.assertTrue(medicalEquipmentPage.isMedicalEquipmentInTable(), "The Medical Equipment is not in the table");
	}

	@Test(priority = 4)
	@Step("Verify editable fields in the Medical Equipment table")
	public void verify_EditableFields() throws WaitException, URLNavigationException, InterruptedException
	{
		Assert.assertTrue(medicalEquipmentPage.isStatusDropdownEditable(), "The STATUS drop down is not editable");
		Assert.assertTrue(medicalEquipmentPage.viewSuccessMessage(), "The STATUS drop down success message did not display");

		Assert.assertTrue(medicalEquipmentPage.isInUseCheckboxEditable(), "The IN USE check box is not editable");
		Assert.assertTrue(medicalEquipmentPage.viewSuccessMessage(), "The IN USE check box success message did not display");

		Assert.assertTrue(medicalEquipmentPage.verifyStatusComboBoxOptions(), "The STATUS drop down options are incorrect");
	}

	@Test(priority = 5)
	@Step("Verify all columns can be sorted in the Medical Equipment table")
	public void verify_ColumnSorting() throws WaitException, URLNavigationException, InterruptedException
	{
		String currentDayMinusX;

		currentDayMinusX = appFunctions.adjustCurrentDateBy("-1", "d");
		medicalEquipmentPage.addMedicalEquipment(currentDayMinusX, "Other", "Glucometer", "Ordered", false);

		Thread.sleep(4000);

		currentDayMinusX = appFunctions.adjustCurrentDateBy("-2", "d");
		medicalEquipmentPage.addMedicalEquipment(currentDayMinusX, "VH Provided", "Scale", "Replaced", true);

		Assert.assertTrue(medicalEquipmentPage.isTableSortableByEquipmentDescriptionAscending(), "The EQUIPMENT DESCRIPTION column did not sort ascendingly");
		Assert.assertTrue(medicalEquipmentPage.isTableSortableByEquipmentDescriptionDescending(), "The EQUIPMENT DESCRIPTION column did not sort descendingly");

		Assert.assertTrue(medicalEquipmentPage.isTableSortableBySourceAscending(), "The SOURCE column did not sort ascendingly");
		Assert.assertTrue(medicalEquipmentPage.isTableSortableBySourceDescending(), "The SOURCE column did not sort descendingly");

		Assert.assertTrue(medicalEquipmentPage.isTableSortableByModifiedAscending(), "The MODIFIED column did not sort ascendingly");
		Assert.assertTrue(medicalEquipmentPage.isTableSortableByModifiedDescending(), "The MODIFIED column did not sort descendingly");

		Assert.assertTrue(medicalEquipmentPage.isTableSortableByStatusAscending(), "The STATUS column did not sort ascendingly");
		Assert.assertTrue(medicalEquipmentPage.isTableSortableByStatusDescending(), "The STATUS column did not sort descendingly");

		Assert.assertTrue(medicalEquipmentPage.isTableSortableByInUseAscending(), "The IN USE column did not sort ascendingly");
		Assert.assertTrue(medicalEquipmentPage.isTableSortableByInUseDescending(), "The IN USE column did not sort descendingly");
	}

	@Test(priority = 6, dataProvider = "CapellaDataProvider")
	@Step("Verify adding Medical Equipment from Excel data")
	public void verify_AddingMedicalEquipment(Map<String, String> map) throws WaitException, URLNavigationException, InterruptedException
	{
		boolean equipmentInUse = false;
		String equipmentAddDay;

		appFunctions.selectPatientFromMyPatients(map.get("PatientName"));

		appFunctions.navigateToMenu("Patient Admin->Medical Equipment");

		equipmentAddDay = appFunctions.adjustCurrentDateBy(map.get("DATE"), "d");

		if (map.get("EQUIPMENTINUSE").equals("Y"))
		{
			equipmentInUse = true;
		}

		medicalEquipmentPage.addMedicalEquipment(equipmentAddDay, map.get("SOURCEDROPDOWN"), map.get("EQUIPMENTTYPE"), map.get("STATUS"), equipmentInUse);

		Assert.assertTrue(medicalEquipmentPage.isMedicalEquipmentInTable(map), "The Medical Equipment is not in the table");
	}

	@AfterClass
	public void tearDown() throws TimeoutException, WaitException
	{
		appFunctions.capellaLogout();
		pageBase.quit();
	}
}
