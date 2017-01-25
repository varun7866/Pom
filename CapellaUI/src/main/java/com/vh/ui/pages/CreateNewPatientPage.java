/**
 * 
 */
package com.vh.ui.pages;

import org.openqa.selenium.By;
import org.openqa.selenium.TimeoutException;
import org.openqa.selenium.WebDriver;

import com.vh.ui.actions.ApplicationFunctions;
import com.vh.ui.exceptions.WaitException;
import com.vh.ui.page.base.WebPage;
import static com.vh.ui.web.locators.CreateNewPatientPageLocators.*;

import ru.yandex.qatools.allure.annotations.Step;

/**
 * @author subalivada
 * @date   Jan 16, 2017
 * @class  CreateNewPatient.java
 *
 */
public class CreateNewPatientPage extends WebPage {
	
	ApplicationFunctions app;
	public CreateNewPatientPage(WebDriver driver) throws WaitException {
		super(driver);
		app = new ApplicationFunctions(driver);
	}
	
	@Step("Entered {0} in first name text field")
	public void enterFirstName(String firstName) throws TimeoutException, WaitException {
		if(wait.checkForElementVisibility(driver, TXT_FIRSTNAME)){
			webActions.enterText(VISIBILITY, TXT_FIRSTNAME, firstName);
		}
	}
	
	@Step("Click on Search Button in member search")
	public void clickOnSearch() throws WaitException {
		if(wait.checkForElementVisibility(driver, BTN_SEARCH)){
			webActions.javascriptClick(BTN_SEARCH);
		}
	}
	
	@Step("Click on Cancel button in member search window")
	public void clickOnCancel() throws WaitException {
		if(wait.checkForElementVisibility(driver, BTN_MEMBER_SEARCHRESULT_CANCEL)){
			webActions.javascriptClick(BTN_MEMBER_SEARCHRESULT_CANCEL);
		}
	}
	
	@Step("Click on New Referral button in member search window")
	public void clickOnNewReferral() throws WaitException {
		if(wait.checkForElementVisibility(driver, BTN_NEW_REFERRAL)){
			webActions.javascriptClick(BTN_NEW_REFERRAL);
		}
	}
	
	@Step("Wait for Referral Management window")
	public boolean waitForReferralManagementWindow() throws WaitException {
		return wait.checkForElementVisibility(driver, WIN_REFERRAL_MGMT);
	}
	
	@Step("Enter {0} in referral date")
	public void enterReferralDate(String referralDate) throws TimeoutException, WaitException	{
		webActions.enterText(VISIBILITY, TXT_REFERRAL_DATE, referralDate);
	}
	
	@Step("Enter {0} in referral received date")
	public void enterReferralReceivedDate(String referralRcvdDate) throws TimeoutException, WaitException	{
		webActions.enterText(VISIBILITY, TXT_REFERRAL_RCVD_DATE, referralRcvdDate);
	}
	
	@Step("Enter {0} in application date")
	public void enterApplicationDate(String applicationDate) throws TimeoutException, WaitException	{
		webActions.enterText(VISIBILITY, TXT_APPLICATION_DATE, applicationDate);
	}
	
	@Step("Select referring payor {0}")
	public void selectReferringPayor(String payor) throws TimeoutException, WaitException {
		app.selectAnItemFromComboBox(COMBO_PAYOR, payor);
	}
	
	@Step("Select disease state {0}")
	public void selectDiseaseState(String diseaseState) throws TimeoutException, WaitException {
		app.selectAnItemFromComboBox(COMBO_DISEASE_STATE, diseaseState);
	}
	
	@Step("Select line of business {0}")
	public void selectLineOfBusiness(String lob) throws TimeoutException, WaitException {
		app.selectAnItemFromComboBox(COMBO_LOB, lob);
	}
	
	@Step("Select service type {0}")
	public void selectServiceType(String serviceType) throws TimeoutException, WaitException {
		app.selectAnItemFromComboBox(COMBO_SERVICE_TYPE, serviceType);
	}
	
