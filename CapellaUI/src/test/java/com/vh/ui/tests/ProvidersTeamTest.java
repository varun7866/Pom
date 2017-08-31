package com.vh.ui.tests;

import java.sql.SQLException;
import java.util.Map;

import org.openqa.selenium.TimeoutException;
import org.openqa.selenium.WebDriver;
import org.testng.Assert;
import org.testng.annotations.AfterClass;
import org.testng.annotations.BeforeClass;
import org.testng.annotations.Test;

import com.vh.test.base.TestBase;
import com.vh.ui.actions.ApplicationFunctions;
import com.vh.ui.exceptions.URLNavigationException;
import com.vh.ui.exceptions.WaitException;
import com.vh.ui.page.base.WebPage;
import com.vh.ui.pages.ProvidersTeamPage;

import ru.yandex.qatools.allure.annotations.Step;

/*
 * @author Harvy Ackermans
 * @date   August 2, 2017
 * @class  ProvidersTeamTest.java
 * 
 * Before running this test suite:
 
 */

public class ProvidersTeamTest extends TestBase
{	
	// Class objects
	WebPage pageBase;
	ApplicationFunctions appFunctions;
	ProvidersTeamPage providersTeamPage;
	
	@BeforeClass
	public void buildUp() throws TimeoutException, WaitException, URLNavigationException, InterruptedException {
		WebDriver driver = getWebDriver();
		pageBase = new WebPage(driver);
		appFunctions = new ApplicationFunctions(driver);
		providersTeamPage = new ProvidersTeamPage(driver);

		appFunctions.capellaLogin();
	}

	@Test(priority = 1, dataProvider = "CapellaDataProvider")
	@Step("Verify the Providers and Team page")
	public void verify_ProvidersAndTeamPage(Map<String, String> map) throws WaitException, URLNavigationException, InterruptedException, TimeoutException, SQLException
	{
		providersTeamPage.deleteProvidersAndTeamDatabase(map.get("MemberID"));

		appFunctions.selectPatientFromMyPatients(map.get("PatientName"));

		appFunctions.navigateToMenu("Patient Care->Care Team");

		Assert.assertTrue(providersTeamPage.viewPageHeaderLabel(), "Failed to identify the Providers and Team page header label");
		Assert.assertTrue(providersTeamPage.viewAddATeamMemberButton(), "Failed to identify the ADD A TEAM MEMBER button");
		Assert.assertTrue(providersTeamPage.viewAddAProviderButton(), "Failed to identify the ADD A PROVIDER button");

		Assert.assertTrue(providersTeamPage.viewActiveInactiveComboBox(), "Failed to identify the Active/Inactive combo box");
		Assert.assertTrue(providersTeamPage.viewActiveInactivePlaceholder(), "Failed to identify the Active/Inactive placeholder");
		Assert.assertTrue(providersTeamPage.verifyActiveInactiveComboBoxOptions(), "The Active/Inactive drop down options are incorrect");

		Assert.assertTrue(providersTeamPage.viewNameTypeColumnHeaderLabel(), "Failed to identify the NAME/TYPE colummn header label");
		Assert.assertTrue(providersTeamPage.viewAddressColumnHeaderLabel(), "Failed to identify the ADDRESS colummn header label");
		Assert.assertTrue(providersTeamPage.viewDatesColumnHeaderLabel(), "Failed to identify the DATES colummn header label");
		Assert.assertTrue(providersTeamPage.viewAllowContactColumnHeaderLabel(), "Failed to identify the ALLOW CONTACT colummn header label");
	}

