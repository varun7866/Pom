package com.vh.ui.web.locators;

import org.openqa.selenium.By;

/*
 * @author Harshida Patel
 * @date   August 1, 2017
 * @class  ReferralsPage.java
 */

public class ReferralsLocators {
	
	public static final By BTN_ADDAREFERRAL = By.xpath("//button[text()='ADD A REFERRAL']");
	public static final By BTN_NEWREFERRALPOPUPAPPOINTMENTREFERRALDATE = By.xpath("//div[@class='modal-content']//button[@class='btnpicker btnpickerenabled']");
	public static final By BTN_NEWREFERRALSAVE = By.xpath("//button[text()='Save']");
	public static final By BTN_REFERRALAPPOINTMENT = By.xpath("//button[text()='Appointment ']");
	public static final By BTN_NEWREFERRALCANCEL = By.xpath("//button[text()='Cancel']");
	public static final By BTN_NEWREFERRALNEXT = By.xpath("//button[text()='Next']");
	public static final By BTN_NEWREFERRALPROVIDERSTEAM = By.xpath("//button[text()=' 1. Providers/Team ']");
	public static final By BTN_NEWREFERRALAPPOINTMENT = By.xpath("//button[text()=' 2. Appointment ']");
	public static final By BTN_NEWREFERRALREASONS = By.xpath("//button[text()=' 3. Reasons ']");


	public static final By CAL_NEWREFERRALPOPUPAPPOINTMENTTABREFERRALDATE = By.xpath("//div[@class='modal-content']//label[text()='Referral Date']/..//input");

	public static final By CBO_NEWREFERRALPOPUPPROVIDERSTEAMTABPROVIDERSTEAM = By.id("referralsDropDownPvdTeam");
	public static final By CBO_NEWREFERRALPOPUPPROVIDERNAME = By.id("referralsTextBoxPvdName");
	public static final By CBO_NEWREFERRALPOPUPREFFEREDTO = By.id("referralsDropDownReferredTo");
	public static final By CBO_NEWREFERRALPOPUPSTREET = By.id("referralsTextBoxStreet");
	public static final By CBO_NEWREFERRALPOPUPAPTSUITE = By.id("referralsTextBoxAptSuite");
	public static final By CBO_NEWREFERRALPOPUPCITY = By.id("referralsTextBoxCity");
	public static final By CBO_NEWREFERRALPOPUPSTATE = By.id("referralsDropDownState");
	public static final By CBO_NEWREFERRALPOPUPZIP = By.id("referralsTextBoxZip");
	public static final By CBO_NEWREFERRALPOPUPPHONE = By.id("referralsTextBoxPhone");
	public static final By CBO_NEWREFERRALPOPUPFAX = By.id("referralsTextBoxFax");

	public static final By CHK_NEWREFERRALPOPUPREASONS = By.id("AC");
	public static final By CHK_NEWREFERRALPOPUPADDNEWPROVIDER = By.id("referralsCheckBoxAddNewPvd");

	public static final By LBL_REFERRALS = By.xpath("//h2[contains(., 'Referrals')]");
	public static final By LBL_REFERRALSPROVIDERNAMECOLUMNHEADER = By.xpath("//span[text()='PROVIDER NAME']");
	public static final By LBL_REFERRALSREASONCOLUMNHEADER = By.xpath("//span[text()='REASON']");
	public static final By LBL_REFERRALSAPPTDATECOLUMNHEADER = By.xpath("//span[text()='APPT DATE']");
	public static final By LBL_NEWREFERRAL = By.xpath("//span[text()='New Referral']");
	public static final By LBL_NEWREFERRALPROVIDERSTEAMLABEL = By.xpath("//div[@id='providersTeamSection']//label[text()='Providers/Team']");
	public static final By LBL_NEWREFERRALCHOOSEANEXISTINGPROVIDERLABEL = By.xpath("//div[@id='providersTeamSection']//label[text()='Choose an existing provider:']");
	public static final By LBL_NEWREFERRALPROVIDERSTEAMDROPDOWNLABEL = By.xpath("//div[@id='providersTeamSection']//label[text()='Providers/Team' and @class='modal-label']");
	public static final By LBL_NEWREFERRALPOPUPORADDANEWPROVIDER = By.xpath("//div[@id='providersTeamSection']//label[text()='Or add a new provider:']");
	public static final By LBL_NEWREFERRALPOPUPPROVIDERNAME = By.xpath("//div[@id='providersTeamSection']//label[text()='Provider Name']");
	public static final By LBL_NEWREFERRALPOPUPREFFEREDTO = By.xpath("//div[@id='providersTeamSection']//label[text()='Referred To']");
	public static final By LBL_NEWREFERRALPOPUPSTREET = By.xpath("//div[@id='providersTeamSection']//label[text()='Street']");
	public static final By LBL_NEWREFERRALPOPUPAPTSUITE = By.xpath("//div[@id='providersTeamSection']//label[text()='Apt/Suite']");
	public static final By LBL_NEWREFERRALPOPUPCITY = By.xpath("//div[@id='providersTeamSection']//label[text()='City']");
	public static final By LBL_NEWREFERRALPOPUPSTATE = By.xpath("//div[@id='providersTeamSection']//label[text()='State']");
	public static final By LBL_NEWREFERRALPOPUPZIP = By.xpath("//div[@id='providersTeamSection']//label[text()='Zip']");
	public static final By LBL_NEWREFERRALPOPUPPHONE = By.xpath("//div[@id='providersTeamSection']//label[text()='Phone']");
	public static final By LBL_NEWREFERRALPOPUPFAX = By.xpath("//div[@id='providersTeamSection']//label[text()='Fax']");
	public static final By LBL_NEWREFERRALPOPUPADDNEWPROVIDER = By.xpath("//span[text()='Add New Provider to Team']");

	public static final By MNU_REFERRALSMENU = By.id("Referrals-27");
	
	public static final By TAB_NEWREFERRALPOPUPAPPOINTMENT = By.xpath("//button[contains(., '2. Appointment')]");
	public static final By TAB_NEWREFERRALPOPUPREASONS = By.xpath("//button[contains(., '3. Reasons')]");

	public static final By TXT_PROVIDERNAME = By.id("referralsTextBoxPvdName");


}


