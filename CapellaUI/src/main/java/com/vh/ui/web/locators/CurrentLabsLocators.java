/**
 * 
 */
package com.vh.ui.web.locators;

import org.openqa.selenium.By;

/*
 * @author Harvy Ackermans
 * @date   June 14, 2017
 * @class  CurrentLabsLocators.java
 */

public class CurrentLabsLocators
{
	public static final By BTN_ADDLAB = By.xpath("//button[text()='Add Lab']");
	public static final By BTN_ADDPOPUPCANCEL = By.xpath("//button[text()='Cancel']");
	public static final By BTN_ADDPOPUPSAVE = By.xpath("//button[text()='Save']");

	public static final By LBL_PAGEHEADER = By.xpath("//div[@class='col-sm-6 lab-screennameheader']");
	public static final By LBL_ADDPOPUPADDLABRESULTS = By.xpath("//span[text()='Add Lab Results']");
	public static final By LBL_ADDPOPUPAPPLYTHISDATETOALLVALUES = By.xpath("//span[text()='APPLY THIS DATE TO ALL VALUES']");
}