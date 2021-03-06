package com.vh.ui.pages;

import static com.vh.ui.web.locators.MedicalEquipmentLocators.BTN_ADDMEDICALEQUIPMENT;
import static com.vh.ui.web.locators.MedicalEquipmentLocators.BTN_ADDPOPUPADD;
import static com.vh.ui.web.locators.MedicalEquipmentLocators.BTN_ADDPOPUPCANCEL;
import static com.vh.ui.web.locators.MedicalEquipmentLocators.BTN_ADDPOPUPDATE;
import static com.vh.ui.web.locators.MedicalEquipmentLocators.CAL_ADDPOPUPDATE;
import static com.vh.ui.web.locators.MedicalEquipmentLocators.CBO_ADDPOPUPEQUIPMENTTYPE;
import static com.vh.ui.web.locators.MedicalEquipmentLocators.CBO_ADDPOPUPSOURCE;
import static com.vh.ui.web.locators.MedicalEquipmentLocators.CBO_ADDPOPUPSTATUS;
import static com.vh.ui.web.locators.MedicalEquipmentLocators.CBO_FIRSTROWSTATUS;
import static com.vh.ui.web.locators.MedicalEquipmentLocators.CHK_ADDPOPUPEQUIPMENTISINUSE;
import static com.vh.ui.web.locators.MedicalEquipmentLocators.CHK_FIRSTROWEQUIPMENTISINUSE;
import static com.vh.ui.web.locators.MedicalEquipmentLocators.LBL_ADDPOPUPADDMEDICALEQUIPMENT;
import static com.vh.ui.web.locators.MedicalEquipmentLocators.LBL_ADDPOPUPDATE;
import static com.vh.ui.web.locators.MedicalEquipmentLocators.LBL_ADDPOPUPEQUIPMENTISINUSE;
import static com.vh.ui.web.locators.MedicalEquipmentLocators.LBL_ADDPOPUPEQUIPMENTTYPE;
import static com.vh.ui.web.locators.MedicalEquipmentLocators.LBL_ADDPOPUPSOURCE;
import static com.vh.ui.web.locators.MedicalEquipmentLocators.LBL_ADDPOPUPSTATUS;
import static com.vh.ui.web.locators.MedicalEquipmentLocators.LBL_DATECOLUMNHEADER;
import static com.vh.ui.web.locators.MedicalEquipmentLocators.LBL_EQUIPMENTDESCRIPTIONCOLUMNHEADER;
import static com.vh.ui.web.locators.MedicalEquipmentLocators.LBL_INUSECOLUMNHEADER;
import static com.vh.ui.web.locators.MedicalEquipmentLocators.LBL_PAGEHEADER;
import static com.vh.ui.web.locators.MedicalEquipmentLocators.LBL_SOURCECOLUMNHEADER;
import static com.vh.ui.web.locators.MedicalEquipmentLocators.LBL_STATUSCOLUMNHEADER;
import static com.vh.ui.web.locators.MedicalEquipmentLocators.PLH_ADDPOPUPEQUIPMENTTYPE;
import static com.vh.ui.web.locators.MedicalEquipmentLocators.PLH_ADDPOPUPSOURCE;
import static com.vh.ui.web.locators.MedicalEquipmentLocators.PLH_ADDPOPUPSTATUS;
import static com.vh.ui.web.locators.MedicalEquipmentLocators.TBL_MEDICALEQUIPMENT;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

import org.openqa.selenium.By;
import org.openqa.selenium.TimeoutException;
import org.openqa.selenium.WebDriver;

import com.vh.ui.actions.ApplicationFunctions;
import com.vh.ui.exceptions.WaitException;
import com.vh.ui.page.base.WebPage;

import ru.yandex.qatools.allure.annotations.Step;

/*
 * @author Harvy Ackermans
 * @date   May 12, 2017
 * @class  MedicalEquipmentPage.java
 */

