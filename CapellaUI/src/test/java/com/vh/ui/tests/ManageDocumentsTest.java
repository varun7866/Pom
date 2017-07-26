package com.vh.ui.tests;
/*
 * @author Swetha Ryali
 * @date   July 17, 2017
 * @class  ManageDocumentsTest.java
 */

import org.openqa.selenium.TimeoutException;
import org.openqa.selenium.WebDriver;
import org.testng.Assert;
import org.testng.annotations.BeforeClass;
import org.testng.annotations.Test;

import com.vh.test.base.TestBase;
import com.vh.ui.actions.ApplicationFunctions;
import com.vh.ui.exceptions.URLNavigationException;
import com.vh.ui.exceptions.WaitException;
import com.vh.ui.page.base.WebPage;
import com.vh.ui.pages.ManageDocumentsPage;

import ru.yandex.qatools.allure.annotations.Step;

public class ManageDocumentsTest extends TestBase {
	
	// Class objects
	WebPage pageBase;
	ApplicationFunctions appFunctions;
	ManageDocumentsPage  manageDocumentsPage;
	
	@BeforeClass
	public void buildUp() throws TimeoutException, WaitException, URLNavigationException, InterruptedException {
		WebDriver driver = getWebDriver();
		pageBase = new WebPage(driver);
		appFunctions = new ApplicationFunctions(driver);
		manageDocumentsPage = new ManageDocumentsPage(driver);

		appFunctions.capellaLogin();
		appFunctions.selectPatientFromMyPatients("Emelita Coulahan");
		appFunctions.navigateToMenu("Patient Admin->Manage Documents");
	}
	
	@Test(priority = 1)
	@Step("Verify the Manage Documents page")
	public void verify_CurrentManageDocumentsPage() throws WaitException, URLNavigationException, InterruptedException
	{
		Assert.assertTrue(manageDocumentsPage.viewManageDocumentPageHeader(), "Failed to identify the Current Manage Documents page header label");
		Assert.assertTrue(manageDocumentsPage.verifyDocumentTypeOptions(), "Failed to identify the Document Type dropdown");
		Assert.assertTrue(manageDocumentsPage.verifyDocumentStatusComboBoxOptions(), "The Document Type dropdown options are incorrect");
		Assert.assertTrue(manageDocumentsPage.viewTypeColumnHeaderLabel(), "Failed to identify the Type column header label");
		Assert.assertTrue(manageDocumentsPage.viewDescriptionColumnHeaderLabel(), "Failed to identify the Description Column header label");
		Assert.assertTrue(manageDocumentsPage.viewEndDateColumnHeaderLabel(), "Failed to identify the End Date Column header label");
		Assert.assertTrue(manageDocumentsPage.viewAddDocumentButton(), "Failed to identify the Add Document button");
	}
	
	@Test(priority = 2)
	@Step("Verify the Add Document popup")
	public void verify_AddDocumentPopup() throws WaitException, URLNavigationException, InterruptedException
	{
		manageDocumentsPage.clickAddDocumentButton();
		Assert.assertTrue(manageDocumentsPage.viewAddDocumentPopupHeader(), "Failed to identify the Add a Document popup header");
		Assert.assertTrue(manageDocumentsPage.viewCancelButtonAddDocument(), "Failed to identify the Cancel button in Add Document popup");
		Assert.assertTrue(manageDocumentsPage.viewFileLabel(), "Failed to identify the File label");
		Assert.assertTrue(manageDocumentsPage.viewFileTextBox(), "Failed to identify the File Textbox");
		Assert.assertTrue(manageDocumentsPage.viewSelectaFileButton(), "Failed to identify the Select a File button");
		Assert.assertTrue(manageDocumentsPage.viewDescriptionLabel(), "Failed to identify the Description label");
		Assert.assertTrue(manageDocumentsPage.viewDescriptionTextArea(), "Failed to identify the Description text area");
		Assert.assertTrue(manageDocumentsPage.viewDocumentTypeLabel(), "Failed to identify the Document Type label");
		Assert.assertTrue(manageDocumentsPage.viewDocumentTypeDropDown(), "Failed to identify the Document Type Drop Down");
		Assert.assertTrue(manageDocumentsPage.verifyDocumentTypeOptionsAddDocument(), "The Document Type dropdown in add document popup options are incorrect");
		Assert.assertTrue(manageDocumentsPage.viewDateofSignatureLabel(), "Failed to identify the Date of Signature label");
		Assert.assertTrue(manageDocumentsPage.viewDateofSignaturePicker(), "Failed to identify the Date of Signature date picker");
		Assert.assertTrue(manageDocumentsPage.viewDateofSignaturePickerButton(), "Failed to identify the Date of Signature date picker button");
		Assert.assertTrue(manageDocumentsPage.isDateofSignatureDefaultDateCurrentDate(), "The Signature date default DATE does not match the current date");
		Assert.assertTrue(manageDocumentsPage.viewLinkReferralButton(), "Failed to identify the Link Referral button");
		Assert.assertTrue(manageDocumentsPage.viewLinktoaHospitalizationButton(), "Failed to identify the Link to a Hospitalization button");
	}
	
