package com.vh.ui.tests;
/*
 * @author Swetha Ryali
 * @date   July 17, 2017
 * @class  HospitalizationTest.java
 */

import java.util.Map;

import org.openqa.selenium.TimeoutException;
import org.openqa.selenium.WebDriver;
import org.testng.Assert;
import org.testng.annotations.AfterClass;
import org.testng.annotations.BeforeClass;
import org.testng.annotations.Test;

import com.vh.test.base.TestBase;
import com.vh.ui.actions.ApplicationFunctions;
import com.vh.ui.exceptions.URLNavigationException;
import com.vh.ui.exceptions.WaitException;
import com.vh.ui.page.base.WebPage;
import com.vh.ui.pages.HospitalizationPage;

import ru.yandex.qatools.allure.annotations.Step;

public class HospitalizationTest extends TestBase {
	
//	 Class objects
	WebPage pageBase;
	ApplicationFunctions appFunctions;
	HospitalizationPage hospitalizationPage;
	
	@BeforeClass
	public void buildUp() throws TimeoutException, WaitException, URLNavigationException, InterruptedException {
		WebDriver driver = getWebDriver();
		pageBase = new WebPage(driver);
		appFunctions = new ApplicationFunctions(driver);
		hospitalizationPage = new HospitalizationPage(driver);

		appFunctions.capellaLogin();
//		appFunctions.selectPatientFromMyPatients("Gareth Coulahan");
		appFunctions.navigateToMenu("Patient Experience->Hospitalization");

	}
	
	@Test(priority = 1)
	@Step("Verify the Hospitalization page")
	public void verify_CurrentHospitalizationPage() throws WaitException, URLNavigationException, InterruptedException
	{
		Assert.assertTrue(hospitalizationPage.viewHospitalizationPageHeaderLabel(), "Failed to identify the Current Hospitalization page header label");
		Assert.assertTrue(hospitalizationPage.viewAddHospitalizationButton(), "Failed to identify the ADD Hospitalization button");
	}
	
