package com.vh.ui.tests;

import org.openqa.selenium.TimeoutException;
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
 * Change the "username" and "password" parameters in the "resources\application.properties" file to your own.
 */

public class LoginTest extends TestBase
{	
	WebPage pageBase;
	LoginPage loginPage;
	ApplicationFunctions appFunctions;
	MyPatientsPage myPatients;

	@BeforeClass
	public void buildUp() throws TimeoutException, WaitException {
		pageBase = new WebPage(getWebDriver());
		appFunctions = new ApplicationFunctions(getWebDriver());
		myPatients = new MyPatientsPage(getWebDriver());
	}

	@Test
	@Step("Verify Invalid User Name")
	public void verify_InvalidUserName() throws WaitException, URLNavigationException, InterruptedException
	{
		loginPage = (LoginPage) pageBase.navigateTo(applicationProperty.getProperty("webURL"));
		Thread.sleep(5000);
		
		Assert.assertTrue(loginPage.viewUserNameTextField(), "Failed to identify UserName text field");
		Assert.assertTrue(loginPage.viewPasswordTextField(), "Failed to identify Password text field");
		loginPage.enterUserName(applicationProperty.getProperty("username") + "test");
		loginPage.enterPassword(applicationProperty.getProperty("password"));
		loginPage.clickLogin();
		
		Assert.assertEquals(loginPage.getLoginErrorMessage(), "Error: Invalid username or password");
	}
	
	@Test
	@Step("Verify Invalid Password")
	public void verify_InvalidPassword() throws WaitException, URLNavigationException, InterruptedException
	{
		loginPage = (LoginPage) pageBase.navigateTo(applicationProperty.getProperty("webURL"));
		Thread.sleep(5000);
	
		Assert.assertTrue(loginPage.viewUserNameTextField(), "Failed to identify UserName text field");
		Assert.assertTrue(loginPage.viewPasswordTextField(), "Failed to identify Password text field");
		loginPage.enterUserName(applicationProperty.getProperty("username"));
		loginPage.enterPassword(applicationProperty.getProperty("password") + "test");
		loginPage.clickLogin();
		
		Assert.assertEquals(loginPage.getLoginErrorMessage(), "Error: Invalid username or password");
	}
	
	@Test
	@Step("Verify Successful Login")
	public void verify_SuccessfulLogin()
			throws WaitException, URLNavigationException, InterruptedException
	{
		loginPage = (LoginPage) pageBase.navigateTo(applicationProperty.getProperty("webURL"));
		Thread.sleep(5000);

		Assert.assertTrue(loginPage.viewUserNameTextField(), "Failed to identify UserName text field");
		Assert.assertTrue(loginPage.viewPasswordTextField(), "Failed to identify Password text field");
		loginPage.enterUserName(applicationProperty.getProperty("username"));
		loginPage.enterPassword(applicationProperty.getProperty("password"));
		loginPage.clickLogin();
		Thread.sleep(5000);

//		Assert.assertTrue(loginPage.viewYesAllowButton(), "Failed to identify Yes, Allow button");
//		loginPage.clickYesAllow();
//		Thread.sleep(5000);

		Assert.assertTrue(myPatients.viewMyPatientsPage(), "Failed to identify My Patients page");
		
		String User_Name = System.getProperty("user.name");

		Assert.assertEquals(appFunctions.getUserNameTextMenuBar(), User_Name.toUpperCase());
	}
	
	@AfterClass
	public void tearDown() throws TimeoutException, WaitException
	{
		appFunctions.capellaLogOut();
		pageBase.quit();
	}
}
