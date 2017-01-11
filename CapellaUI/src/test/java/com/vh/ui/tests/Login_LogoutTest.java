package com.vh.ui.tests;

import org.openqa.selenium.TimeoutException;
import org.testng.Assert;
import org.testng.annotations.Test;

import com.vh.test.base.TestBase;
import com.vh.ui.exceptions.URLNavigationException;
import com.vh.ui.exceptions.WaitException;
import com.vh.ui.page.base.WebPage;
import com.vh.ui.pages.WebLoginPage;
import com.vh.ui.pages.WebMyDashboardPage;

import ru.yandex.qatools.allure.annotations.Step;

public class Login_LogoutTest extends TestBase{
	
	WebPage pageBase;
	WebLoginPage webLoginPage;
	WebMyDashboardPage webMyDashboardpage;

	
	@Test(priority=1)
	@Step("Launch Application")
	public void launchApplication() throws WaitException, URLNavigationException, InterruptedException
	{
		pageBase = new WebPage(getWebDriver());
		webLoginPage = (WebLoginPage) pageBase.navigateTo(applicationProperty.getProperty("webURL"));
		Thread.sleep(5000);
	}
	
	@Test(priority=2)
	@Step("Verify user name text field")
	public void verifyUserNameTextField() throws TimeoutException, WaitException
	{
		Assert.assertTrue(webLoginPage.viewUserNameTextField(), "Failed to identify UserName text field");
	}
	
	@Test(priority=3)
	@Step("Verify password text field")
	public void verifyPasswordTextField() throws TimeoutException, WaitException
	{
		Assert.assertTrue(webLoginPage.viewPasswordTextField(), "Failed to identify Password text field");
	}
	
	@Test(priority=4)
	@Step("Verify token text field")
	public void verifyTokenTextField() throws TimeoutException, WaitException
	{
		Assert.assertTrue(webLoginPage.viewTokenTextField(), "Failed to identify Token text field");
	}
	
	@Test(priority=5)
	public void validateLogin() throws TimeoutException, WaitException
	{
		webLoginPage.enterUserName("tin1");
		webLoginPage.enterPassword("test123");
		webLoginPage.enterToken("111111");
		
		WebMyDashboardPage webMyDashboardpage = webLoginPage.clickLogin();
	}
}
