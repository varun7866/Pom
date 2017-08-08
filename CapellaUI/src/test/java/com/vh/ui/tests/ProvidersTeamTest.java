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
		// appFunctions.selectPatientFromMyPatients("Glayds Whoriskey");
		// appFunctions.navigateToMenu("Patient Care->Care Team");
	}

	@Test(priority = 2, dataProvider = "CapellaDataProvider")
	@Step("Verify Adding a Team Member with different scenarios")
	public void verify_AddingTeamMember(Map<String, String> map) throws WaitException, URLNavigationException, InterruptedException
	{
		appFunctions.selectPatientFromMyPatients(map.get("PatientName"));

		appFunctions.navigateToMenu("Patient Care->Care Team");

		providersTeamPage.addATeamMember(map);
	}

	@Test(priority = 3, dataProvider = "CapellaDataProvider")
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
		pageBase.quit();
	}
}
