package com.vh.ui.web.locators;

import org.openqa.selenium.By;

public class HospitalizationLocators {
	
	public static final By LBL_PATIENTEXPERIENCEHOSPITALIZATIONS = By.xpath("//hospitalization//h2[@class='page-title']");
	public static final By BTN_ADDHOSPITALIZATION = By.xpath("//button[contains(., 'ADD HOSPITALIZATION')]");
	
	//---------Admittance tab locators-----------
	public static final By BTN_NEWHOSPNEWHOSPADDPOPUPADMITTANCETABCANCEL = By.xpath("//button[text()='Cancel']");
	public static final By BTN_NEWHOSPNEWHOSPADDPOPUPADMITTANCETABNEXT = By.xpath("//button[text()='Next']");
	public static final By BTN_NEWHOSPPOPUPADMITTANCETABADMITDATECAL = By.xpath("//*[@id='admitdate']/div/div[1]/div/button");
	public static final By BTN_NEWHOSPPOPUPADMITTANCETABNOTIFICATIONDATECAL = By.xpath("//*[@id='notificationdate']/div/div/div/button");
	
	public static final By LBL_NEWHOSPNEWHOSPADDPOPUPADMITTANCETABADMITTANCEHEADER = By.xpath("//span[text()='Admittance']");
	public static final By LBL_NEWHOSPNEWHOSPADDPOPUPADMITTANCETABFACILITYNAME = By.xpath("//div[@class='admittance-form']//label[text()='FACILITY NAME']");
	public static final By LBL_NEWHOSPNEWHOSPADDPOPUPADMITTANCETABADMITDATE = By.id("admitdate");
	public static final By LBL_NEWHOSPNEWHOSPADDPOPUPADMITTANCETABNOTIFICATIONDATE = By.id("notificationdate");
	public static final By LBL_NEWHOSPNEWHOSPADDPOPUPADMITTANCETABNOTIFIEDBy = By.xpath("//modal-content//label[text()='NOTIFIED BY']");
	public static final By LBL_NEWHOSPNEWHOSPADDPOPUPADMITTANCETABREASON = By.xpath("//modal-content//label[text()='REASON']");
	public static final By LBL_NEWHOSPADDPOPUPADMITTANCETABREADMIT = By.xpath("//modal-content//label[text()='READMIT']");
	public static final By LBL_NEWHOSPADDPOPUPADMITTANCETABPHONE = By.xpath("//modal-content//label[text()='PHONE']");
	public static final By LBL_NEWHOSPADDPOPUPADMITTANCETABFAX = By.xpath("//modal-content//label[text()='FAX']");
	public static final By LBL_NEWHOSPADDPOPUPADMITTANCETABADMITTYPE = By.xpath("//modal-content//label[text()='ADMIT TYPE']");
	public static final By LBL_NEWHOSPADDPOPUPADMITTANCETABSOURCEOFADMIT = By.xpath("//modal-content//label[text()='SOURCE OF ADMIT']");
	public static final By LBL_NEWHOSPADDPOPUPADMITTANCETABPRIORLOCATION = By.xpath("//modal-content//label[text()='LOCATION PRIOR TO VISIT']");
	public static final By LBL_NEWHOSPADDPOPUPADMITTANCETABADMITTINGDIAGNOSIS = By.xpath("//modal-content//label[text()='ADMITTING DIAGNOSIS']");
	public static final By LBL_NEWHOSPADDPOPUPADMITTANCETABRELATEDSUBCATEGORY = By.xpath("//modal-content//label[text()='RELATED SUBCATEGORY']");
	public static final By LBL_NEWHOSPADDPOPUPADMITTANCETABWORKINGDIAGNOSIS = By.xpath("//modal-content//label[text()='SOURCE OF ADMIT']");
	public static final By LBL_NEWHOSPADDPOPUPADMITTANCETABPLANNEDADMISSION = By.xpath("//span[text()='Planned Admission']");
	public static final By LBL_NEWHOSPADDPOPUPADMITTANCETABAVOIDABLEADM = By.xpath("//span[text()='Avoidable Admission']");
	public static final By LBL_NEWHOSPADDPOPUPADMITTANCETABVCWHOSPCMGR = By.xpath("//span[text()='Verbal contact with Hospital Case Manager']");
	public static final By LBL_NEWHOSPADDPOPUPADMITTANCETABCOMMENT = By.xpath("//modal-content//label[text()='COMMENT']");
	