	@Step("Select source {0}")
	public void selectSource(String source) throws TimeoutException, WaitException {
		app.selectAnItemFromComboBox(COMBO_SOURCE, source);
	}
	
	@Step("Click on Referral Management Save button")
	public void clickRefMgmtSaveButton()
	{
		webActions.javascriptClick(BTN_REFERRAL_MGMT_SAVE);
	}
	
	@Step("Enter {0} in last name")
	public void enterLastName(String lastName) throws TimeoutException, WaitException	{
		webActions.enterText(VISIBILITY, TXT_LASTNAME, lastName);
	}
	
	@Step("Enter {0} in date of birth")
	public void enterDOB(String dob) throws TimeoutException, WaitException	{
		webActions.enterText(VISIBILITY, TXT_DOB, dob);
	}
	
	@Step("Enter {0} in zip code")
	public void enterZipCode(String zipCode) throws TimeoutException, WaitException	{
		webActions.enterText(VISIBILITY, TXT_ZIPCODE, zipCode);
	}
	
	@Step("Enter {0} in address")
	public void enterAddress(String address) throws TimeoutException, WaitException	{
		webActions.enterText(VISIBILITY, TXT_ADDRESS1, address);
	}
	
	@Step("Enter {0} in apt/suite")
	public void enterAptSuite(String suite) throws TimeoutException, WaitException	{
		webActions.enterText(VISIBILITY, TXT_ADDRESS2, suite);
	}
	
	@Step("Enter {0} in city")
	public void enterCity(String city) throws TimeoutException, WaitException	{
		webActions.enterText(VISIBILITY, TXT_CITY, city);
	}
	
	@Step("Select {0} in state")
	public void selectState(String state) throws TimeoutException, WaitException	{
		app.selectAnItemFromComboBox(COMBO_STATE, state);
	}
	
	@Step("Enter {0} in home phone")
	public void enterHomePhone(String phone) throws TimeoutException, WaitException	{
		webActions.enterText(CLICKABILITY, TXT_HOME_PHONE, phone);
	}
	
	@Step("Select {0} in primary phone")
	public void selectPrimaryPhone(String primaryPhone) throws TimeoutException, WaitException	{
		app.selectAnItemFromComboBox(COMBO_PRIMARY_PHONE, primaryPhone);
	}
	
	@Step("Select {0} in primary phone")
	public void selectGender(String gender) throws TimeoutException, WaitException	{
		app.selectAnItemFromComboBox(COMBO_GENDER, gender);
	}
	
	@Step("Enter {0} in policy")
	public void enterPolicy(String policy) throws TimeoutException, WaitException	{
		webActions.enterText(VISIBILITY, TXT_POLICY, policy);
	}
	
	@Step("Click on Demographics Save button")
	public void clickDemographicsSaveButton()
	{
		webActions.javascriptClick(BTN_DEMOGRAPHICS_SAVE);
	}
	
	@Step("Wait for the message box to appear")
	public boolean waitForChangesSavedMessageBox() throws WaitException, InterruptedException
	{
		return app.checkMessageBoxExist(By.xpath("//div[@id='myModal']"), By.xpath("//div[@id='myModal']/div[2]/div[1]/div[1]/div[2]/div[1]/div[1]/b[1]"), "Member added successfully.");
	}
	
	@Step("Close the message box")
	public void closeTheMessageBox() throws WaitException, InterruptedException
	{
		app.clickButtonOnMessageBox(WINDOW_CHANGES_SAVED_SUCCESSFULLY, LBL_MSG, "Member added successfully.", BTN_OK);
	}
	
	@Step("Get enrollment status")
	public String getEnrollmentStatus() throws TimeoutException, WaitException
	{
		return webActions.getText(PRESENCE, LBL_ENROLLMENT_STATUS);
	}
	
	@Step("Get member id")
	public String getMemberId() throws TimeoutException, WaitException
	{
		return webActions.getText(PRESENCE, LBL_MEMBER_ID);
	}
}
