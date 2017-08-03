package com.vh.ui.pages;

import static com.vh.ui.web.locators.ProvidersTeamLocators.BTN_ADDATEAMMEMBER;
import static com.vh.ui.web.locators.ProvidersTeamLocators.CBO_NEWTEAMPOPUPTEAMTYPE;

import java.util.Map;

import org.openqa.selenium.TimeoutException;
import org.openqa.selenium.WebDriver;

import com.vh.ui.actions.ApplicationFunctions;
import com.vh.ui.exceptions.WaitException;
import com.vh.ui.page.base.WebPage;

import ru.yandex.qatools.allure.annotations.Step;

/*
 * @author Harvy Ackermans
 * @date   August 2, 2017
 * @class  ProviderTeamPage.java
 */

public class ProvidersTeamPage extends WebPage
{
	ApplicationFunctions appFunctions;

	public ProvidersTeamPage(WebDriver driver) throws WaitException {
		super(driver);

		appFunctions = new ApplicationFunctions(driver);
	}

	@Step("Adds a team member to the table")
	public void addATeamMember(Map<String, String> map) throws TimeoutException, WaitException, InterruptedException
	{
		Thread.sleep(2000); // Give time for the Providers and Team screen to display

		clickAddATeamMemberButton();
		selectNewTeamPopupTeamTypeComboBox(map.get("TEAMTYPE"));
	}

	@Step("Click the ADD A TEAM MEMBER button")
	public void clickAddATeamMemberButton() throws TimeoutException, WaitException
	{
		webActions.click(VISIBILITY, BTN_ADDATEAMMEMBER);
	}

	@Step("Select an option form the New Team popup TEAM TYPE combo box")
	public void selectNewTeamPopupTeamTypeComboBox(String optionToSelect) throws TimeoutException, WaitException
	{
		webActions.selectFromDropDown(VISIBILITY, CBO_NEWTEAMPOPUPTEAMTYPE, optionToSelect);
	}
}