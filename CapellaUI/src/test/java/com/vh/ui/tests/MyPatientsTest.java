package com.vh.ui.tests;

import org.openqa.selenium.TimeoutException;
import org.testng.annotations.AfterClass;

import com.vh.test.base.TestBase;
import com.vh.ui.actions.ApplicationFunctions;
import com.vh.ui.exceptions.WaitException;
import com.vh.ui.page.base.WebPage;

/*
 * @author Harvy Ackermans
 * @date   March 28, 2017
 * @class  MyPatientsTest.java
 */

public class MyPatientsTest extends TestBase
{	
	// Class objects
	WebPage pageBase;
	ApplicationFunctions appFunctions;
	
	// @Test
	// @Step("Verify Invalid User Name")
	// public void verify_InvalidUserName() throws WaitException,
	// URLNavigationException, InterruptedException
	// {
	// pageBase = new WebPage(getWebDriver());
	// loginPage = (LoginPage)
	// pageBase.navigateTo(applicationProperty.getProperty("webURL"));
//		Thread.sleep(5000);
	//
	// Assert.assertTrue(loginPage.viewUserNameTextField(), "Failed to identify
	// UserName text field");
	// Assert.assertTrue(loginPage.viewPasswordTextField(), "Failed to identify
	// Password text field");
	// loginPage.enterUserName("vhnta");
	// loginPage.enterPassword("test123");
	// loginPage.clickLogin();
	//
	// Assert.assertEquals(loginPage.getLoginErrorMessage(), "Error: Invalid
	// username or password");
	// }
	
	@AfterClass
	public void tearDown() throws TimeoutException, WaitException
	{
		appFunctions.capellaLogOut();
		pageBase.quit();
	}
}
