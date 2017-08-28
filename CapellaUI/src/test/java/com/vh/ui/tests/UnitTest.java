package com.vh.ui.tests;

import static com.vh.ui.web.locators.HospitalizationLocators.CAL_NEWHOSPPOPUPADMITTANCETABADMITDATECAL;

import java.io.IOException;

import org.openqa.selenium.TimeoutException;
import org.openqa.selenium.WebDriver;
import org.testng.annotations.AfterClass;
import org.testng.annotations.BeforeClass;
import org.testng.annotations.Test;

import com.vh.test.base.TestBase;
import com.vh.ui.actions.ApplicationFunctions;
import com.vh.ui.actions.WebActions;
import com.vh.ui.exceptions.URLNavigationException;
import com.vh.ui.exceptions.WaitException;
import com.vh.ui.page.base.WebPage;
import com.vh.ui.pages.HospitalizationPage;

/*
 * @author Harvy Ackermans
 * @date   March 29, 2017
 * @class  UnitTest.java
 * 
 * Before running this test suite:
 * 
 */

public class UnitTest extends TestBase
{	
	WebPage pageBase;
	WebActions webActions;
	ApplicationFunctions appFunctions;
	HospitalizationPage hospitalizationsPage;

	@BeforeClass
	public void buildUp() throws TimeoutException, WaitException, URLNavigationException, InterruptedException {
		WebDriver driver = getWebDriver();
		pageBase = new WebPage(driver);
		webActions = new WebActions(driver);
		appFunctions = new ApplicationFunctions(driver);
		hospitalizationsPage = new HospitalizationPage(driver);

		appFunctions.capellaLogin();
		appFunctions.selectPatientFromMyPatients("Waliy Al D Holroyd"); // QA
		appFunctions.navigateToMenu("Patient Experience->Hospitalizations");
	}    
	
	@Test
	public void function4() throws IOException, TimeoutException, WaitException, InterruptedException
	{
		hospitalizationsPage.clickAddHospitalizationButton();
		hospitalizationsPage.clickNewHospPopupAdmittanceTabAdmitDatePickerButton();

		appFunctions.selectDateFromCalendarAsMdYYYY(CAL_NEWHOSPPOPUPADMITTANCETABADMITDATECAL, "8/15/2017");
    }

	@AfterClass
	public void tearDown() throws TimeoutException, WaitException
	{
		// appFunctions.capellaLogout();
		// pageBase.quit();
	}
}