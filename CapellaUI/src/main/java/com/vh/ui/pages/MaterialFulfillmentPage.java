package com.vh.ui.pages;

import static com.vh.ui.web.locators.MaterialFulfillmentLocators.BTN_MATERIALSPOPUP1NEXTSTEP;
import static com.vh.ui.web.locators.MaterialFulfillmentLocators.BTN_MATERIALSPOPUP2DATEREQUESTED;
import static com.vh.ui.web.locators.MaterialFulfillmentLocators.BTN_MATERIALSPOPUP2FULFILLEDON;
import static com.vh.ui.web.locators.MaterialFulfillmentLocators.BTN_MATERIALSPOPUP2NEXTSTEP;
import static com.vh.ui.web.locators.MaterialFulfillmentLocators.BTN_ORDERMATERIAL;
import static com.vh.ui.web.locators.MaterialFulfillmentLocators.CAL_MATERIALSPOPUP2DATEREQUESTED;
import static com.vh.ui.web.locators.MaterialFulfillmentLocators.CAL_MATERIALSPOPUP2FULFILLEDON;
import static com.vh.ui.web.locators.MaterialFulfillmentLocators.CBO_MATERIALSPOPUP2FULFILLEDBY;
import static com.vh.ui.web.locators.MaterialFulfillmentLocators.CBO_MATERIALSPOPUP2ORDERTYPE;
import static com.vh.ui.web.locators.MaterialFulfillmentLocators.CBO_MATERIALSPOPUP2REQUESTEDBY;
import static com.vh.ui.web.locators.MaterialFulfillmentLocators.CHK_MATERIALSPOPUP2FOLLOWUP;

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
 * @date   August 7, 2017
 * @class  MaterialFulfillmentPage.java
 */

public class MaterialFulfillmentPage extends WebPage
{
	ApplicationFunctions appFunctions;

	public MaterialFulfillmentPage(WebDriver driver) throws WaitException {
		super(driver);

		appFunctions = new ApplicationFunctions(driver);
	}

	@Step("Orders a Material and adds it to the table")
	public void orderMaterial(Map<String, String> map) throws TimeoutException, WaitException, InterruptedException
	{
		String currentDayMinusX = null;

		clickOrderMaterialButton();

		Thread.sleep(7000); // Give time for the list of Materials to load

		clickMaterialsPopup1PlusIcon(map.get("MATERIAL"));
		clickMaterialsPopup1NextStepButton();

		clickMaterialsPopup2DateRequestedDatePickerButton();
		currentDayMinusX = appFunctions.adjustCurrentDateBy(map.get("DATEREQUESTED"), "d");
		appFunctions.selectDateFromCalendarAsd(CAL_MATERIALSPOPUP2DATEREQUESTED, currentDayMinusX);
		selectMaterialsPopup2RequestedByComboBox(map.get("REQUESTEDBY"));

		if (map.get("FOLLOWUP") != null)
		{
			checkMaterialsPopup2FollowUpCheckBox(map.get("FOLLOWUP"));
		}

		if (map.get("ORDERTYPE") != null)
		{
			selectMaterialsPopup2OrderTypeComboBox(map.get("ORDERTYPE"));
		}

		if (map.get("ORDERTYPE").equals("In Person"))
		{
			selectMaterialsPopup2FulfilledByComboBox(map.get("FULFILLEDBY"));
			clickMaterialsPopup2FulfilledOnDatePickerButton();
			currentDayMinusX = appFunctions.adjustCurrentDateBy(map.get("FULFILLEDON"), "d");
			appFunctions.selectDateFromCalendarAsd(CAL_MATERIALSPOPUP2FULFILLEDON, currentDayMinusX);
		}

		clickMaterialsPopup2NextStepButton();
	}

	@Step("Click the ORDER MATERIAL button")
	public void clickOrderMaterialButton() throws TimeoutException, WaitException
	{
		webActions.javascriptClick(BTN_ORDERMATERIAL);
	}

	@Step("Click the Materials popup 1 plus icon for the {0} MATERIAL")
	public void clickMaterialsPopup1PlusIcon(String value) throws TimeoutException, WaitException
	{
		final By BTN_MATERIALSPOPUP1PLUSSSIGN = By.xpath("//div[@class='modal-content']//div[text()='" + value + "']/..//div[@class='divTableCell order-material-icon-column icon-add']");

		webActions.javascriptClick(BTN_MATERIALSPOPUP1PLUSSSIGN);
	}

	@Step("Click the Materials popup 1 NEXT STEP button")
	public void clickMaterialsPopup1NextStepButton() throws TimeoutException, WaitException
	{
		webActions.javascriptClick(BTN_MATERIALSPOPUP1NEXTSTEP);
	}

	@Step("Click the Materials popup 2 DATE REQUESTED date picker button")
	public void clickMaterialsPopup2DateRequestedDatePickerButton() throws TimeoutException, WaitException
	{
		webActions.click(VISIBILITY, BTN_MATERIALSPOPUP2DATEREQUESTED);
	}

	@Step("Select an option form the Material popup 2 REQUESTED BY combo box")
	public void selectMaterialsPopup2RequestedByComboBox(String value) throws TimeoutException, WaitException
	{
		webActions.selectFromDropDownOld(VISIBILITY, CBO_MATERIALSPOPUP2REQUESTEDBY, value);
	}

	@Step("Enter {0} in the Materials popup 2 Follow-up check box")
	public void checkMaterialsPopup2FollowUpCheckBox(String value) throws TimeoutException, WaitException
	{
		if (value.equals("Y"))
		{
			webActions.click(VISIBILITY, CHK_MATERIALSPOPUP2FOLLOWUP);
		}
	}

	@Step("Select an option form the Material popup 2 ORDER TYPE combo box")
	public void selectMaterialsPopup2OrderTypeComboBox(String value) throws TimeoutException, WaitException
	{
		webActions.selectFromDropDownOld(VISIBILITY, CBO_MATERIALSPOPUP2ORDERTYPE, value);
	}

	@Step("Select an option form the Material popup 2 FULFILLED BY combo box")
	public void selectMaterialsPopup2FulfilledByComboBox(String value) throws TimeoutException, WaitException
	{
		webActions.selectFromDropDownOld(VISIBILITY, CBO_MATERIALSPOPUP2FULFILLEDBY, value);
	}

	@Step("Click the Materials popup 2 FULFILLED ON date picker button")
	public void clickMaterialsPopup2FulfilledOnDatePickerButton() throws TimeoutException, WaitException
	{
		webActions.click(VISIBILITY, BTN_MATERIALSPOPUP2FULFILLEDON);
	}

	@Step("Click the Materials popup 2 NEXT STEP button")
	public void clickMaterialsPopup2NextStepButton() throws TimeoutException, WaitException
	{
		webActions.javascriptClick(BTN_MATERIALSPOPUP2NEXTSTEP);
	}
}