/**
 * 
 */
package com.vh.ui.web.locators;

import org.openqa.selenium.By;

/*
 * @author Harvy Ackermans
 * @date   March 23, 2017
 * @class  LoginLocators.java
 */

public class LoginLocators
{
	public static final By BTN_LOGIN = By.xpath("//button[text()='Login']");
	public static final By BTN_YESALLOW = By.xpath("//button[text()='Yes, Allow']");

	public static final By CHK_REMEMBERMYDECISION = By.xpath("//input[@name='RememberConsent']");

	public static final By LBL_LOGINERRORMSG = By.xpath("//strong[text()='Error:']/..");

	public static final By TXT_USERNAME = By.id("username");
	public static final By TXT_PASSWORD = By.id("password");
    public static final By TXT_USERNAME_PATIENTBANNER = By.xpath("//h4[contains(., 'Welcome')]");
}