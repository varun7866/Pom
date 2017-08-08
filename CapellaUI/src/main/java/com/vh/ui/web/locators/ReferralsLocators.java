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

	public static final By CAL_NEWREFERRALPOPUPAPPOINTMENTTABREFERRALDATE = By.xpath("//div[@class='modal-content']//label[text()='Referral Date']/..//input");

	public static final By CBO_NEWREFERRALPOPUPPROVIDERSTEAMTABPROVIDERSTEAM = By.id("referralsDropDownPvdTeam");

	public static final By CHK_NEWREFERRALPOPUPREASONS = By.id("AC");

	public static final By LBL_REFERRALS = By.xpath("//h2[contains(., 'Referrals')]");

	public static final By MNU_REFERRALSMENU = By.id("Referrals-27");
	
	public static final By TAB_NEWREFERRALPOPUPAPPOINTMENT = By.xpath("//button[contains(., '2. Appointment')]");
	public static final By TAB_NEWREFERRALPOPUPREASONS = By.xpath("//button[contains(., '3. Reasons')]");

	public static final By TXT_PROVIDERNAME = By.id("referralsTextBoxPvdName");


}


