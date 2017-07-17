package com.vh.ui.web.locators;

import org.openqa.selenium.By;

public class HospitalizationLocators {
	
	public static final By LBL_PATIENTEXPERIENCEHOSPITALIZATIONS = By.xpath("//hospitalization//h2[@class='page-title']");
	public static final By BTN_ADDHOSPITALIZATION = By.xpath("//button[contains(., 'ADD HOSPITALIZATION')]");	
	
	//----------Transfer tab locators-------------
	
	public static final By BTN_NEWPOPUPTRANSFERTAB = By.xpath("//button[contains(., '2.TRANSFER')]");
	public static final By BTN_NEWPOPUPTRANSFERDATECAL = By.xpath("//div[@class='transfer-form']//*[@ng-reflect-name='transferDate']/div/div/div/button");
	public static final By BTN_NEWPOPUPADDTRANSFER = By.xpath("//button[@class='btn-add-transfer']");
	
	public static final By LBL_NEWPOPUPTRANSFERHEADER = By.xpath("//span[@class='transfer-form-header']");
	public static final By LBL_NEWPOPUPTRANSFERFACILITYNAME = By.xpath("//div[@class='transfer-form']//label[text()='FACILITY NAME']");
	public static final By LBL_NEWPOPUPTRANSFERDATE = By.xpath("//div[@class='transfer-form']//label[text()='TRANSFER DATE']");
	public static final By LBL_NEWPOPUPTRANSFERPHONE = By.xpath("//div[@class='transfer-form']//label[text()='PHONE']");
	public static final By LBL_NEWPOPUPTRANSFERFAX = By.xpath("//div[@class='transfer-form']//label[text()='FAX']");
	public static final By LBL_ADDTRANSFER = By.xpath("//button[contains(., 'ADD TRANSFER')]");
	
	public static final By TXT_NEWPOPUPTRANSFERFACILITYNAME = By.xpath("//div[@class='transfer-form']//*[@id='transferFacilityName2']");
	public static final By TXT_NEWPOPUPTRANSFERPHONE = By.xpath("//div[@class='transfer-form']//*[@id='phone']");
	public static final By TXT_NEWPOPUPTRANSFERFAX = By.xpath("//div[@class='transfer-form']//*[@id='fax']");
	
	public static final By CAL_TRANSFERDATE = By.xpath("//div[@class='transfer-form']//input[@aria-label='Date input field']");
	
	//----------Discharge tab locators------------
	
	public static final By BTN_NEWPOPUPDISCHARGETAB = By.xpath("//button[contains(., '3.DISCHARGE')]");	
	public static final By BTN_NEWPOPUPDISCHARGEDATECAL = By.xpath("//*[@id='dischargedate']/div/div/div/button[@class='btnpicker btnpickerenabled']");
	public static final By BTN_NEWPOPUPDISCHARGENOTIFICATIONDATECAL = By.xpath("//*[@id='notificatedate']/div/div/div/button[@class='btnpicker btnpickerenabled']");
	public static final By BTN_NEWPOPUPPLANDATECAL = By.xpath("//*[@id='plandate']/div/div/div/button[@class='btnpicker btnpickerenabled']");

	
	public static final By LBL_NEWPOPUPDISCHARGEHEADER = By.xpath("//span[@class='discharge-form-header']");
	public static final By LBL_NEWPOPUPDISCHARGEDATE = By.xpath("//*label[text()='DISCHARGE DATE']");
	public static final By LBL_NEWPOPUPDISCHARGENOTIFICATIONDATE = By.xpath("//label[text()='NOTIFICATION DATE']");	
	public static final By LBL_NEWPOPUPDISCHARGEPLANDATE = By.xpath("//label[text()='PLAN DATE']");
	public static final By LBL_NEWPOPUPDISCHARGEPATIENTREFUSEDPLAN = By.xpath("//label[text()='PATIENT REFUSED PLAN']");
	public static final By LBL_NEWPOPUPDISCHARGEDIAGNOSIS = By.xpath("//label[text()='DISCHARGE DIAGNOSIS']");
	public static final By LBL_NEWPOPUPDISCHARGERELATEDSUBCATEGORY = By.xpath("//label[text()='RELATED SUBCATEGORY']");
	public static final By LBL_NEWPOPUPDISPOSITION = By.xpath("//label[text()='DISPOSITION']");
    public static final By LBL_NEWPOPUPMEDICALEQUIPMENT = By.xpath("//label[text()='MEDICAL EQUIPMENT']");
	public static final By LBL_NEWPOPUPHOMEHEALTHNAME = By.xpath("//label[text()='HOME HEALTH NAME']");
	public static final By LBL_NEWPOPUPHOMEHEALTHREASON = By.xpath("//label[text()='HOME HEALTH REASON']");
	
	public static final By CAL_NEWPOPUPADDDISCHARGEDATE = By.xpath("//*[@id='dischargedate']/div/div/input");
	public static final By CAL_NEWPOPUPADDDISCHARGENOTIFICATIONDATE = By.xpath("//*[@id='notificatedate']/div/div/input");
	public static final By CAL_NEWPOPUPADDPLANDATE = By.xpath("//*[@id='plandate']/div/div/input");
	
	public static final By RDO_NEWPOPUPADDPATIENTREFUSEDPLANYES = By.xpath("//*[@id='patientrefusedyes']");
	public static final By RDO_NEWPOPUPADDPATIENTREFUSEDPLANNO = By.xpath("//*[@id='patientrefusedno']");
	public static final By RDO_NEWPOPUPMEDICALEQUIPMENTYES = By.xpath("//*[@id='equipmentyes']");
	public static final By RDO_NEWPOPUPMEDICALEQUIPMENTNO = By.xpath("//*[@id='equipmentno']");
	
	public static final By CBO_NEWPOPUPDISCHARGEDIAGNOSIS = By.xpath("//select[@id='dischargediagnosis']");
	public static final By CBO_NEWPOPUPDISCHARGERELATEDSUBCATEGORY = By.xpath("//select[@id='drelatedsubcategory']");
	public static final By CBO_NEWPOPUPDISPOSITION = By.xpath("//select[@id='disposition']");
	public static final By CBO_NEWPOPUPHOMEHEALTHREASON = By.xpath("//select[@id='homehealthreason']");
	
	public static final By TXT_NEWPOPUPHOMEHEALTHNAME = By.xpath("//*[@id='homehealthname']");

	
//	public static final By PLH_NEWPOPUPDISCHARGEDIAGNOSIS = By.xpath("//span[text()='Dipstick For Protein']/../../../div[2]/div/select[@ng-reflect-model='No Test']");

    //------------------------- SUBMIT button-----------------------
	public static final By BTN_NEWHOSPITALIZATIONSUBMIT = By.xpath("//button[contains(., 'Submit')]");	
	
    //------------------------- Cancel button-----------------------
	public static final By BTN_NEWHOSPITALIZATIONCANCEL = By.xpath("//button[contains(., 'Cancel')]");	
	
	
}

