package com.vh.ui.pages;

import static com.vh.ui.web.locators.ManageDocumentsLocators.BTN_ADDDOCUMENT;
import static com.vh.ui.web.locators.ManageDocumentsLocators.BTN_ADDDOCUMENTADD;
import static com.vh.ui.web.locators.ManageDocumentsLocators.BTN_ADDDOCUMENTCANCEL;
import static com.vh.ui.web.locators.ManageDocumentsLocators.BTN_ADDDOCUMENTDATEOFSIGNATURECAL;
import static com.vh.ui.web.locators.ManageDocumentsLocators.BTN_ADDDOCUMENTLINKREFERRAL;
import static com.vh.ui.web.locators.ManageDocumentsLocators.BTN_ADDDOCUMENTLINKTOHOSPITALIZATION;
import static com.vh.ui.web.locators.ManageDocumentsLocators.BTN_ADDDOCUMENTSELECTAFILE;
import static com.vh.ui.web.locators.ManageDocumentsLocators.BTN_CONNECTAHOSPITALIZATIONCANCEL;
import static com.vh.ui.web.locators.ManageDocumentsLocators.BTN_CONNECTAHOSPITALIZATIONCONNECT;
import static com.vh.ui.web.locators.ManageDocumentsLocators.BTN_CONNECTAREFERRALCANCEL;
import static com.vh.ui.web.locators.ManageDocumentsLocators.BTN_CONNECTAREFERRALCONNECT;
import static com.vh.ui.web.locators.ManageDocumentsLocators.CAL_ADDDOCUMENTDATEOFSIGNATURE;
import static com.vh.ui.web.locators.ManageDocumentsLocators.CBO_ADDDOCUMENTDOCUMENTTYPE;
import static com.vh.ui.web.locators.ManageDocumentsLocators.CBO_DOCUMENTSTATUSDROPDOWN;
import static com.vh.ui.web.locators.ManageDocumentsLocators.CBO_DOCUMENTTYPESDROPDOWN;
import static com.vh.ui.web.locators.ManageDocumentsLocators.LBL_ADDDOCUMENTDATEOFSIGNATURE;
import static com.vh.ui.web.locators.ManageDocumentsLocators.LBL_ADDDOCUMENTDESCRIPTION;
import static com.vh.ui.web.locators.ManageDocumentsLocators.LBL_ADDDOCUMENTDOCUMENTTYPE;
import static com.vh.ui.web.locators.ManageDocumentsLocators.LBL_ADDDOCUMENTFILE;
import static com.vh.ui.web.locators.ManageDocumentsLocators.LBL_ADDDOCUMENTPOPUPHEADER;
import static com.vh.ui.web.locators.ManageDocumentsLocators.LBL_CONNECTAHOSPITALIZATIONADMIT;
import static com.vh.ui.web.locators.ManageDocumentsLocators.LBL_CONNECTAHOSPITALIZATIONDISCHARGE;
import static com.vh.ui.web.locators.ManageDocumentsLocators.LBL_CONNECTAHOSPITALIZATIONFACILITY;
import static com.vh.ui.web.locators.ManageDocumentsLocators.LBL_CONNECTAHOSPITALIZATIONHEADER;
import static com.vh.ui.web.locators.ManageDocumentsLocators.LBL_CONNECTAHOSPITALIZATIONTYPE;
import static com.vh.ui.web.locators.ManageDocumentsLocators.LBL_CONNECTAREFERRALAPPTDATE;
import static com.vh.ui.web.locators.ManageDocumentsLocators.LBL_CONNECTAREFERRALHEADER;
import static com.vh.ui.web.locators.ManageDocumentsLocators.LBL_CONNECTAREFERRALPROVIDERNAME;
import static com.vh.ui.web.locators.ManageDocumentsLocators.LBL_CONNECTAREFERRALREASON;
import static com.vh.ui.web.locators.ManageDocumentsLocators.LBL_MANAGEDOCUMENTSDESCRIPTIONHEADER;
import static com.vh.ui.web.locators.ManageDocumentsLocators.LBL_MANAGEDOCUMENTSENDDATEHEADER;
import static com.vh.ui.web.locators.ManageDocumentsLocators.LBL_MANAGEDOCUMENTSTYPEHEADER;
import static com.vh.ui.web.locators.ManageDocumentsLocators.LBL_PATIENTADMINMANAGEDOCUMENTS;
import static com.vh.ui.web.locators.ManageDocumentsLocators.TXT_ADDDOCUMENTDESCRIPTION;
import static com.vh.ui.web.locators.ManageDocumentsLocators.TXT_ADDDOCUMENTFILE;
import static com.vh.ui.web.locators.ManageDocumentsLocators.ROW_CONNECTAREFERRALFIRSTROW;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.openqa.selenium.By;
import org.openqa.selenium.TimeoutException;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;

