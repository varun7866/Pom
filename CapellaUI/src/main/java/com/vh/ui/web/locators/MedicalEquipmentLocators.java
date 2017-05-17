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
	public static final By LBL_PAGEHEADER = By.xpath("//div[text()='MEDICAL EQUIPMENT']");
	public static final By LBL_EQUIPMENTDESCRIPTIONCOLUMNHEADER = By.xpath("//tr/th[text()='EQUIPMENT DESCRIPTION']");
	public static final By LBL_SOURCECOLUMNHEADER = By.xpath("//tr/th[text()='SOURCE']");
	public static final By LBL_DATECOLUMNHEADER = By.xpath("//tr/th[text()='DATE']");
	public static final By LBL_STATUSCOLUMNHEADER = By.xpath("//tr/th[text()='STATUS']");
	public static final By LBL_INUSECOLUMNHEADER = By.xpath("//tr/th[text()='IN USE']");
}