package com.vh.ui.tests;

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
import com.vh.ui.pages.LoginPage;
import com.vh.ui.pages.MyPatientsPage;

import ru.yandex.qatools.allure.annotations.Step;

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
	LoginPage loginPage;
	ApplicationFunctions appFunctions;
	MyPatientsPage myPatients;
	WebDriver driver;

	@BeforeClass
	public void buildUp() throws TimeoutException, WaitException {
		driver = getWebDriver();
		pageBase = new WebPage(driver);
		appFunctions = new ApplicationFunctions(driver);
		myPatients = new MyPatientsPage(driver);
	}
	
	@Test(priority = 1)
	@Step("Verify Menu Bar options")
	public void verify_MenuBar_Options() throws WaitException, URLNavigationException, InterruptedException
	{
		loginPage = (LoginPage) pageBase.navigateTo(applicationProperty.getProperty("webURL"));
		Thread.sleep(5000);

		Assert.assertTrue(loginPage.viewUserNameTextField(), "Failed to identify UserName text field");
		Assert.assertTrue(loginPage.viewPasswordTextField(), "Failed to identify Password text field");
		loginPage.enterUserName(applicationProperty.getProperty("username"));
		loginPage.enterPassword(applicationProperty.getProperty("password"));
		loginPage.clickLogin();
		Thread.sleep(5000);

		Assert.assertTrue(loginPage.viewYesAllowButton(), "Failed to identify Yes, Allow button");
		loginPage.clickRememberMyDecision();
		Thread.sleep(1000);
		loginPage.clickYesAllow();
		Thread.sleep(5000);

		Assert.assertTrue(myPatients.viewMyPatientsPage(), "Failed to identify My Patients page");
		
		appFunctions.clickMyTasksMenuBar();
		Thread.sleep(3000);
		appFunctions.clickMyScheduleMenuBar();
		Thread.sleep(3000);
		appFunctions.clickAdminMenuBar();
		Thread.sleep(3000);
		appFunctions.clickMyPatientsMenuBar();
	}
	
	@AfterClass
	public void tearDown() throws TimeoutException, WaitException
	{
		appFunctions.capellaLogout();
		pageBase.quit();
	}
}
