/**
 * 
 */
package com.vh.ui.pages;

import static com.vh.ui.web.locators.WebMyDashboardPageLocators.BTN_CLOSE_PATIENT_YES;
import static com.vh.ui.web.locators.WebMyDashboardPageLocators.BTN_EXPAND_OPENPATIENT;
import static com.vh.ui.web.locators.WebMyDashboardPageLocators.BTN_LOGOUT;
import static com.vh.ui.web.locators.WebMyDashboardPageLocators.BTN_LOGOUT_OK;
import static com.vh.ui.web.locators.WebMyDashboardPageLocators.LBL_DO_YOU_WANT_TO_FINALIZE;
import static com.vh.ui.web.locators.WebMyDashboardPageLocators.LBL_LOGOUT_MSG;
import static com.vh.ui.web.locators.WebMyDashboardPageLocators.LBL_NO_OF_PATIENTS;
import static com.vh.ui.web.locators.WebMyDashboardPageLocators.LBL_USERNAME;
import static com.vh.ui.web.locators.WebMyDashboardPageLocators.OPEN_PATIENT_CONTAINER;
import static com.vh.ui.web.locators.WebMyDashboardPageLocators.POPUP_CLOSE_PATIENT;

import java.util.List;

import org.openqa.selenium.By;
import org.openqa.selenium.TimeoutException;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;

import com.vh.ui.exceptions.WaitException;
import com.vh.ui.page.base.WebPage;
import com.vh.ui.utilities.Utilities;
import com.vh.ui.waits.WebDriverWaits;

import ru.yandex.qatools.allure.annotations.Step;

/**
 * @author SUBALIVADA
 * @date   Nov 21, 2016
 * @class  WebMyDashboardPage.java
 *
 */
public class WebMyDashboardPage extends WebPage{

	WebLoginPage webLoginPage;
	
	/**
	 * @param driver
	 * @throws WaitException
	 */
	public WebMyDashboardPage(WebDriver driver) throws WaitException {
		super(driver);
	}

	public boolean viewUserName() throws WaitException{
		LOGGER.debug("In WebMyDashboardPage - viewUserName method");
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_USERNAME);
	}
	
	public boolean viewLogoutButton() throws WaitException{
		LOGGER.debug("In WebMyDashboardPage - viewLogoutButton method");
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, BTN_LOGOUT);
	}
	
	public String verifyUserName() throws TimeoutException, WaitException{
		LOGGER.debug("In WebMyDashboardPage - verifyUserName method");
		return webActions.getText(VISIBILITY, LBL_USERNAME);
	}
	
	public void clickLogout() throws TimeoutException, WaitException{
		LOGGER.debug("In WebMyDashboardPage - clickLogout method");
		webActions.actionClick(PRESENCE, BTN_LOGOUT);
	}	
}
