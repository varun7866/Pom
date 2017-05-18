package com.vh.ui.pages;

import static com.vh.ui.web.locators.MedicalEquipmentLocators.BTN_ADDMEDICALEQUIPMENT;
import static com.vh.ui.web.locators.MedicalEquipmentLocators.BTN_ADDPOPUPADD;
import static com.vh.ui.web.locators.MedicalEquipmentLocators.BTN_ADDPOPUPCANCEL;
import static com.vh.ui.web.locators.MedicalEquipmentLocators.BTN_ADDPOPUPDATE;
import static com.vh.ui.web.locators.MedicalEquipmentLocators.CAL_ADDPOPUPDATE;
import static com.vh.ui.web.locators.MedicalEquipmentLocators.CBO_ADDPOPUPEQUIPMENTTYPE;
import static com.vh.ui.web.locators.MedicalEquipmentLocators.CBO_ADDPOPUPSOURCE;
import static com.vh.ui.web.locators.MedicalEquipmentLocators.CBO_ADDPOPUPSTATUS;
import static com.vh.ui.web.locators.MedicalEquipmentLocators.CHK_ADDPOPUPEQUIPMENTISINUSE;
import static com.vh.ui.web.locators.MedicalEquipmentLocators.LBL_ADDMEDICALEQUIPMENT;
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
	ApplicationFunctions appFunctions;

	public MedicalEquipmentPage(WebDriver driver) throws WaitException {
		super(driver);

		appFunctions = new ApplicationFunctions(driver);
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

	@Step("Verify the visibility of the In Use column header label")
	public boolean viewInUseColumnHeaderLabel() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_INUSECOLUMNHEADER);
	}

	@Step("Verify the visibility of the ADD MEDICAL EQUIPMENT button")
	public boolean viewAddMedicalEquipmentButton() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, BTN_ADDMEDICALEQUIPMENT);
	}

	@Step("Click the ADD MEDICAL EQUIPMENT button")
	public void clickAddMedicalEquipmentButton() throws TimeoutException, WaitException
	{
		webActions.click(VISIBILITY, BTN_ADDMEDICALEQUIPMENT);
	}

	@Step("Verify the visibility of the Add Medical Equipment popup")
	public boolean viewAddMedicalEquipmentPopup() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_ADDMEDICALEQUIPMENT);
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

	@Step("Verify the Add Medical Equipment popup date range in the DATE picker is valid")
	public boolean isAddPopupDateRangeValid() throws TimeoutException, WaitException, InterruptedException
	{
		return appFunctions.isCalendarDateRangeValid(CAL_ADDPOPUPDATE);
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

	@Step("Select an option form the Add Medical Equipment popup STATUS combo box")
	public void selectAddPopupStatusComboBox(String optionToSelect) throws TimeoutException, WaitException
	{
		webActions.selectFromDropDown(VISIBILITY, CBO_ADDPOPUPSTATUS, optionToSelect);
	}
}