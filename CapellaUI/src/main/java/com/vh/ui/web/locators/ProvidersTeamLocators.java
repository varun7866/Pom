package com.vh.ui.web.locators;

import org.openqa.selenium.By;

/*
 * @author Harvy Ackermans
 * @date   August 2, 2017
 * @class  ProvidersTeamLocators.java
 */

public class ProvidersTeamLocators
{
	public static final By BTN_ADDATEAMMEMBER = By.xpath("//button//span[text()='ADD A TEAM MEMBER']");
	public static final By BTN_NEWTEAMPOPUPSUBMIT = By.xpath("//button//span[text()='Submit']");
	public static final By BTN_NEWTEAMPOPUPPATIENTSEEINGSINCE = By.xpath("//label[text()='PATIENT SEEING SINCE ']/../../..//button[@class='mat-datepicker-toggle']");
	public static final By BTN_ADDAPROVIDER = By.xpath("//button//span[text()='ADD A PROVIDER']");

	public static final By CBO_NEWTEAMPOPUPTEAMTYPE = By.xpath("//providers-team-add-team//md-select/div/span[contains(., 'TEAM TYPE')]");
	public static final By CBO_NEWTEAMPOPUPSTATE = By.xpath("//providers-team-add-team//md-select/div/span[contains(., 'STATE')]");

	public static final By CHK_NEWTEAMPOPUPALLOWCOMMUNICATION = By.xpath("//span[contains(., 'Allow Communication')]/..//input");
	public static final By CHK_NEWTEAMPOPUPFAXNUMBERVERIFIED = By.xpath("//span[contains(., 'Fax Number Verified')]/..//input");

	public static final By TXT_NEWTEAMPOPUPNAME = By.xpath("//input[@ng-reflect-placeholder='NAME']");
	public static final By TXT_NEWTEAMPOPUPEMAIL = By.xpath("//input[@ng-reflect-placeholder='EMAIL']");
	public static final By TXT_NEWTEAMPOPUPADDRESS = By.xpath("//input[@ng-reflect-placeholder='ADDRESS']");
	public static final By TXT_NEWTEAMPOPUPAPTSUITE = By.xpath("//input[@ng-reflect-placeholder='APT/SUITE']");
	public static final By TXT_NEWTEAMPOPUPCITY = By.xpath("//input[@ng-reflect-placeholder='CITY']");
	public static final By TXT_NEWTEAMPOPUPZIP = By.xpath("//input[@ng-reflect-placeholder='ZIP']");
	public static final By TXT_NEWTEAMPOPUPPHONE = By.xpath("//input[@ng-reflect-placeholder='PHONE']");
	public static final By TXT_NEWTEAMPOPUPFAX = By.xpath("//input[@ng-reflect-placeholder='FAX']");
	public static final By TXT_NEWTEAMPOPUPOTHERPHONE = By.xpath("//input[@ng-reflect-placeholder='OTHER PHONE']");
	public static final By TXT_NEWTEAMPOPUPPATIENTSEEINGSINCE = By.xpath("//input[@ng-reflect-placeholder='PATIENT SEEING SINCE']");
}