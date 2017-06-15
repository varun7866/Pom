package com.vh.ui.pages;

import static com.vh.ui.web.locators.CurrentLabsLocators.BTN_ADDLAB;
import static com.vh.ui.web.locators.CurrentLabsLocators.BTN_ADDPOPUPCANCEL;
import static com.vh.ui.web.locators.CurrentLabsLocators.BTN_ADDPOPUPSAVE;
import static com.vh.ui.web.locators.CurrentLabsLocators.LBL_ADDPOPUPADDLABRESULTS;
import static com.vh.ui.web.locators.CurrentLabsLocators.LBL_PAGEHEADER;
import static com.vh.ui.web.locators.MedicalEquipmentLocators.BTN_ADDPOPUPDATE;
import static com.vh.ui.web.locators.MedicalEquipmentLocators.CAL_ADDPOPUPDATE;
import static com.vh.ui.web.locators.MedicalEquipmentLocators.LBL_ADDPOPUPDATE;

import org.openqa.selenium.TimeoutException;
import org.openqa.selenium.WebDriver;

import com.vh.ui.actions.ApplicationFunctions;
import com.vh.ui.exceptions.WaitException;
import com.vh.ui.page.base.WebPage;

import ru.yandex.qatools.allure.annotations.Step;

/*
 * @author Harvy Ackermans
 * @date   June 14, 2017
 * @class  CurrentLabsPage.java
 */

public class CurrentLabsPage extends WebPage
{
	ApplicationFunctions appFunctions;

	public CurrentLabsPage(WebDriver driver) throws WaitException {
		super(driver);

		appFunctions = new ApplicationFunctions(driver);
	}

	@Step("Verify the visibility of the Current Labs page header label")
	public boolean viewPageHeaderLabel() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_PAGEHEADER);
	}

	@Step("Verify the visibility of the ADD LAB button")
	public boolean viewAddLabButton() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, BTN_ADDLAB);
	}

	@Step("Click the ADD LAB button")
	public void clickAddLabButton() throws TimeoutException, WaitException
	{
		webActions.click(CLICKABILITY, BTN_ADDLAB);
	}

	@Step("Verify the visibility of the Add Lab Results popup")
	public boolean viewAddLabResultsPopup() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_ADDPOPUPADDLABRESULTS);
	}

	@Step("Verify the visibility of the Add Labs Results popup CANCEL button")
	public boolean viewAddPopupCancelButton() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, BTN_ADDPOPUPCANCEL);
	}

	@Step("Verify the visibility of the Add Lab Results popup ADD button")
	public boolean viewAddPopupSaveButton() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, BTN_ADDPOPUPSAVE);
	}

	@Step("Verify the visibility of the Add Lab Results popup APPLY THIS DATE TO ALL VALUES label")
	public boolean viewAddPopupApplyThisDateToAllValuesLabel() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_ADDPOPUPDATE);
	}

	@Step("Verify the visibility of the Add Lab Results popup APPLY THIS DATE TO ALL VALUES picker")
	public boolean viewAddPopupDatePicker() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, CAL_ADDPOPUPDATE);
	}

	@Step("Verify the visibility of the Add Lab Results popup APPLY THIS DATE TO ALL VALUES picker button")
	public boolean viewAddPopupDatePickerButton() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, BTN_ADDPOPUPDATE);
	}
}