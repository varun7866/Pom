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
	public static final By BTN_ADDPOPUPCANCEL = By.xpath("//div[@class='modal-content']//button[text()='Cancel']");
	public static final By BTN_ADDPOPUPADD = By.xpath("//div[@class='modal-content']//button[text()='Add']");
	public static final By BTN_ADDPOPUPDATE = By.xpath("//div[@class='modal-content']//button[@class='btnpicker btnpickerenabled']");

	public static final By CAL_ADDPOPUPDATE = By.xpath("//div[@class='modal-content']//label[text()='DATE']/..//input");

	public static final By CBO_FIRSTROWSTATUS = By.xpath("//table[@class='medical-equipment-table']//tr[1]//select");
	public static final By CBO_ADDPOPUPSOURCE = By.xpath("//select[@id='source']");
	public static final By CBO_ADDPOPUPEQUIPMENTTYPE = By.xpath("//select[@id='equipment-type']");
	public static final By CBO_ADDPOPUPSTATUS = By.xpath("//div[@class='modal-content']//select[@id='status']");

	public static final By CHK_FIRSTROWEQUIPMENTISINUSE = By.xpath("//table[@class='medical-equipment-table']//tr[1]//input");
	public static final By CHK_ADDPOPUPEQUIPMENTISINUSE = By.id("equipmentInUseCheckbox");

	public static final By LBL_PAGEHEADER = By.xpath("//h2[text()='MEDICAL EQUIPMENT']");
	public static final By LBL_EQUIPMENTDESCRIPTIONCOLUMNHEADER = By.xpath("//tr/th/div[contains(., 'EQUIPMENT DESCRIPTION')]");
	public static final By LBL_SOURCECOLUMNHEADER = By.xpath("//tr/th/div[contains(., 'SOURCE')]");
	public static final By LBL_DATECOLUMNHEADER = By.xpath("//tr/th/div[contains(., 'DATE')]");
	public static final By LBL_STATUSCOLUMNHEADER = By.xpath("//tr/th/div[contains(., 'STATUS')]");
	public static final By LBL_INUSECOLUMNHEADER = By.xpath("//tr/th/div[contains(., 'IN USE')]");
	public static final By LBL_ADDPOPUPADDMEDICALEQUIPMENT = By.xpath("//span[text()='Add Medical Equipment']");
	public static final By LBL_ADDPOPUPDATE = By.xpath("//div[@class='modal-content']//label[text()='DATE']");
	public static final By LBL_ADDPOPUPSOURCE = By.xpath("//div[@class='modal-content']//label[text()='SOURCE']");
	public static final By LBL_ADDPOPUPEQUIPMENTISINUSE = By.xpath("//div[@class='modal-content']//label[text()='Equipment is in Use']");
	public static final By LBL_ADDPOPUPEQUIPMENTTYPE = By.xpath("//div[@class='modal-content']//label[text()='EQUIPMENT TYPE']");
	public static final By LBL_ADDPOPUPSTATUS = By.xpath("//div[@class='modal-content']//label[text()='STATUS']");

	public static final By PLH_ADDPOPUPSOURCE = By.xpath("//select[@id='source']/option[@class='firstOption' and text()='Select a value']");
	public static final By PLH_ADDPOPUPEQUIPMENTTYPE = By.xpath("//select[@id='equipment-type']/option[@class='firstOption' and text()='Select a value']");
	public static final By PLH_ADDPOPUPSTATUS = By.xpath("//select[@id='status']/option[@class='firstOption' and text()='Select a value']");

	public static final By TBL_MEDICALEQUIPMENT = By.xpath("//table[@class='medical-equipment-table']");

	public static final By TXT_ADDPOPUPDATE = By.xpath("//div[@class='modal-content']//input/@ng-reflect-model");
}