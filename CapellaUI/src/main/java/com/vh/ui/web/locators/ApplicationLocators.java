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
	public static final By BTN_LOGOUT = By.xpath("//span[@data-capella-automation-id ='LogOut']");
	public static final By BTN_USERNOTES = By.cssSelector("*[class^='notes-button']");
	public static final By LBL_USERNAME = By
			.xpath("//*[starts-with(@data-capella-automation-id,'label-UserFirstName')]");
	public static final By LBL_LOGOUT_MSG = By.xpath("id('myModal')/div[2]/div[2]/div[2]/span[1]/b");
	public static final By BTN_LOGOUT_OK = By
			.xpath("id('myModal')/div[2]/div[3]/div[2]/input[1][@data-capella-automation-id ='LogOut-Btn-OK']");
}