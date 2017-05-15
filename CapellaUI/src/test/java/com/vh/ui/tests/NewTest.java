package com.vh.ui.tests;

import org.openqa.selenium.TimeoutException;
import org.openqa.selenium.WebDriver;
import org.testng.Assert;
import org.testng.annotations.AfterClass;
import org.testng.annotations.BeforeClass;

import com.vh.test.base.TestBase;
import com.vh.ui.actions.ApplicationFunctions;
import com.vh.ui.exceptions.URLNavigationException;
import com.vh.ui.exceptions.WaitException;
import com.vh.ui.page.base.WebPage;
import com.vh.ui.pages.LoginPage;

public class NewTest extends TestBase
  {	
		// Class objects
		WebPage pageBase;
		ApplicationFunctions appFunctions;
		LoginPage loginPage;

	@BeforeClass
	public void buildUp() throws TimeoutException, WaitException, URLNavigationException, InterruptedException {

		System.out.println("hello");
		WebDriver driver = getWebDriver();
		pageBase = new WebPage(driver);
		appFunctions = new ApplicationFunctions(driver);

		loginPage = (LoginPage) pageBase.navigateTo(applicationProperty.getProperty("webURL"));
		Thread.sleep(5000);

		Assert.assertTrue(loginPage.viewUserNameTextField(), "Failed to identify UserName text field");
		Assert.assertTrue(loginPage.viewPasswordTextField(), "Failed to identify Password text field");
		loginPage.enterUserName(applicationProperty.getProperty("username"));
		loginPage.enterPassword(applicationProperty.getProperty("password"));
		loginPage.clickLogin();
		Thread.sleep(3000);

		Assert.assertTrue(loginPage.viewYesAllowButton(), "Failed to identify Yes, Allow button");
		loginPage.clickRememberMyDecision();
		Thread.sleep(1000);
		loginPage.clickYesAllow();
		Thread.sleep(5000);

		String User_Name = System.getProperty("user.name");

		Assert.assertEquals(appFunctions.getUserNameTextMenuBar(), User_Name.toUpperCase());
	}

	@AfterClass
	public void tearDown() throws TimeoutException, WaitException {
		appFunctions.capellaLogOut();
		pageBase.quit();
	}
}
