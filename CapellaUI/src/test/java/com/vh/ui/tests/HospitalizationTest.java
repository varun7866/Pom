package com.vh.ui.tests;
/*
 * @author Swetha Ryali
 * @date   July 17, 2017
 * @class  HospitalizationTest.java
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
import com.vh.ui.pages.HospitalizationPage;

import ru.yandex.qatools.allure.annotations.Step;

public class HospitalizationTest extends TestBase {
	
	// Class objects
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
		appFunctions.selectPatientFromMyPatients("Emelita Coulahan");
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
	public void verify_AddHospitalizationPopup() throws WaitException, URLNavigationException, InterruptedException
	{
		hospitalizationPage.clickAddHospitalizationButton();
	}
	
	@Test(priority = 3)
	@Step("Verify the Transfer tab by clicking on the transfer button in the Add New Hospitalization")
	public void verify_AddTransferTab() throws WaitException, URLNavigationException, InterruptedException
	{
		hospitalizationPage.clickAddTransferTabButton();
		Assert.assertTrue(hospitalizationPage.viewTransferTabHeader(), "Failed to identify the transfer tab header label");
		Assert.assertTrue(hospitalizationPage.viewFacilityNameLabel(), "Failed to identify the facility name label");
		Assert.assertTrue(hospitalizationPage.viewFacilityNameTextBox(), "Failed to identify the facility name text box");
		Assert.assertTrue(hospitalizationPage.viewTransferDateLabel(), "Failed to identify the transfer date label");
		Assert.assertTrue(hospitalizationPage.viewTransferDatePicker(), "Failed to identify the transfer date picker");
		Assert.assertTrue(hospitalizationPage.viewTransferDatePickerButton(), "Failed to identify the transfer date picker button");
		Assert.assertTrue(hospitalizationPage.viewTransferPhoneLabel(), "Failed to identify the transfer phone label");
		Assert.assertTrue(hospitalizationPage.viewTransferPhoneTextBox(), "Failed to identify the transfer phone text box");
		Assert.assertTrue(hospitalizationPage.viewTransferFaxLabel(), "Failed to identify the transfer fax label");
		Assert.assertTrue(hospitalizationPage.viewTransferFaxTextBox(), "Failed to identify the transfer fax text box");
	}
	
	@Test(priority = 4)
	@Step("Verify the Discharge tab by clicking on the discharge button in the Add New Hospitalization")
	public void verify_AddDischargeTab() throws WaitException, URLNavigationException, InterruptedException
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
	}	


}

