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
	public static final By BTN_ADDPOPUPDATE = By.xpath("//div[@class='modal-dialog undefined']//button[@class='btnpicker btnpickerenabled']");

	public static final By CAL_ADDPOPUPDATE = By.xpath("//div[@class='modal-dialog undefined']//label[text()='DATE']/..//input");

	public static final By CBO_FIRSTROWSTATUS = By.xpath("//table[@class='medical-equipment-table']//tr[1]//select");
	public static final By CBO_ADDPOPUPSOURCE = By.xpath("//select[@id='source']");
	public static final By CBO_ADDPOPUPEQUIPMENTTYPE = By.xpath("//select[@id='equipment-type']");
	public static final By CBO_ADDPOPUPSTATUS = By.xpath("//div[@class='modal-dialog undefined']//select[@id='status']");

	public static final By CHK_FIRSTROWEQUIPMENTISINUSE = By.xpath("//table[@class='medical-equipment-table']//tr[1]//input");
	public static final By CHK_ADDPOPUPEQUIPMENTISINUSE = By.id("equipmentInUseCheckbox");

	public static final By LBL_PAGEHEADER = By.xpath("//h2[text()='MEDICAL EQUIPMENT']");
	public static final By LBL_EQUIPMENTDESCRIPTIONCOLUMNHEADER = By.xpath("//tr/th/div[contains(., 'EQUIPMENT DESCRIPTION')]");
	public static final By LBL_SOURCECOLUMNHEADER = By.xpath("//tr/th[contains(., 'SOURCE')]");
	public static final By LBL_MODIFIEDCOLUMNHEADER = By.xpath("//tr/th[contains(., 'MODIFIED')]");
	public static final By LBL_STATUSCOLUMNHEADER = By.xpath("//tr/th[contains(., 'STATUS')]");
	public static final By LBL_INUSECOLUMNHEADER = By.xpath("//tr/th[contains(., 'IN USE')]");
	public static final By LBL_ADDMEDICALEQUIPMENT = By.xpath("//span[text()='Add Medical Equipment']");
	public static final By LBL_ADDPOPUPDATE = By.xpath("//div[@class='modal-dialog undefined']//label[text()='DATE']");
	public static final By LBL_ADDPOPUPSOURCE = By.xpath("//div[@class='modal-dialog undefined']//label[text()='SOURCE']");
	public static final By LBL_ADDPOPUPEQUIPMENTISINUSE = By.xpath("//div[@class='modal-dialog undefined']//label[text()='Equipment is in Use']");
	public static final By LBL_ADDPOPUPEQUIPMENTTYPE = By.xpath("//div[@class='modal-dialog undefined']//label[text()='EQUIPMENT TYPE']");
	public static final By LBL_ADDPOPUPSTATUS = By.xpath("//div[@class='modal-dialog undefined']//label[text()='STATUS']");

	public static final By TBL_MEDICALEQUIPMENT = By.xpath("//table[@class='medical-equipment-table']");

	public static final By TXT_ADDPOPUPDATE = By.xpath("//div[@class='modal-dialog undefined']//input/@ng-reflect-model");
}