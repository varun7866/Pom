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
	public static final By BTN_ADDAPROVIDER = By.xpath("//button//span[text()='ADD A PROVIDER']");
	public static final By BTN_NEWTEAMPOPUPSUBMIT = By.xpath("//button//span[text()='Submit']");
	public static final By BTN_NEWTEAMPOPUPPATIENTSEEINGSINCE = By.xpath("//label[text()='PATIENT SEEING SINCE ']/../../..//button[@class='mat-datepicker-toggle']");
	public static final By BTN_NEWPROVIDERPOPUPSEARCH = By.xpath("//button//span[text()='Search']");
	public static final By BTN_NEWPROVIDERPOPUPADDPROVIDER = By.xpath("//button//span[contains(., 'ADD PROVIDER')]");
	public static final By BTN_NEWTEAMPOPUPX = By.xpath("//button[@class='dialog-close mat-icon-button']");

	public static final By CBO_ACTIVEINACTIVE = By.xpath("//select");
	public static final By CBO_NEWTEAMPOPUPTEAMTYPE = By.xpath("//providers-team-add-team//md-select/div/span[contains(., 'TEAM TYPE')]");
	public static final By CBO_NEWTEAMPOPUPSTATE = By.xpath("//providers-team-add-team//md-select/div/span[contains(., 'STATE')]");
	public static final By CBO_NEWPROVIDERPOPUPASSOCIATEAS = By.xpath("//providers-team-add-provider//md-select/div/span[contains(., 'ASSOCIATE AS')]");

	public static final By CHK_NEWTEAMPOPUPALLOWCOMMUNICATION = By.xpath("//span[contains(., 'Allow Communication')]/..//input");
	public static final By CHK_NEWTEAMPOPUPFAXNUMBERVERIFIED = By.xpath("//span[contains(., 'Fax Number Verified')]/..//input");

	public static final By LBL_PAGEHEADER = By.xpath("//h2[contains(., 'Providers and Team')]");
	public static final By LBL_NAMETYPECOLUMNHEADER = By.xpath("//span[text()='NAME/TYPE']");
	public static final By LBL_ADDRESSCOLUMNHEADER = By.xpath("//span[text()='ADDRESS']");
	public static final By LBL_DATESCOLUMNHEADER = By.xpath("//span[text()='DATES']");
	public static final By LBL_ALLOWCONTACTCOLUMNHEADER = By.xpath("//span[text()='ALLOW CONTACT']");
	public static final By LBL_NEWTEAMPOPUPHEADER = By.id("md-dialog-title-0");
	public static final By LBL_NEWTEAMPOPUPTEAMTYPE = By.xpath("//span[contains(., 'TEAM TYPE')]");

	public static final By PLH_ACTIVEINACTIVE = By.xpath("//select//option[@value='0: Active']");

	public static final By TXT_NEWTEAMPOPUPNAME = By.id("md-input-27");
	public static final By TXT_NEWTEAMPOPUPEMAIL = By.id("md-input-29");
	public static final By TXT_NEWTEAMPOPUPADDRESS = By.xpath("//input[@ng-reflect-placeholder='ADDRESS']");
	public static final By TXT_NEWTEAMPOPUPAPTSUITE = By.xpath("//input[@ng-reflect-placeholder='APT/SUITE']");
	public static final By TXT_NEWTEAMPOPUPCITY = By.xpath("//input[@ng-reflect-placeholder='CITY']");
	public static final By TXT_NEWTEAMPOPUPZIP = By.xpath("//input[@ng-reflect-placeholder='ZIP']");
	public static final By TXT_NEWTEAMPOPUPPHONE = By.xpath("//input[@ng-reflect-placeholder='PHONE']");
	public static final By TXT_NEWTEAMPOPUPFAX = By.xpath("//input[@ng-reflect-placeholder='FAX']");
	public static final By TXT_NEWTEAMPOPUPOTHERPHONE = By.xpath("//input[@ng-reflect-placeholder='OTHER PHONE']");
	public static final By TXT_NEWTEAMPOPUPPATIENTSEEINGSINCE = By.xpath("//input[@ng-reflect-placeholder='PATIENT SEEING SINCE']");
}