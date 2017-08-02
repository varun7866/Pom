package com.vh.ui.web.locators;

import org.openqa.selenium.By;

public class ManageDocumentsLocators {
	
	//----------Manage Documents Screen-------------
	
	public static final By LBL_PATIENTADMINMANAGEDOCUMENTS = By.xpath("//manage-documents//h2[@class='page-title']");
	public static final By LBL_MANAGEDOCUMENTSTYPEHEADER = By.xpath("//manage-documents//div[@class='divTableCell divTableHeadCell documents-title-column']");
	public static final By LBL_MANAGEDOCUMENTSDESCRIPTIONHEADER = By.xpath("//manage-documents//div[@class='divTableCell divTableHeadCell documents-description-column']");
	public static final By LBL_MANAGEDOCUMENTSENDDATEHEADER  = By.xpath("//manage-documents//div[@class='divTableCell divTableHeadCell documents-end-date-column']");
	
	public static final By BTN_ADDDOCUMENT = By.id("addDocumentButton");
	
	public static final By CBO_DOCUMENTTYPESDROPDOWN = By.xpath("//manage-documents//select[@ng-reflect-model='']");
	public static final By CBO_DOCUMENTSTATUSDROPDOWN = By.xpath("//manage-documents//select[@ng-reflect-model='all']");
	
	public static final By TBL_MANAGEDOCUMENTS = By.xpath("//div[@class='divTable']");
	
	//----------Add Document Pop up-------------
	
	public static final By BTN_ADDDOCUMENTCANCEL = By.xpath("//button[contains(., 'Cancel')]");
	public static final By BTN_ADDDOCUMENTADD = By.xpath("//button[contains(., 'Add')]");
	public static final By BTN_ADDDOCUMENTSELECTAFILE = By.xpath("//div/label[contains(., 'SELECT A FILE')]");
	public static final By BTN_ADDDOCUMENTLINKREFERRAL = By.id("link-referral-button");
	public static final By BTN_ADDDOCUMENTLINKTOHOSPITALIZATION = By.id("link-hospitalization-button");
	public static final By BTN_ADDDOCUMENTDATEOFSIGNATURECAL = By.xpath("//my-date-picker//div/button");
	
	public static final By LBL_ADDDOCUMENTPOPUPHEADER = By.xpath("//span[@class='add-modal-header-span']");
	public static final By LBL_ADDDOCUMENTFILE = By.xpath("//modal-content/div/label[contains(., 'FILE')]");
	public static final By LBL_ADDDOCUMENTDESCRIPTION = By.xpath("//div/label[contains(., 'DESCRIPTION')]");
	public static final By LBL_ADDDOCUMENTDOCUMENTTYPE = By.xpath("//div/label[contains(., 'DOCUMENT TYPE')]");
	public static final By LBL_ADDDOCUMENTDATEOFSIGNATURE = By.xpath("//div/label[contains(., 'DATE OF SIGNATURE')]");
	
	public static final By TXT_ADDDOCUMENTFILE = By.id("fileName");
	public static final By TXT_ADDDOCUMENTDESCRIPTION = By.xpath("//div//textarea[@name='description']");
	
	public static final By CBO_ADDDOCUMENTDOCUMENTTYPE = By.xpath("//add-manage-documents//div/select[@class='form-control ng-untouched ng-pristine ng-valid']");
	
	public static final By CAL_ADDDOCUMENTDATEOFSIGNATURE = By.xpath("//my-date-picker//input");
	
	//----------Connect a Referral Pop up-------------
	
	public static final By TBL_CONNECTAREFERRAL = By.xpath("///referral-connect-dialog//div[@class='divTable']");
	
	public static final By LBL_CONNECTAREFERRALHEADER = By.xpath("//referral-connect-dialog//span[contains(., 'Connect a Referral')]");
	public static final By LBL_CONNECTAREFERRALPROVIDERNAME = By.xpath("//div[@class='divTableCell divTableHeadCell referral-provider-column']");
	public static final By LBL_CONNECTAREFERRALREASON = By.xpath("//div[@class='divTableCell divTableHeadCell referral-reason-column']");
	public static final By LBL_CONNECTAREFERRALAPPTDATE = By.xpath("//div[@class='divTableCell divTableHeadCell referral-apptDate-column']");
	
	public static final By BTN_CONNECTAREFERRALCANCEL = By.xpath("//referral-connect-dialog//button[contains(., 'Cancel')]");
	public static final By BTN_CONNECTAREFERRALCONNECT = By.xpath("//referral-connect-dialog//button[contains(., 'Connect')]");		
	
	//----------Connect a Hospitalization Pop up-------------
	
	public static final By TBL_CONNECTAHOSPITALIZATION = By.xpath("///hospitalization-connect-dialog//SPAN[@class='divTable']");
	
	public static final By LBL_CONNECTAHOSPITALIZATIONHEADER= By.xpath("//hospitalization-connect-dialog//span[contains(., 'Connect a Hospitalization')]");
	public static final By LBL_CONNECTAHOSPITALIZATIONFACILITY = By.xpath("//div[@class='divTableCell divTableHeadCell hospitalization-facility-column']");
	public static final By LBL_CONNECTAHOSPITALIZATIONTYPE = By.xpath("//div[@class='divTableCell divTableHeadCell hospitalization-readmit-column']");
	public static final By LBL_CONNECTAHOSPITALIZATIONADMIT = By.xpath("//div[@class='divTableCell divTableHeadCell hospitalization-admitDate-column']");
	public static final By LBL_CONNECTAHOSPITALIZATIONDISCHARGE = By.xpath("//div[@class='divTableCell divTableHeadCell hospitalization-dischargeDate-column']");
	
	public static final By BTN_CONNECTAHOSPITALIZATIONCANCEL = By.xpath("//hospitalization-connect-dialog//button[contains(., 'Cancel')]");
	public static final By BTN_CONNECTAHOSPITALIZATIONCONNECT = By.xpath("//hospitalization-connect-dialog//button[contains(., 'Connect')]");		
}

