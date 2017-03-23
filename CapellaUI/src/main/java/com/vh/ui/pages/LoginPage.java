/**
 * 
 */
package com.vh.ui.pages;

import static com.vh.ui.web.locators.LoginLocators.BTN_LOGIN;
import static com.vh.ui.web.locators.LoginLocators.LBL_LOGINERRORMSG;
import static com.vh.ui.web.locators.LoginLocators.TXT_PASSWORD;
import static com.vh.ui.web.locators.LoginLocators.TXT_TOKEN;
import static com.vh.ui.web.locators.LoginLocators.TXT_USERNAME;

import org.openqa.selenium.By;
import org.openqa.selenium.TimeoutException;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;
import org.testng.Assert;

import com.vh.ui.exceptions.URLNavigationException;
import com.vh.ui.exceptions.WaitException;
import com.vh.ui.page.base.WebPage;
import com.vh.ui.utilities.Utilities;

import ru.yandex.qatools.allure.annotations.Step;

/*
 * @author Harvy Ackermans
 * @date   March 23, 2017
 * @class  LoginTest.java
 */

public class LoginPage extends WebPage
{
	public LoginPage(WebDriver driver) throws WaitException {
		super(driver);
	}
	
	@Step("Verifying the visibility of User Name text field")
	public boolean viewUserNameTextField() throws TimeoutException, WaitException {
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, TXT_USERNAME);
	}
	
	@Step("Verifying the visibility of Password text field")
	public boolean viewPasswordTextField() throws TimeoutException, WaitException {
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, TXT_PASSWORD);
	}
	
	@Step("Verifying the visibility of Token text field")
	public boolean viewTokenTextField() throws TimeoutException, WaitException {
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, TXT_TOKEN);
	}
	
	@Step("Entered {0} in user name  text field")
	public LoginPage enterUserName(String userNameVal) throws TimeoutException, WaitException {
		webActions.enterText(VISIBILITY, TXT_USERNAME, userNameVal);
		return this;
	}
	
	@Step("Entered {0} in Password text field")
	public LoginPage enterPassword(String pwd) throws TimeoutException, WaitException {
		webActions.enterText(VISIBILITY, TXT_PASSWORD, pwd);
		return this;
	}
	
	@Step("Entered {0} in token text field")
	public LoginPage enterToken(String token) throws TimeoutException, WaitException {
		webActions.enterText(VISIBILITY, TXT_TOKEN, token);
		return this;
	}
	
	@Step("Click Login")
	public MyDashboardPage clickLogin() throws TimeoutException, WaitException {
		webActions.click(VISIBILITY, BTN_LOGIN);
		return new MyDashboardPage(getDriver());
	}
	
	@Step("Get the login error message")
	public String getLoginErrorMessage() throws TimeoutException, WaitException
	{
//		WebDriverWait Wait = new WebDriverWait(driver, 30);
//		WebElement we = driver.findElement(LBL_LOGINERRORMSG);
//		Wait.until(ExpectedConditions.visibilityOf(we));
		//Wait.until(ExpectedConditions.alertIsPresent());
		//return driverIE.switchTo().alert().getText();
//		Utilities.highlightElement(driver, we);
		String Invalid_Errormessage = webActions.getText(VISIBILITY, LBL_LOGINERRORMSG);
		System.out.println(Invalid_Errormessage);
//		WE_InvalidOKButton.click();
//		
//		Thread.sleep(5000);
//		//Wait.wait(30);
//		
//		WE_UserName.clear();
//		WE_Password.clear();
//		WE_Token.clear();
		return Invalid_Errormessage;
		
	}
	
	@Step("Login to Capella application {0} with user name {1}")
	public boolean loginToCapella(String url, String username, String password, String token) throws URLNavigationException, WaitException, InterruptedException
	{
		LoginPage loginPage = (LoginPage) navigateTo(url);
//		Thread.sleep(5000);
		
		if(loginPage.viewUserNameTextField())
		{
			loginPage.enterUserName(username);
			loginPage.enterPassword(password);
			loginPage.enterToken(token);
		
			MyDashboardPage webMyDashboardpage = loginPage.clickLogin();
			Thread.sleep(10000);
			return true;
		}
		return false;
		
	}
}