	public static final By TXT_NEWHOSPADDPOPUPADMITTANCETABFACILITYNAME = By.id("facilityname");
	public static final By TXT_NEWHOSPADDPOPUPADMITTANCETABPHONE = By.id("phone");
	public static final By TXT_NEWHOSPADDPOPUPADMITTANCETABFAX = By.id("fax");
	public static final By TXT_NEWHOSPADDPOPUPADMITTANCETABWORKINGDIAGNOSIS = By.id("workingdiagnosis");
	public static final By TXT_NEWHOSPADDPOPUPADMITTANCETABCOMMENT = By.id("comment");

	public static final By CBO_NEWHOSPPOPUPADMITTANCETABNOTIFIEDBy = By.id("notifiedby");
	public static final By CBO_NEWHOSPPOPUPADMITTANCETABREASON = By.id("reason");
	public static final By CBO_NEWHOSPPOPUPADMITTANCETABADMITTYPE = By.id("admittype");
	public static final By CBO_NEWHOSPPOPUPADMITTANCETABSOURCEOFADMIT = By.id("sourceofadmit");
	public static final By CBO_NEWHOSPPOPUPADMITTANCETABPRIORLOCATION = By.id("priorlocation");
	public static final By CBO_NEWHOSPPOPUPADMITTANCETABADMITTINGDIAGNOSIS = By.id("admittindiagnosis");
	public static final By CBO_NEWHOSPPOPUPADMITTANCETABRELATEDSUBCATEGORY = By.id("relatedsubcategory");
	
	public static final By CAL_NEWHOSPPOPUPADMITTANCETABADMITDATECAL = By.xpath("//*[@id='admitdate']/div/div/input");
	public static final By CAL_NEWHOSPPOPUPADMITTANCETABNOTIFICATIONDATECAL = By.xpath("//*[@id='notificationdate']/div/div/input");
	
	public static final By RDO_NEWHOSPPOPUPADMITTANCETABREADMITYES = By.id("readmityes");
	public static final By RDO_NEWHOSPPOPUPADMITTANCETABREADMITNO = By.id("readmitno");
	
	public static final By CHK_NEWHOSPPOPUPADMITTANCETABPLANNEDADMISSION = By.id("plannedAdmissionCheckbox");
	public static final By CHK_NEWHOSPPOPUPADMITTANCETABAVOIDABLEADM = By.id("avoidableAdmissionCheckbox");
	public static final By CHK_NEWHOSPPOPUPADMITTANCETABVCWHOSPCMGR = By.id("verbalContactCheckbox");
	
	//----------Transfer tab locators-------------
	
	public static final By BTN_NEWHOSPPOPUPTRANSFERTABTRANSFERBUTTON = By.xpath("//button[contains(., '2.TRANSFER')]");
	public static final By BTN_NEWHOSPTRANSFERTABNEXT = By.xpath("//button[text()='Next']");
	public static final By BTN_NEWHOSPPOPUPTRANSFERTABTRANSFERDATECAL = By.xpath("//div[@class='transfer-form']//*[@ng-reflect-name='transferDate']/div/div/div/button");
	public static final By BTN_NEWHOSPPOPUPTRANSFERTABADDTRANSFER = By.xpath("//button[@class='btn-add-transfer']");
	
	public static final By LBL_NEWHOSPPOPUPTRANSFERTABTRANSFERHEADER = By.xpath("//span[@class='transfer-form-header']");
	public static final By LBL_NEWHOSPPOPUPTRANSFERTABTRANSFERFACILITYNAME = By.xpath("//div[@class='transfer-form']//label[text()='FACILITY NAME']");
	public static final By LBL_NEWHOSPPOPUPTRANSFERTABTRANSFERDATE = By.xpath("//div[@class='transfer-form']//label[text()='TRANSFER DATE']");
	public static final By LBL_NEWHOSPPOPUPTRANSFERTABTRANSFERPHONE = By.xpath("//div[@class='transfer-form']//label[text()='PHONE']");
	public static final By LBL_NEWHOSPPOPUPTRANSFERTABTRANSFERFAX = By.xpath("//div[@class='transfer-form']//label[text()='FAX']");
	public static final By LBL_ADDTRANSFER = By.xpath("//button[contains(., 'ADD TRANSFER')]");
	
