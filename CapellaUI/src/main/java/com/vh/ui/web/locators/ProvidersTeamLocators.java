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

	public static final By CBO_NEWTEAMPOPUPTEAMTYPE = By.xpath("//button//span[text()='ADD A TEAM MEMBER']");
	public static final By CBO_NEWTEAMPOPUPSTATE = By.xpath("//button//span[text()='STATE']");

	public static final By TXT_NEWTEAMPOPUPNAME = By.xpath("//input[@ng-reflect-placeholder='NAME']");
	public static final By TXT_NEWTEAMPOPUPEMAIL = By.xpath("//input[@ng-reflect-placeholder='EMAIL']");
	public static final By TXT_NEWTEAMPOPUPADDRESS = By.xpath("//input[@ng-reflect-placeholder='ADDRESS']");
	public static final By TXT_NEWTEAMPOPUPAPTSUITE = By.xpath("//input[@ng-reflect-placeholder='APT/SUITE']");
	public static final By TXT_NEWTEAMPOPUPCITY = By.xpath("//input[@ng-reflect-placeholder='CITY']");
	public static final By TXT_NEWTEAMPOPUPZIP = By.xpath("//input[@ng-reflect-placeholder='ZIP']");
}