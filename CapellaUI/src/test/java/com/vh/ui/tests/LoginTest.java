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
 * @date   March 23, 2017
 * @class  LoginTest.java
 * 
 * Before running this test suite:
 * 1. Change the "username" and "password" parameters in the "resources\application.properties" file to your own
 * 2. Clear your browser's cache
 */

public class LoginTest extends TestBase
{	
	WebPage pageBase;
	LoginPage loginPage;
	ApplicationFunctions appFunctions;
	MyPatientsPage myPatients;

	@BeforeClass
	public void buildUp() throws TimeoutException, WaitException {
		WebDriver driver = getWebDriver();
		pageBase = new WebPage(driver);
		appFunctions = new ApplicationFunctions(driver);
		myPatients = new MyPatientsPage(driver);
	}

	@Test(priority = 1)
	@Step("Verify Invalid User Name")
	public void verify_InvalidUserName() throws WaitException, URLNavigationException, InterruptedException
	{
		loginPage = (LoginPage) pageBase.navigateTo(applicationProperty.getProperty("webURL"));
//		Thread.sleep(5000);
		
		Assert.assertTrue(loginPage.viewUserNameTextField(), "Failed to identify UserName text field");
		Assert.assertTrue(loginPage.viewPasswordTextField(), "Failed to identify Password text field");
		loginPage.enterUserName(applicationProperty.getProperty("username") + "test");
		loginPage.enterPassword(applicationProperty.getProperty("password"));
		loginPage.clickLogin();
		
		Assert.assertEquals(loginPage.getLoginErrorMessage(), "Error: Invalid username or password");
	}
	
	@Test(priority = 2)
	@Step("Verify Invalid Password")
	public void verify_InvalidPassword() throws WaitException, URLNavigationException, InterruptedException
	{
		loginPage = (LoginPage) pageBase.navigateTo(applicationProperty.getProperty("webURL"));
//		Thread.sleep(5000);
	
		Assert.assertTrue(loginPage.viewUserNameTextField(), "Failed to identify UserName text field");
		Assert.assertTrue(loginPage.viewPasswordTextField(), "Failed to identify Password text field");
		loginPage.enterUserName(applicationProperty.getProperty("username"));
		loginPage.enterPassword(applicationProperty.getProperty("password") + "test");
		loginPage.clickLogin();
		
		Assert.assertEquals(loginPage.getLoginErrorMessage(), "Error: Invalid username or password");
	}
	
	@Test(priority = 3)
	@Step("Verify Successful Login")
	public void verify_SuccessfulLogin()
			throws WaitException, URLNavigationException, InterruptedException
	{
		loginPage = (LoginPage) pageBase.navigateTo(applicationProperty.getProperty("webURL"));
//		Thread.sleep(5000);

		Assert.assertTrue(loginPage.viewUserNameTextField(), "Failed to identify UserName text field");
		Assert.assertTrue(loginPage.viewPasswordTextField(), "Failed to identify Password text field");
		loginPage.enterUserName(applicationProperty.getProperty("username"));
		loginPage.enterPassword(applicationProperty.getProperty("password"));
		loginPage.clickLogin();
//		Thread.sleep(3000);

		Assert.assertTrue(loginPage.viewYesAllowButton(), "Failed to identify Yes, Allow button");
		loginPage.clickRememberMyDecision();
//		Thread.sleep(1000);
		loginPage.clickYesAllow();
//		Thread.sleep(5000);

		// Assert.assertTrue(myPatients.viewMyPatientsPage(), "Failed to identify My Patients page");
		
		String User_Name = System.getProperty("user.name");

		Assert.assertEquals(appFunctions.getUserNameTextMenuBar(), User_Name.toUpperCase());
	}
	
	@AfterClass
	public void tearDown() throws TimeoutException, WaitException
	{
		appFunctions.capellaLogout();
		pageBase.quit();
	}
}