	@Test(priority = 2)
	@Step("Verify the Add Hospitalization popup")
	public void verify_AddHospitalizationPopupAdmittanceTab() throws WaitException, URLNavigationException, InterruptedException
	{
		hospitalizationPage.clickAddHospitalizationButton();
		Thread.sleep(1000);
		Assert.assertTrue(hospitalizationPage.viewNewHospPopupAdmittanceTabHeader(), "Failed to identify the Admittance tab header label in Add Hospitalization popup");
		Assert.assertTrue(hospitalizationPage.viewNewHospPopupAdmittanceTabFaciltityNameLabel(), "Failed to identify the Facility name label in Add Hospitalization popup");
		Assert.assertTrue(hospitalizationPage.viewNewHospPopupAdmittanceTabFaciltityNameTextBox(), "Failed to identify the Facility name text box in Add Hospitalization popup");
		Assert.assertTrue(hospitalizationPage.viewNewHospPopupAdmittanceTabAdmitDateLabel(), "Failed to identify the Admit date label in Add Hospitalization popup");
		Assert.assertTrue(hospitalizationPage.viewNewHospPopupAdmittanceTabAdmitDatePicker(), "Failed to identify the Admit Date Picker");
		Assert.assertTrue(hospitalizationPage.viewNewHospPopupAdmittanceTabAdmitDatePickerButton(), "Failed to identify the Admit Date Picker button");
		Assert.assertTrue(hospitalizationPage.viewNewHospPopupAdmittanceTabNotificationDate(), "Failed to identify the Notification Date label in Add Hospitalization popup");
		Assert.assertTrue(hospitalizationPage.viewNewHospPopupAdmittanceTabNotificationDatePicker(), "Failed to identify the Notification Date Picker");
		Assert.assertTrue(hospitalizationPage.viewNewHospPopupAdmittanceTabNotificationDate(), "Failed to identify the Notification Date Picker button");
		Assert.assertTrue(hospitalizationPage.viewNewHospPopupAdmittanceTabNotifiedByLabel(), "Failed to identify the Notified By label");
//		Assert.assertTrue(hospitalizationPage.verifyNewHospPopupAdmittanceTabNotifiedBydropdownOptions(), "Failed to identify the Notified By drop down options");
		Assert.assertTrue(hospitalizationPage.viewNewHospPopupAdmittanceTabReasonLabel(), "Failed to identify the Reason label ");	
//		Assert.assertTrue(hospitalizationPage.verifyNewHospPopupAdmittanceTabReasondropdownOptions(), "Failed to identify Reason dropdown options");
		Assert.assertTrue(hospitalizationPage.viewNewHospPopupAdmittanceTabReadmitLabel(), "Failed to identify the Readmit label");
		Assert.assertTrue(hospitalizationPage.viewNewHospPopupAdmittanceTabPhoneLabel(), "Failed to identify the Admittance tab phone label");
		Assert.assertTrue(hospitalizationPage.viewNewHospPopupAdmittanceTabPhoneTextBox(), "Failed to identify the Admittance tab phone text box");
		Assert.assertTrue(hospitalizationPage.viewNewHospPopupAdmittanceTabFaxLabel(), "Failed to identify the Admittance tab Fax label");
		Assert.assertTrue(hospitalizationPage.viewNewHospPopupAdmittanceTabFaxTextBox(), "Failed to identify the Admittance tab Fax text box");
		Assert.assertTrue(hospitalizationPage.viewNewHospPopupAdmittanceTabAdmittypeLabel(), "Failed to identify the Admit Type label in Add Hospitalization popup");
//		Assert.assertTrue(hospitalizationPage.verifyNewHospPopupAdmittanceTabAdmittypedropdownOptions(), "Failed to identify the Admit type drop down options");
		Assert.assertTrue(hospitalizationPage.viewNewHospPopupAdmittanceTabSourceofAdmitLabel(), "Failed to identify the Source of Admit label in Add Hospitalization popup");
//		Assert.assertTrue(hospitalizationPage.verifyNewHospPopupAdmittanceTabSourceofadmitdropdownOptions(), "Failed to identify the Source of Admit label in Add Hospitalization popup");
		Assert.assertTrue(hospitalizationPage.viewNewHospPopupAdmittanceTabPriorLocationLabel(), "Failed to identify the Prior Location label in admittance tab");
//		Assert.assertTrue(hospitalizationPage.verifyNewHospPopupAdmittanceTabPriorLocationdropdownOptions(), "Failed to Prior Location dropdown options in admittance tab");
		Assert.assertTrue(hospitalizationPage.viewNewHospPopupAdmittanceTabAdmittingDiagnosisLabel(), "Failed to identify the Admitting Diagnosis label");
//		Assert.assertTrue(hospitalizationPage.verifyNewHospPopupAdmittanceTabAdmittingDiagnosisdropdownOptions(), "Failed to identify the Admitting Diagnosis dropdown options");
		Assert.assertTrue(hospitalizationPage.viewNewHospPopupAdmittanceTabRelatedSubCategoryLabel(), "Failed to identify the Notification Date label in Add Hospitalization popup");
		Assert.assertTrue(hospitalizationPage.viewNewHospPopupAdmittanceTabWorkingDiagnosisLabel(), "Failed to identify the Notification Date Picker");
		Assert.assertTrue(hospitalizationPage.viewNewHospPopupAdmittanceTabWorkingDiagnosisTextBox(), "Failed to identify the Notification Date Picker");
		Assert.assertTrue(hospitalizationPage.viewNewHospPopupAdmittanceTabPlannedAdmissionLabel(), "Failed to identify the Notification Date Picker button");
		Assert.assertTrue(hospitalizationPage.viewNewHospPopupAdmittanceTabAvoidableAdmissionLabel(), "Failed to identify the Notified By label");
		Assert.assertTrue(hospitalizationPage.viewNewHospPopupAdmittanceTabHOSPCMGRLabel(), "Failed to identify the Notified By drop down options");
		Assert.assertTrue(hospitalizationPage.viewNewHospPopupAdmittanceTabCommentLabel(), "Failed to identify the Reason label ");	
		Assert.assertTrue(hospitalizationPage.viewNewHospPopupAdmittanceTabCommentTextBox(), "Failed to identify the Reason label ");	
		hospitalizationPage.clickNextButtonNewHospPopupAdmittanceTab();	
		//Verify all the error messages when all the mandatory fields are not populated.
		Assert.assertTrue(hospitalizationPage.verifyNewHospPopupFacilityNameAdmittanceTabErrorMesssage(), "Failed to identify the Reason label ");	
		Assert.assertTrue(hospitalizationPage.verifyNewHospPopupAdmittanceTabNotifiedByErrorMesssage(), "Failed to identify the Reason label ");	
		Assert.assertTrue(hospitalizationPage.viewNewHospPopupAdmittanceTabCommentTextBox(), "Failed to identify the Reason label ");	
		Assert.assertTrue(hospitalizationPage.verifyNewHospPopupAdmittanceTabAdmitTypeErrorMesssage(), "Failed to identify the Reason label ");	
		Assert.assertTrue(hospitalizationPage.verifyNewHospPopupAdmittanceTabSourceofAdmitErrorMesssage(), "Failed to identify the Reason label ");	
		Assert.assertTrue(hospitalizationPage.verifyNewHospPopupAdmittanceTabAdmittingDiagnosisErrorMesssage(), "Failed to identify the Reason label ");
		Assert.assertTrue(hospitalizationPage.verifyNewHospPopupAdmittanceTabRelatedSubcategoryErrorMesssage(), "Failed to identify the Reason label ");	
		Assert.assertTrue(hospitalizationPage.verifyNewHospPopupAdmittanceTabWorkingDiagnosisErrorMesssage(), "Failed to identify the Reason label ");	
	}
	
