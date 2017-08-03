package com.vh.ui.tests;

import java.util.Map;

import org.openqa.selenium.TimeoutException;
import org.openqa.selenium.WebDriver;
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
 * 1. Change the "username" and "password" parameters in the "resources\application.properties" file to your own
 * 2. Clear your browser's cache
 * 3. You will need a CKD and an ESRD Patient
 * 4. It's not required, but it would be a good idea to delete all existing Labs from table PTLB_PATIENT_LABS for your Patients
 * Note: KT/V & URR are invalid for a CKD Patient
 * Note: URINE ALBUMIN/CREATININE RATIO is invalid for an ESRD Patient
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
		// appFunctions.selectPatientFromMyPatients("Glayds Whoriskey"); // CKD Patient
		// appFunctions.navigateToMenu("Patient Care->Care Team");
	}

	@Test(priority = 2, dataProvider = "CapellaDataProvider")
	@Step("Verify Adding a Team Member with different scenarios")
	public void verify_AddingTeamMember(Map<String, String> map) throws WaitException, URLNavigationException, InterruptedException
	{
		appFunctions.selectPatientFromMyPatients(map.get("PatientName"));

		appFunctions.navigateToMenu("Patient Care->Care Team");

		Thread.sleep(2000); // Give time for the Providers and Team screen to display

		providersTeamPage.clickAddATeamMemberButton();
	}

	@AfterClass
	public void tearDown() throws TimeoutException, WaitException
	{
		// appFunctions.capellaLogout();
		// pageBase.quit();
	}
}