	@Test(priority = 2)
	@Step("Verify the New Team popup")
	public void verify_NewTeamPopup() throws WaitException, URLNavigationException, InterruptedException, TimeoutException, SQLException
	{
		providersTeamPage.clickAddATeamMemberButton();

		Assert.assertTrue(providersTeamPage.viewNewTeamPopupHeaderLabel(), "Failed to identify the New Team popup header label");
		Assert.assertTrue(providersTeamPage.viewNewTeamPopupXButton(), "Failed to identify the New Team popup X Button");

		Assert.assertTrue(providersTeamPage.viewNewTeamPopupTeamTypeLabel(), "Failed to identify the New Team popup TEAM TYPE label");
		Assert.assertTrue(providersTeamPage.viewNewTeamPopupTeamTypeComboBox(), "Failed to identify the New Team popup TEAM TYPE combo box");
		Assert.assertTrue(providersTeamPage.viewNewTeamPopupTeamTypePlaceholder(), "Failed to identify the New Team popup TEAM TYPE placeholder");
		Assert.assertTrue(providersTeamPage.verifyNewTeamPopupTeamTypeComboBoxOptions(), "The New Team popup TEAM TYPE drop down options are incorrect");

		Assert.assertTrue(providersTeamPage.viewNewTeamPopupNameLabel(), "Failed to identify the New Team popup NAME label");
		Assert.assertTrue(providersTeamPage.viewNewTeamPopupNameTextBox(), "Failed to identify the New Team popup NAME text box");

		Assert.assertTrue(providersTeamPage.viewNewTeamPopupEmailLabel(), "Failed to identify the New Team popup EMAIL label");
		Assert.assertTrue(providersTeamPage.viewNewTeamPopupEmailTextBox(), "Failed to identify the New Team popup EMAIL text box");

		Assert.assertTrue(providersTeamPage.viewNewTeamPopupAddressLabel(), "Failed to identify the New Team popup ADDRESS label");
		Assert.assertTrue(providersTeamPage.viewNewTeamPopupAddressTextBox(), "Failed to identify the New Team popup ADDRESS text box");

		Assert.assertTrue(providersTeamPage.viewNewTeamPopupAptSuiteLabel(), "Failed to identify the New Team popup APT/SUITE label");
		Assert.assertTrue(providersTeamPage.viewNewTeamPopupAptSuiteTextBox(), "Failed to identify the New Team popup APT/SUITE text box");

		Assert.assertTrue(providersTeamPage.viewNewTeamPopupCityLabel(), "Failed to identify the New Team popup CITY label");
		Assert.assertTrue(providersTeamPage.viewNewTeamPopupCityTextBox(), "Failed to identify the New Team popup CITY text box");

		Assert.assertTrue(providersTeamPage.viewNewTeamPopupStateLabel(), "Failed to identify the New Team popup STATE label");
		Assert.assertTrue(providersTeamPage.viewNewTeamPopupStateComboBox(), "Failed to identify the New Team popup STATE combo box");
		Assert.assertTrue(providersTeamPage.viewNewTeamPopupStatePlaceholder(), "Failed to identify the New Team popup STATE placeholder");
		Assert.assertTrue(providersTeamPage.verifyNewTeamPopupStateComboBoxOptions(), "The New Team popup STATE drop down options are incorrect");

		Assert.assertTrue(providersTeamPage.viewNewTeamPopupZipLabel(), "Failed to identify the New Team popup ZIP label");
		Assert.assertTrue(providersTeamPage.viewNewTeamPopupZipTextBox(), "Failed to identify the New Team popup ZIP text box");

		Assert.assertTrue(providersTeamPage.viewNewTeamPopupPhoneLabel(), "Failed to identify the New Team popup PHONE label");
		Assert.assertTrue(providersTeamPage.viewNewTeamPopupPhoneTextBox(), "Failed to identify the New Team popup PHONE text box");

		Assert.assertTrue(providersTeamPage.viewNewTeamPopupFaxLabel(), "Failed to identify the New Team popup FAX label");
		Assert.assertTrue(providersTeamPage.viewNewTeamPopupFaxTextBox(), "Failed to identify the New Team popup FAX text box");

		Assert.assertTrue(providersTeamPage.viewNewTeamPopupOtherPhoneLabel(), "Failed to identify the New Team popup OTHER PHONE label");
		Assert.assertTrue(providersTeamPage.viewNewTeamPopupOtherPhoneTextBox(), "Failed to identify the New Team popup OTHER PHONE text box");

		Assert.assertTrue(providersTeamPage.viewNewTeamPopupAllowCommunicationLabel(), "Failed to identify the New Team popup Allow Communication label");
		Assert.assertTrue(providersTeamPage.viewNewTeamPopupAllowCommunicationCheckBox(), "Failed to identify the New Team popup Allow Communication check box");

		Assert.assertTrue(providersTeamPage.viewNewTeamPopupFaxNumberVerifiedLabel(), "Failed to identify the New Team popup Fax Number Verified label");
		Assert.assertTrue(providersTeamPage.viewNewTeamPopupFaxNumberVerifiedCheckBox(), "Failed to identify the New Team popup Fax Number Verified check box");

		Assert.assertTrue(providersTeamPage.viewNewTeamPopupPatientSeeingSinceLabel(), "Failed to identify the New Team popup PATIENT SEEING SINCE label");
		Assert.assertTrue(providersTeamPage.viewNewTeamPopupPatientSeeingSinceDatePicker(), "Failed to identify the New Team popup PATIENT SEEING SINCE date picker");
		Assert.assertTrue(providersTeamPage.viewNewTeamPopupPatientSeeingSinceDatePickerButton(),
		        "Failed to identify the Add Medical Equipment popup PATIENT SEEING SINCE date picker button");

		Assert.assertTrue(providersTeamPage.viewNewTeamPopupCancelButton(), "Failed to identify the New Team popup CANCEL button");
		Assert.assertTrue(providersTeamPage.viewNewTeamPopupSubmitButton(), "Failed to identify the New Team popup SUBMIT button");
	}

	// @Test(priority = 3)
	// @Step("Verify the New Provider popup")
	public void verify_NewProviderPopup(Map<String, String> map) throws WaitException, URLNavigationException, InterruptedException
	{
		providersTeamPage.clickAddAProviderButton();
	}

	@Test(priority = 4, dataProvider = "CapellaDataProvider")
	@Step("Verify Adding a Team Member with different scenarios")
	public void verify_AddingTeamMember(Map<String, String> map) throws WaitException, URLNavigationException, InterruptedException
	{
		appFunctions.selectPatientFromMyPatients(map.get("PatientName"));

		appFunctions.navigateToMenu("Patient Care->Care Team");

		providersTeamPage.addATeamMember(map);
	}

	@Test(priority = 5, dataProvider = "CapellaDataProvider")
	@Step("Verify Adding a Provider with different scenarios")
	public void verify_AddingProvider(Map<String, String> map) throws WaitException, URLNavigationException, InterruptedException
	{
		appFunctions.selectPatientFromMyPatients(map.get("PatientName"));

		appFunctions.navigateToMenu("Patient Care->Care Team");

		providersTeamPage.addAProvider(map);
	}

	@AfterClass
	public void tearDown() throws TimeoutException, WaitException
	{
		appFunctions.capellaLogout();
		closeDrivers();
	}
}
