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
	public static final By BTN_NEWTEAMPOPUPX = By.xpath("//div[@class='dialog-header-actions']//button");

	public static final By CAL_NEWTEAMPOPUPPATIENTSEEINGSINCE = By.xpath("//providers-team-add-team//label[contains(., 'PATIENT SEEING SINCE')]/../../input");

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
	public static final By LBL_NEWTEAMPOPUPHEADER = By.xpath("//h2[contains(., 'New Team')]");
	public static final By LBL_NEWTEAMPOPUPTEAMTYPE = By.xpath("//providers-team-add-team//span[contains(., 'TEAM TYPE')]");
	public static final By LBL_NEWTEAMPOPUPNAME = By.xpath("//providers-team-add-team//label[contains(., 'NAME')]/span[text()='*']");
	public static final By LBL_NEWTEAMPOPUPEMAIL = By.xpath("//providers-team-add-team//label[contains(., 'EMAIL')]");
	public static final By LBL_NEWTEAMPOPUPADDRESS = By.xpath("//providers-team-add-team//label[contains(., 'ADDRESS')]");
	public static final By LBL_NEWTEAMPOPUPAPTSUITE = By.xpath("//providers-team-add-team//label[contains(., 'APT/SUITE')]");
	public static final By LBL_NEWTEAMPOPUPCITY = By.xpath("//providers-team-add-team//label[contains(., 'CITY')]");
	public static final By LBL_NEWTEAMPOPUPSTATE = By.xpath("//providers-team-add-team//span[contains(., 'STATE')]");
	public static final By LBL_NEWTEAMPOPUPZIP = By.xpath("//providers-team-add-team//span[contains(., 'ZIP')]");
	public static final By LBL_NEWTEAMPOPUPPHONE = By.xpath("//providers-team-add-team//span[contains(., 'PHONE')]");
	public static final By LBL_NEWTEAMPOPUPFAX = By.xpath("//providers-team-add-team//span[contains(., 'FAX')]");
	public static final By LBL_NEWTEAMPOPUPOTHERPHONE = By.xpath("//providers-team-add-team//span[contains(., 'OTHER PHONE')]");
	public static final By LBL_NEWTEAMPOPUPALLOWCOMMUNICATION = By.xpath("//span[contains(., 'Allow Communication')]");
	public static final By LBL_NEWTEAMPOPUPFAXNUMBERVERIFIED = By.xpath("//span[contains(., 'Fax Number Verified')]");
	public static final By LBL_NEWTEAMPOPUPPATIENTSEEINGSINCE = By.xpath("//span[contains(., 'PATIENT SEEING SINCE')]");

	public static final By PLH_ACTIVEINACTIVE = By.xpath("//select//option[@value='0: Active']");
	public static final By PLH_NEWTEAMPOPUPTEAMTYPE = By.xpath("//providers-team-add-team//span[contains(., 'TEAM TYPE')]/..//span[text()='Select a value']");
	public static final By PLH_NEWTEAMPOPUPSTATE = By.xpath("//providers-team-add-team//span[contains(., 'STATE')]/..//span[text()='Select a value']");

	public static final By TXT_NEWTEAMPOPUPNAME = By.xpath("//providers-team-add-team//label[contains(., 'NAME')]/../../input");
	public static final By TXT_NEWTEAMPOPUPEMAIL = By.xpath("//providers-team-add-team//label[contains(., 'EMAIL')]/../../input");
	public static final By TXT_NEWTEAMPOPUPADDRESS = By.xpath("//providers-team-add-team//label[contains(., 'ADDRESS')]/../../input");
	public static final By TXT_NEWTEAMPOPUPAPTSUITE = By.xpath("//providers-team-add-team//label[contains(., 'APT/SUITE')]/../../input");
	public static final By TXT_NEWTEAMPOPUPCITY = By.xpath("//providers-team-add-team//label[contains(., 'CITY')]/../../input");
	public static final By TXT_NEWTEAMPOPUPZIP = By.xpath("//providers-team-add-team//label[contains(., 'ZIP')]/../../input");
	public static final By TXT_NEWTEAMPOPUPPHONE = By.xpath("//providers-team-add-team//label[contains(., 'PHONE')]/../../input");
	public static final By TXT_NEWTEAMPOPUPFAX = By.xpath("//providers-team-add-team//label[contains(., 'FAX')]/../../input");
	public static final By TXT_NEWTEAMPOPUPOTHERPHONE = By.xpath("//providers-team-add-team//label[contains(., 'OTHER PHONE')]/../../input");
	public static final By TXT_NEWTEAMPOPUPPATIENTSEEINGSINCE = By.xpath("//providers-team-add-team//label[contains(., 'PATIENT SEEING SINCE')]/../../input");
}