	@Test(priority = 3)
	@Step("Verify the Transfer tab by clicking on the transfer button in the Add New Hospitalization")
	public void verify_AddHospitalizationPopupTransferTab() throws WaitException, URLNavigationException, InterruptedException
	{
		hospitalizationPage.clickNewHospPopupAddTransferTabButton();
		Assert.assertTrue(hospitalizationPage.viewNewHospPopupTransferTabHeader(), "Failed to identify the transfer tab header label");
		Assert.assertTrue(hospitalizationPage.viewNewHospPopupTransferTabFacilityNameLabel(), "Failed to identify the facility name label");
		Assert.assertTrue(hospitalizationPage.viewNewHospPopupTransferTabFacilityNameTextBox(), "Failed to identify the facility name text box");
		Assert.assertTrue(hospitalizationPage.viewNewHospPopupTransferTabTransferDateLabel(), "Failed to identify the transfer date label");
		Assert.assertTrue(hospitalizationPage.viewNewHospPopupTransferTabTransferDatePicker(), "Failed to identify the transfer date picker");
		Assert.assertTrue(hospitalizationPage.viewNewHospPopupTransferTabTransferDatePickerButton(), "Failed to identify the transfer date picker button");
		Assert.assertTrue(hospitalizationPage.viewNewHospPopupTransferTabPhoneLabel(), "Failed to identify the transfer phone label");
		Assert.assertTrue(hospitalizationPage.viewNewHospPopupTransferTabPhoneTextBox(), "Failed to identify the transfer phone text box");
		Assert.assertTrue(hospitalizationPage.viewNewHospPopupTransferTabFaxLabel(), "Failed to identify the transfer fax label");
		Assert.assertTrue(hospitalizationPage.viewNewHospPopupTransferTabFaxTextBox(), "Failed to identify the transfer fax text box");
	}
	
