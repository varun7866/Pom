package com.vh.ui.pages;

import static com.vh.ui.web.locators.ReferralsLocators.BTN_ADDAREFERRAL;
import static com.vh.ui.web.locators.ReferralsLocators.BTN_NEWREFERRALPOPUPAPPOINTMENTREFERRALDATE;
import static com.vh.ui.web.locators.ReferralsLocators.BTN_NEWREFERRALSAVE;
import static com.vh.ui.web.locators.ReferralsLocators.CAL_NEWREFERRALPOPUPAPPOINTMENTTABREFERRALDATE;
import static com.vh.ui.web.locators.ReferralsLocators.CBO_NEWREFERRALPOPUPPROVIDERSTEAMTABPROVIDERSTEAM;
import static com.vh.ui.web.locators.ReferralsLocators.CHK_NEWREFERRALPOPUPREASONS;
import static com.vh.ui.web.locators.ReferralsLocators.LBL_REFERRALS;
import static com.vh.ui.web.locators.ReferralsLocators.MNU_REFERRALSMENU;
import static com.vh.ui.web.locators.ReferralsLocators.TAB_NEWREFERRALPOPUPAPPOINTMENT;
import static com.vh.ui.web.locators.ReferralsLocators.TAB_NEWREFERRALPOPUPREASONS;

import java.util.Map;

import org.openqa.selenium.TimeoutException;
import org.openqa.selenium.WebDriver;

import com.vh.ui.actions.ApplicationFunctions;
import com.vh.ui.exceptions.WaitException;
import com.vh.ui.page.base.WebPage;

import ru.yandex.qatools.allure.annotations.Step;

/*
 * @author Harshida Patel
 * @date   August 1, 2017
 * @class  ReferralsPage.java
 */

public class ReferralsPage extends WebPage
{
	ApplicationFunctions appFunctions;

	public ReferralsPage(WebDriver driver) throws WaitException {
		super(driver);

		appFunctions = new ApplicationFunctions(driver);
	}

	@Step("Verify the visibility of the Referrals menu")
	public boolean viewReferralsPageMenu() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, MNU_REFERRALSMENU);
	}

	@Step("Verify the visibility of the Referrals page header label")
	public boolean viewReferralsPageHeader() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_REFERRALS);
	}
	
	@Step("Verify the visibility of the Referrals page header label")
	public void AddReferral(Map<String, String> map) throws TimeoutException, WaitException, InterruptedException
	{
		String currentDayMinusX;

		clickAddAReferral();
		selectNewReferralPopupProvidersTeamTabProvidersTeamComboBox(map.get("PROVIDERSTEAM"));
		clickNewReferralPopupAppointmentTab();
		clickNewReferralPopupAppointmentTabDatePickerButton();
		currentDayMinusX = appFunctions.adjustCurrentDateBy(map.get("REFERRALDATE"), "d");
		appFunctions.selectDateFromCalendarAsd(CAL_NEWREFERRALPOPUPAPPOINTMENTTABREFERRALDATE, currentDayMinusX);
		clickNewReferralPopupReasonsTab();
		clickNewReferralPopupReasonsTabReasons();
		clickNewReferralSave();

	}

	@Step("Verify click on Add a Referral button")
	public void clickAddAReferral() throws TimeoutException, WaitException
	{
		webActions.javascriptClick(BTN_ADDAREFERRAL);
	}

	@Step("Select New Referral Popup Providers/Team tab, Providers/Team Combo box")
	public void selectNewReferralPopupProvidersTeamTabProvidersTeamComboBox(String value) throws TimeoutException, WaitException
	{
		webActions.selectFromDropDownOld(VISIBILITY, CBO_NEWREFERRALPOPUPPROVIDERSTEAMTABPROVIDERSTEAM, value);
	}

	@Step("Click on New Referral Popup 2.APPOINTMENT Tab")
	public void clickNewReferralPopupAppointmentTab() throws TimeoutException, WaitException
	{
		webActions.click(VISIBILITY, TAB_NEWREFERRALPOPUPAPPOINTMENT);
	}

	@Step("Click the New Referral popup 2.APPOINTMENT Tab REFERRAL DATE date picker button")
	public void clickNewReferralPopupAppointmentTabDatePickerButton() throws TimeoutException, WaitException
	{
		webActions.click(VISIBILITY, BTN_NEWREFERRALPOPUPAPPOINTMENTREFERRALDATE);
	}

	//

	@Step("Click on New Referral Popup 3.REASONS Tab")
	public void clickNewReferralPopupReasonsTab() throws TimeoutException, WaitException
	{
		webActions.click(VISIBILITY, TAB_NEWREFERRALPOPUPREASONS);
	}

	@Step("Click on New Referral Popup 3.REASONS Tab Reasons")
	public void clickNewReferralPopupReasonsTabReasons() throws TimeoutException, WaitException
	{
		webActions.click(VISIBILITY, CHK_NEWREFERRALPOPUPREASONS);
	}

	@Step("Click on New Referral SAVE button")
	public void clickNewReferralSave() throws TimeoutException, WaitException
	{
		webActions.click(VISIBILITY, BTN_NEWREFERRALSAVE);
	}

}