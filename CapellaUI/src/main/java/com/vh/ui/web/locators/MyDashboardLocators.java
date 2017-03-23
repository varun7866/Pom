/**
 * 
 */
package com.vh.ui.web.locators;

import org.openqa.selenium.By;

/**
 * @author SUBALIVADA
 * @date   Nov 21, 2016
 * @class  WebMyDashboardPageLocators.java
 *
 */
public class MyDashboardLocators {
	//logout
	public static final By BTN_LOGOUT = By.xpath("//span[@data-capella-automation-id ='LogOut']");
	public static final By BTN_USERNOTES = By.cssSelector("*[class^='notes-button']");
	public static final By LBL_USERNAME = By.xpath("//*[starts-with(@data-capella-automation-id,'label-UserFirstName')]");
	public static final By LBL_LOGOUT_MSG = By.xpath("id('myModal')/div[2]/div[2]/div[2]/span[1]/b");
	public static final By BTN_LOGOUT_OK = By.xpath("id('myModal')/div[2]/div[3]/div[2]/input[1][@data-capella-automation-id ='LogOut-Btn-OK']");
	
	//Open patient widget
	public static final By BTN_EXPAND_OPENPATIENT = By.xpath("//div[@data-capella-automation-id ='expandDiv-OpenPatients']");
	public static final By BTN_COLLAPSE_OPENPATIENT = By.xpath("//div[@data-capella-automation-id='collapseDiv-OpenPatients']");
	public static final By LBL_NO_OF_PATIENTS = By.xpath("//span[@title='Number of open Patients']");
	public static final By OPEN_PATIENT_CONTAINER = By.id("Container3Body");
	public static final By POPUP_CLOSE_PATIENT = By.id("myModal");
	public static final By LBL_DO_YOU_WANT_TO_FINALIZE = By.xpath("id('myModal')/div[2]/div[1]/div[1]/div[2]/div[1]/div[1]/b[1]");
	public static final By BTN_CLOSE_PATIENT_YES = By.xpath("//button[@data-capella-automation-id='Close Patient?_Btn_yes']");
}