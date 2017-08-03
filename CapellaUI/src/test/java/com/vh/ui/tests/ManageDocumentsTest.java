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
//		appFunctions.selectPatientFromMyPatients("Emelita Coulahan");
		appFunctions.selectPatientFromMyPatients("Gareth Coulahan");
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
		String projectPath = System.getProperty("user.dir");
		String manageDocPath = projectPath +  "\\resources\\managedocuments\\" + "image.jpg";
		manageDocumentsPage.uploadFile("FileUpload.exe", manageDocPath);
		manageDocumentsPage.addDescriptionAddDocument("testing");
		manageDocumentsPage.selectDocumentTypeOptionAddDocument("2728");
		Assert.assertTrue(manageDocumentsPage.isAddDocumentopupAddButtonEnabled(), "The Add Medical Equipment popup ADD button should not be enabled at this point");
		manageDocumentsPage.clickDateofSignaturePickerButton();
//		Assert.assertTrue(manageDocumentsPage.isDateofSignatureDateRangeValid(), "The Add Medical Equipment popup enabled DATE range is invalid");
//		manageDocumentsPage.selectDateofSignatureCurrentDateFromCalendar();
		manageDocumentsPage.clickAddButtonAddDocument();
	}
	
	@Test(priority = 4)
	@Step("Verify the Connect a Referral popup")
	public void verify_ConnectaReferralPopup() throws WaitException, URLNavigationException, InterruptedException
	{
		manageDocumentsPage.clickLinktoReferralsButton();
		Assert.assertTrue(manageDocumentsPage.viewConnectaReferralHeader(), "Failed to identify the Connect a Referral header label");
		Assert.assertTrue(manageDocumentsPage.viewProviderNamelabel(), "Failed to identify the provider name label");
		Assert.assertTrue(manageDocumentsPage.viewReasonlabel(), "Failed to identify the reason label");
		Assert.assertTrue(manageDocumentsPage.viewApptDatelabel(), "Failed to identify the appt date label");
		Assert.assertTrue(manageDocumentsPage.viewCancelButtonReferral(), "Failed to identify the cancel button");
		Assert.assertTrue(manageDocumentsPage.viewConnectButtonReferral(), "Failed to identify the connect button");
		Assert.assertTrue(manageDocumentsPage.viewConnectAReferralFirstRow(), "Failed to identify the first row in Connect a Referral popup");
		manageDocumentsPage.selectConnectAReferralFirstRow();
		manageDocumentsPage.clickConnectButtonReferral();
	}
	
	@Test(priority = 5)
	@Step("Verify the Connect a Referral popup")
	public void verify_ConnectaHospitalizationPopup() throws WaitException, URLNavigationException, InterruptedException
	{
		manageDocumentsPage.clickLinktoHospitalizationButton();
		Assert.assertTrue(manageDocumentsPage.viewConnectaHospitalizationHeader(), "Failed to identify the Connect a Hospitalization header label");
		Assert.assertTrue(manageDocumentsPage.viewFacilitylabel(), "Failed to identify the Faility label");
		Assert.assertTrue(manageDocumentsPage.viewTypelabel(), "Failed to identify the Type label");
		Assert.assertTrue(manageDocumentsPage.viewAdmitlabel(), "Failed to identify the Admit label");
		Assert.assertTrue(manageDocumentsPage.viewDischargelabel(), "Failed to identify the Discharge label");
		Assert.assertTrue(manageDocumentsPage.viewCancelButtonHospitalization(), "Failed to identify the cancel button");
		Assert.assertTrue(manageDocumentsPage.viewConnectButtonHospitalization(), "Failed to identify the connect button");
		manageDocumentsPage.clickCancelButtonHospitalization();
		
	}
	
}

