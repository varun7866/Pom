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
	public static final By BTN_LOGOUT = By.xpath("//button[text()='Logout']");

	public static final By LNK_MENUBAR_MYPATIENTS = By.xpath("//ul/li/a[text()='My Patients']");
	public static final By LNK_MENUBAR_MYTASKS = By.xpath("//ul/li/a[text()='My Tasks']");
	public static final By LNK_MENUBAR_MYSCHEDULE = By.xpath("//ul/li/a[text()='My Schedule']");
	public static final By LNK_MENUBAR_ADMIN = By.xpath("//ul/li/a[text()='Admin']");
	
	public static final By LBL_PATIENTCONTACTS = By.xpath("//h2[@class='page-title contacts-title']");

    public static final By TXT_MENUBAR_USERNAME = By.xpath("//h4[contains(., 'Welcome')]");
}