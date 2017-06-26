/**
 * 
 */
package com.vh.ui.web.locators;

import org.openqa.selenium.By;

/*
 * @author Harvy Ackermans
 * @date   June 14, 2017
 * @class  CurrentLabsLocators.java
 */

public class CurrentLabsLocators
{
	public static final By BTN_ADDLAB = By.xpath("//button[text()='Add Lab']");
	public static final By BTN_ADDPOPUPCANCEL = By.xpath("//button[text()='Cancel']");
	public static final By BTN_ADDPOPUPSAVE = By.xpath("//button[text()='Save']");
	public static final By BTN_ADDPOPUPAPPLYTHISDATETOALLVALUES = By
	        .xpath("//div[@class='modal-dialog modal-lg']//span[text()='APPLY THIS DATE TO ALL VALUES']/../../..//input/..//button[@class='btnpicker btnpickerenabled']");

	public static final By CAL_ADDPOPUPAPPLYTHISDATETOALLVALUES = By.xpath("//div[@class='modal-dialog modal-lg']//span[text()='APPLY THIS DATE TO ALL VALUES']/../../..//input");

	public static final By GOL_ADDPOPUPPHOSPHOROUS = By.xpath("//span[text()='Phosphorous']/../../../div[3]/div/div/span[text()='Goal: Between 0.5 and 5.5']");
	public static final By GOL_ADDPOPUPGFR = By.xpath("//span[text()='GFR']/../../../div[3]/div/div/span[text()='Goal: Between 30 and 125']");
	public static final By GOL_ADDPOPUPLDL = By.xpath("//span[text()='LDL']/../../../div[3]/div/div/span[text()='Goal: Between 0 and 100']");
	public static final By GOL_ADDPOPUPALBUMIN = By.xpath("//span[text()='Albumin']/../../../div[3]/div/div/span[text()='Goal: Between 4 and 7']");
	public static final By GOL_ADDPOPUPCO2LEVEL = By.xpath("//span[text()='Co2 Level']/../../../div[3]/div/div/span[text()='Goal: Between 22 and 31']");
	public static final By GOL_ADDPOPUPKTV = By.xpath("//span[text()='KT/V']/../../../div[3]/div/div/span[text()='Goal: ESRD between 1.2 and 3']");
	public static final By GOL_ADDPOPUPPOTASSIUM = By.xpath("//span[text()='Potassium']/../../../div[3]/div/div/span[text()='Goal: Between 3.5 and 5.2']");
	public static final By GOL_ADDPOPUPHEPATITISBTITER = By.xpath("//span[text()='Hepatitis B Titer']/../../../div[3]/div/div/span[text()='Goal: Between 10 and 100']");
	public static final By GOL_ADDPOPUPTSAT = By.xpath("//span[text()='TSAT']/../../../div[3]/div/div/span[text()='Goal: Between 20 and 100']");
	public static final By GOL_ADDPOPUPBLOODPRESUREDIASTOLIC = By.xpath("//span[text()='Blood Pressure Diastolic']/../../../div[3]/div/div/span[text()='Goal: Between 0 and 80']");
	public static final By GOL_ADDPOPUPCALCIUMXPHOSPHOROUS = By.xpath("//span[text()='Calcium X Phosphorous']/../../../div[3]/div/div/span[text()='Goal: Between 30 and 60']");

