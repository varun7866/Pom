/**
 * 
 */
package com.vh.ui.web.locators;

import org.openqa.selenium.By;

/*
 * @author Harvy Ackermans
 * @date   March 28, 2017
 * @class  ApplicationLocators.java
 */

public class ApplicationLocators
{
	// logout
	public static final By TXT_USERNAME_MENUBAR = By.xpath("//header/h1[contains(., 'Welcome')]");
	public static final By BTN_LOGOUT = By.xpath("//button[text()='Logout']");
}