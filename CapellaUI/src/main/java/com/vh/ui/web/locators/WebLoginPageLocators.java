/**
 * 
 */
package com.vh.ui.web.locators;

import org.openqa.selenium.By;

/**
 * @author SUBALIVADA
 * @date   Nov 21, 2016
 * @class  WebLoginPageLocators.java
 *
 */
public class WebLoginPageLocators {
	public static final By TXT_USERNAME = By.id("inputUsername");
	public static final By TXT_PASSWORD = By.id("password");
	public static final By TXT_TOKEN = By.id("token");
	public static final By BTN_LOGIN = By.id("modalview-login-button");
	public static final By LBL_LOGINERRORMSG = By.xpath("id('myModal')/div[3]/div[2]/span[1]/b[@data-capella-automation-id ='label-ErrorMessage']");
}
