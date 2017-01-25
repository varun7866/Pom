/**
 * 
 */
package com.vh.ui.web.locators;

import org.openqa.selenium.By;

/**
 * @author subalivada
 * @date   Jan 16, 2017
 * @class  CreateNewPatientLocators.java
 *
 */
public class CreateNewPatientPageLocators {
	public static final By TXT_FIRSTNAME = By.xpath("//input[@data-capella-automation-id='model.SearchFilter.FirstName']");
	public static final By BTN_SEARCH = By.xpath("//button[@data-capella-automation-id='on-member-search-clicked']");
	public static final By BTN_MEMBER_SEARCHRESULT_CANCEL = By.id("Member_Search_Result_Cancel_Btn");
	public static final By BTN_NEW_REFERRAL = By.id("Member_Search_Result_NewReferral_Btn");
	public static final By WIN_REFERRAL_MGMT = By.id("ReferralEdit");
	public static final By TXT_REFERRAL_DATE = By.id("cal1");
	public static final By TXT_REFERRAL_RCVD_DATE = By.id("cal2");
	public static final By TXT_APPLICATION_DATE = By.id("cal3");
	public static final By COMBO_PAYOR = By.xpath("//div[@data-capella-automation-id='referralManagement_ReferringPayor_Dropdown']");
	public static final By COMBO_DISEASE_STATE = By.xpath("//div[@data-capella-automation-id='referralManagement_DiseaseState_Dropdown']");
	public static final By COMBO_LOB = By.xpath("//div[@data-capella-automation-id='referralManagement_LineOfBuisness_Dropdown']");
	public static final By COMBO_SERVICE_TYPE = By.xpath("//div[@data-capella-automation-id='referralManagement_ServiceType_Dropdown']");
	public static final By COMBO_SOURCE = By.xpath("//div[@data-capella-automation-id='refferralSourceDropDown']");
	public static final By BTN_REFERRAL_MGMT_SAVE = By.xpath("//button[@data-capella-automation-id='Save_Btn']");
	
	public static final By TXT_LASTNAME = By.xpath("//input[@name='LastName']");
	public static final By TXT_DOB = By.xpath("//input[@id='newPtDOBTextBox']");
	public static final By TXT_ZIPCODE = By.xpath("//input[@name='PntMailAddrZip']");
	public static final By TXT_ADDRESS1 = By.xpath("//input[@name='PntMailAddr1']");
	public static final By TXT_ADDRESS2 = By.xpath("//input[@name='PntMailAddr2']");
	public static final By TXT_CITY = By.xpath("//input[@name='PntMailAddrCity']");
	public static final By COMBO_STATE = By.xpath("//div[@data-capella-automation-id='Add-New-Referral-PntMailAddrStateSelected']");
	public static final By TXT_HOME_PHONE = By.xpath("//input[@id='livingphbox']");
	public static final By COMBO_PRIMARY_PHONE = By.xpath("//div[@data-capella-automation-id='New-Referral-PntPrimePhoneType']");
	public static final By COMBO_GENDER = By.xpath("//div[@data-capella-automation-id='New-Referral-PntGenderSelected']");
	public static final By TXT_POLICY = By.xpath("//input[@data-capella-automation-id='EditDemographicsCopy.MemberIdentifiers.GroupPolicyNo[MemIdentifierKeyAttrName]']");
	public static final By BTN_DEMOGRAPHICS_SAVE = By.xpath("//div[@data-capella-automation-id='Add-New-Referral-saveNewPatientData']");
	
	public static final By WINDOW_CHANGES_SAVED_SUCCESSFULLY = By.xpath("//div[@id='myModal']");
	public static final By LBL_MSG = By.xpath("//div[@id='myModal']/div[2]/div[1]/div[1]/div[2]/div[1]/div[1]/b[1]");
	public static final By BTN_OK = By.xpath("//button[@data-capella-automation-id='The Changes have been saved successfully_Btn_Single_Ok']");
	
	public static final By LBL_ENROLLMENT_STATUS = By.xpath("//div[@data-capella-automation-id='label-getPatientEnrollStatusByKey(Detail.PatientDetails.EnrollmentDetails.CurrentEligibilityStatus)']");
	public static final By LBL_MEMBER_ID = By.xpath("//div[@data-capella-automation-id='label-Demographics.ID']");
}
