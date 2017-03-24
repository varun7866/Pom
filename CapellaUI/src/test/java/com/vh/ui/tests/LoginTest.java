package com.vh.ui.tests;

import org.openqa.selenium.TimeoutException;
import org.testng.Assert;
import org.testng.annotations.AfterClass;
import org.testng.annotations.Test;

import com.vh.test.base.TestBase;
import com.vh.ui.actions.ApplicationFunctions;
import com.vh.ui.exceptions.URLNavigationException;
import com.vh.ui.exceptions.WaitException;
import com.vh.ui.page.base.WebPage;
import com.vh.ui.pages.LoginPage;
import com.vh.ui.pages.MyDashboardPage;

import ru.yandex.qatools.allure.annotations.Step;

/*
 * @author Harvy Ackermans
 * @date   March 23, 2017
 * @class  LoginTest.java
 */

public class LoginTest extends TestBase
{	
	// Class objects
	WebPage pageBase;
	LoginPage loginPage;
	MyDashboardPage myDashboard;
	ApplicationFunctions appFunctions;
	
	@Test
	@Step("Verify Invalid User Name")
	public void verify_InvalidUserName() throws WaitException, URLNavigationException, InterruptedException
	{		
		pageBase = new WebPage(getWebDriver());
		loginPage = (LoginPage) pageBase.navigateTo(applicationProperty.getProperty("webURL"));
		Thread.sleep(5000);
		
		Assert.assertTrue(loginPage.viewUserNameTextField(), "Failed to identify UserName text field");
		Assert.assertTrue(loginPage.viewPasswordTextField(), "Failed to identify Password text field");
		loginPage.enterUserName("vhnta");
		loginPage.enterPassword("test123");		
		loginPage.clickLogin();
		
		Assert.assertEquals(loginPage.getLoginErrorMessage(), "Error: Invalid username or password");
	}
	
	@Test
	@Step("Verify Invalid Password")
	public void verify_InvalidPassword() throws WaitException, URLNavigationException, InterruptedException
	{
		
		pageBase = new WebPage(getWebDriver());
		loginPage = (LoginPage) pageBase.navigateTo(applicationProperty.getProperty("webURL"));
		Thread.sleep(5000);
	
		Assert.assertTrue(loginPage.viewUserNameTextField(), "Failed to identify UserName text field");
		Assert.assertTrue(loginPage.viewPasswordTextField(), "Failed to identify Password text field");
		loginPage.enterUserName("vhncl");
		loginPage.enterPassword("test1234");		
		loginPage.clickLogin();
		
		Assert.assertEquals(loginPage.getLoginErrorMessage(), "Error: Invalid username or password");
	}
	
	@Test
	@Step("Verify Successful Login")
	public void verify_SuccessfulLogin() throws WaitException, URLNavigationException, InterruptedException
	{
		pageBase = new WebPage(getWebDriver());
		loginPage = (LoginPage) pageBase.navigateTo(applicationProperty.getProperty("webURL"));
		Thread.sleep(5000);

		Assert.assertTrue(loginPage.viewUserNameTextField(), "Failed to identify UserName text field");
		Assert.assertTrue(loginPage.viewPasswordTextField(), "Failed to identify Password text field");
		loginPage.enterUserName("hackermans");
		loginPage.enterPassword("Feb2017!");
		loginPage.clickLogin();
	
		// Assert.assertEquals(loginPage.getLoginErrorMessage(), "Error: Invalid
		// username or password");
	}
//	
//	@Step("File upload functionality")
//    public void uploadFile() throws Exception {
//        String filename = "some-file.txt";
//        File file = new File(filename);
//        String path = file.getAbsolutePath();
//        WebDriver driver = getWebDriver();
//        driver.get("http://the-internet.herokuapp.com/upload");
//        driver.findElement(By.id("file-upload")).sendKeys(path);
//        driver.findElement(By.id("file-submit")).click();
//        String text = driver.findElement(By.id("uploaded-files")).getText();
//    }
	
	@AfterClass
	public void tearDown() throws TimeoutException, WaitException
	{
		appFunctions.capellaLogOut();
		pageBase.quit();
	}
}