import com.vh.ui.actions.ApplicationFunctions;
import com.vh.ui.exceptions.WaitException;
import com.vh.ui.page.base.WebPage;

import ru.yandex.qatools.allure.annotations.Step;

/*
 * @author Swetha Ryali
 * @date   July 25, 2017
 * @class  ManageDocumentsPage.java
 */

public class ManageDocumentsPage extends WebPage
{
	ApplicationFunctions appFunctions;

	public ManageDocumentsPage(WebDriver driver) throws WaitException {
		super(driver);

		appFunctions = new ApplicationFunctions(driver);
	}

	@Step("Verify the visibility of the Manage Documents page header label")
	public boolean viewManageDocumentPageHeader() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_PATIENTADMINMANAGEDOCUMENTS);
	}
	
	@Step("Verify the options of the document type box")
	public boolean verifyDocumentTypeOptions() throws TimeoutException, WaitException
	{
		List<String> dropDownOptions = new ArrayList<String>();
		dropDownOptions.add("All Document Types");
		dropDownOptions.add("2728");
		dropDownOptions.add("ACP");
		dropDownOptions.add("Care Plan");
		dropDownOptions.add("Depression Follow-up Results");
		dropDownOptions.add("Devices Usage Consent");
		dropDownOptions.add("Diabetic Foot Exam Verification");
		dropDownOptions.add("Diabetic Retinal Eye Exam Verification");
		dropDownOptions.add("Discharge Summary");
		dropDownOptions.add("ESCO HIE Consent Form");
		dropDownOptions.add("Humana Member Summary");
		dropDownOptions.add("Influenza Verification");
		dropDownOptions.add("Insurance Verification");
		dropDownOptions.add("MD Response");
		dropDownOptions.add("Medical Attestation");
		dropDownOptions.add("Medical Authorization - CKD");
		dropDownOptions.add("Medical Authorization - ESRD");
		dropDownOptions.add("New Member Questionnaire");
		dropDownOptions.add("Other");
		dropDownOptions.add("Patient Acknowledgement");
		dropDownOptions.add("Permission to Discuss");
		dropDownOptions.add("Pneumococcal Verification");
		dropDownOptions.add("Provider Care Report");
		dropDownOptions.add("QA Compliance Report");
		dropDownOptions.add("RCM-Record");
		dropDownOptions.add("Unable to Contact Packet");
		dropDownOptions.add("Unknown");
		dropDownOptions.add("Wellness Visit");
		
		return appFunctions.verifyDropDownOptions(CBO_DOCUMENTTYPESDROPDOWN, dropDownOptions);
	}
	
	@Step("Verify the options of the documents status combo box")
	public boolean verifyDocumentStatusComboBoxOptions() throws TimeoutException, WaitException
	{
		List<String> dropDownOptions = new ArrayList<String>();
		dropDownOptions.add("ALL");
		dropDownOptions.add("ACTIVE");
		dropDownOptions.add("INACTIVE/DELETED");

		return appFunctions.verifyDropDownOptions(CBO_DOCUMENTSTATUSDROPDOWN, dropDownOptions);
	}

	@Step("Verify the visibility of the Type column header label")
	public boolean viewTypeColumnHeaderLabel() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_MANAGEDOCUMENTSTYPEHEADER);
	}

	@Step("Verify the visibility of the Description column header label")
	public boolean viewDescriptionColumnHeaderLabel() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_MANAGEDOCUMENTSDESCRIPTIONHEADER);
	}

	@Step("Verify the visibility of the End Date column header label")
	public boolean viewEndDateColumnHeaderLabel() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_MANAGEDOCUMENTSENDDATEHEADER);
	}
	
	@Step("Verify the visibility of the ADD DOCUMENT button")
	public boolean viewAddDocumentButton() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, BTN_ADDDOCUMENT);
	}

	@Step("Click the ADD DOCUMENT button")
	public void clickAddDocumentButton() throws TimeoutException, WaitException
	{
		webActions.click(CLICKABILITY, BTN_ADDDOCUMENT);
	}
	
	@Step("Verify the visibility of Add a document popup header")
	public boolean viewAddDocumentPopupHeader() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_ADDDOCUMENTPOPUPHEADER);
	}	
	
	@Step("Verify the visibility of the Cancel button in the ADD DOCUMENT popup")
	public boolean viewCancelButtonAddDocument() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, BTN_ADDDOCUMENTCANCEL);
	}	

	@Step("Click the Cancel button in the ADD DOCUMENT popup")
	public void clickCancelButtonAddDocument() throws TimeoutException, WaitException
	{
		webActions.click(CLICKABILITY, BTN_ADDDOCUMENTCANCEL);
	}
	
	@Step("Verify the visibility of the Add button in the ADD DOCUMENT popup")
	public boolean viewAddButtonAddDocument() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, BTN_ADDDOCUMENTADD);
	}	

	@Step("Click the Add button in the ADD DOCUMENT popup")
	public void clickAddButtonAddDocument() throws TimeoutException, WaitException
	{
		webActions.click(CLICKABILITY, BTN_ADDDOCUMENTADD);
	}
	
	@Step("Verify if the add document popup ADD button is enabled")
	public boolean isAddDocumentopupAddButtonEnabled() throws TimeoutException, WaitException
	{
		return webActions.isElementEnabledLocatedBy(BTN_ADDDOCUMENTADD);
	}
	
	@Step("Verify the visibility of the File label in the Add Document popup")
	public boolean viewFileLabel() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_ADDDOCUMENTFILE);
	}
	
	@Step("Verify the visibility of the File Box in the Add Document popup")
	public boolean viewFileTextBox() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, TXT_ADDDOCUMENTFILE);
	}
	
	@Step("Verify the visibility of the Select a file button")
	public boolean viewSelectaFileButton() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, BTN_ADDDOCUMENTSELECTAFILE);
	}

	@Step("Click the Select A File button in the ADD DOCUMENT popup")
	public void clickSelectaFileButtonAddDocument()
	{
		try {
//			webActions.click(CLICKABILITY, BTN_ADDDOCUMENTSELECTAFILE);
			webActions.javascriptClick(BTN_ADDDOCUMENTSELECTAFILE);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	@Step("Upload file {1}")
	public void uploadFile(String exeFileName, String fileToUploadPath) {
			
//		WebDriverWait wait = new WebDriverWait(driver,10);
//		wait.until(ExpectedConditions.alertIsPresent());
		
		webActions.fileUploadByAutoIt(exeFileName, fileToUploadPath);
		
		try {
			Thread.sleep(3000);
		} catch (InterruptedException e) {
			e.printStackTrace();
		} 
	}
	
	@Step("Verify the visibility of the Description label in the Add Document popup")
	public boolean viewDescriptionLabel() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_ADDDOCUMENTDESCRIPTION);
	}
	
	@Step("Verify the visibility of the Description text area in the Add Document popup")
	public boolean viewDescriptionTextArea() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, TXT_ADDDOCUMENTDESCRIPTION);
	}

	@Step("Verify adding Description in the Add Document popup")
    public void addDescriptionAddDocument(String addDescription) throws TimeoutException, WaitException {
    	webActions.enterText(NOTREQUIRED, TXT_ADDDOCUMENTDESCRIPTION, addDescription);
    }
   

	@Step("Verify the visibility of the Document Type label in the Add Document popup")
	public boolean viewDocumentTypeLabel() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_ADDDOCUMENTDOCUMENTTYPE);
	}
	
	@Step("Verify the visibility of the Document Type drop down in the Add Document popup")
	public boolean viewDocumentTypeDropDown() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, CBO_ADDDOCUMENTDOCUMENTTYPE);
	}
	
	@Step("Verify the options of the document type box")
	public boolean verifyDocumentTypeOptionsAddDocument() throws TimeoutException, WaitException
	{
		List<String> dropDownOptions = new ArrayList<String>();
		dropDownOptions.add("Select a value");
		dropDownOptions.add("2728");
		dropDownOptions.add("ACP");
		dropDownOptions.add("Care Plan");
		dropDownOptions.add("Depression Follow-up Results");
		dropDownOptions.add("Devices Usage Consent");
		dropDownOptions.add("Diabetic Foot Exam Verification");
		dropDownOptions.add("Diabetic Retinal Eye Exam Verification");
		dropDownOptions.add("Discharge Summary");
		dropDownOptions.add("ESCO HIE Consent Form");
		dropDownOptions.add("Humana Member Summary");
		dropDownOptions.add("Influenza Verification");
		dropDownOptions.add("Insurance Verification");
		dropDownOptions.add("MD Response");
		dropDownOptions.add("Medical Attestation");
		dropDownOptions.add("Medical Authorization - CKD");
		dropDownOptions.add("Medical Authorization - ESRD");
		dropDownOptions.add("New Member Questionnaire");
		dropDownOptions.add("Other");
		dropDownOptions.add("Patient Acknowledgement");
		dropDownOptions.add("Permission to Discuss");
		dropDownOptions.add("Pneumococcal Verification");
		dropDownOptions.add("Provider Care Report");
		dropDownOptions.add("QA Compliance Report");
		dropDownOptions.add("RCM-Record");
		dropDownOptions.add("Unable to Contact Packet");
		dropDownOptions.add("Unknown");
		dropDownOptions.add("Wellness Visit");
		
		return appFunctions.verifyDropDownOptions(CBO_ADDDOCUMENTDOCUMENTTYPE, dropDownOptions);
	}

	@Step("Select an option form the document type combo box")
	public void selectDocumentTypeOptionAddDocument(String optionToSelect) throws TimeoutException, WaitException
	{
		webActions.selectFromDropDown(VISIBILITY, CBO_ADDDOCUMENTDOCUMENTTYPE, optionToSelect);
	}
	
	@Step("Verify the visibility of the Date of signature label in the Add Document popup")
	public boolean viewDateofSignatureLabel() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_ADDDOCUMENTDATEOFSIGNATURE);
	}

	@Step("Verify the visibility of the Date of signature date picker")
	public boolean viewDateofSignaturePicker() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, CAL_ADDDOCUMENTDATEOFSIGNATURE);
	}

	@Step("Verify the visibility of the Date of signature date picker button")
	public boolean viewDateofSignaturePickerButton() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, BTN_ADDDOCUMENTDATEOFSIGNATURECAL);
	}

	@Step("Verify the Date of signature date in the DATE picker is equal to the current date")
	public boolean isDateofSignatureDefaultDateCurrentDate() throws TimeoutException, WaitException, InterruptedException
	{
		return appFunctions.isCalendarDateEqualToCurrentDate(CAL_ADDDOCUMENTDATEOFSIGNATURE);
	}

	@Step("Click the Date of signature date date picker button")
	public void clickDateofSignaturePickerButton() throws TimeoutException, WaitException
	{
		webActions.click(VISIBILITY, BTN_ADDDOCUMENTDATEOFSIGNATURECAL);
	}

	@Step("Verify the Date of signature enabled date range in the DATE picker is valid")
	public boolean isDateofSignatureDateRangeValid() throws TimeoutException, WaitException, InterruptedException
	{
		return appFunctions.isCalendarEnabledDateRangeValid(CAL_ADDDOCUMENTDATEOFSIGNATURE);
	}

	@Step("Select the Date of signature current date from the DATE picker")
	public void selectDateofSignatureCurrentDateFromCalendar() throws TimeoutException, WaitException, InterruptedException
	{
		DateFormat dateFormat = new SimpleDateFormat("d");
		Date dateObject = new Date();
		String currentDay = dateFormat.format(dateObject);

		try
		{
			// Determine if the currently displayed month is the current month by checking if the previous month button is disabled.
			// If the previous month button is disabled, that means the previous month is displayed, thus we need to click the next month button to display the current month.
			// If the previous month button is enabled, that means the current month is displayed and the findElement method will fail causing the flow to go directly to the Catch,
			// bypassing the next month button click.
			By calendarPrevMMonthDisabledButton = By
			        .xpath(CAL_ADDDOCUMENTDATEOFSIGNATURE.toString().substring(10) + "/../..//div[@style='float:left']//button[@class='headerbtn mydpicon icon-mydpleft headerbtndisabled']");
			driver.findElement(calendarPrevMMonthDisabledButton);
			By calendarNextMMonthButton = By.xpath(CAL_ADDDOCUMENTDATEOFSIGNATURE.toString().substring(10) + "/../..//div[@style='float:left']//button[@class='headerbtn mydpicon icon-mydpright headerbtnenabled']");
			webActions.click(VISIBILITY, calendarNextMMonthButton);
		}
		catch (Exception ex)
		{
			
		}
		
		appFunctions.selectDateFromCalendar(CAL_ADDDOCUMENTDATEOFSIGNATURE, currentDay);		
	}


	@Step("Verify the visibility of the Link Referral button")
	public boolean viewLinkReferralButton() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, BTN_ADDDOCUMENTLINKREFERRAL);
	}
	
	@Step("Click the Link to Referrals button")
	public void clickLinktoReferralsButton() throws TimeoutException, WaitException
	{
		webActions.click(CLICKABILITY, BTN_ADDDOCUMENTLINKREFERRAL);
	}

	@Step("Verify the visibility of the Connect a referral header")
	public boolean viewConnectaReferralHeader() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_CONNECTAREFERRALHEADER);
	}
	
	@Step("Verify the visibility of the Provider Name label in Connect a Referral popup")
	public boolean viewProviderNamelabel() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_CONNECTAREFERRALPROVIDERNAME);
	}
	
	@Step("Verify the visibility of the Reason label in Connect a Referral popup")
	public boolean viewReasonlabel() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_CONNECTAREFERRALREASON);
	}
	
	@Step("Verify the visibility of the Appt Date label in Connect a Referral popup")
	public boolean viewApptDatelabel() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_CONNECTAREFERRALAPPTDATE);
	}
	
	@Step("Verify the visibility of the Cancel button in Connect a Referral popup")
	public boolean viewCancelButtonReferral() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, BTN_CONNECTAREFERRALCANCEL);
	}
	
	@Step("Click the Cancel button in Connect a Referral popup")
	public void clickCancelButtonReferral() throws TimeoutException, WaitException
	{
		webActions.click(CLICKABILITY, BTN_CONNECTAREFERRALCANCEL);
	}
	
	@Step("Verify the visibility of the Connect button in Connect a Referral popup")
	public boolean viewConnectButtonReferral() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, BTN_CONNECTAREFERRALCONNECT);
	}
	
	@Step("Click the Connect button in Connect a Referral popup")
	public void clickConnectButtonReferral() throws TimeoutException, WaitException
	{
		webActions.click(CLICKABILITY, BTN_CONNECTAREFERRALCONNECT);
	}
		
	@Step("Verify the visibility of the first row in Connect a Referral popup")
	public boolean viewConnectAReferralFirstRow() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, ROW_CONNECTAREFERRALFIRSTROW);
	}
	
	@Step("Select the first row in Connect a Referral popup")
	public void selectConnectAReferralFirstRow() throws TimeoutException, WaitException
	{
		webActions.click(CLICKABILITY, ROW_CONNECTAREFERRALFIRSTROW);
	}
		

	@Step("Verify the visibility of the Link to a Hospitalization button")
	public boolean viewLinktoaHospitalizationButton() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, BTN_ADDDOCUMENTLINKTOHOSPITALIZATION);
	}
	
	@Step("Click the Link to Hospitalization button")
	public void clickLinktoHospitalizationButton() throws TimeoutException, WaitException
	{
		webActions.click(CLICKABILITY, BTN_ADDDOCUMENTLINKTOHOSPITALIZATION);
	}
	
	@Step("Verify the visibility of the Connect a Hospitalization header")
	public boolean viewConnectaHospitalizationHeader() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_CONNECTAHOSPITALIZATIONHEADER);
	}
	
	@Step("Verify the visibility of the Facility Name label in Connect a Hospitalization popup")
	public boolean viewFacilitylabel() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_CONNECTAHOSPITALIZATIONFACILITY);
	}
	
	@Step("Verify the visibility of the Type label in Connect a Hospitalization popup")
	public boolean viewTypelabel() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_CONNECTAHOSPITALIZATIONTYPE);
	}
	
	@Step("Verify the visibility of the Admit label in Connect a Hospitalization popup")
	public boolean viewAdmitlabel() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_CONNECTAHOSPITALIZATIONADMIT);
	}
	
	@Step("Verify the visibility of the Discharge Date label in Connect a Hospitalization popup")
	public boolean viewDischargelabel() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_CONNECTAHOSPITALIZATIONDISCHARGE);
	}
	
	@Step("Verify the visibility of the Cancel button in Connect a Hospitalization popup")
	public boolean viewCancelButtonHospitalization() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, BTN_CONNECTAHOSPITALIZATIONCANCEL);
	}
	
	@Step("Click the Cancel button in Connect a Hospitalization popup")
	public void clickCancelButtonHospitalization() throws TimeoutException, WaitException
	{
		webActions.click(CLICKABILITY, BTN_CONNECTAHOSPITALIZATIONCANCEL);
	}
	
	@Step("Verify the visibility of the Connect button in Connect a Hospitalization popup")
	public boolean viewConnectButtonHospitalization() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, BTN_CONNECTAHOSPITALIZATIONCONNECT);
	}
	
	@Step("Click the Connect button in Connect a Hospitalization popup")
	public void clickConnectButtonHospitalization() throws TimeoutException, WaitException
	{
		webActions.click(CLICKABILITY, BTN_CONNECTAHOSPITALIZATIONCONNECT);
	}
}