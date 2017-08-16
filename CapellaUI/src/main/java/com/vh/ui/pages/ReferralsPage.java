package com.vh.ui.pages;

import static com.vh.ui.web.locators.ReferralsLocators.BTN_ADDAREFERRAL;
import static com.vh.ui.web.locators.ReferralsLocators.BTN_NEWREFERRALAPPOINTMENT;
import static com.vh.ui.web.locators.ReferralsLocators.BTN_NEWREFERRALCANCEL;
import static com.vh.ui.web.locators.ReferralsLocators.BTN_NEWREFERRALNEXT;
import static com.vh.ui.web.locators.ReferralsLocators.BTN_NEWREFERRALPOPUPAPPOINTMENTREFERRALDATE;
import static com.vh.ui.web.locators.ReferralsLocators.BTN_NEWREFERRALPROVIDERSTEAM;
import static com.vh.ui.web.locators.ReferralsLocators.BTN_NEWREFERRALREASONS;
import static com.vh.ui.web.locators.ReferralsLocators.CAL_NEWREFERRALPOPUPAPPOINTMENTTABREFERRALDATE;
import static com.vh.ui.web.locators.ReferralsLocators.CBO_NEWREFERRALPOPUPAPTSUITE;
import static com.vh.ui.web.locators.ReferralsLocators.CBO_NEWREFERRALPOPUPCITY;
import static com.vh.ui.web.locators.ReferralsLocators.CBO_NEWREFERRALPOPUPFAX;
import static com.vh.ui.web.locators.ReferralsLocators.CBO_NEWREFERRALPOPUPPHONE;
import static com.vh.ui.web.locators.ReferralsLocators.CBO_NEWREFERRALPOPUPPROVIDERNAME;
import static com.vh.ui.web.locators.ReferralsLocators.CBO_NEWREFERRALPOPUPPROVIDERSTEAMTABPROVIDERSTEAM;
import static com.vh.ui.web.locators.ReferralsLocators.CBO_NEWREFERRALPOPUPREFFEREDTO;
import static com.vh.ui.web.locators.ReferralsLocators.CBO_NEWREFERRALPOPUPSTATE;
import static com.vh.ui.web.locators.ReferralsLocators.CBO_NEWREFERRALPOPUPSTREET;
import static com.vh.ui.web.locators.ReferralsLocators.CBO_NEWREFERRALPOPUPZIP;
import static com.vh.ui.web.locators.ReferralsLocators.CHK_NEWREFERRALPOPUPADDNEWPROVIDER;
import static com.vh.ui.web.locators.ReferralsLocators.CHK_NEWREFERRALPOPUPREASONS;
import static com.vh.ui.web.locators.ReferralsLocators.LBL_NEWREFERRAL;
import static com.vh.ui.web.locators.ReferralsLocators.LBL_NEWREFERRALCHOOSEANEXISTINGPROVIDERLABEL;
import static com.vh.ui.web.locators.ReferralsLocators.LBL_NEWREFERRALPOPUPADDNEWPROVIDER;
import static com.vh.ui.web.locators.ReferralsLocators.LBL_NEWREFERRALPOPUPAPTSUITE;
import static com.vh.ui.web.locators.ReferralsLocators.LBL_NEWREFERRALPOPUPCITY;
import static com.vh.ui.web.locators.ReferralsLocators.LBL_NEWREFERRALPOPUPFAX;
import static com.vh.ui.web.locators.ReferralsLocators.LBL_NEWREFERRALPOPUPORADDANEWPROVIDER;
import static com.vh.ui.web.locators.ReferralsLocators.LBL_NEWREFERRALPOPUPPHONE;
import static com.vh.ui.web.locators.ReferralsLocators.LBL_NEWREFERRALPOPUPPROVIDERNAME;
import static com.vh.ui.web.locators.ReferralsLocators.LBL_NEWREFERRALPOPUPREFFEREDTO;
import static com.vh.ui.web.locators.ReferralsLocators.LBL_NEWREFERRALPOPUPSTATE;
import static com.vh.ui.web.locators.ReferralsLocators.LBL_NEWREFERRALPOPUPSTREET;
import static com.vh.ui.web.locators.ReferralsLocators.LBL_NEWREFERRALPOPUPZIP;
import static com.vh.ui.web.locators.ReferralsLocators.LBL_NEWREFERRALPROVIDERSTEAMDROPDOWNLABEL;
import static com.vh.ui.web.locators.ReferralsLocators.LBL_NEWREFERRALPROVIDERSTEAMLABEL;
import static com.vh.ui.web.locators.ReferralsLocators.LBL_REFERRALS;
import static com.vh.ui.web.locators.ReferralsLocators.LBL_REFERRALSAPPTDATECOLUMNHEADER;
import static com.vh.ui.web.locators.ReferralsLocators.LBL_REFERRALSPROVIDERNAMECOLUMNHEADER;
import static com.vh.ui.web.locators.ReferralsLocators.LBL_REFERRALSREASONCOLUMNHEADER;
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

