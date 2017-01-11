package com.vh.ui.tests;

import org.openqa.selenium.TimeoutException;
import org.testng.Assert;
import org.testng.annotations.AfterTest;
import org.testng.annotations.BeforeTest;
import org.testng.annotations.Test;

import com.vh.test.base.TestBase;
import com.vh.ui.actions.ApplicationFunctions;
import com.vh.ui.exceptions.URLNavigationException;
import com.vh.ui.exceptions.WaitException;
import com.vh.ui.page.base.WebPage;
import com.vh.ui.pages.WebLoginPage;
import com.vh.ui.pages.WebMyDashboardPage;

/**
 * @author SUBALIVADA
 * @date   Jan 09, 2017
 * @class  CreateNewPatientTest.java
 *
 */
public class CreateNewPatientTest extends TestBase {
	WebPage pageBase;
	WebLoginPage webLoginPage;
	WebMyDashboardPage webMyDashboardpage;
	ApplicationFunctions app;
	
	@BeforeTest
	public void init() throws WaitException
	{
		pageBase = new WebPage(getWebDriver());
		app = new ApplicationFunctions(pageBase.getDriver());
	}
	
	@Test
	public void navigateToMenu() throws URLNavigationException, WaitException, InterruptedException
	{
		
		webLoginPage = (WebLoginPage) pageBase.navigateTo(applicationProperty.getProperty("webURL"));
		Thread.sleep(5000);
		
		Assert.assertTrue(webLoginPage.viewUserNameTextField(), "Failed to identify UserName text field");
		Assert.assertTrue(webLoginPage.viewPasswordTextField(), "Failed to identify Password text field");
		Assert.assertTrue(webLoginPage.viewTokenTextField(), "Failed to identify Token text field");
		webLoginPage.enterUserName("vhnaa");
		webLoginPage.enterPassword("test123");
		webLoginPage.enterToken("111111");
		
		webMyDashboardpage = webLoginPage.clickLogin();
		Thread.sleep(10000);
		
		app.closeAllPatients();
//		app.clickOnMainMenu("My Patients");
//		Thread.sleep(5000);
//		String tableLocator = "//div[@id='vhnpatients_grid']/div[2]/table";
//		app.selectPatientFromMyPatient("//div[@id='vhnpatients_grid']/div[2]/table", "", 1, 2);
//		System.out.println(app.getTextFromTable(tableLocator, 1, 1, 2));
	}
	
	@AfterTest
	public void tearDown() throws TimeoutException, WaitException
	{
		app.capellaLogOut();
		closeDrivers();
	}
}
