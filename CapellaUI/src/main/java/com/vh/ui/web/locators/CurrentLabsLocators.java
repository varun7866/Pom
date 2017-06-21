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
	public static final By BTN_ADDPOPUPAPPLYTHISDATETOALLVALUES = By
	        .xpath("//div[@class='modal-dialog modal-lg']//span[text()='APPLY THIS DATE TO ALL VALUES']/../../..//input/..//button[@class='btnpicker btnpickerenabled']");

	public static final By CAL_ADDPOPUPAPPLYTHISDATETOALLVALUES = By.xpath("//div[@class='modal-dialog modal-lg']//span[text()='APPLY THIS DATE TO ALL VALUES']/../../..//input");

	public static final By LBL_PAGEHEADER = By.xpath("//h2[contains(., 'Labs')]");
	public static final By LBL_ADDPOPUPADDLABRESULTS = By.xpath("//span[text()='Add Lab Results']");
	public static final By LBL_ADDPOPUPAPPLYTHISDATETOALLVALUES = By.xpath("//span[text()='APPLY THIS DATE TO ALL VALUES']");
	public static final By LBL_ADDPOPUPHEIGHT = By.xpath("//span[text()='Height']");
	public static final By LBL_ADDPOPUPTARGETDRYWEIGHT = By.xpath("//span[text()='Target Dry Weight']");

	public static final By PLH_ADDPOPUPHEIGHT = By.xpath("//span[text()='Height']/../../../div[2]/div/input[@placeholder='cm']");
	public static final By PLH_ADDPOPUPTARGETDRYWEIGHT = By.xpath("//span[text()='Target Dry Weight']/../../../div[2]/div/input[@placeholder='kg']");

	public static final By TXT_ADDPOPUPHEIGHT = By.xpath("//span[text()='Height']/../../../div[2]/div/input");
	public static final By TXT_ADDPOPUPTARGETDRYWEIGHT = By.xpath("//span[text()='Target Dry Weight']/../../../div[2]/div/input");
}