// Verify Referrals Page //
	
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
	
	@Step("Verify the visibility of the PROVIDER NAME label")
	public boolean viewReferralsPageProviderNameColumnHeader() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_REFERRALSPROVIDERNAMECOLUMNHEADER);
	}

	@Step("Verify the visibility of the REASON label")
	public boolean viewReferralsPageReasonColumnHeader() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_REFERRALSREASONCOLUMNHEADER);
	}

	@Step("Verify the visibility of the APPT DATE label")
	public boolean viewReferralsPageApptDateColumnHeader() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_REFERRALSAPPTDATECOLUMNHEADER);
	}

	@Step("Verify the visibility of the APPT DATE label")
	public boolean viewReferralsPageAddAReferralButton() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, BTN_ADDAREFERRAL);
	}

// Add a New Referral //
	
	@Step("Verify able to Add A referral")
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

	@Step("Click on Referrals Chevron to expand Provider details")
	public void clickReferralChevron() throws TimeoutException, WaitException
	{
		webActions.click(VISIBILITY, BTN_NEWREFERRALPOPUPAPPOINTMENTREFERRALDATE);
	}

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

// Verify New Referral Window //
	
	@Step("Verify the visibility of the New Referral, New Referral label")
	public boolean viewNewReferral() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_NEWREFERRAL);
	}
	
	@Step("Verify the visibility of the New Referral Cancel button")
	public boolean viewNewReferralCancel() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, BTN_NEWREFERRALCANCEL);
	}
	
	@Step("Verify the visibility of the New Referral Next button")
	public boolean viewNewReferralNext() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, BTN_NEWREFERRALNEXT);
	}

	@Step("Verify the visibility of the New Referral PROVIDERS/TEAM button")
	public boolean viewNewReferralProvidersTeam() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, BTN_NEWREFERRALPROVIDERSTEAM);
	}

	@Step("Verify the visibility of the New Referral APPOINTMENT button")
	public boolean viewNewReferralAppointment() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, BTN_NEWREFERRALAPPOINTMENT);
	}

	@Step("Verify the visibility of the New Referral REASONS button")
	public boolean viewNewReferralReasons() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, BTN_NEWREFERRALREASONS);
	}

	@Step("Verify the visibility of the New Referral Providers/Team label")
	public boolean viewNewReferralProvidersTeamLabel() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_NEWREFERRALPROVIDERSTEAMLABEL);
	}

	@Step("Verify the visibility of the New Referral Choose an existing provider label")
	public boolean viewNewReferralChooseAnExistingProviderLabel() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_NEWREFERRALCHOOSEANEXISTINGPROVIDERLABEL);
	}

	@Step("Verify the visibility of the New Referral PROVIDERS/TEAM drop-down label")
	public boolean viewNewReferralProviderTeamDropdownLabel() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_NEWREFERRALPROVIDERSTEAMDROPDOWNLABEL);
	}

	@Step("Verify the visibility of the New Referral PROVIDERS/TEAM drop-down label")
	public boolean viewNewReferralProviderTeamDropdownField() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, CBO_NEWREFERRALPOPUPPROVIDERSTEAMTABPROVIDERSTEAM);
	}

	@Step("Verify the visibility of the New Referral 'OR Add A New Provider' label")
	public boolean viewNewReferralOrAddaNewProvider() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_NEWREFERRALPOPUPORADDANEWPROVIDER);
	}

	@Step("Verify the visibility of the New Referral PROVIDERS/TEAM drop-down label")
	public boolean viewNewReferralProviderName() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_NEWREFERRALPOPUPPROVIDERNAME);
	}

	@Step("Verify the visibility of the New Referral PROVIDERS NAME")
	public boolean viewNewReferralProviderNameField() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, CBO_NEWREFERRALPOPUPPROVIDERNAME);
	}

	@Step("Verify the visibility of the New Referral REFERREL TO label")
	public boolean viewNewReferralReferredTo() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_NEWREFERRALPOPUPREFFEREDTO);
	}

	@Step("Verify the visibility of the New Referral REFERRED TO field")
	public boolean viewNewReferralReferredToField() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, CBO_NEWREFERRALPOPUPREFFEREDTO);
	}

	@Step("Verify the visibility of the New Referral STREET label")
	public boolean viewNewReferralStreet() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_NEWREFERRALPOPUPSTREET);
	}

	@Step("Verify the visibility of the New Referral STREET field")
	public boolean viewNewReferralStreetField() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, CBO_NEWREFERRALPOPUPSTREET);
	}

	@Step("Verify the visibility of the New Referral APT/SUITE label")
	public boolean viewNewReferralAptSuite() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_NEWREFERRALPOPUPAPTSUITE);
	}

	@Step("Verify the visibility of the New Referral APT/SUITE field")
	public boolean viewNewReferralAptSuiteField() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, CBO_NEWREFERRALPOPUPAPTSUITE);
	}

	@Step("Verify the visibility of the New Referral CITY label")
	public boolean viewNewReferralCity() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_NEWREFERRALPOPUPCITY);
	}

	@Step("Verify the visibility of the New Referral CITY field")
	public boolean viewNewReferralCityField() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, CBO_NEWREFERRALPOPUPCITY);
	}

	@Step("Verify the visibility of the New Referral STATE label")
	public boolean viewNewReferralState() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_NEWREFERRALPOPUPSTATE);
	}

	@Step("Verify the visibility of the New Referral STATE field")
	public boolean viewNewReferralStateField() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, CBO_NEWREFERRALPOPUPSTATE);
	}

	@Step("Verify the visibility of the New Referral ZIP label")
	public boolean viewNewReferralZip() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_NEWREFERRALPOPUPZIP);
	}

	@Step("Verify the visibility of the New Referral ZIP field")
	public boolean viewNewReferralZipField() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, CBO_NEWREFERRALPOPUPZIP);
	}

	@Step("Verify the visibility of the New Referral PHONE field")
	public boolean viewNewReferralPhone() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_NEWREFERRALPOPUPPHONE);
	}

	@Step("Verify the visibility of the New Referral PHONE field")
	public boolean viewNewReferralPhoneField() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, CBO_NEWREFERRALPOPUPPHONE);
	}

	@Step("Verify the visibility of the New Referral FAX field")
	public boolean viewNewReferralFax() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_NEWREFERRALPOPUPFAX);
	}

	@Step("Verify the visibility of the New Referral FAX field")
	public boolean viewNewReferralFaxField() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, CBO_NEWREFERRALPOPUPFAX);
	}

	@Step("Verify the visibility of the Add New Provider to Team Check-box")
	public boolean viewNewReferralAddNewProviderCheckBox() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, CHK_NEWREFERRALPOPUPADDNEWPROVIDER);
	}

	@Step("Verify the visibility of the Add New Provider label")
	public boolean viewNewReferralAddNewProvider() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_NEWREFERRALPOPUPADDNEWPROVIDER);
	}
}