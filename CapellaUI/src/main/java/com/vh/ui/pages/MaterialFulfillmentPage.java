package com.vh.ui.pages;

import static com.vh.ui.web.locators.MaterialFulfillmentLocators.BTN_ORDERMATERIAL;

import java.util.Map;

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
		clickOrderMaterialButton();

		// if (map.get("TEAMTYPE") != null)
		// {
			// selectNewTeamPopupTeamTypeComboBox(map.get("TEAMTYPE"));
		// }
	}

	@Step("Click the ORDER MATERIAL button")
	public void clickOrderMaterialButton() throws TimeoutException, WaitException
	{
		webActions.javascriptClick(BTN_ORDERMATERIAL);
	}
}