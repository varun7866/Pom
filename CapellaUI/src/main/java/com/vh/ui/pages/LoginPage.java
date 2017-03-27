package com.vh.ui.pages;

import static com.vh.ui.web.locators.LoginLocators.BTN_ADDTOCONTACTS;
import static com.vh.ui.web.locators.LoginLocators.BTN_LOGIN;
import static com.vh.ui.web.locators.LoginLocators.BTN_YESALLOW;
import static com.vh.ui.web.locators.LoginLocators.LBL_LOGINERRORMSG;
import static com.vh.ui.web.locators.LoginLocators.TXT_PASSWORD;
import static com.vh.ui.web.locators.LoginLocators.TXT_USERNAME;

import org.openqa.selenium.TimeoutException;
import org.openqa.selenium.WebDriver;

import com.vh.ui.exceptions.URLNavigationException;
import com.vh.ui.exceptions.WaitException;
import com.vh.ui.page.base.WebPage;

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
	
	@Step("Verifying the visibility of the User Name text field")
	public boolean viewUserNameTextField() throws TimeoutException, WaitException {
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, TXT_USERNAME);
	}
	
	@Step("Verifying the visibility of the Password text field")
	public boolean viewPasswordTextField() throws TimeoutException, WaitException {
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, TXT_PASSWORD);
	}
	
	@Step("Verifying the visibility of the Yes, Allow button")
	public boolean viewYesAllowButton() throws TimeoutException, WaitException {
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, BTN_YESALLOW);
	}

	@Step("Verifying the visibility of the My Patients page")
	public boolean viewMyPatientsPage() throws TimeoutException, WaitException {
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, BTN_ADDTOCONTACTS);
	}

	@Step("Entered {0} in the User Name text field")
	public LoginPage enterUserName(String userNameVal) throws TimeoutException, WaitException {
		webActions.enterText(VISIBILITY, TXT_USERNAME, userNameVal);
		return this;
	}
	
	@Step("Entered {0} in the Password text field")
	public LoginPage enterPassword(String pwd) throws TimeoutException, WaitException {
		webActions.enterText(VISIBILITY, TXT_PASSWORD, pwd);
		return this;
	}	
	
	@Step("Click Login")
	public MyDashboardPage clickLogin() throws TimeoutException, WaitException {
		webActions.click(VISIBILITY, BTN_LOGIN);
		return new MyDashboardPage(getDriver());
	}
	
	@Step("Click Yes, Allow")
	public MyDashboardPage clickYesAllow() throws TimeoutException, WaitException {
		webActions.click(VISIBILITY, BTN_YESALLOW);
		return new MyDashboardPage(getDriver());
	}

	@Step("Get the login error message")
	public String getLoginErrorMessage() throws TimeoutException, WaitException
	{
		String Invalid_Errormessage = webActions.getText(VISIBILITY, LBL_LOGINERRORMSG);
		System.out.println(Invalid_Errormessage);

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
			
			MyDashboardPage myDashboard = loginPage.clickLogin();
			Thread.sleep(10000);
			return true;
		}
		return false;
	}
}