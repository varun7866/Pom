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
	public static final By BTN_PTCHART = By.xpath("//span[text()='Pt Chart']/..");
	public static final By LNK_MYPATIENTS_MENUBAR = By.xpath("//ul/li/a[text()='My Patients']");
	public static final By LNK_MYCONTACTS_MENUBAR = By.xpath("//ul/li/a[text()='My Contacts']");
	public static final By LNK_CONSOLIDATED_MENUBAR = By.xpath("//ul/li/a[text()='Consolidated']");
	public static final By LNK_ADMIN_MENUBAR = By.xpath("//ul/li/a[text()='Admin']");
}