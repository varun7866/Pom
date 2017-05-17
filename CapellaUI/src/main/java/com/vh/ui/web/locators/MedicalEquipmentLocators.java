/**
 * 
 */
package com.vh.ui.web.locators;

import org.openqa.selenium.By;

/*
 * @author Harvy Ackermans
 * @date   May 12, 2017
 * @class  MedicalEquipmentLocators.java
 */

public class MedicalEquipmentLocators
{
	public static final By BTN_ADDMEDICALEQUIPMENT = By.id("theButton");
	public static final By BTN_ADDPOPUPCANCEL = By.xpath("//div[@class='modal-dialog undefined']//button[text()='Cancel']");
	public static final By BTN_ADDPOPUPADD = By.xpath("//div[@class='modal-dialog undefined']//button[text()='Add']");

	public static final By CAL_ADDPOPUPDATE = By.xpath("//div[@class='modal-dialog undefined']//label[text()='DATE']//..//input");

	public static final By CBO_ADDPOPUPSOURCE = By.id("source");
	public static final By CBO_ADDPOPUPEQUIPMENTTYPE = By.id("equipment-type");
	public static final By CBO_ADDPOPUPSTATUS = By.id("status");

	public static final By CHK_ADDPOPUPEQUIPMENTISINUSE = By.id("equipmentInUseCheckbox");

	public static final By LBL_PAGEHEADER = By.xpath("//div[text()='MEDICAL EQUIPMENT']");
	public static final By LBL_EQUIPMENTDESCRIPTIONCOLUMNHEADER = By.xpath("//tr/th[text()='EQUIPMENT DESCRIPTION']");
	public static final By LBL_SOURCECOLUMNHEADER = By.xpath("//tr/th[text()='SOURCE']");
	public static final By LBL_DATECOLUMNHEADER = By.xpath("//tr/th[text()='DATE']");
	public static final By LBL_STATUSCOLUMNHEADER = By.xpath("//tr/th[text()='STATUS']");
	public static final By LBL_INUSECOLUMNHEADER = By.xpath("//tr/th[text()='IN USE']");
	public static final By LBL_ADDMEDICALEQUIPMENT = By.xpath("//span[text()='Add Medical Equipment']");
	public static final By LBL_ADDPOPUPDATE = By.xpath("//div[@class='modal-dialog undefined']//label[text()='DATE']");
	public static final By LBL_ADDPOPUPSOURCE = By.xpath("//div[@class='modal-dialog undefined']//label[text()='SOURCE']");
	public static final By LBL_ADDPOPUPEQUIPMENTISINUSE = By.xpath("//div[@class='modal-dialog undefined']//label[text()='Equipment is in Use']");
	public static final By LBL_ADDPOPUPEQUIPMENTTYPE = By.xpath("//div[@class='modal-dialog undefined']//label[text()='EQUIPMENT TYPE']");
	public static final By LBL_ADDPOPUPSTATUS = By.xpath("//div[@class='modal-dialog undefined']//label[text()='STATUS']");
}