	@Test(priority = 4)
	@Step("Verify the Discharge tab by clicking on the discharge button in the Add New Hospitalization")
	public void verify_AddHospitalizationPopupDischargeTab() throws WaitException, URLNavigationException, InterruptedException
	{
		hospitalizationPage.clickNewHospPopupAddDischargeTabButton();
		Assert.assertTrue(hospitalizationPage.viewNewHospPopupDischargeTabHeader(), "Failed to identify the Discharge tab header label");
		Assert.assertTrue(hospitalizationPage.viewNewHospPopupDischargeTabDischargeDateLabel(), "Failed to identify the Discharge Date label");
		Assert.assertTrue(hospitalizationPage.viewNewHospPopupDischargeTabDischargeDatePicker(), "Failed to identify the Discharge Date Picker");
		Assert.assertTrue(hospitalizationPage.viewNewHospPopupDischargeTabDischargeDatePickerButton(), "Failed to identify the Discharge Date Picker button");
		Assert.assertTrue(hospitalizationPage.viewNewHospPopupDischargeTabNotificationDateLabel(), "Failed to identify the Discharge Notification Date label");
		Assert.assertTrue(hospitalizationPage.viewNewHospPopupDischargeTabNotificationDatePicker(), "Failed to identify the Discharge Notification Date Picker");
		Assert.assertTrue(hospitalizationPage.viewNewHospPopupDischargeTabNotificationDatePickerButton(), "Failed to identify the Discharge Notification Date Picker button");	
		Assert.assertTrue(hospitalizationPage.viewNewHospPopupDischargeTabPlanDateLabel(), "Failed to identify the Plan Date label");
		Assert.assertTrue(hospitalizationPage.viewNewHospPopupDischargeTabPlanDatePicker(), "Failed to identify the Plan Date Picker");
		Assert.assertTrue(hospitalizationPage.viewNewHospPopupDischargeTabPlanDatePickerButton(), "Failed to identify the Plan Date Picker button");	
		Assert.assertTrue(hospitalizationPage.viewNewHospPopupDischargeTabPatientRefusedPlanLabel(), "Failed to identify the Patient refused plan label");
		Assert.assertTrue(hospitalizationPage.viewNewHospPopupDischargeTabPatientRefusedPlanYesradiobutton(), "Failed to identify the Patient refused plan YES radio button");
		Assert.assertTrue(hospitalizationPage.viewNewHospPopupDischargeTabPatientRefusedPlanNoradiobutton(), "Failed to identify the Patient refused plan NO radio button");
		Assert.assertTrue(hospitalizationPage.viewNewHospPopupDischargeTabDischargeDiagnosisLabel(), "Failed to identify the Discharge Diagnosis label");
		Assert.assertTrue(hospitalizationPage.viewNewHospPopupDischargeTabDischargeDiagnosisComboBox(), "Failed to identify the Discharge Diagnosis dropdowm box");
		Assert.assertTrue(hospitalizationPage.viewNewHospPopupDischargeTabRelatedSubcategoryLabel(), "Failed to identify the Related Subcategory label");
		Assert.assertTrue(hospitalizationPage.viewNewHospPopupDischargeTabRelatedSubcategoryComboBox(), "Failed to identify the Related Subcategory drop down");
		Assert.assertTrue(hospitalizationPage.viewNewHospPopupDischargeTabDispositionLabel(), "Failed to identify the Discharge Disposition label");
		Assert.assertTrue(hospitalizationPage.viewNewHospPopupDischargeTabDispositionComboBox(), "Failed to identify the Discharge Disposition drop down");
		Assert.assertTrue(hospitalizationPage.viewNewHospPopupDischargeTabHomeHealthNameLabel(), "Failed to identify the Home Health Name  label");
		Assert.assertTrue(hospitalizationPage.viewNewHospPopupDischargeTabHomeHealthNameTextBox(), "Failed to identify the Home Health Name text box");
		Assert.assertTrue(hospitalizationPage.viewNewHospPopupDischargeTabHomeHealthReasonLabel(), "Failed to identify the Home Health Reason Label");
		Assert.assertTrue(hospitalizationPage.viewNewHospPopupDischargeTabHomeHealthReasonComboBox(), "Failed to identify the Home Health Reason drop down");
		hospitalizationPage.clickNewHospPopupCancelButton();
	}	

	@Test(priority = 5, dataProvider = "CapellaDataProvider")
	@Step("Verify the Discharge tab by clicking on the discharge button in the Add New Hospitalization")
	public void AddaHospitalizationRecord(Map<String, String> map) throws WaitException, URLNavigationException, InterruptedException
	{
		
		appFunctions.selectPatientFromMyPatients(map.get("PatientName"));
		appFunctions.navigateToMenu("Patient Experience->Hospitalization");
		Thread.sleep(10000);
		Assert.assertTrue(hospitalizationPage.viewHospitalizationPageHeaderLabel(), "Failed to identify the Current Hospitalization page header label");

//		hospitalizationPage.addHospitalizationRecord(map);
		Thread.sleep(7000);
		hospitalizationPage.viewAddedHospitalizationRecordExists(map);
	}
	
	@Test(priority = 6, dataProvider = "CapellaDataProvider")
	@Step("Verify the Add New Hospitalization button will be disabled when a current hospitalzation record exists with no discharge date")
	public void AddaAdmitHospitalizationRecord(Map<String, String> map) throws WaitException, URLNavigationException, InterruptedException
	{
		
		appFunctions.selectPatientFromMyPatients(map.get("PatientName"));
		appFunctions.navigateToMenu("Patient Experience->Hospitalization");
		Thread.sleep(10000);
		Assert.assertTrue(hospitalizationPage.viewHospitalizationPageHeaderLabel(), "Failed to identify the Current Hospitalization page header label");

//		hospitalizationPage.addHospitalizationRecord(map);
		Thread.sleep(7000);
		hospitalizationPage.viewAddedHospitalizationRecordExists(map);
	}
	
	@AfterClass
	public void tearDown() throws TimeoutException, WaitException
	{
	appFunctions.capellaLogout();
	pageBase.quit();
	}
}