	public static final By TXT_NEWHOSPPOPUPTRANSFERTABTRANSFERFACILITYNAME = By.xpath("//div[@class='transfer-form']//*[@id='transferFacilityName2']");
	public static final By TXT_NEWHOSPPOPUPTRANSFERTABTRANSFERPHONE = By.xpath("//div[@class='transfer-form']//*[@id='phone']");
	public static final By TXT_NEWHOSPPOPUPTRANSFERTABTRANSFERFAX = By.xpath("//div[@class='transfer-form']//input[@ng-reflect-name='facilityFax2']");
	
	public static final By CAL_NEWHOSPPOPUPADMITTANCETABTRANSFERDATE = By.xpath("//div[@class='transfer-form']//input[@aria-label='Date input field']");
	
	//----------Discharge tab locators------------
	
	public static final By BTN_NEWHOSPPOPUPDISCHARGETABDISCHARGETAB = By.xpath("//button[contains(., '3.DISCHARGE')]");	
	public static final By BTN_NEWHOSPPOPUPDISCHARGETABDISCHARGEDATECAL = By.xpath("//*[@id='dischargedate']/div/div/div/button[@class='btnpicker btnpickerenabled']");
	public static final By BTN_NEWHOSPPOPUPDISCHARGETABNOTIFICATIONDATECAL = By.xpath("//*[@id='notificatedate']/div/div/div/button[@class='btnpicker btnpickerenabled']");
	public static final By BTN_NEWHOSPPOPUPDISCHARGETABPLANDATECAL = By.xpath("//*[@id='plandate']/div/div/div/button[@class='btnpicker btnpickerenabled']");

	
	public static final By LBL_NEWHOSPPOPUPDISCHARGETABDISCHARGEHEADER = By.xpath("//span[@class='discharge-form-header']");
	public static final By LBL_NEWHOSPPOPUPDISCHARGETABDISCHARGEDATE = By.xpath("//label[text()='DISCHARGE DATE']");
	public static final By LBL_NEWHOSPPOPUPDISCHARGETABDISCHARGENOTIFICATIONDATE = By.xpath("//label[text()='NOTIFICATION DATE']");	
	public static final By LBL_NEWHOSPPOPUPDISCHARGETABDISCHARGEPLANDATE = By.xpath("//label[text()='PLAN DATE']");
	public static final By LBL_NEWHOSPPOPUPDISCHARGETABDISCHARGEPATIENTREFUSEDPLAN = By.xpath("//label[text()='PATIENT REFUSED PLAN']");
	public static final By LBL_NEWHOSPPOPUPDISCHARGETABDISCHARGEDIAGNOSIS = By.xpath("//label[text()='DISCHARGE DIAGNOSIS']");
	public static final By LBL_NEWHOSPPOPUPDISCHARGETABDISCHARGERELATEDSUBCATEGORY = By.xpath("//label[text()='RELATED SUBCATEGORY']");
	public static final By LBL_NEWHOSPPOPUPDISCHARGETABDISPOSITION = By.xpath("//label[text()='DISPOSITION']");
    public static final By LBL_NEWHOSPPOPUPDISCHARGETABMEDICALEQUIPMENT = By.xpath("//label[text()='MEDICAL EQUIPMENT']");
	public static final By LBL_NEWHOSPPOPUPDISCHARGETABHOMEHEALTHNAME = By.xpath("//label[text()='HOME HEALTH NAME']");
	public static final By LBL_NEWHOSPPOPUPDISCHARGETABHOMEHEALTHREASON = By.xpath("//label[text()='HOME HEALTH REASON']");
	
	public static final By CAL_NEWHOSPPOPUPDISCHARGETABADDDISCHARGEDATE = By.xpath("//*[@id='dischargedate']/div/div/input");
	public static final By CAL_NEWHOSPPOPUPDISCHARGETABNOTIFICATIONDATE = By.xpath("//*[@id='notificatedate']/div/div/input");
	public static final By CAL_NEWHOSPPOPUPDISCHARGETABADDPLANDATE = By.xpath("//*[@id='plandate']/div/div/input");
	
