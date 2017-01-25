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
import com.vh.ui.pages.WebLoginPage;
import com.vh.ui.pages.WebMyDashboardPage;

import ru.yandex.qatools.allure.annotations.Step;

public class LoginTest  extends TestBase{
	
	WebPage pageBase;
	WebLoginPage webLoginPage;
	WebMyDashboardPage webMyDashboardpage;
	ApplicationFunctions app;
	
	@Test
	@Step("Verify Invalid UserName")
	public void verify_InvalidUserName() throws WaitException, URLNavigationException, InterruptedException
	{
		
		pageBase = new WebPage(getWebDriver());
		webLoginPage = (WebLoginPage) pageBase.navigateTo(applicationProperty.getProperty("webURL"));
		Thread.sleep(5000);
		
		Assert.assertTrue(webLoginPage.viewUserNameTextField(), "Failed to identify UserName text field");
		Assert.assertTrue(webLoginPage.viewPasswordTextField(), "Failed to identify Password text field");
		Assert.assertTrue(webLoginPage.viewTokenTextField(), "Failed to identify Token text field");
		webLoginPage.enterUserName("vhnta");
		webLoginPage.enterPassword("test123");
		webLoginPage.enterToken("111111");
		
		webLoginPage.clickLogin();
		
		Assert.assertEquals(webLoginPage.getLoginErrorMessage(), "Invalid username / password combination");
	}
	
	@Test
	@Step("Verify Invalid Password")
	public void verify_InvalidPassword() throws WaitException, URLNavigationException, InterruptedException
	{
		
		pageBase = new WebPage(getWebDriver());
		webLoginPage = (WebLoginPage) pageBase.navigateTo(applicationProperty.getProperty("webURL"));
		Thread.sleep(5000);
		
		Assert.assertTrue(webLoginPage.viewUserNameTextField(), "Failed to identify UserName text field");
		Assert.assertTrue(webLoginPage.viewPasswordTextField(), "Failed to identify Password text field");
		Assert.assertTrue(webLoginPage.viewTokenTextField(), "Failed to identify Token text field");
		webLoginPage.enterUserName("vhnlb");
		webLoginPage.enterPassword("test1234");
		webLoginPage.enterToken("111111");
		
		webLoginPage.clickLogin();
		
		Assert.assertEquals(webLoginPage.getLoginErrorMessage(), "Invalid username / password combination");
	}
	
	@Test
	@Step("Verify Successful Login")
	public void verify_SuccessfulLogin() throws WaitException, URLNavigationException, InterruptedException
	{
		pageBase = new WebPage(getWebDriver());
		app = new ApplicationFunctions(pageBase.getDriver());
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
		boolean isPass = app.closeAllPatients();
		Thread.sleep(10000);
	}
	
	@Step("File upload functionality")
    public void uploadFile() throws Exception {
        String filename = "some-file.txt";
        File file = new File(filename);
        String path = file.getAbsolutePath();
        WebDriver driver = getWebDriver();
        driver.get("http://the-internet.herokuapp.com/upload");
        driver.findElement(By.id("file-upload")).sendKeys(path);
        driver.findElement(By.id("file-submit")).click();
        String text = driver.findElement(By.id("uploaded-files")).getText();
    }
	
	@AfterClass
	public void tearDown() throws TimeoutException, WaitException
	{
		app.capellaLogOut();
		pageBase.quit();
	}
}
