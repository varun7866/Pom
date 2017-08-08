package com.vh.ui.web.locators;

import org.openqa.selenium.By;

public class HospitalizationLocators {
	
	public static final By LBL_PATIENTEXPERIENCEHOSPITALIZATIONS = By.xpath("//hospitalization//h2[@class='page-title']");
	public static final By BTN_ADDHOSPITALIZATION = By.xpath("//button[contains(., 'ADD HOSPITALIZATION')]");
	
	//---------Appointment tab locators-----------
	public static final By BTN_ADDPOPUPADMCANCEL = By.xpath("//button[text()='Cancel']");
	public static final By BTN_ADDPOPUPADMNEXT = By.xpath("//button[text()='Next']");
	public static final By LBL_ADDPOPUPADMADMITTANCE = By.xpath("//span[text()='Admittance']");
	public static final By LBL_ADDPOPUPADMFACILITYNAME = By.id("//div[@class='admittance-form']//label[text()='FACILITY NAME']");
	public static final By TXT_ADDPOPUPADMFACILITYNAME = By.xpath("//*[@id='facilityname']");
	public static final By LBL_ADDPOPUPADMADMITDATE = By.id("admitdate");
	public static final By TXT_ADDPOPUPADMADMITDATE = By.xpath("//*[@id='admitdate']/div/div/input");
	public static final By LBL_ADDPOPUPADMNOTIFICATIONDATE = By.id("notificationdate");
	public static final By TXT_ADDPOPUPADMNOTIFICATIONDATE = By.xpath("//*[@id='notificationdate']/div/div/input");
	public static final By LBL_ADDPOPUPADMNOTIFIEDBy = By.id("//div[@class='admittance-form']//label[text()='notifiedBy']");
	public static final By CMB_ADDPOPUPADMNOTIFIEDBy = By.xpath("//*[@id='notifiedBy']");
	public static final By LBL_ADDPOPUPADMREASON = By.id("//div[@class='admittance-form']//label[text()='reason']");
	public static final By TXT_ADDPOPUPADMREASON = By.xpath("//*[@id='reason']");
	public static final By LBL_ADDPOPUPADMPHONE = By.id("//div[@class='admittance-form']//label[text()='phone']");
	public static final By TXT_ADDPOPUPADMPHONE = By.xpath("//*[@id='phone']");
	public static final By LBL_ADDPOPUPADMFAX = By.id("//div[@class='admittance-form']//label[text()='fax']");
	public static final By TXT_ADDPOPUPADMFAX = By.xpath("//*[@id='fax']");
	public static final By LBL_ADDPOPUPADMADMITTYPE = By.id("//div[@class='admittance-form']//label[text()='admittype']");
	public static final By TXT_ADDPOPUPADMADMITTYPE = By.xpath("//*[@id='admittype']");
	public static final By LBL_ADDPOPUPADSOURCEOFADMIT = By.id("//div[@class='admittance-form']//label[text()='sourceofadmit']");
	public static final By TXT_ADDPOPUPSOURCEOFADMIT = By.xpath("//*[@id='sourceofadmit']");
	public static final By LBL_ADDPOPUPADMPRIORLOCATION = By.id("//div[@class='admittance-form']//label[text()='priorlocation']");
	public static final By TXT_ADDPOPUPADMPRIORLOCATION = By.xpath("//*[@id='priorlocation']");
	public static final By LBL_ADDPOPUPADMADMITTINGDIAGNOSIS = By.id("//div[@class='admittance-form']//label[text()='admittindiagnosis']");
	public static final By TXT_ADDPOPUPADMDMITTINGDIAGNOSIS = By.xpath("//*[@id='admittindiagnosis']");
	public static final By LBL_ADDPOPUPADMRELATEDSUBCATEGORY = By.id("//div[@class='admittance-form']//label[text()='relatedsubcategory']");
	public static final By TXT_ADDPOPUPADMRELATEDSUBCATEGORY = By.xpath("//*[@id='relatedsubcategory']");
	public static final By LBL_ADDPOPUPADMWORKINGDIAGNOSIS = By.id("//div[@class='admittance-form']//label[text()='workingdiagnosis']");
	public static final By TXT_ADDPOPUPADMWORKINGDIAGNOSIS = By.xpath("//*[@id='workingdiagnosis']");
	public static final By CHK_ADDPOPUPADMPLANNEDADMISSION = By.xpath("//*[@id='plannedAdmissionCheckbox']");
	public static final By LBL_ADDPOPUPADMPLANNEDADMISSION = By.xpath("//span[text()='Planned Admission']");
	public static final By CHK_ADDPOPUPADMAVOIDABLEADM = By.xpath("//*[@id='avoidableAdmissionCheckbox']");
	public static final By LBL_ADDPOPUPADMAVOIDABLEADM = By.xpath("//span[text()='AVOIDABLE ADMISSION']");
	public static final By CHK_ADDPOPUPADMVCWHOSPCMGR = By.xpath("//*[@id='verbalContactCheckbox']");
	public static final By LBL_ADDPOPUPADMVCWHOSPCMGR = By.xpath("//span[text()='Verbal contact with Hospital Case Manager']");
	public static final By LBL_ADDPOPUPADMCOMMENT = By.id("//div[@class='admittance-form']//label[text()='comment']");
	public static final By TXT_ADDPOPUPADMCOMMENT = By.xpath("//*[@id='comment']");

	
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
	public static final By TXT_NEWPOPUPTRANSFERFAX = By.xpath("//div[@class='transfer-form']//input[@ng-reflect-name='facilityFax2']");
	
	public static final By CAL_TRANSFERDATE = By.xpath("//div[@class='transfer-form']//input[@aria-label='Date input field']");
	
	//----------Discharge tab locators------------
	
	public static final By BTN_NEWPOPUPDISCHARGETAB = By.xpath("//button[contains(., '3.DISCHARGE')]");	
	public static final By BTN_NEWPOPUPDISCHARGEDATECAL = By.xpath("//*[@id='dischargedate']/div/div/div/button[@class='btnpicker btnpickerenabled']");
	public static final By BTN_NEWPOPUPDISCHARGENOTIFICATIONDATECAL = By.xpath("//*[@id='notificatedate']/div/div/div/button[@class='btnpicker btnpickerenabled']");
	public static final By BTN_NEWPOPUPPLANDATECAL = By.xpath("//*[@id='plandate']/div/div/div/button[@class='btnpicker btnpickerenabled']");

	
	public static final By LBL_NEWPOPUPDISCHARGEHEADER = By.xpath("//span[@class='discharge-form-header']");
	public static final By LBL_NEWPOPUPDISCHARGEDATE = By.xpath("//label[text()='DISCHARGE DATE']");
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

