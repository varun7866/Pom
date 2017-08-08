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
 * @author Harvy Ackermans
 * @date   June 22, 2017
 * @class  PatientNavigationTest.java
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
		// appFunctions.selectPatientFromMyPatients("Mikal Gallogly"); // QA
		// appFunctions.selectPatientFromMyPatients("Aasaf Whoriskey"); // Stage
		// appFunctions.navigateToMenu("Patient Admin->Referrals");
	}
	
	// @Test(priority = 1)
	// @Step("Verify the Referrals page")
	public void verify_CurrentReferralsPage() throws WaitException, URLNavigationException, InterruptedException
	{
		Assert.assertTrue(referralsPage.viewReferralsPageMenu(), "Failed to identify the Referrals menu");
		Assert.assertTrue(referralsPage.viewReferralsPageHeader(), "Failed to identify the Referrals page");

	}

	@Test(priority = 2, dataProvider = "CapellaDataProvider")
	@Step("Verify the Referrals page")
	public void verify_AddReferral(Map<String, String> map) throws WaitException, URLNavigationException, InterruptedException
	{
		appFunctions.selectPatientFromMyPatients(map.get("PatientName"));
		appFunctions.navigateToMenu("Patient Admin->Referrals");
		referralsPage.AddReferral(map);

	}
	


}