	public static final By RDO_NEWHOSPPOPUPDISCHARGETABADDPATIENTREFUSEDPLANYES = By.id("patientrefusedyes");
	public static final By RDO_NEWHOSPPOPUPDISCHARGETABADDPATIENTREFUSEDPLANNO = By.id("patientrefusedno");
	public static final By RDO_NEWHOSPPOPUPDISCHARGETABMEDICALEQUIPMENTYES = By.id("equipmentyes");
	public static final By RDO_NEWHOSPPOPUPDISCHARGETABMEDICALEQUIPMENTNO = By.id("equipmentno");
	
	public static final By CBO_NEWHOSPPOPUPDISCHARGETABDISCHARGEDIAGNOSIS = By.xpath("//select[@id='dischargediagnosis']");
	public static final By CBO_NEWHOSPPOPUPDISCHARGETABDISCHARGERELATEDSUBCATEGORY = By.xpath("//select[@id='drelatedsubcategory']");
	public static final By CBO_NEWHOSPPOPUPDISCHARGETABDISPOSITION = By.xpath("//select[@id='disposition']");
	public static final By CBO_NEWHOSPPOPUPDISCHARGETABHOMEHEALTHREASON = By.xpath("//select[@id='homehealthreason']");
	
	public static final By TXT_NEWHOSPPOPUPDISCHARGETABHOMEHEALTHNAME = By.id("homehealthname");

	
//	public static final By PLH_NEWHOSPPOPUPDISCHARGETABDISCHARGEDIAGNOSIS = By.xpath("//span[text()='Dipstick For Protein']/../../../div[2]/div/select[@ng-reflect-model='No Test']");

    //------------------------- SUBMIT button-----------------------
	public static final By BTN_NEWHOSPITALIZATIONSUBMIT = By.xpath("//button[contains(., 'Submit')]");	
	
    //------------------------- Cancel button-----------------------
	public static final By BTN_NEWHOSPITALIZATIONCANCEL = By.xpath("//button[contains(., 'Cancel')]");
	
	//------ Alert messages locators--------------------
	
	public static final By LBL_NEWHOSPPOPUPADMITTANCETABFACILITYNAMEERRORMESSAGE = By.xpath("//modal-content//form/div/div/div/div[contains(., 'FacilityName is required')]");
	public static final By LBL_NEWHOSPPOPUPADMITTANCETABNOTIFICATIONDATEERRORMESSAGE = By.xpath("//modal-content//form/div/div/div/div[contains(., 'Admit Notification Date is required')]");
	public static final By LBL_NEWHOSPPOPUPADMITTANCETABNOTIFIEDBYERRORMESSAGE = By.xpath("//modal-content//form/div/div/div/div[contains(., 'Notified By is required')]");
	public static final By LBL_NEWHOSPPOPUPADMITTANCETABADMITTYPEERRORMESSAGE = By.xpath("//modal-content//form/div/div/div/div[contains(., 'Admit Type is required')]");
	public static final By LBL_NEWHOSPPOPUPADMITTANCETABSOURCEOFADMITERRORMESSAGE = By.xpath("//modal-content//form/div/div/div/div[contains(., 'Source Of Admit is required')]");
	public static final By LBL_NEWHOSPPOPUPADMITTANCETABADMITTINGDIAGNOSISERRORMESSAGE = By.xpath("//modal-content//form/div/div/div/div[contains(., 'Admitting Diagnosis is required')]");
	public static final By LBL_NEWHOSPPOPUPADMITTANCETABSUBCATEGORYERRORMESSAGE = By.xpath("//modal-content//form/div/div/div/div[contains(., 'Subcategory for Admit Diagnosis is required')]");
	public static final By LBL_NEWHOSPPOPUPADMITTANCETABWORKINGDIAGNOSISERRORMESSAGE = By.xpath("//modal-content//form/div/div/div/div[contains(., 'Working Diagnosis is required')]");
	public static final By LBL_NEWHOSPPOPUPDISCHARGETABWDISPOSITIONERRORMESSAGE = By.xpath("//modal-content//form/div/div/div/div[contains(., 'Working Diagnosis is required')]");
	
	public static final By LBL_HOSPITALIZATIORECORDS = By.xpath("//hospitalization//div[@class='hospitalization-item-borderBottom']");

}

