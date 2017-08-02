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
import static com.vh.ui.web.locators.MedicalEquipmentLocators.CAL_ADDPOPUPDATE;

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
			webActions.click(CLICKABILITY, BTN_ADDDOCUMENTSELECTAFILE);	
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	@Step("Upload file {1}")
	public void uploadFile(String exeFileName, String fileToUploadPath) {
			
		WebDriverWait wait = new WebDriverWait(driver,10);
		wait.until(ExpectedConditions.alertIsPresent());
		
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
//		dropDownOptions.add("All Document Types");
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
		
		appFunctions.selectDateFromCalendar(CAL_ADDPOPUPDATE, currentDay);		
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

	@Step("Verify the visibility of the Link to a Hospitalization button")
	public boolean viewLinktoaHospitalizationButton() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, BTN_ADDDOCUMENTLINKTOHOSPITALIZATION);
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
	public void clickCancelButtonHospitalizationl() throws TimeoutException, WaitException
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


/*	@Step("Verify the visibility of the Status column header label")
	public boolean viewStatusColumnHeaderLabel() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_STATUSCOLUMNHEADER);
	}

	@Step("Verify the Status drop down is editable")
	public boolean isStatusDropdownEditable() throws TimeoutException, WaitException
	{
		String attributeValueBefore;
		String attributeValueAfter;

		attributeValueBefore = webActions.getAttributeValue(VISIBILITY, CBO_FIRSTROWSTATUS, "ng-reflect-model");

		if (attributeValueBefore.equals("E"))
		{
			webActions.selectFromDropDown(VISIBILITY, CBO_FIRSTROWSTATUS, "Returned");
		} else
		{
			webActions.selectFromDropDown(VISIBILITY, CBO_FIRSTROWSTATUS, "Error");
		}

		attributeValueAfter = webActions.getAttributeValue(VISIBILITY, CBO_FIRSTROWSTATUS, "ng-reflect-model");

		if (attributeValueBefore.equals(attributeValueAfter))
		{
			return false;
		}
		else
		{
			return true;
		}		
	}

	@Step("Verify the success message is displayed")
	public boolean viewSuccessMessage() throws TimeoutException, WaitException
	{
		return appFunctions.verifySuccessMessage("Medical equipment have been saved successfully");
	}

	@Step("Verify the options of the STATUS combo box")
	public boolean verifyStatusComboBoxOptions() throws TimeoutException, WaitException
	{
		List<String> dropDownOptions = new ArrayList<String>();
		dropDownOptions.add("Delivered");
		dropDownOptions.add("Error");
		dropDownOptions.add("Ordered");
		dropDownOptions.add("Replaced");
		dropDownOptions.add("Returned");

		return appFunctions.verifyDropDownOptions(CBO_FIRSTROWSTATUS, dropDownOptions);
	}

	@Step("Verify the visibility of the In Use column header label")
	public boolean viewInUseColumnHeaderLabel() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_INUSECOLUMNHEADER);
	}

	@Step("Verify the In Use check box is editable")
	public boolean isInUseCheckboxEditable() throws TimeoutException, WaitException, InterruptedException
	{
		String attributeValueBefore;
		String attributeValueAfter;

		attributeValueBefore = webActions.getAttributeValue(VISIBILITY, CHK_FIRSTROWEQUIPMENTISINUSE, "ng-reflect-checked");

		webActions.click(VISIBILITY, CHK_FIRSTROWEQUIPMENTISINUSE);

		attributeValueAfter = webActions.getAttributeValue(VISIBILITY, CHK_FIRSTROWEQUIPMENTISINUSE, "ng-reflect-checked");

		if (attributeValueBefore == null)
		{
			attributeValueBefore = "false";
		}

		if (attributeValueAfter == null)
		{
			attributeValueAfter = "false";
		}

		if (attributeValueBefore.equals(attributeValueAfter))
		{
			return false;
		} else
		{
			return true;
		}
	}



	@Step("Checks if a specific Medical Equipment is in the table")
	public boolean isMedicalEquipmentInTable() throws TimeoutException, WaitException
	{
		String[][] tableData = appFunctions.getTextFromTable(TBL_MEDICALEQUIPMENT, 5);

		DateFormat dateFormat = new SimpleDateFormat("M/d/yyyy");
		Date dateObject = new Date();

		for (String[] row : tableData)
		{
			if (row[0].equals("Bed Trapeze") && // If the data in the EQUIPMENT DESCRIPTION column equals "Bed Trapeze"
			        row[1].equals("VHProvided") && // If the data in the SOURCE column equals "VH Provided"
			        row[2].equals(dateFormat.format(dateObject))) // If the date in the DATE column equals the current date
			{
				return true;
			}
		}

		return false;
	}

	@Step("Checks if a specific Medical Equipment is in the table compared to the data from Excel")
	public boolean isMedicalEquipmentInTable(Map<String, String> map) throws TimeoutException, WaitException, InterruptedException
	{
		String equipmentDate;

		Thread.sleep(1000); // Pause to give time for the new Medical Equipment to be added to the table before we read the table

		String[][] tableData = appFunctions.getTextFromTable(TBL_MEDICALEQUIPMENT, 5);

		equipmentDate = appFunctions.adjustCurrentDateBy(map.get("DATE"), "M/d/yyyy");

		for (String[] row : tableData)
		{
			if (row[0].equals(map.get("EQUIPMENTTYPE")) && // If the data in the EQUIPMENT DESCRIPTION column equals the data from Excel
			        row[1].equals(map.get("SOURCE")) && // If the data in the SOURCE column equals the data from Excel
			        row[2].equals(equipmentDate)) // If the date in the DATE column equals the data from Excel
			{
				return true;
			}
		}

		return false;
	}

	@Step("Verify the visibility of the Add Medical Equipment popup")
	public boolean viewAddMedicalEquipmentPopup() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_ADDPOPUPADDMEDICALEQUIPMENT);
	}

	@Step("Verify the visibility of the Add Medical Equipment popup CANCEL button")
	public boolean viewAddPopupCancelButton() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, BTN_ADDPOPUPCANCEL);
	}

	@Step("Verify the visibility of the Add Medical Equipment popup ADD button")
	public boolean viewAddPopupAddButton() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, BTN_ADDPOPUPADD);
	}

	@Step("Click the Add Medical Equipment popup ADD button")
	public void clickAddPopupAddButton() throws TimeoutException, WaitException
	{
		webActions.click(VISIBILITY, BTN_ADDPOPUPADD);
	}

	@Step("Verify if the add popup ADD button is enabled")
	public boolean isAddPopupAddButtonEnabled() throws TimeoutException, WaitException
	{
		return webActions.isElementEnabledLocatedBy(BTN_ADDPOPUPADD);
	}

	@Step("Verify the visibility of the Add Medical Equipment popup DATE label")
	public boolean viewAddPopupDateLabel() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_ADDPOPUPDATE);
	}

	@Step("Verify the visibility of the Add Medical Equipment popup DATE picker")
	public boolean viewAddPopupDatePicker() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, CAL_ADDPOPUPDATE);
	}

	@Step("Verify the visibility of the Add Medical Equipment popup DATE picker button")
	public boolean viewAddPopupDatePickerButton() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, BTN_ADDPOPUPDATE);
	}

	@Step("Verify the Add Medical Equipment popup default date in the DATE picker is equal to the current date")
	public boolean isAddPopupDefaultDateCurrentDate() throws TimeoutException, WaitException, InterruptedException
	{
		return appFunctions.isCalendarDateEqualToCurrentDate(CAL_ADDPOPUPDATE);
	}

	@Step("Click the Add Medical Equipment popup date picker button")
	public void clickAddPopupDatePickerButton() throws TimeoutException, WaitException
	{
		webActions.click(VISIBILITY, BTN_ADDPOPUPDATE);
	}

	@Step("Verify the Add Medical Equipment popup enabled date range in the DATE picker is valid")
	public boolean isAddPopupEnabledDateRangeValid() throws TimeoutException, WaitException, InterruptedException
	{
		return appFunctions.isCalendarEnabledDateRangeValid(CAL_ADDPOPUPDATE);
	}

	@Step("Select the Add Medical Equipment popup current date from the DATE picker")
	public void selectAddPopupCurrentDateFromCalendar() throws TimeoutException, WaitException, InterruptedException
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
			        .xpath(CAL_ADDPOPUPDATE.toString().substring(10) + "/../..//div[@style='float:left']//button[@class='headerbtn mydpicon icon-mydpleft headerbtndisabled']");
			driver.findElement(calendarPrevMMonthDisabledButton);
			By calendarNextMMonthButton = By.xpath(CAL_ADDPOPUPDATE.toString().substring(10) + "/../..//div[@style='float:left']//button[@class='headerbtn mydpicon icon-mydpright headerbtnenabled']");
			webActions.click(VISIBILITY, calendarNextMMonthButton);
		}
		catch (Exception ex)
		{
			
		}
		
		appFunctions.selectDateFromCalendar(CAL_ADDPOPUPDATE, currentDay);		
	}

	@Step("Verify the visibility of the Add Medical Equipment popup SOURCE label")
	public boolean viewAddPopupSourceLabel() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_ADDPOPUPSOURCE);
	}

	@Step("Verify the visibility of the Add Medical Equipment popup SOURCE combo box")
	public boolean viewAddPopupSourceComboBox() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, CBO_ADDPOPUPSOURCE);
	}

	@Step("Verify the visibility of the Add Medical Equipment popup SOURCE placeholder")
	public boolean viewAddpopupSourcePlaceholder() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, PLH_ADDPOPUPSOURCE);
	}

	@Step("Verify the options of the Add Medical Equipment popup SOURCE combo box")
	public boolean verifyAddPopupSourceComboBoxOptions() throws TimeoutException, WaitException
	{
		List<String> dropDownOptions = new ArrayList<String>();
		dropDownOptions.add("Select a value");
		dropDownOptions.add("Other");
		dropDownOptions.add("VH Provided");

		return appFunctions.verifyDropDownOptions(CBO_ADDPOPUPSOURCE, dropDownOptions);
	}

	@Step("Select an option form the Add Medical Equipment popup SOURCE combo box")
	public void selectAddPopupSourceComboBox(String optionToSelect) throws TimeoutException, WaitException
	{
		webActions.selectFromDropDown(VISIBILITY, CBO_ADDPOPUPSOURCE, optionToSelect);
	}

	@Step("Verify the visibility of the Add Medical Equipment popup Equipment is in Use label")
	public boolean viewAddPopupEquipmentIsInUseLabel() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_ADDPOPUPEQUIPMENTISINUSE);
	}

	@Step("Verify the visibility of the Add Medical Equipment popup Equipment is in Use check box")
	public boolean viewAddPopupEquipmentIsInUseCheckBox() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, CHK_ADDPOPUPEQUIPMENTISINUSE);
	}

	@Step("Check the Add Medical Equipment popup Equipment is in Use check box")
	public void checkAddPopupEquipmentIsInUseCheckBox() throws TimeoutException, WaitException
	{
		webActions.click(VISIBILITY, CHK_ADDPOPUPEQUIPMENTISINUSE);
	}

	@Step("Verify the visibility of the Add Medical Equipment popup EQUIPMENT TYPE label")
	public boolean viewAddPopupEquipmentTypeLabel() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_ADDPOPUPEQUIPMENTTYPE);
	}

	@Step("Verify the visibility of the Add Medical Equipment popup EQUIPMENT TYPE combo box")
	public boolean viewAddPopupEquipmentTypeComboBox() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, CBO_ADDPOPUPEQUIPMENTTYPE);
	}

	@Step("Verify the visibility of the Add Medical Equipment popup EQUIPMENT TYPE placeholder")
	public boolean viewAddpopupEquipmentTypePlaceholder() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, PLH_ADDPOPUPEQUIPMENTTYPE);
	}

	@Step("Verify the options of the Add Medical Equipment popup EQUIPMENT TYPE combo box")
	public boolean verifyAddPopupEquipmentTypeComboBoxOptions() throws TimeoutException, WaitException
	{
		List<String> dropDownOptions = new ArrayList<String>();
		dropDownOptions.add("Select a value");
		dropDownOptions.add("Bed Trapeze");
		dropDownOptions.add("BP Machine");
		dropDownOptions.add("Cane");
		dropDownOptions.add("Commode");
		dropDownOptions.add("Digital Thermometer");
		dropDownOptions.add("Glucometer");
		dropDownOptions.add("Hospital Bed");
		dropDownOptions.add("Hoyer Lift");
		dropDownOptions.add("Incontinent Supplies");
		dropDownOptions.add("Nebulizer");
		dropDownOptions.add("Ostomy Care Supplies");
		dropDownOptions.add("Oxygen");
		dropDownOptions.add("PD cycler");
		dropDownOptions.add("Scale");
		dropDownOptions.add("Slider Board");
		dropDownOptions.add("Stethoscope");
		dropDownOptions.add("Tub/Shower Chair");
		dropDownOptions.add("Walker");
		dropDownOptions.add("Wheelchair");
		dropDownOptions.add("Wound Care Supplies");
		dropDownOptions.add("Wound Vac");

		return appFunctions.verifyDropDownOptions(CBO_ADDPOPUPEQUIPMENTTYPE, dropDownOptions);
	}

	@Step("Select an option form the Add Medical Equipment popup EQUIPMENT TYPE combo box")
	public void selectAddPopupEquipmentTypeComboBox(String optionToSelect) throws TimeoutException, WaitException
	{
		webActions.selectFromDropDown(VISIBILITY, CBO_ADDPOPUPEQUIPMENTTYPE, optionToSelect);
	}

	@Step("Verify the visibility of the Add Medical Equipment popup STATUS label")
	public boolean viewAddPopupStatusLabel() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_ADDPOPUPSTATUS);
	}

	@Step("Verify the visibility of the Add Medical Equipment popup STATUS combo box")
	public boolean viewAddPopupStatusComboBox() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, CBO_ADDPOPUPSTATUS);
	}

	@Step("Verify the visibility of the Add Medical Equipment popup STATUS placeholder")
	public boolean viewAddpopupStatusPlaceholder() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, PLH_ADDPOPUPSTATUS);
	}

	@Step("Verify the options of the Add Medical Equipment popup STATUS combo box")
	public boolean verifyAddPopupStatusComboBoxOptions() throws TimeoutException, WaitException
	{
		List<String> dropDownOptions = new ArrayList<String>();
		dropDownOptions.add("Select a value");
		dropDownOptions.add("Delivered");
		dropDownOptions.add("Error");
		dropDownOptions.add("Ordered");
		dropDownOptions.add("Replaced");
		dropDownOptions.add("Returned");

		return appFunctions.verifyDropDownOptions(CBO_ADDPOPUPSTATUS, dropDownOptions);
	}

	@Step("Select an option from the Add Medical Equipment popup STATUS combo box")
	public void selectAddPopupStatusComboBox(String optionToSelect) throws TimeoutException, WaitException
	{
		webActions.selectFromDropDown(VISIBILITY, CBO_ADDPOPUPSTATUS, optionToSelect);
	}

	*//**
	 * Adds one Medical Equipment to the Medical Equipment table
	 * 
	 * @param dateToSelect
	 *            The day to select in the date picker
	 * @param source
	 *            The source to select in the SOURCE drop down
	 * @param equipmentType
	 *            The equipment type to select in the EQUIPMENT TYPE drop down
	 * @param status
	 *            The status to select in the STATUS drop down
	 * @param equipmentInUse
	 *            Whether or not to select the Equipment is in Use check box
	 * @throws TimeoutException
	 * @throws WaitException
	 * @throws InterruptedException
	 *//*
	@Step("Adds one Medical Equipment to the Medical Equipment table")
	public void addMedicalEquipment(String dateToSelect, String source, String equipmentType, String status, boolean equipmentInUse) throws TimeoutException, WaitException, InterruptedException
	{
		clickAddMedicalEquipmentButton();
		
		clickAddPopupDatePickerButton();
		appFunctions.selectDateFromCalendar(CAL_ADDPOPUPDATE, dateToSelect);
		selectAddPopupSourceComboBox(source);
		selectAddPopupEquipmentTypeComboBox(equipmentType);
		selectAddPopupStatusComboBox(status);
		
		if (equipmentInUse)
		{
			checkAddPopupEquipmentIsInUseCheckBox();
		}

		clickAddPopupAddButton();
	}

	@Step("Verify the EQUIPMENT DESCRIPTION column sorts ascendingly")
	public boolean isTableSortableByEquipmentDescriptionAscending() throws TimeoutException, WaitException
	{
		webActions.click(VISIBILITY, LBL_EQUIPMENTDESCRIPTIONCOLUMNHEADER);

		return appFunctions.isColumnSorted(TBL_MEDICALEQUIPMENT, 1, "A", "text");
	}

	@Step("Verify the EQUIPMENT DESCRIPTION column sorts dscendingly")
	public boolean isTableSortableByEquipmentDescriptionDescending() throws TimeoutException, WaitException
	{
		webActions.click(VISIBILITY, LBL_EQUIPMENTDESCRIPTIONCOLUMNHEADER);

		return appFunctions.isColumnSorted(TBL_MEDICALEQUIPMENT, 1, "D", "text");
	}

	@Step("Verify the SOURCE column sorts ascendingly")
	public boolean isTableSortableBySourceAscending() throws TimeoutException, WaitException
	{
		webActions.click(VISIBILITY, LBL_SOURCECOLUMNHEADER);

		return appFunctions.isColumnSorted(TBL_MEDICALEQUIPMENT, 2, "A", "text");
	}

	@Step("Verify the SOURCE column sorts dscendingly")
	public boolean isTableSortableBySourceDescending() throws TimeoutException, WaitException
	{
		webActions.click(VISIBILITY, LBL_SOURCECOLUMNHEADER);

		return appFunctions.isColumnSorted(TBL_MEDICALEQUIPMENT, 2, "D", "text");
	}

	@Step("Verify the MODIFIED column sorts ascendingly")
	public boolean isTableSortableByModifiedAscending() throws TimeoutException, WaitException
	{
		webActions.click(VISIBILITY, LBL_DATECOLUMNHEADER);

		return appFunctions.isColumnSorted(TBL_MEDICALEQUIPMENT, 3, "A", "text");
	}

	@Step("Verify the MODIFIED column sorts dscendingly")
	public boolean isTableSortableByModifiedDescending() throws TimeoutException, WaitException
	{
		webActions.click(VISIBILITY, LBL_DATECOLUMNHEADER);

		return appFunctions.isColumnSorted(TBL_MEDICALEQUIPMENT, 3, "D", "text");
	}

	@Step("Verify the STATUS column sorts ascendingly")
	public boolean isTableSortableByStatusAscending() throws TimeoutException, WaitException
	{
		webActions.click(VISIBILITY, LBL_STATUSCOLUMNHEADER);

		return appFunctions.isColumnSorted(TBL_MEDICALEQUIPMENT, 4, "A", "dropdown");
	}

	@Step("Verify the STATUS column sorts dscendingly")
	public boolean isTableSortableByStatusDescending() throws TimeoutException, WaitException
	{
		webActions.click(VISIBILITY, LBL_STATUSCOLUMNHEADER);

		return appFunctions.isColumnSorted(TBL_MEDICALEQUIPMENT, 4, "D", "dropdown");
	}

	@Step("Verify the IN USE column sorts ascendingly")
	public boolean isTableSortableByInUseAscending() throws TimeoutException, WaitException
	{
		webActions.click(VISIBILITY, LBL_INUSECOLUMNHEADER);

		return appFunctions.isColumnSorted(TBL_MEDICALEQUIPMENT, 5, "A", "checkbox");
	}

	@Step("Verify the IN USE column sorts dscendingly")
	public boolean isTableSortableByInUseDescending() throws TimeoutException, WaitException
	{
		webActions.click(VISIBILITY, LBL_INUSECOLUMNHEADER);

		return appFunctions.isColumnSorted(TBL_MEDICALEQUIPMENT, 5, "D", "checkbox");
	}*/
}