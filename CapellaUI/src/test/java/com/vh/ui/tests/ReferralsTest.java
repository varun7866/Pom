package com.vh.ui.tests;

import java.util.Map;

import org.openqa.selenium.TimeoutException;
import org.openqa.selenium.WebDriver;
import org.testng.Assert;
import org.testng.annotations.BeforeClass;
import org.testng.annotations.Test;

import com.vh.test.base.TestBase;
import com.vh.ui.actions.ApplicationFunctions;
import com.vh.ui.exceptions.URLNavigationException;
import com.vh.ui.exceptions.WaitException;
import com.vh.ui.page.base.WebPage;
import com.vh.ui.pages.ReferralsPage;

import ru.yandex.qatools.allure.annotations.Step;

/*
 * @author Harshida Patel
 * @date   August 1, 2017
 * @class  ReferralsPage.java
 * 
 * Before running this test suite:
 * 1. Change the "username" and "password" parameters in the "resources\application.properties" file to your own
 * 2. Clear your browser's cache
 */
	
public class ReferralsTest extends TestBase
{
	// Class objects
	WebPage pageBase;
	ApplicationFunctions appFunctions;
	ReferralsPage referralsPage;
	
	@BeforeClass
	public void buildUp() throws TimeoutException, WaitException, URLNavigationException, InterruptedException {
		WebDriver driver = getWebDriver();
		pageBase = new WebPage(driver);
		appFunctions = new ApplicationFunctions(driver);
		referralsPage = new ReferralsPage(driver);

		appFunctions.capellaLogin();

	}
	
	@Test(priority = 1, dataProvider = "CapellaDataProvider")
	@Step("Verify the Referrals page")
	public void verify_CurrentReferralsPage(Map<String, String> map) throws WaitException, URLNavigationException, InterruptedException
	{
		appFunctions.selectPatientFromMyPatients(map.get("PatientName"));
		appFunctions.navigateToMenu("Patient Admin->Referrals");

		Assert.assertTrue(referralsPage.viewReferralsPageMenu(), "Failed to identify the Referrals menu");
		Assert.assertTrue(referralsPage.viewReferralsPageHeader(), "Failed to identify the Referrals page");
		Assert.assertTrue(referralsPage.viewReferralsPageProviderNameColumnHeader(), "Failed to identify the PROVIDER NAME label");
		Assert.assertTrue(referralsPage.viewReferralsPageReasonColumnHeader(), "Failed to identify the REASON label");
		Assert.assertTrue(referralsPage.viewReferralsPageApptDateColumnHeader(), "Failed to identify the APPT DATE label");
		Assert.assertTrue(referralsPage.viewReferralsPageAddAReferralButton(), "Failed to identify the ADD A REFERRAL button");
		referralsPage.clickAddAReferral();

	}

	@Test(priority = 2, dataProvider = "CapellaDataProvider")
	@Step("Verify Add New Referral window")
	public void verify_AddReferral(Map<String, String> map) throws WaitException, URLNavigationException, InterruptedException
	{

		Assert.assertTrue(referralsPage.viewNewReferral(), "Failed to identify the New Referral label");
		Assert.assertTrue(referralsPage.viewNewReferralCancel(), "Failed to identify the New Referral Cancel button");
		Assert.assertTrue(referralsPage.viewNewReferralNext(), "Failed to identify the New Referral Next button");
		Assert.assertTrue(referralsPage.viewNewReferralProvidersTeam(), "Failed to identify the New Referral PROVIDERS/TEAM button");
		Assert.assertTrue(referralsPage.viewNewReferralAppointment(), "Failed to identify the New Referral APPOINTMENT button");
		Assert.assertTrue(referralsPage.viewNewReferralReasons(), "Failed to identify the New Referral REASONS button");
		Assert.assertTrue(referralsPage.viewNewReferralProvidersTeamLabel(), "Failed to identify the New Referral Providers/Team label");
		Assert.assertTrue(referralsPage.viewNewReferralChooseAnExistingProviderLabel(), "Failed to identify the New Referral Choose an existing provider label");
		Assert.assertTrue(referralsPage.viewNewReferralProviderTeamDropdownLabel(), "Failed to identify the New Referral PROVIDER/TEAM drop-down label");
		Assert.assertTrue(referralsPage.viewNewReferralProviderTeamDropdownField(), "Failed to identify the New Referral PROVIDER/TEAM drop-down Field");
		Assert.assertTrue(referralsPage.viewNewReferralOrAddaNewProvider(), "Failed to identify the 'Or add a new provider' label");
		Assert.assertTrue(referralsPage.viewNewReferralProviderName(), "Failed to identify the PROVIDER NAME label");
		Assert.assertTrue(referralsPage.viewNewReferralProviderNameField(), "Failed to identify the PROVIDER NAME field");
		Assert.assertTrue(referralsPage.viewNewReferralReferredTo(), "Failed to identify the REFERRED TO label");
		Assert.assertTrue(referralsPage.viewNewReferralReferredToField(), "Failed to identify the REFERRED TO field");
		Assert.assertTrue(referralsPage.viewNewReferralStreet(), "Failed to identify the STREET label");
		Assert.assertTrue(referralsPage.viewNewReferralStreetField(), "Failed to identify the STREET field");
		Assert.assertTrue(referralsPage.viewNewReferralAptSuite(), "Failed to identify the APT/SUITE label");
		Assert.assertTrue(referralsPage.viewNewReferralAptSuiteField(), "Failed to identify the APT/SUITE field");
		Assert.assertTrue(referralsPage.viewNewReferralCity(), "Failed to identify the CITY label");
		Assert.assertTrue(referralsPage.viewNewReferralCityField(), "Failed to identify the CITY field");
		Assert.assertTrue(referralsPage.viewNewReferralState(), "Failed to identify the STATE label");
		Assert.assertTrue(referralsPage.viewNewReferralStateField(), "Failed to identify the STATE field");
		Assert.assertTrue(referralsPage.viewNewReferralZip(), "Failed to identify the ZIP label");
		Assert.assertTrue(referralsPage.viewNewReferralZipField(), "Failed to identify the ZIP field");
		Assert.assertTrue(referralsPage.viewNewReferralPhone(), "Failed to identify the PHONE label");
		Assert.assertTrue(referralsPage.viewNewReferralPhoneField(), "Failed to identify the PHONE field");
		Assert.assertTrue(referralsPage.viewNewReferralFax(), "Failed to identify the FAX label");
		Assert.assertTrue(referralsPage.viewNewReferralFaxField(), "Failed to identify the FAX field");
		Assert.assertTrue(referralsPage.viewNewReferralAddNewProviderCheckBox(), "Failed to identify the 'Add New Provider To Team Check-box");
		Assert.assertTrue(referralsPage.viewNewReferralAddNewProvider(), "Failed to identify 'Add New Provider' label");

	}
	

	// ADD REFERRALS**********

	@Test(priority = 3, dataProvider = "CapellaDataProvider")
	 @Step("Add Referrals")
	 public void AddReferral(Map<String, String> map) throws WaitException, URLNavigationException, InterruptedException
	 {
	 appFunctions.selectPatientFromMyPatients(map.get("PatientName"));
	 appFunctions.navigateToMenu("Patient Admin->Referrals");
	 referralsPage.AddReferral(map);
	
	 }


}