	public static final By LBL_PAGEHEADER = By.xpath("//h2[contains(., 'Labs')]");
	public static final By LBL_ADDPOPUPADDLABRESULTS = By.xpath("//span[text()='Add Lab Results']");
	public static final By LBL_ADDPOPUPAPPLYTHISDATETOALLVALUES = By.xpath("//span[text()='APPLY THIS DATE TO ALL VALUES']");
	public static final By LBL_ADDPOPUPHEIGHT = By.xpath("//div[@class='modal-dialog modal-lg']//span[text()='Height']");
	public static final By LBL_ADDPOPUPTARGETDRYWEIGHT = By.xpath("//div[@class='modal-dialog modal-lg']//span[text()='Target Dry Weight']");
	public static final By LBL_ADDPOPUPPHOSPHOROUS = By.xpath("//div[@class='modal-dialog modal-lg']//span[text()='Phosphorous']");
	public static final By LBL_ADDPOPUPGFR = By.xpath("//div[@class='modal-dialog modal-lg']//span[text()='GFR']");
	public static final By LBL_ADDPOPUPLDL = By.xpath("//div[@class='modal-dialog modal-lg']//span[text()='LDL']");
	public static final By LBL_ADDPOPUPALBUMIN = By.xpath("//div[@class='modal-dialog modal-lg']//span[text()='Albumin']");
	public static final By LBL_ADDPOPUPCO2LEVEL = By.xpath("//div[@class='modal-dialog modal-lg']//span[text()='Co2 Level']");
	public static final By LBL_ADDPOPUPKTV = By.xpath("//div[@class='modal-dialog modal-lg']//span[text()='KT/V']");
	public static final By LBL_ADDPOPUPPOTASSIUM = By.xpath("//div[@class='modal-dialog modal-lg']//span[text()='Potassium']");
	public static final By LBL_ADDPOPUPHEPATITISBTITER = By.xpath("//div[@class='modal-dialog modal-lg']//span[text()='Hepatitis B Titer']");
	public static final By LBL_ADDPOPUPTSAT = By.xpath("//div[@class='modal-dialog modal-lg']//span[text()='TSAT']");
	public static final By LBL_ADDPOPUPBLOODPRESUREDIASTOLIC = By.xpath("//div[@class='modal-dialog modal-lg']//span[text()='Blood Pressure Diastolic']");
	public static final By LBL_ADDPOPUPWEIGHT = By.xpath("//div[@class='modal-dialog modal-lg']//span[text()='Weight']");
	public static final By LBL_ADDPOPUPCALCIUMXPHOSPHOROUS = By.xpath("//div[@class='modal-dialog modal-lg']//span[text()='Calcium X Phosphorous']");

	public static final By PLH_ADDPOPUPHEIGHT = By.xpath("//span[text()='Height']/../../../div[2]/div/input[@placeholder='cm']");
	public static final By PLH_ADDPOPUPTARGETDRYWEIGHT = By.xpath("//span[text()='Target Dry Weight']/../../../div[2]/div/input[@placeholder='kg']");
	public static final By PLH_ADDPOPUPWEIGHT = By.xpath("//span[text()='Weight']/../../../div[2]/div/input[@placeholder='kg']");

	public static final By TXT_ADDPOPUPHEIGHT = By.xpath("//span[text()='Height']/../../../div[2]/div/input");
	public static final By TXT_ADDPOPUPTARGETDRYWEIGHT = By.xpath("//span[text()='Target Dry Weight']/../../../div[2]/div/input");
	public static final By TXT_ADDPOPUPPHOSPHOROUS = By.xpath("//span[text()='Phosphorous']/../../../div[2]/div/input");
	public static final By TXT_ADDPOPUPGFR = By.xpath("//span[text()='GFR']/../../../div[2]/div/input");
	public static final By TXT_ADDPOPUPLDL = By.xpath("//span[text()='LDL']/../../../div[2]/div/input");
	public static final By TXT_ADDPOPUPALBUMIN = By.xpath("//span[text()='Albumin']/../../../div[2]/div/input");
	public static final By TXT_ADDPOPUPCO2LEVEL = By.xpath("//span[text()='Co2 Level']/../../../div[2]/div/input");
	public static final By TXT_ADDPOPUPKTV = By.xpath("//span[text()='KT/V']/../../../div[2]/div/input");
	public static final By TXT_ADDPOPUPPOTASSIUM = By.xpath("//span[text()='Potassium']/../../../div[2]/div/input");
	public static final By TXT_ADDPOPUPHEPATITISBTITER = By.xpath("//span[text()='Hepatitis B Titer']/../../../div[2]/div/input");
	public static final By TXT_ADDPOPUPTSAT = By.xpath("//span[text()='TSAT']/../../../div[2]/div/input");
	public static final By TXT_ADDPOPUPBLOODPRESUREDIASTOLIC = By.xpath("//span[text()='Blood Pressure Diastolic']/../../../div[2]/div/input");
	public static final By TXT_ADDPOPUPWEIGHT = By.xpath("//span[text()='Weight']/../../../div[2]/div/input");
	public static final By TXT_ADDPOPUPCALCIUMXPHOSPHOROUS = By.xpath("//span[text()='Calcium X Phosphorous']/../../../div[2]/div/input");
}