	@Test(priority = 3)
	@Step("Verify Adding a Document")
	public void verify_AddingaDocument() throws WaitException, URLNavigationException, InterruptedException
	{
		manageDocumentsPage.clickSelectaFileButtonAddDocument();
		
		manageDocumentsPage.addDescriptionAddDocument("Verify add document automation");
		manageDocumentsPage.selectDocumentTypeOptionAddDocument("Diabetic Retinal Eye Exam Verification");
		Assert.assertTrue(manageDocumentsPage.isAddDocumentopupAddButtonEnabled(), "The Add Medical Equipment popup ADD button should not be disabled at this point");
		manageDocumentsPage.clickDateofSignaturePickerButton();
		Assert.assertTrue(manageDocumentsPage.isDateofSignatureDateRangeValid(), "The Add Medical Equipment popup enabled DATE range is invalid");
		manageDocumentsPage.selectDateofSignatureCurrentDateFromCalendar();
		manageDocumentsPage.clickAddButtonAddDocument();
	}
	
/*	@Test(priority = 3)
	@Step("Verify the Connect a Referral popup")
	public void verify_ConnectaReferralPopup() throws WaitException, URLNavigationException, InterruptedException
	{
		manageDocumentsPage.clickLinktoReferralsButton();
		Assert.assertTrue(manageDocumentsPage.viewConnectaReferralHeader(), "Failed to identify the transfer tab header label");
		Assert.assertTrue(manageDocumentsPage.viewProviderNamelabel(), "Failed to identify the facility name label");
		Assert.assertTrue(manageDocumentsPage.viewReasonlabel(), "Failed to identify the facility name text box");
		Assert.assertTrue(manageDocumentsPage.viewApptDatelabel(), "Failed to identify the transfer date label");
		Assert.assertTrue(manageDocumentsPage.viewCancelButtonReferral(), "Failed to identify the transfer date picker");
		Assert.assertTrue(manageDocumentsPage.viewConnectButtonReferral(), "Failed to identify the transfer date picker button");
	}*/
	
/*	@Test(priority = 4)
	@Step("Verify the Discharge tab by clicking on the discharge button in the Add New Hospitalization")
	public void verify_ConnectaHospitalizationPopup() throws WaitException, URLNavigationException, InterruptedException
	{
		hospitalizationPage.clickAddDischargeTabButton();
		Assert.assertTrue(hospitalizationPage.viewDischargeTabHeader(), "Failed to identify the Discharge tab header label");
		Assert.assertTrue(hospitalizationPage.viewDischargeDateLabel(), "Failed to identify the Discharge Date label");
		Assert.assertTrue(hospitalizationPage.viewDischargeDatePicker(), "Failed to identify the Discharge Date Picker");
		Assert.assertTrue(hospitalizationPage.viewDischargeDatePickerButton(), "Failed to identify the Discharge Date Picker button");
		Assert.assertTrue(hospitalizationPage.viewDischargeNotificationDateLabel(), "Failed to identify the Discharge Notification Date label");
		Assert.assertTrue(hospitalizationPage.viewDischargeNotificationDatePicker(), "Failed to identify the Discharge Notification Date Picker");
		Assert.assertTrue(hospitalizationPage.viewDischargeNotificationDatePickerButton(), "Failed to identify the Discharge Notification Date Picker button");	
		Assert.assertTrue(hospitalizationPage.viewPlanDateLabel(), "Failed to identify the Plan Date label");
		Assert.assertTrue(hospitalizationPage.viewPlanDatePicker(), "Failed to identify the Plan Date Picker");
		Assert.assertTrue(hospitalizationPage.viewPlanDatePickerButton(), "Failed to identify the Plan Date Picker button");	
		Assert.assertTrue(hospitalizationPage.viewPatientRefusedPlanLabel(), "Failed to identify the Patient refused plan label");
		Assert.assertTrue(hospitalizationPage.viewPatientRefusedPlanYesradiobutton(), "Failed to identify the Patient refused plan YES radio button");
		Assert.assertTrue(hospitalizationPage.viewPatientRefusedPlanNoradiobutton(), "Failed to identify the Patient refused plan NO radio button");
		Assert.assertTrue(hospitalizationPage.viewDischargeDiagnosisLabel(), "Failed to identify the Discharge Diagnosis label");
		Assert.assertTrue(hospitalizationPage.viewDischargeDiagnosisComboBox(), "Failed to identify the Discharge Diagnosis dropdowm box");
		Assert.assertTrue(hospitalizationPage.viewDischargeRelatedSubcategoryLabel(), "Failed to identify the Related Subcategory label");
		Assert.assertTrue(hospitalizationPage.viewDischargeRelatedSubcategoryComboBox(), "Failed to identify the Related Subcategory drop down");
		Assert.assertTrue(hospitalizationPage.viewDischargeDispositionLabel(), "Failed to identify the Discharge Disposition label");
		Assert.assertTrue(hospitalizationPage.viewDischargeDispositionComboBox(), "Failed to identify the Discharge Disposition drop down");
		Assert.assertTrue(hospitalizationPage.viewMedicalEquipmentLabel(), "Failed to identify the Medical Equipment label");
		Assert.assertTrue(hospitalizationPage.viewMedicalEquipmentYesradiobutton(), "Failed to identify the Medical Equipment YES radio button");
		Assert.assertTrue(hospitalizationPage.viewMedicalEquipmentNoradiobutton(), "Failed to identify the Medical Equipment NO radio button");
		Assert.assertTrue(hospitalizationPage.viewHomeHealthNameLabel(), "Failed to identify the Home Health Name  label");
		Assert.assertTrue(hospitalizationPage.viewHomeHealthNameTextBox(), "Failed to identify the Home Health Name text box");
		Assert.assertTrue(hospitalizationPage.viewHomeHealthReasonLabel(), "Failed to identify the Home Health Reason Label");
		Assert.assertTrue(hospitalizationPage.viewHomeHealthReasonComboBox(), "Failed to identify the Home Health Reason drop down");
	}	*/


}

