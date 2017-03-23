package com.vh.ui.tests;

import java.io.File;

import org.openqa.selenium.By;
import org.openqa.selenium.TimeoutException;
import org.openqa.selenium.WebDriver;
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
		Assert.assertTrue(loginPage.viewTokenTextField(), "Failed to identify Token text field");
		loginPage.enterUserName("vhnta");
		loginPage.enterPassword("test123");
		loginPage.enterToken("111111");
		
		loginPage.clickLogin();
		
		Assert.assertEquals(loginPage.getLoginErrorMessage(), "Invalid username / password combination");
	}
	
//	@Test
//	@Step("Verify Invalid Password")
//	public void verify_InvalidPassword() throws WaitException, URLNavigationException, InterruptedException
//	{
//		
//		pageBase = new WebPage(getWebDriver());
//		loginPage = (LoginPage) pageBase.navigateTo(applicationProperty.getProperty("webURL"));
//		Thread.sleep(5000);
//		
//		Assert.assertTrue(loginPage.viewUserNameTextField(), "Failed to identify UserName text field");
//		Assert.assertTrue(loginPage.viewPasswordTextField(), "Failed to identify Password text field");
//		Assert.assertTrue(loginPage.viewTokenTextField(), "Failed to identify Token text field");
//		loginPage.enterUserName("vhnlb");
//		loginPage.enterPassword("test1234");
//		loginPage.enterToken("111111");
//		
//		loginPage.clickLogin();
//		
//		Assert.assertEquals(loginPage.getLoginErrorMessage(), "Invalid username / password combination");
//	}
//	
//	@Test
//	@Step("Verify Successful Login")
//	public void verify_SuccessfulLogin() throws WaitException, URLNavigationException, InterruptedException
//	{
//		pageBase = new WebPage(getWebDriver());
//		app = new ApplicationFunctions(pageBase.getDriver());
//		loginPage = (LoginPage) pageBase.navigateTo(applicationProperty.getProperty("webURL"));
//		Thread.sleep(5000);
//		
//		Assert.assertTrue(loginPage.viewUserNameTextField(), "Failed to identify UserName text field");
//		Assert.assertTrue(loginPage.viewPasswordTextField(), "Failed to identify Password text field");
//		Assert.assertTrue(loginPage.viewTokenTextField(), "Failed to identify Token text field");
//		loginPage.enterUserName("vhnaa");
//		loginPage.enterPassword("test123");
//		loginPage.enterToken("111111");
//		
//		webMyDashboardpage = loginPage.clickLogin();
//		Thread.sleep(10000);
//		boolean isPass = app.closeAllPatients();
//		Thread.sleep(10000);
//	}
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