public class MedicalEquipmentPage extends WebPage
{
	String memberUID;

	ApplicationFunctions appFunctions;

	public MedicalEquipmentPage(WebDriver driver) throws WaitException {
		super(driver);

		appFunctions = new ApplicationFunctions(driver);
	}

	@Step("Delete all Medical Equipment for the given Patient")
	public void deleteMedicalEquipmentDatabase(String memberID) throws TimeoutException, WaitException, SQLException
	{
		memberUID = appFunctions.getMemberUIDFromMemberID(memberID);

		final String SQL_DELETE_PTME_PTME_PATIENT_MEDICAL_EQUIP = "DELETE PTME_PATIENT_MEDICAL_EQUIP WHERE PTME_MEM_UID = '" + memberUID + "'";
		appFunctions.queryDatabase(SQL_DELETE_PTME_PTME_PATIENT_MEDICAL_EQUIP);

		appFunctions.closeDatabaseConnection();
	}

	@Step("Verify the visibility of the Medical Equipment page header label")
	public boolean viewPageHeaderLabel() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_PAGEHEADER);
	}

	@Step("Verify the visibility of the Equipment Description column header label")
	public boolean viewEquipmentDescriptionColumnHeaderLabel() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_EQUIPMENTDESCRIPTIONCOLUMNHEADER);
	}

	@Step("Verify the visibility of the Source column header label")
	public boolean viewSourceColumnHeaderLabel() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_SOURCECOLUMNHEADER);
	}

	@Step("Verify the visibility of the Date column header label")
	public boolean viewDateColumnHeaderLabel() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_DATECOLUMNHEADER);
	}

	@Step("Verify the visibility of the Status column header label")
	public boolean viewStatusColumnHeaderLabel() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_STATUSCOLUMNHEADER);
	}

	@Step("Verify the Status drop down is editable")
	public boolean isStatusDropdownEditable() throws TimeoutException, WaitException
	{
		String attributeValueBefore;
		String attributeValueAfter;

		attributeValueBefore = webActions.getAttributeValue(VISIBILITY, CBO_FIRSTROWSTATUS, "ng-reflect-model");

		if (attributeValueBefore.equals("E"))
		{
			webActions.selectFromDropDown(VISIBILITY, CBO_FIRSTROWSTATUS, "Returned");
		} else
		{
			webActions.selectFromDropDown(VISIBILITY, CBO_FIRSTROWSTATUS, "Error");
		}

		attributeValueAfter = webActions.getAttributeValue(VISIBILITY, CBO_FIRSTROWSTATUS, "ng-reflect-model");

		if (attributeValueBefore.equals(attributeValueAfter))
		{
			return false;
		}
		else
		{
			return true;
		}		
	}

	@Step("Verify the success message is displayed")
	public boolean viewSuccessMessage() throws TimeoutException, WaitException
	{
		return appFunctions.verifySuccessMessage("Medical equipment have been saved successfully");
	}

	@Step("Verify the options of the STATUS combo box")
	public boolean verifyStatusComboBoxOptions() throws TimeoutException, WaitException
	{
		List<String> dropDownOptions = new ArrayList<String>();
		dropDownOptions.add("Delivered");
		dropDownOptions.add("Error");
		dropDownOptions.add("Ordered");
		dropDownOptions.add("Replaced");
		dropDownOptions.add("Returned");

		return appFunctions.verifyDropDownOptions(CBO_FIRSTROWSTATUS, dropDownOptions);
	}

	@Step("Verify the visibility of the In Use column header label")
	public boolean viewInUseColumnHeaderLabel() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_INUSECOLUMNHEADER);
	}

	@Step("Verify the In Use check box is editable")
	public boolean isInUseCheckboxEditable() throws TimeoutException, WaitException, InterruptedException
	{
		String attributeValueBefore;
		String attributeValueAfter;

		attributeValueBefore = webActions.getAttributeValue(VISIBILITY, CHK_FIRSTROWEQUIPMENTISINUSE, "class");

		webActions.click(VISIBILITY, CHK_FIRSTROWEQUIPMENTISINUSE);

		attributeValueAfter = webActions.getAttributeValue(VISIBILITY, CHK_FIRSTROWEQUIPMENTISINUSE, "class");

		if (attributeValueBefore.equals(attributeValueAfter))
		{
			return false;
		} else
		{
			return true;
		}
	}

	@Step("Verify the visibility of the ADD MEDICAL EQUIPMENT button")
	public boolean viewAddMedicalEquipmentButton() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, BTN_ADDMEDICALEQUIPMENT);
	}

	@Step("Click the ADD MEDICAL EQUIPMENT button")
	public void clickAddMedicalEquipmentButton() throws TimeoutException, WaitException
	{
		webActions.javascriptClick(BTN_ADDMEDICALEQUIPMENT);
	}

	@Step("Checks if a specific Medical Equipment is in the table")
	public boolean isMedicalEquipmentInTable() throws TimeoutException, WaitException
	{
		String[][] tableData = appFunctions.getTextFromTable(TBL_MEDICALEQUIPMENT, 5);

		DateFormat dateFormat = new SimpleDateFormat("M/d/yyyy");
		Date dateObject = new Date();

		for (String[] row : tableData)
		{
			if (row[0].equals("Bed Trapeze") && // If the data in the EQUIPMENT DESCRIPTION column equals "Bed Trapeze"
			        row[1].equals("VHProvided") && // If the data in the SOURCE column equals "VH Provided"
			        row[2].equals(dateFormat.format(dateObject))) // If the date in the DATE column equals the current date
			{
				return true;
			}
		}

		return false;
	}

	@Step("Checks if a specific Medical Equipment is in the table compared to the data from Excel")
	public boolean isMedicalEquipmentInTable(Map<String, String> map) throws TimeoutException, WaitException, InterruptedException
	{
		String equipmentDate;

		Thread.sleep(1000); // Pause to give time for the new Medical Equipment to be added to the table before we read the table

		String[][] tableData = appFunctions.getTextFromTable(TBL_MEDICALEQUIPMENT, 5);

		equipmentDate = appFunctions.adjustCurrentDateBy(map.get("EQUIPMENTDATE"), "M/d/yyyy");

		for (String[] row : tableData)
		{
			if (row[0].equals(map.get("EQUIPMENTTYPE")) && // If the data in the EQUIPMENT DESCRIPTION column equals the data from Excel
			        row[1].equals(map.get("SOURCE")) && // If the data in the SOURCE column equals the data from Excel
			        row[2].equals(equipmentDate)) // If the date in the DATE column equals the data from Excel
			{
				return true;
			}
		}

		return false;
	}

	@Step("Verify the Medical Equipment was added to the database correctly")
	public boolean verifyMedicalEquipmentDatabase(Map<String, String> map) throws TimeoutException, WaitException, InterruptedException, SQLException
	{
		final String SQL_SELECT_PTME_PATIENT_MEDICAL_EQUIP = "SELECT PTME_NOT_INUSE_YN FROM PTME_PATIENT_MEDICAL_EQUIP WHERE PTME_MEM_UID = '" + memberUID + "'";

		ResultSet queryResultSet = appFunctions.queryDatabase(SQL_SELECT_PTME_PATIENT_MEDICAL_EQUIP);

		queryResultSet.next();

		if (queryResultSet.getString("PTME_NOT_INUSE_YN").equals(map.get("EQUIPMENTINUSE")))
		{
			appFunctions.closeDatabaseConnection();

			return true;
		}
		else
		{
			appFunctions.closeDatabaseConnection();

			return false;
		}
	}

	@Step("Verify the visibility of the Add Medical Equipment popup")
	public boolean viewAddMedicalEquipmentPopup() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_ADDPOPUPADDMEDICALEQUIPMENT);
	}

	@Step("Verify the Add Medical Equipment popup has closed")
	public boolean viewAddMedicalEquipmentPopupClosed() throws TimeoutException, WaitException
	{
		return wait.waitForElementInvisible(driver, LBL_ADDPOPUPADDMEDICALEQUIPMENT);
	}

	@Step("Verify the visibility of the Add Medical Equipment popup CANCEL button")
	public boolean viewAddPopupCancelButton() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, BTN_ADDPOPUPCANCEL);
	}

	@Step("Verify the visibility of the Add Medical Equipment popup ADD button")
	public boolean viewAddPopupAddButton() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, BTN_ADDPOPUPADD);
	}

	@Step("Click the Add Medical Equipment popup ADD button")
	public void clickAddPopupAddButton() throws TimeoutException, WaitException
	{
		webActions.click(VISIBILITY, BTN_ADDPOPUPADD);
	}

	@Step("Verify if the add popup ADD button is enabled")
	public boolean isAddPopupAddButtonEnabled() throws TimeoutException, WaitException
	{
		return webActions.isElementEnabledLocatedBy(BTN_ADDPOPUPADD);
	}

	@Step("Verify the visibility of the Add Medical Equipment popup DATE label")
	public boolean viewAddPopupDateLabel() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_ADDPOPUPDATE);
	}

	@Step("Verify the visibility of the Add Medical Equipment popup DATE picker")
	public boolean viewAddPopupDatePicker() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, CAL_ADDPOPUPDATE);
	}

	@Step("Verify the visibility of the Add Medical Equipment popup DATE picker button")
	public boolean viewAddPopupDatePickerButton() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, BTN_ADDPOPUPDATE);
	}

	@Step("Verify the Add Medical Equipment popup default date in the DATE picker is equal to the current date")
	public boolean isAddPopupDefaultDateCurrentDate() throws TimeoutException, WaitException, InterruptedException
	{
		return appFunctions.isCalendarDateEqualToCurrentDate(CAL_ADDPOPUPDATE);
	}

	@Step("Click the Add Medical Equipment popup date picker button")
	public void clickAddPopupDatePickerButton() throws TimeoutException, WaitException
	{
		webActions.click(VISIBILITY, BTN_ADDPOPUPDATE);
	}

	@Step("Verify the Add Medical Equipment popup enabled date range in the DATE picker is valid")
	public boolean isAddPopupEnabledDateRangeValid() throws TimeoutException, WaitException, InterruptedException
	{
		return appFunctions.isCalendarEnabledDateRangeValid(CAL_ADDPOPUPDATE);
	}

	@Step("Select the Add Medical Equipment popup current date from the DATE picker")
	public void selectAddPopupCurrentDateFromCalendar() throws TimeoutException, WaitException, InterruptedException
	{
		DateFormat dateFormat = new SimpleDateFormat("d");
		Date dateObject = new Date();
		String currentDay = dateFormat.format(dateObject);

		try
		{
			// Determine if the currently displayed month is the current month by checking if the previous month button is disabled.
			// If the previous month button is disabled, that means the previous month is displayed, thus we need to click the next month button to display the current month.
			// If the previous month button is enabled, that means the current month is displayed and the findElement method will fail causing the flow to go directly to the Catch,
			// bypassing the next month button click.
			By calendarPrevMMonthDisabledButton = By
			        .xpath(CAL_ADDPOPUPDATE.toString().substring(10) + "/../..//div[@style='float:left']//button[@class='headerbtn mydpicon icon-mydpleft headerbtndisabled']");
			driver.findElement(calendarPrevMMonthDisabledButton);
			By calendarNextMMonthButton = By.xpath(CAL_ADDPOPUPDATE.toString().substring(10) + "/../..//div[@style='float:left']//button[@class='headerbtn mydpicon icon-mydpright headerbtnenabled']");
			webActions.click(VISIBILITY, calendarNextMMonthButton);
		}
		catch (Exception ex)
		{
			
		}
		
		appFunctions.selectDateFromCalendarAsd(CAL_ADDPOPUPDATE, currentDay);
	}

	@Step("Verify the visibility of the Add Medical Equipment popup SOURCE label")
	public boolean viewAddPopupSourceLabel() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_ADDPOPUPSOURCE);
	}

	@Step("Verify the visibility of the Add Medical Equipment popup SOURCE combo box")
	public boolean viewAddPopupSourceComboBox() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, CBO_ADDPOPUPSOURCE);
	}

	@Step("Verify the visibility of the Add Medical Equipment popup SOURCE placeholder")
	public boolean viewAddPopupSourcePlaceholder() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, PLH_ADDPOPUPSOURCE);
	}

	@Step("Verify the options of the Add Medical Equipment popup SOURCE combo box")
	public boolean verifyAddPopupSourceComboBoxOptions() throws TimeoutException, WaitException
	{
		List<String> dropDownOptions = new ArrayList<String>();
		dropDownOptions.add("Select a value");
		dropDownOptions.add("Other");
		dropDownOptions.add("VH Provided");

		return appFunctions.verifyDropDownOptions(CBO_ADDPOPUPSOURCE, dropDownOptions);
	}

	@Step("Select an option form the Add Medical Equipment popup SOURCE combo box")
	public void selectAddPopupSourceComboBox(String optionToSelect) throws TimeoutException, WaitException
	{
		webActions.selectFromDropDown(VISIBILITY, CBO_ADDPOPUPSOURCE, optionToSelect);
	}

	@Step("Verify the visibility of the Add Medical Equipment popup Equipment is in Use label")
	public boolean viewAddPopupEquipmentIsInUseLabel() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_ADDPOPUPEQUIPMENTISINUSE);
	}

	@Step("Verify the visibility of the Add Medical Equipment popup Equipment is in Use check box")
	public boolean viewAddPopupEquipmentIsInUseCheckBox() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, CHK_ADDPOPUPEQUIPMENTISINUSE);
	}

	@Step("Check the Add Medical Equipment popup Equipment is in Use check box")
	public void checkAddPopupEquipmentIsInUseCheckBox() throws TimeoutException, WaitException
	{
		webActions.click(VISIBILITY, CHK_ADDPOPUPEQUIPMENTISINUSE);
	}

	@Step("Verify the visibility of the Add Medical Equipment popup EQUIPMENT TYPE label")
	public boolean viewAddPopupEquipmentTypeLabel() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_ADDPOPUPEQUIPMENTTYPE);
	}

	@Step("Verify the visibility of the Add Medical Equipment popup EQUIPMENT TYPE combo box")
	public boolean viewAddPopupEquipmentTypeComboBox() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, CBO_ADDPOPUPEQUIPMENTTYPE);
	}

	@Step("Verify the visibility of the Add Medical Equipment popup EQUIPMENT TYPE placeholder")
	public boolean viewAddpopupEquipmentTypePlaceholder() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, PLH_ADDPOPUPEQUIPMENTTYPE);
	}

	@Step("Verify the options of the Add Medical Equipment popup EQUIPMENT TYPE combo box")
	public boolean verifyAddPopupEquipmentTypeComboBoxOptions() throws TimeoutException, WaitException
	{
		List<String> dropDownOptions = new ArrayList<String>();
		dropDownOptions.add("Select a value");
		dropDownOptions.add("Bed Trapeze");
		dropDownOptions.add("BP Machine");
		dropDownOptions.add("Cane");
		dropDownOptions.add("Commode");
		dropDownOptions.add("Digital Thermometer");
		dropDownOptions.add("Glucometer");
		dropDownOptions.add("Hospital Bed");
		dropDownOptions.add("Hoyer Lift");
		dropDownOptions.add("Incontinent Supplies");
		dropDownOptions.add("Nebulizer");
		dropDownOptions.add("Ostomy Care Supplies");
		dropDownOptions.add("Oxygen");
		dropDownOptions.add("PD cycler");
		dropDownOptions.add("Scale");
		dropDownOptions.add("Slider Board");
		dropDownOptions.add("Stethoscope");
		dropDownOptions.add("Tub/Shower Chair");
		dropDownOptions.add("Walker");
		dropDownOptions.add("Wheelchair");
		dropDownOptions.add("Wound Care Supplies");
		dropDownOptions.add("Wound Vac");

		return appFunctions.verifyDropDownOptions(CBO_ADDPOPUPEQUIPMENTTYPE, dropDownOptions);
	}

	@Step("Select an option form the Add Medical Equipment popup EQUIPMENT TYPE combo box")
	public void selectAddPopupEquipmentTypeComboBox(String optionToSelect) throws TimeoutException, WaitException
	{
		webActions.selectFromDropDown(VISIBILITY, CBO_ADDPOPUPEQUIPMENTTYPE, optionToSelect);
	}

	@Step("Verify the visibility of the Add Medical Equipment popup STATUS label")
	public boolean viewAddPopupStatusLabel() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_ADDPOPUPSTATUS);
	}

	@Step("Verify the visibility of the Add Medical Equipment popup STATUS combo box")
	public boolean viewAddPopupStatusComboBox() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, CBO_ADDPOPUPSTATUS);
	}

	@Step("Verify the visibility of the Add Medical Equipment popup STATUS placeholder")
	public boolean viewAddpopupStatusPlaceholder() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, PLH_ADDPOPUPSTATUS);
	}

	@Step("Verify the options of the Add Medical Equipment popup STATUS combo box")
	public boolean verifyAddPopupStatusComboBoxOptions() throws TimeoutException, WaitException
	{
		List<String> dropDownOptions = new ArrayList<String>();
		dropDownOptions.add("Select a value");
		dropDownOptions.add("Delivered");
		dropDownOptions.add("Error");
		dropDownOptions.add("Ordered");
		dropDownOptions.add("Replaced");
		dropDownOptions.add("Returned");

		return appFunctions.verifyDropDownOptions(CBO_ADDPOPUPSTATUS, dropDownOptions);
	}

	@Step("Select an option from the Add Medical Equipment popup STATUS combo box")
	public void selectAddPopupStatusComboBox(String optionToSelect) throws TimeoutException, WaitException
	{
		webActions.selectFromDropDown(VISIBILITY, CBO_ADDPOPUPSTATUS, optionToSelect);
	}

	/**
	 * Adds one Medical Equipment to the Medical Equipment table
	 * 
	 * @param dateToSelect
	 *            The day to select in the date picker
	 * @param source
	 *            The source to select in the SOURCE drop down
	 * @param equipmentType
	 *            The equipment type to select in the EQUIPMENT TYPE drop down
	 * @param status
	 *            The status to select in the STATUS drop down
	 * @param equipmentInUse
	 *            Whether or not to select the Equipment is in Use check box
	 * @throws TimeoutException
	 * @throws WaitException
	 * @throws InterruptedException
	 */
	@Step("Adds one Medical Equipment to the Medical Equipment table")
	public void addMedicalEquipment(String dateToSelect, String source, String equipmentType, String status, boolean equipmentInUse) throws TimeoutException, WaitException, InterruptedException
	{
		clickAddMedicalEquipmentButton();
		
		clickAddPopupDatePickerButton();
		appFunctions.selectDateFromCalendarAsd(CAL_ADDPOPUPDATE, dateToSelect);
		selectAddPopupSourceComboBox(source);
		selectAddPopupEquipmentTypeComboBox(equipmentType);
		selectAddPopupStatusComboBox(status);
		
		if (equipmentInUse)
		{
			checkAddPopupEquipmentIsInUseCheckBox();
		}

		clickAddPopupAddButton();
	}

	@Step("Verify the EQUIPMENT DESCRIPTION column sorts ascendingly")
	public boolean isTableSortableByEquipmentDescriptionAscending() throws TimeoutException, WaitException
	{
		webActions.click(VISIBILITY, LBL_EQUIPMENTDESCRIPTIONCOLUMNHEADER);

		return appFunctions.isColumnSorted(TBL_MEDICALEQUIPMENT, 1, "A", "text");
	}

	@Step("Verify the EQUIPMENT DESCRIPTION column sorts dscendingly")
	public boolean isTableSortableByEquipmentDescriptionDescending() throws TimeoutException, WaitException
	{
		webActions.click(VISIBILITY, LBL_EQUIPMENTDESCRIPTIONCOLUMNHEADER);

		return appFunctions.isColumnSorted(TBL_MEDICALEQUIPMENT, 1, "D", "text");
	}

	@Step("Verify the SOURCE column sorts ascendingly")
	public boolean isTableSortableBySourceAscending() throws TimeoutException, WaitException
	{
		webActions.click(VISIBILITY, LBL_SOURCECOLUMNHEADER);

		return appFunctions.isColumnSorted(TBL_MEDICALEQUIPMENT, 2, "A", "text");
	}

	@Step("Verify the SOURCE column sorts dscendingly")
	public boolean isTableSortableBySourceDescending() throws TimeoutException, WaitException
	{
		webActions.click(VISIBILITY, LBL_SOURCECOLUMNHEADER);

		return appFunctions.isColumnSorted(TBL_MEDICALEQUIPMENT, 2, "D", "text");
	}

	@Step("Verify the MODIFIED column sorts ascendingly")
	public boolean isTableSortableByModifiedAscending() throws TimeoutException, WaitException
	{
		webActions.click(VISIBILITY, LBL_DATECOLUMNHEADER);

		return appFunctions.isColumnSorted(TBL_MEDICALEQUIPMENT, 3, "A", "text");
	}

	@Step("Verify the MODIFIED column sorts dscendingly")
	public boolean isTableSortableByModifiedDescending() throws TimeoutException, WaitException
	{
		webActions.click(VISIBILITY, LBL_DATECOLUMNHEADER);

		return appFunctions.isColumnSorted(TBL_MEDICALEQUIPMENT, 3, "D", "text");
	}

	@Step("Verify the STATUS column sorts ascendingly")
	public boolean isTableSortableByStatusAscending() throws TimeoutException, WaitException
	{
		webActions.click(VISIBILITY, LBL_STATUSCOLUMNHEADER);

		return appFunctions.isColumnSorted(TBL_MEDICALEQUIPMENT, 4, "A", "dropdown");
	}

	@Step("Verify the STATUS column sorts dscendingly")
	public boolean isTableSortableByStatusDescending() throws TimeoutException, WaitException
	{
		webActions.click(VISIBILITY, LBL_STATUSCOLUMNHEADER);

		return appFunctions.isColumnSorted(TBL_MEDICALEQUIPMENT, 4, "D", "dropdown");
	}

	@Step("Verify the IN USE column sorts ascendingly")
	public boolean isTableSortableByInUseAscending() throws TimeoutException, WaitException
	{
		webActions.click(VISIBILITY, LBL_INUSECOLUMNHEADER);

		return appFunctions.isColumnSorted(TBL_MEDICALEQUIPMENT, 5, "A", "checkbox");
	}

	@Step("Verify the IN USE column sorts dscendingly")
	public boolean isTableSortableByInUseDescending() throws TimeoutException, WaitException
	{
		webActions.click(VISIBILITY, LBL_INUSECOLUMNHEADER);

		return appFunctions.isColumnSorted(TBL_MEDICALEQUIPMENT, 5, "D", "checkbox");
	}
}