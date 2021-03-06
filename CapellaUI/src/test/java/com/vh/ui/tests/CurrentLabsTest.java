package com.vh.ui.tests;

import java.sql.SQLException;
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
import com.vh.ui.pages.CurrentLabsPage;

import ru.yandex.qatools.allure.annotations.Step;

/*
 * @author Harvy Ackermans
 * @date   June 14, 2017
 * @class  CurrentLabsTest.java
 * 
 * Before running this test suite:
 * 1. Change the "username" and "password" parameters in the "resources\application.properties" file to your own
 * 2. Clear your browser's cache
 * 3. You will need a CKD and an ESRD Patient
 * 4. It's not required, but it would be a good idea to delete all existing Labs from table PTLB_PATIENT_LABS for your Patients
 * Note: KT/V & URR are invalid for a CKD Patient
 * Note: URINE ALBUMIN/CREATININE RATIO is invalid for an ESRD Patient
 */

public class CurrentLabsTest extends TestBase
{	
	// Class objects
	WebPage pageBase;
	ApplicationFunctions appFunctions;
	CurrentLabsPage currentLabsPage;
	
	@BeforeClass
	public void buildUp() throws TimeoutException, WaitException, URLNavigationException, InterruptedException {
		WebDriver driver = getWebDriver();
		pageBase = new WebPage(driver);
		appFunctions = new ApplicationFunctions(driver);
		currentLabsPage = new CurrentLabsPage(driver);

		appFunctions.capellaLogin();
	}

	@Test(priority = 1, dataProvider = "CapellaDataProvider")
	@Step("Verify the Current Labs page")
	public void verify_CurrentLabsPage(Map<String, String> map) throws WaitException, URLNavigationException, InterruptedException, TimeoutException, SQLException
	{
		currentLabsPage.deleteCurrentLabsDatabase(map.get("MemberID"));

		appFunctions.selectPatientFromMyPatients(map.get("PatientName")); // CKD Patient

		appFunctions.navigateToMenu("Patient Experience->Labs->Current Labs");

		Assert.assertTrue(currentLabsPage.viewPageHeaderLabel(), "Failed to identify the Current Labs page header label");
		Assert.assertTrue(currentLabsPage.viewAddLabButton(), "Failed to identify the ADD LAB button");
	}

	@Test(priority = 2, dataProvider = "CapellaDataProvider")
	@Step("Verify the Add Lab Results popup for CKD Patients")
	public void verify_AddLabResultsPopupCKD(Map<String, String> map) throws WaitException, URLNavigationException, InterruptedException
	{
		appFunctions.selectPatientFromMyPatients(map.get("PatientName")); // CKD Patient

		appFunctions.navigateToMenu("Patient Experience->Labs->Current Labs");

		currentLabsPage.clickAddLabButton();

		Assert.assertTrue(currentLabsPage.viewAddLabResultsPopup(), "Failed to identify the Add Labs Results popup header label");

		Assert.assertTrue(currentLabsPage.viewAddPopupCancelButton(), "Failed to identify the Add Lab Results popup CANCEL button");
		Assert.assertTrue(currentLabsPage.viewAddPopupSaveButton(), "Failed to identify the Add Lab Results popup SAVE button");

		Assert.assertTrue(currentLabsPage.viewAddPopupApplyThisDateToAllValuesLabel(), "Failed to identify the Add Lab Results popup APPLY THIS DATE TO ALL VALUES label");
		Assert.assertTrue(currentLabsPage.viewAddPopupDatePicker(), "Failed to identify the Add Lab Results popup APPLY THIS DATE TO ALL VALUES picker");
		Assert.assertTrue(currentLabsPage.viewAddPopupDatePickerButtons("CKD"), "Failed to identify all of the Add Lab Results popup date picker buttons for CKD");
		Assert.assertTrue(currentLabsPage.isAddPopupDateAplliedToAllDates("CKD", 0), "The Add Lab Results popup dates did not all default to current date for CKD");
		Assert.assertTrue(currentLabsPage.isAddPopupDateAplliedToAllDates("CKD", -1), "The Add Lab Results popup APPLY THIS DATE TO ALL VALUES was not applied to all dates for CKD");

		Assert.assertTrue(currentLabsPage.viewAddpopupHeightLabel(), "Failed to identify the Add Lab Results popup HEIGHT label");
		Assert.assertTrue(currentLabsPage.viewAddpopupHeightTextBox(), "Failed to identify the Add Lab Results popup HEIGHT text box");
		Assert.assertTrue(currentLabsPage.viewAddpopupHeightPlaceholder(), "Failed to identify the Add Lab Results popup HEIGHT placeholder");

		Assert.assertTrue(currentLabsPage.viewAddpopupTargetDryWeightLabel(), "Failed to identify the Add Lab Results popup TARGET DRY WEIGHT label");
		Assert.assertTrue(currentLabsPage.viewAddpopupTargetDryWeightTextBox(), "Failed to identify the Add Lab Results popup TARGET DRY WEIGHT text box");
		Assert.assertTrue(currentLabsPage.viewAddpopupTargetDryWeightPlaceholder(), "Failed to identify the Add Lab Results popup TARGET DRY WEIGHT placeholder");

		Assert.assertTrue(currentLabsPage.viewAddpopupPhosphorousLabel(), "Failed to identify the Add Lab Results popup PHOSPHOROUS label");
		Assert.assertTrue(currentLabsPage.viewAddpopupPhosphorousTextBox(), "Failed to identify the Add Lab Results popup PHOSPHOROUS text box");
		Assert.assertTrue(currentLabsPage.viewAddpopupPhosphorousGoal(), "Failed to identify the Add Lab Results popup PHOSPHOROUS Goal");

		Assert.assertTrue(currentLabsPage.viewAddpopupGFRLabel(), "Failed to identify the Add Lab Results popup GFR label");
		Assert.assertTrue(currentLabsPage.viewAddpopupGFRTextBox(), "Failed to identify the Add Lab Results popup GFR text box");
		Assert.assertTrue(currentLabsPage.viewAddpopupGFRGoal(), "Failed to identify the Add Lab Results popup GFR Goal");

		Assert.assertTrue(currentLabsPage.viewAddpopupLDLLabel(), "Failed to identify the Add Lab Results popup LDL label");
		Assert.assertTrue(currentLabsPage.viewAddpopupLDLTextBox(), "Failed to identify the Add Lab Results popup LDL text box");
		Assert.assertTrue(currentLabsPage.viewAddpopupLDLGoal(), "Failed to identify the Add Lab Results popup LDL Goal");

		Assert.assertTrue(currentLabsPage.viewAddpopupAlbuminLabel(), "Failed to identify the Add Lab Results popup ALBUMIN label");
		Assert.assertTrue(currentLabsPage.viewAddpopupAlbuminTextBox(), "Failed to identify the Add Lab Results popup ALBUMIN text box");
		Assert.assertTrue(currentLabsPage.viewAddpopupAlbuminGoal(), "Failed to identify the Add Lab Results popup ALBUMIN Goal");

		Assert.assertTrue(currentLabsPage.viewAddpopupDipstickForProteinLabel(), "Failed to identify the Add Lab Results popup DIPSTICK FOR PROTEIN label");
		Assert.assertTrue(currentLabsPage.viewAddPopupDipstickForProteinComboBox(), "Failed to identify the Add Lab Results popup DIPSTICK FOR PROTEIN combo box");
		Assert.assertTrue(currentLabsPage.viewAddpopupDipstickForProteinPlaceholder(), "Failed to identify the Add Lab Results popup DIPSTICK FOR PROTEIN placeholder");
		Assert.assertTrue(currentLabsPage.verifyAddPopupDipstickForProteinComboBoxOptions(), "The Add Lab Results popup DIPSTICK FOR DIPSTICK FOR PROTEIN drop down options are incorrect");
		Assert.assertTrue(currentLabsPage.viewAddpopupDipstickForProteinGoal(), "Failed to identify the Add Lab Results popup DIPSTICK FOR PROTEIN Goal");

		Assert.assertTrue(currentLabsPage.viewAddpopupCalciumLabel(), "Failed to identify the Add Lab Results popup CALCIUM label");
		Assert.assertTrue(currentLabsPage.viewAddpopupCalciumTextBox(), "Failed to identify the Add Lab Results popup CALCIUM text box");
		Assert.assertTrue(currentLabsPage.viewAddpopupCalciumGoal1(), "Failed to identify the Add Lab Results popup CALCIUM Goal 1");
		Assert.assertTrue(currentLabsPage.viewAddpopupCalciumGoal2(), "Failed to identify the Add Lab Results popup CALCIUM Goal 2");

		Assert.assertTrue(currentLabsPage.viewAddpopupURRLabel(), "Failed to identify the Add Lab Results popup URR label");
		Assert.assertTrue(currentLabsPage.viewAddpopupURRTextBox(), "Failed to identify the Add Lab Results popup URR text box");
		Assert.assertTrue(currentLabsPage.viewAddpopupURRGoal(), "Failed to identify the Add Lab Results popup URR Goal");

		Assert.assertTrue(currentLabsPage.viewAddpopupPTHLabel(), "Failed to identify the Add Lab Results popup PTH label");
		Assert.assertTrue(currentLabsPage.viewAddpopupPTHTextBox(), "Failed to identify the Add Lab Results popup PTH text box");
		Assert.assertTrue(currentLabsPage.viewAddpopupPTHGoal1(), "Failed to identify the Add Lab Results popup PTH Goal 1");
		Assert.assertTrue(currentLabsPage.viewAddpopupPTHGoal2(), "Failed to identify the Add Lab Results popup PTH Goal 2");
		Assert.assertTrue(currentLabsPage.viewAddpopupPTHGoal3(), "Failed to identify the Add Lab Results popup PTH Goal 3");
		Assert.assertTrue(currentLabsPage.viewAddpopupPTHGoal4(), "Failed to identify the Add Lab Results popup PTH Goal 4");
		Assert.assertTrue(currentLabsPage.viewAddpopupPTHGoal5(), "Failed to identify the Add Lab Results popup PTH Goal 5");

		Assert.assertTrue(currentLabsPage.viewAddpopupFerritinLabel(), "Failed to identify the Add Lab Results popup FERRITIN label");
		Assert.assertTrue(currentLabsPage.viewAddpopupFerritinTextBox(), "Failed to identify the Add Lab Results popup FERRITIN text box");
		Assert.assertTrue(currentLabsPage.viewAddpopupFerritinGoal(), "Failed to identify the Add Lab Results popup FERRITIN Goal");

		Assert.assertTrue(currentLabsPage.viewAddpopupBloodPressureLabel(), "Failed to identify the Add Lab Results popup BLOOD PRESURE label");
		Assert.assertTrue(currentLabsPage.viewAddpopupBloodPressureSystolicTextBox(), "Failed to identify the Add Lab Results popup BLOOD PRESURE SYSTOLIC text box");
		Assert.assertTrue(currentLabsPage.viewAddpopupBloodPressureDiastolicTextBox(), "Failed to identify the Add Lab Results popup BLOOD PRESURE DIASTOLIC text box");
		Assert.assertTrue(currentLabsPage.viewAddpopupBloodPressureSystolicGoal(), "Failed to identify the Add Lab Results popup BLOOD PRESURE SYSTOLIC Goal");
		Assert.assertTrue(currentLabsPage.viewAddpopupBloodPressureDiastolicGoal(), "Failed to identify the Add Lab Results popup BLOOD PRESURE DIASTOLIC Goal");

		Assert.assertTrue(currentLabsPage.viewAddpopupWeightLabel(), "Failed to identify the Add Lab Results popup WEIGHT label");
		Assert.assertTrue(currentLabsPage.viewAddpopupWeightTextBox(), "Failed to identify the Add Lab Results popup WEIGHT text box");
		Assert.assertTrue(currentLabsPage.viewAddpopupWeightPlaceholder(), "Failed to identify the Add Lab Results popup WEIGHT placeholder");

		Assert.assertTrue(currentLabsPage.viewAddpopupCalciumXPhosphorousLabel(), "Failed to identify the Add Lab Results popup CALCIUM X PHOSPHOROUS label");
		Assert.assertTrue(currentLabsPage.viewAddpopupCalciumXPhosphorousTextBox(), "Failed to identify the Add Lab Results popup CALCIUM X PHOSPHOROUS text box");
		Assert.assertTrue(currentLabsPage.viewAddpopupCalciumXPhosphorousGoal(), "Failed to identify the Add Lab Results popup CALCIUM X PHOSPHOROUS Goal");

		Assert.assertTrue(currentLabsPage.viewAddpopupCreatinineLabel(), "Failed to identify the Add Lab Results popup CREATININE label");
		Assert.assertTrue(currentLabsPage.viewAddpopupCreatinineTextBox(), "Failed to identify the Add Lab Results popup CREATININE text box");
		Assert.assertTrue(currentLabsPage.viewAddpopupCreatinineGoal(), "Failed to identify the Add Lab Results popup CCREATININE Goal");

		Assert.assertTrue(currentLabsPage.viewAddpopupHGBA1CLabel(), "Failed to identify the Add Lab Results popup HGB A1C label");
		Assert.assertTrue(currentLabsPage.viewAddpopupHGBA1CTextBox(), "Failed to identify the Add Lab Results popup HGB A1C text box");
		Assert.assertTrue(currentLabsPage.viewAddpopupHGBA1CGoal(), "Failed to identify the Add Lab Results popup HGB A1C Goal");

		Assert.assertTrue(currentLabsPage.viewAddpopupHGBLabel(), "Failed to identify the Add Lab Results popup HGB label");
		Assert.assertTrue(currentLabsPage.viewAddpopupHGBTextBox(), "Failed to identify the Add Lab Results popup HGB text box");
		Assert.assertTrue(currentLabsPage.viewAddpopupHGBGoal(), "Failed to identify the Add Lab Results popup HGB Goal");

		Assert.assertTrue(currentLabsPage.viewAddpopupUrineAlbuminCreatinineRatioLabel(), "Failed to identify the Add Lab Results popup URINE ALBUMIN/CREATININE RATIO label");
		Assert.assertTrue(currentLabsPage.viewAddpopupUrineAlbuminCreatinineRatioTextBox(), "Failed to identify the Add Lab Results popup URINE ALBUMIN/CREATININE RATIO text box");
		Assert.assertTrue(currentLabsPage.viewAddpopupUrineAlbuminCreatinineRatioGoal(), "Failed to identify the Add Lab Results popup URINE ALBUMIN/CREATININE RATIO Goal");

		Assert.assertTrue(currentLabsPage.viewAddpopupCo2LevelLabel(), "Failed to identify the Add Lab Results popup CO2 LEVEL label");
		Assert.assertTrue(currentLabsPage.viewAddpopupCo2LevelTextBox(), "Failed to identify the Add Lab Results popup CO2 LEVEL text box");
		Assert.assertTrue(currentLabsPage.viewAddpopupCo2LevelGoal(), "Failed to identify the Add Lab Results popup CO2 LEVEL Goal");

		Assert.assertTrue(currentLabsPage.viewAddpopupKTVLabel(), "Failed to identify the Add Lab Results popup KT/V label");
		Assert.assertTrue(currentLabsPage.viewAddpopupKTVTextBox(), "Failed to identify the Add Lab Results popup KT/V text box");
		Assert.assertTrue(currentLabsPage.viewAddpopupKTVGoal(), "Failed to identify the Add Lab Results popup KT/V Goal");

		Assert.assertTrue(currentLabsPage.viewAddpopupPotassiumLabel(), "Failed to identify the Add Lab Results popup POTASSIUM label");
		Assert.assertTrue(currentLabsPage.viewAddpopupPotassiumTextBox(), "Failed to identify the Add Lab Results popup POTASSIUM text box");
		Assert.assertTrue(currentLabsPage.viewAddpopupPotassiumGoal(), "Failed to identify the Add Lab Results popup POTASSIUM Goal");
		
		Assert.assertTrue(currentLabsPage.viewAddpopupHepatitisBTiterLabel(), "Failed to identify the Add Lab Results popup HEPATITIS B TITER label");
		Assert.assertTrue(currentLabsPage.viewAddpopupHepatitisBTiterTextBox(), "Failed to identify the Add Lab Results popup HEPATITIS B TITER text box");
		Assert.assertTrue(currentLabsPage.viewAddpopupHepatitisBTiterGoal(), "Failed to identify the Add Lab Results popup HEPATITIS B TITER Goal");

		Assert.assertTrue(currentLabsPage.viewAddpopupTSATLabel(), "Failed to identify the Add Lab Results popup TSAT label");
		Assert.assertTrue(currentLabsPage.viewAddpopupTSATTextBox(), "Failed to identify the Add Lab Results popup TSAT text box");
		Assert.assertTrue(currentLabsPage.viewAddpopupTSATGoal(), "Failed to identify the Add Lab Results popup TSAT Goal");

		currentLabsPage.clickAddPopupCancelButton();
	}

	@Test(priority = 3, dataProvider = "CapellaDataProvider")
	@Step("Verify the Add Lab Results popup for ESRD Patients")
	public void verify_AddLabResultsPopupESRD(Map<String, String> map) throws WaitException, URLNavigationException, InterruptedException
	{
		appFunctions.selectPatientFromMyPatients(map.get("PatientName")); // ESRD Patient

		appFunctions.navigateToMenu("Patient Experience->Labs->Current Labs");

		currentLabsPage.clickAddLabButton();

		Assert.assertTrue(currentLabsPage.viewAddLabResultsPopup(), "Failed to identify the Add Labs Results popup header label");

		Assert.assertTrue(currentLabsPage.viewAddPopupCancelButton(), "Failed to identify the Add Lab Results popup CANCEL button");
		Assert.assertTrue(currentLabsPage.viewAddPopupSaveButton(), "Failed to identify the Add Lab Results popup SAVE button");

		Assert.assertTrue(currentLabsPage.viewAddPopupApplyThisDateToAllValuesLabel(), "Failed to identify the Add Lab Results popup APPLY THIS DATE TO ALL VALUES label");
		Assert.assertTrue(currentLabsPage.viewAddPopupDatePicker(), "Failed to identify the Add Lab Results popup APPLY THIS DATE TO ALL VALUES picker");
		Assert.assertTrue(currentLabsPage.viewAddPopupDatePickerButtons("ESRD"), "Failed to identify all of the Add Lab Results popup date picker buttons for ESRD");
		Assert.assertTrue(currentLabsPage.isAddPopupDateAplliedToAllDates("ESRD", 0), "The Add Lab Results popup dates did not all default to current date for ESRD");
		Assert.assertTrue(currentLabsPage.isAddPopupDateAplliedToAllDates("ESRD", -1), "The Add Lab Results popup APPLY THIS DATE TO ALL VALUES was not applied to all dates for ESRD");

		Assert.assertTrue(currentLabsPage.viewAddpopupHeightLabel(), "Failed to identify the Add Lab Results popup HEIGHT label");
		Assert.assertTrue(currentLabsPage.viewAddpopupHeightTextBox(), "Failed to identify the Add Lab Results popup HEIGHT text box");
		Assert.assertTrue(currentLabsPage.viewAddpopupHeightPlaceholder(), "Failed to identify the Add Lab Results popup HEIGHT placeholder");

		Assert.assertTrue(currentLabsPage.viewAddpopupTargetDryWeightLabel(), "Failed to identify the Add Lab Results popup TARGET DRY WEIGHT label");
		Assert.assertTrue(currentLabsPage.viewAddpopupTargetDryWeightTextBox(), "Failed to identify the Add Lab Results popup TARGET DRY WEIGHT text box");
		Assert.assertTrue(currentLabsPage.viewAddpopupTargetDryWeightPlaceholder(), "Failed to identify the Add Lab Results popup TARGET DRY WEIGHT placeholder");

		Assert.assertTrue(currentLabsPage.viewAddpopupPhosphorousLabel(), "Failed to identify the Add Lab Results popup PHOSPHOROUS label");
		Assert.assertTrue(currentLabsPage.viewAddpopupPhosphorousTextBox(), "Failed to identify the Add Lab Results popup PHOSPHOROUS text box");
		Assert.assertTrue(currentLabsPage.viewAddpopupPhosphorousGoal(), "Failed to identify the Add Lab Results popup PHOSPHOROUS Goal");

		Assert.assertTrue(currentLabsPage.viewAddpopupGFRLabel(), "Failed to identify the Add Lab Results popup GFR label");
		Assert.assertTrue(currentLabsPage.viewAddpopupGFRTextBox(), "Failed to identify the Add Lab Results popup GFR text box");
		Assert.assertTrue(currentLabsPage.viewAddpopupGFRGoal(), "Failed to identify the Add Lab Results popup GFR Goal");

		Assert.assertTrue(currentLabsPage.viewAddpopupLDLLabel(), "Failed to identify the Add Lab Results popup LDL label");
		Assert.assertTrue(currentLabsPage.viewAddpopupLDLTextBox(), "Failed to identify the Add Lab Results popup LDL text box");
		Assert.assertTrue(currentLabsPage.viewAddpopupLDLGoal(), "Failed to identify the Add Lab Results popup LDL Goal");

		Assert.assertTrue(currentLabsPage.viewAddpopupAlbuminLabel(), "Failed to identify the Add Lab Results popup Albumin label");
		Assert.assertTrue(currentLabsPage.viewAddpopupAlbuminTextBox(), "Failed to identify the Add Lab Results popup Albumin text box");
		Assert.assertTrue(currentLabsPage.viewAddpopupAlbuminGoal(), "Failed to identify the Add Lab Results popup Albumin Goal");

		Assert.assertTrue(currentLabsPage.viewAddpopupCo2LevelLabel(), "Failed to identify the Add Lab Results popup CO2 LEVEL label");
		Assert.assertTrue(currentLabsPage.viewAddpopupCo2LevelTextBox(), "Failed to identify the Add Lab Results popup CO2 LEVEL text box");
		Assert.assertTrue(currentLabsPage.viewAddpopupCo2LevelGoal(), "Failed to identify the Add Lab Results popup CO2 LEVEL Goal");

		Assert.assertTrue(currentLabsPage.viewAddpopupKTVLabel(), "Failed to identify the Add Lab Results popup KT/V label");
		Assert.assertTrue(currentLabsPage.viewAddpopupKTVTextBox(), "Failed to identify the Add Lab Results popup KT/V text box");
		Assert.assertTrue(currentLabsPage.viewAddpopupKTVGoal(), "Failed to identify the Add Lab Results popup KT/V Goal");

		Assert.assertTrue(currentLabsPage.viewAddpopupPotassiumLabel(), "Failed to identify the Add Lab Results popup POTASSIUM label");
		Assert.assertTrue(currentLabsPage.viewAddpopupPotassiumTextBox(), "Failed to identify the Add Lab Results popup POTASSIUM text box");
		Assert.assertTrue(currentLabsPage.viewAddpopupPotassiumGoal(), "Failed to identify the Add Lab Results popup POTASSIUM Goal");

		Assert.assertTrue(currentLabsPage.viewAddpopupHepatitisBTiterLabel(), "Failed to identify the Add Lab Results popup HEPATITIS B TITER label");
		Assert.assertTrue(currentLabsPage.viewAddpopupHepatitisBTiterTextBox(), "Failed to identify the Add Lab Results popup HEPATITIS B TITER text box");
		Assert.assertTrue(currentLabsPage.viewAddpopupHepatitisBTiterGoal(), "Failed to identify the Add Lab Results popup HEPATITIS B TITER Goal");

		Assert.assertTrue(currentLabsPage.viewAddpopupTSATLabel(), "Failed to identify the Add Lab Results popup TSAT label");
		Assert.assertTrue(currentLabsPage.viewAddpopupTSATTextBox(), "Failed to identify the Add Lab Results popup TSAT text box");
		Assert.assertTrue(currentLabsPage.viewAddpopupTSATGoal(), "Failed to identify the Add Lab Results popup TSAT Goal");

		Assert.assertTrue(currentLabsPage.viewAddpopupWeightLabel(), "Failed to identify the Add Lab Results popup WEIGHT label");
		Assert.assertTrue(currentLabsPage.viewAddpopupWeightTextBox(), "Failed to identify the Add Lab Results popup WEIGHT text box");
		Assert.assertTrue(currentLabsPage.viewAddpopupWeightPlaceholder(), "Failed to identify the Add Lab Results popup WEIGHT placeholder");

		Assert.assertTrue(currentLabsPage.viewAddpopupCalciumXPhosphorousLabel(), "Failed to identify the Add Lab Results popup CALCIUM X PHOSPHOROUS label");
		Assert.assertTrue(currentLabsPage.viewAddpopupCalciumXPhosphorousTextBox(), "Failed to identify the Add Lab Results popup CALCIUM X PHOSPHOROUS text box");
		Assert.assertTrue(currentLabsPage.viewAddpopupCalciumXPhosphorousGoal(), "Failed to identify the Add Lab Results popup CALCIUM X PHOSPHOROUS Goal");

		Assert.assertTrue(currentLabsPage.viewAddpopupCreatinineLabel(), "Failed to identify the Add Lab Results popup CREATININE label");
		Assert.assertTrue(currentLabsPage.viewAddpopupCreatinineTextBox(), "Failed to identify the Add Lab Results popup CREATININE text box");
		Assert.assertTrue(currentLabsPage.viewAddpopupCreatinineGoal(), "Failed to identify the Add Lab Results popup CCREATININE Goal");

		Assert.assertTrue(currentLabsPage.viewAddpopupHGBA1CLabel(), "Failed to identify the Add Lab Results popup HGB A1C label");
		Assert.assertTrue(currentLabsPage.viewAddpopupHGBA1CTextBox(), "Failed to identify the Add Lab Results popup HGB A1C text box");
		Assert.assertTrue(currentLabsPage.viewAddpopupHGBA1CGoal(), "Failed to identify the Add Lab Results popup HGB A1C Goal");

		Assert.assertTrue(currentLabsPage.viewAddpopupHGBLabel(), "Failed to identify the Add Lab Results popup HGB label");
		Assert.assertTrue(currentLabsPage.viewAddpopupHGBTextBox(), "Failed to identify the Add Lab Results popup HGB text box");
		Assert.assertTrue(currentLabsPage.viewAddpopupHGBGoal(), "Failed to identify the Add Lab Results popup HGB Goal");

		Assert.assertTrue(currentLabsPage.viewAddpopupUrineAlbuminCreatinineRatioLabel(), "Failed to identify the Add Lab Results popup URINE ALBUMIN/CREATININE RATIO label");
		Assert.assertTrue(currentLabsPage.viewAddpopupUrineAlbuminCreatinineRatioTextBox(), "Failed to identify the Add Lab Results popup URINE ALBUMIN/CREATININE RATIO text box");
		Assert.assertTrue(currentLabsPage.viewAddpopupUrineAlbuminCreatinineRatioGoal(), "Failed to identify the Add Lab Results popup URINE ALBUMIN/CREATININE RATIO Goal");

		Assert.assertTrue(currentLabsPage.viewAddpopupCalciumLabel(), "Failed to identify the Add Lab Results popup CALCIUM label");
		Assert.assertTrue(currentLabsPage.viewAddpopupCalciumTextBox(), "Failed to identify the Add Lab Results popup CALCIUM text box");
		Assert.assertTrue(currentLabsPage.viewAddpopupCalciumGoal1(), "Failed to identify the Add Lab Results popup CALCIUM Goal 1");
		Assert.assertTrue(currentLabsPage.viewAddpopupCalciumGoal2(), "Failed to identify the Add Lab Results popup CALCIUM Goal 2");

		Assert.assertTrue(currentLabsPage.viewAddpopupURRLabel(), "Failed to identify the Add Lab Results popup URR label");
		Assert.assertTrue(currentLabsPage.viewAddpopupURRTextBox(), "Failed to identify the Add Lab Results popup URR text box");
		Assert.assertTrue(currentLabsPage.viewAddpopupURRGoal(), "Failed to identify the Add Lab Results popup URR Goal");

		Assert.assertTrue(currentLabsPage.viewAddpopupPTHLabel(), "Failed to identify the Add Lab Results popup PTH label");
		Assert.assertTrue(currentLabsPage.viewAddpopupPTHTextBox(), "Failed to identify the Add Lab Results popup PTH text box");
		Assert.assertTrue(currentLabsPage.viewAddpopupPTHGoal1(), "Failed to identify the Add Lab Results popup PTH Goal 1");
		Assert.assertTrue(currentLabsPage.viewAddpopupPTHGoal2(), "Failed to identify the Add Lab Results popup PTH Goal 2");
		Assert.assertTrue(currentLabsPage.viewAddpopupPTHGoal3(), "Failed to identify the Add Lab Results popup PTH Goal 3");
		Assert.assertTrue(currentLabsPage.viewAddpopupPTHGoal4(), "Failed to identify the Add Lab Results popup PTH Goal 4");
		Assert.assertTrue(currentLabsPage.viewAddpopupPTHGoal5(), "Failed to identify the Add Lab Results popup PTH Goal 5");

		Assert.assertTrue(currentLabsPage.viewAddpopupFerritinLabel(), "Failed to identify the Add Lab Results popup FERRITIN label");
		Assert.assertTrue(currentLabsPage.viewAddpopupFerritinTextBox(), "Failed to identify the Add Lab Results popup FERRITIN text box");
		Assert.assertTrue(currentLabsPage.viewAddpopupFerritinGoal(), "Failed to identify the Add Lab Results popup FERRITIN Goal");

		Assert.assertTrue(currentLabsPage.viewAddpopupBloodPressureLabel(), "Failed to identify the Add Lab Results popup BLOOD PRESURE label");
		Assert.assertTrue(currentLabsPage.viewAddpopupBloodPressureSystolicTextBox(), "Failed to identify the Add Lab Results popup BLOOD PRESURE SYSTOLIC text box");
		Assert.assertTrue(currentLabsPage.viewAddpopupBloodPressureDiastolicTextBox(), "Failed to identify the Add Lab Results popup BLOOD PRESURE DIASTOLIC text box");
		Assert.assertTrue(currentLabsPage.viewAddpopupBloodPressureSystolicGoal(), "Failed to identify the Add Lab Results popup BLOOD PRESURE SYSTOLIC Goal");
		Assert.assertTrue(currentLabsPage.viewAddpopupBloodPressureDiastolicGoal(), "Failed to identify the Add Lab Results popup BLOOD PRESURE DIASTOLIC Goal");

		currentLabsPage.clickAddPopupCancelButton();
	}

	@Test(priority = 4, dataProvider = "CapellaDataProvider")
	@Step("Verify Aading Labs with different scenarios")
	public void verify_AddingLabs(Map<String, String> map) throws WaitException, URLNavigationException, InterruptedException
	{
		appFunctions.selectPatientFromMyPatients(map.get("PatientName"));

		appFunctions.navigateToMenu("Patient Experience->Labs->Current Labs");

		currentLabsPage.clickAddLabButton();

		if (map.get("PatientType").equals("CKD"))
		{
			currentLabsPage.populateAddPopupAllCKD(map);
		} else
		{
			if (map.get("PatientType").equals("ESRD"))
			{
				currentLabsPage.populateAddPopupAllESRD(map);
			}
		}

		currentLabsPage.clickAddPopupSaveButton();

		if (map.get("PatientType").equals("CKD") && map.get("CheckValidation").equals("Y"))
		{
			Assert.assertTrue(currentLabsPage.viewAddpopupKTVErrorMessage(), "Failed to identify the Add Lab Results popup KT/V error message");
			Assert.assertTrue(currentLabsPage.viewAddpopupURRErrorMessage(), "Failed to identify the Add Lab Results popup URR error message");
			Assert.assertTrue(currentLabsPage.viewAddpopupBloodPressureErrorMessage(), "Failed to identify the Add Lab Results popup BLOOD PRESSURE error message");

			currentLabsPage.clearKTVTextBox();
			currentLabsPage.clearURRTextBox();
			currentLabsPage.clearBloodPressureSystolicTextBox();
			currentLabsPage.clearBloodPressureDiastolicTextBox();

			currentLabsPage.clickAddPopupSaveButton();
		}
		else
		{
			if (map.get("PatientType").equals("ESRD") && map.get("CheckValidation").equals("Y"))
			{
				Assert.assertTrue(currentLabsPage.viewAddpopupUrineAlbuminCreatinineRatioErrorMessage(),
				        "Failed to identify the Add Lab Results popup Urine Albumin Creatinine Ratio error message");
				Assert.assertTrue(currentLabsPage.viewAddpopupBloodPressureErrorMessage(), "Failed to identify the Add Lab Results popup BLOOD PRESSURE error message");

				currentLabsPage.clearUrineAlbuminCreatinineRatioTextBox();
				currentLabsPage.clearBloodPressureSystolicTextBox();
				currentLabsPage.clearBloodPressureDiastolicTextBox();

				currentLabsPage.clickAddPopupSaveButton();
			}
		}

		String drawDateGregorian = appFunctions.adjustCurrentDateBy(map.get("APPLYTHISDATETOALLVALUES"), "MM/dd/YYYY");

		if (map.get("HEIGHT") != null)
		{
			Assert.assertTrue(currentLabsPage.viewHeightLabelValue(map.get("HEIGHT")), "Failed to identify the HEIGHT label/value");
			Assert.assertTrue(currentLabsPage.viewHeightDrawDate(drawDateGregorian), "Failed to identify the HEIGHT draw date");
			Assert.assertTrue(currentLabsPage.viewHeightSource(), "Failed to identify the HEIGHT Source");
			Assert.assertTrue(currentLabsPage.viewHeightColor("T"), "Failed to identify HEIGHT as the correct color");
			Assert.assertTrue(currentLabsPage.viewGraphPopupHeightLabelValue(map.get("HEIGHT")), "Failed to identify the graph popup HEIGHT label/value");
			Assert.assertTrue(currentLabsPage.viewHeightColor("P"), "Failed to identify graph popup HEIGHT as the correct color");
			Assert.assertTrue(currentLabsPage.viewGraphPopupHeightPoint(map.get("HEIGHT")), "Failed to identify the graph popup HEIGHT point");
			Assert.assertTrue(currentLabsPage.viewGraphPopupHeightDrawDate(drawDateGregorian), "Failed to identify the graph popup HEIGHT draw date");

			currentLabsPage.clickAddLabButton();
		}

		if (map.get("WEIGHT") != null)
		{
			Assert.assertTrue(currentLabsPage.viewWeightLabelValue(map.get("WEIGHT")), "Failed to identify the WEIGHT label/value");
			Assert.assertTrue(currentLabsPage.viewWeightDrawDate(drawDateGregorian), "Failed to identify the WEIGHT draw date");
			Assert.assertTrue(currentLabsPage.viewWeightSource(), "Failed to identify the WEIGHT Source");
			Assert.assertTrue(currentLabsPage.viewWeightColor("T"), "Failed to identify WEIGHT as the correct color");
			Assert.assertTrue(currentLabsPage.viewGraphPopupWeightLabelValue(map.get("WEIGHT")), "Failed to identify the graph popup WEIGHT label/value");
			Assert.assertTrue(currentLabsPage.viewWeightColor("P"), "Failed to identify graph popup WEIGHT as the correct color");
			Assert.assertTrue(currentLabsPage.viewGraphPopupWeightPoint(map.get("WEIGHT")), "Failed to identify the graph popup WEIGHT point");
			Assert.assertTrue(currentLabsPage.viewGraphPopupWeightDrawDate(drawDateGregorian), "Failed to identify the graph popup WEIGHT draw date");

			currentLabsPage.clickAddLabButton();
		}

		if (map.get("TARGETDRYWEIGHT") != null)
		{
			Assert.assertTrue(currentLabsPage.viewTargetDryWeightLabelValue(map.get("TARGETDRYWEIGHT")), "Failed to identify the TARGET DRY WEIGHT label/value");
			Assert.assertTrue(currentLabsPage.viewTargetDryWeightDrawDate(drawDateGregorian), "Failed to identify the TARGET DRY WEIGHT draw date");
			Assert.assertTrue(currentLabsPage.viewTargetDryWeightSource(), "Failed to identify the TARGET DRY WEIGHT Source");
			Assert.assertTrue(currentLabsPage.viewTargetDryWeightColor("T"), "Failed to identify TARGET DRY WEIGHT as the correct color");
			Assert.assertTrue(currentLabsPage.viewGraphPopupTargetDryWeightLabelValue(map.get("TARGETDRYWEIGHT")), "Failed to identify the graph popup TARGETDRYWEIGHT label/value");
			Assert.assertTrue(currentLabsPage.viewTargetDryWeightColor("P"), "Failed to identify graph popup TARGET DRY WEIGHT as the correct color");
			Assert.assertTrue(currentLabsPage.viewGraphPopupTargetDryWeightPoint(map.get("TARGETDRYWEIGHT")), "Failed to identify the graph popup TARGET DRY WEIGHT point");
			Assert.assertTrue(currentLabsPage.viewGraphPopupTargetDryWeightDrawDate(drawDateGregorian), "Failed to identify the graph popup TARGET DRY WEIGHT draw date");

			currentLabsPage.clickAddLabButton();
		}

		if (map.get("CALCIUMXPHOSPHOROUS") != null)
		{
			Assert.assertTrue(currentLabsPage.viewCalciumXPhosphorousLabelValue(map.get("CALCIUMXPHOSPHOROUS")), "Failed to identify the CALCIUM X PHOSPHOROUS label/value");
			Assert.assertTrue(currentLabsPage.viewCalciumXPhosphorousGoal(), "Failed to identify the CALCIUM X PHOSPHOROUS Goal");
			Assert.assertTrue(currentLabsPage.viewCalciumXPhosphorousDrawDate(drawDateGregorian), "Failed to identify the CALCIUM X PHOSPHOROUS draw date");
			Assert.assertTrue(currentLabsPage.viewCalciumXPhosphorousSource(), "Failed to identify the CALCIUM X PHOSPHOROUS Source");
			Assert.assertTrue(currentLabsPage.viewCalciumXPhosphorousColor(Integer.parseInt(map.get("CALCIUMXPHOSPHOROUS")), "T"),
			        "Failed to identify CALCIUM X PHOSPHOROUS as the correct color");
			Assert.assertTrue(currentLabsPage.viewGraphPopupCalciumXPhosphorousLabelValue(map.get("CALCIUMXPHOSPHOROUS")),
			        "Failed to identify the graph popup CALCIUM X PHOSPHOROUS label/value");
			Assert.assertTrue(currentLabsPage.viewGraphPopupCalciumXPhosphorousGoal(), "Failed to identify the graph popup CALCIUM X PHOSPHOROUS Goal");
			Assert.assertTrue(currentLabsPage.viewCalciumXPhosphorousColor(Integer.parseInt(map.get("CALCIUMXPHOSPHOROUS")), "P"),
			        "Failed to identify graph popup CALCIUM X PHOSPHOROUS as the correct color");
			Assert.assertTrue(currentLabsPage.viewGraphPopupCalciumXPhosphorousPoint(map.get("CALCIUMXPHOSPHOROUS")), "Failed to identify the graph popup CALCIUM X PHOSPHOROUS point");
			Assert.assertTrue(currentLabsPage.viewGraphPopupCalciumXPhosphorousDrawDate(drawDateGregorian), "Failed to identify the graph popup CALCIUM X PHOSPHOROUS draw date");

			currentLabsPage.clickAddLabButton();
		}

		if (map.get("PHOSPHOROUS") != null)
		{
			Assert.assertTrue(currentLabsPage.viewPhosphorousLabelValue(map.get("PHOSPHOROUS")), "Failed to identify the PHOSPHOROUS label/value");
			Assert.assertTrue(currentLabsPage.viewPhosphorousGoal(), "Failed to identify the PHOSPHOROUS Goal");
			Assert.assertTrue(currentLabsPage.viewPhosphorousDrawDate(drawDateGregorian), "Failed to identify the PHOSPHOROUS draw date");
			Assert.assertTrue(currentLabsPage.viewPhosphorousSource(), "Failed to identify the PHOSPHOROUS Source");
			Assert.assertTrue(currentLabsPage.viewPhosphorousColor(Double.parseDouble(map.get("PHOSPHOROUS")), "T"), "Failed to identify PHOSPHOROUS as the correct color");
			Assert.assertTrue(currentLabsPage.viewGraphPopupPhosphorousLabelValue(map.get("PHOSPHOROUS")), "Failed to identify the graph popup PHOSPHOROUS label/value");
			Assert.assertTrue(currentLabsPage.viewGraphPopupPhosphorousGoal(), "Failed to identify the graph popup PHOSPHOROUS Goal");
			Assert.assertTrue(currentLabsPage.viewPhosphorousColor(Double.parseDouble(map.get("PHOSPHOROUS")), "P"), "Failed to identify graph popup PHOSPHOROUS as the correct color");
			Assert.assertTrue(currentLabsPage.viewGraphPopupPhosphorousPoint(map.get("PHOSPHOROUS")), "Failed to identify the graph popup PHOSPHOROUS point");
			Assert.assertTrue(currentLabsPage.viewGraphPopupPhosphorousDrawDate(drawDateGregorian), "Failed to identify the graph popup PHOSPHOROUS draw date");

			currentLabsPage.clickAddLabButton();
		}

		if (map.get("CREATININE") != null)
		{
			Assert.assertTrue(currentLabsPage.viewCreatinineLabelValue(map.get("CREATININE")), "Failed to identify the CREATININE label/value");
			Assert.assertTrue(currentLabsPage.viewCreatinineGoal(), "Failed to identify the CREATININE Goal");
			Assert.assertTrue(currentLabsPage.viewCreatinineDrawDate(drawDateGregorian), "Failed to identify the CREATININE draw date");
			Assert.assertTrue(currentLabsPage.viewCreatinineSource(), "Failed to identify the CREATININE Source");
			Assert.assertTrue(currentLabsPage.viewCreatinineColor(Double.parseDouble(map.get("CREATININE")), "T"), "Failed to identify CREATININE as the correct color");
			Assert.assertTrue(currentLabsPage.viewGraphPopupCreatinineLabelValue(map.get("CREATININE")), "Failed to identify the graph popup CREATININE label/value");
			Assert.assertTrue(currentLabsPage.viewGraphPopupCreatinineGoal(), "Failed to identify the graph popup CREATININE Goal");
			Assert.assertTrue(currentLabsPage.viewCreatinineColor(Double.parseDouble(map.get("CREATININE")), "P"), "Failed to identify graph popup CREATININE as the correct color");
			Assert.assertTrue(currentLabsPage.viewGraphPopupCreatininePoint(map.get("CREATININE")), "Failed to identify the graph popup CREATININE point");
			Assert.assertTrue(currentLabsPage.viewGraphPopupCreatinineDrawDate(drawDateGregorian), "Failed to identify the graph popup CREATININE draw date");

			currentLabsPage.clickAddLabButton();
		}

		if (map.get("GFR") != null)
		{
			Assert.assertTrue(currentLabsPage.viewGFRLabelValue(map.get("GFR")), "Failed to identify the GFR label/value");
			Assert.assertTrue(currentLabsPage.viewGFRGoal(), "Failed to identify the GFR Goal");
			Assert.assertTrue(currentLabsPage.viewGFRDrawDate(drawDateGregorian), "Failed to identify the GFR draw date");
			Assert.assertTrue(currentLabsPage.viewGFRSource(), "Failed to identify the GFR Source");
			Assert.assertTrue(currentLabsPage.viewGFRColor(Integer.parseInt(map.get("GFR")), "T"), "Failed to identify GFR as the correct color");
			Assert.assertTrue(currentLabsPage.viewGraphPopupGFRLabelValue(map.get("GFR")), "Failed to identify the graph popup GFR label/value");
			Assert.assertTrue(currentLabsPage.viewGraphPopupGFRGoal(), "Failed to identify the graph popup GFR Goal");
			Assert.assertTrue(currentLabsPage.viewGFRColor(Integer.parseInt(map.get("GFR")), "P"), "Failed to identify graph popup GFR as the correct color");
			Assert.assertTrue(currentLabsPage.viewGraphPopupGFRPoint(map.get("GFR")), "Failed to identify the graph popup GFR point");
			Assert.assertTrue(currentLabsPage.viewGraphPopupGFRDrawDate(drawDateGregorian), "Failed to identify the graph popup GFR draw date");

			currentLabsPage.clickAddLabButton();
		}

		if (map.get("HGBA1C") != null)
		{
			Assert.assertTrue(currentLabsPage.viewHGBA1CLabelValue(map.get("HGBA1C")), "Failed to identify the HGBA1C label/value");
			Assert.assertTrue(currentLabsPage.viewHGBA1CGoal(), "Failed to identify the HGBA1C Goal");
			Assert.assertTrue(currentLabsPage.viewHGBA1CDrawDate(drawDateGregorian), "Failed to identify the HGBA1C draw date");
			Assert.assertTrue(currentLabsPage.viewHGBA1CSource(), "Failed to identify the HGBA1C Source");
			Assert.assertTrue(currentLabsPage.viewHGBA1CColor(Integer.parseInt(map.get("HGBA1C")), "T"), "Failed to identify HGBA1C as the correct color");
			Assert.assertTrue(currentLabsPage.viewGraphPopupHGBA1CLabelValue(map.get("HGBA1C")), "Failed to identify the graph popup HGBA1C label/value");
			Assert.assertTrue(currentLabsPage.viewGraphPopupHGBA1CGoal(), "Failed to identify the graph popup HGBA1C Goal");
			Assert.assertTrue(currentLabsPage.viewHGBA1CColor(Integer.parseInt(map.get("HGBA1C")), "P"), "Failed to identify graph popup HGBA1C as the correct color");
			Assert.assertTrue(currentLabsPage.viewGraphPopupHGBA1CPoint(map.get("HGBA1C")), "Failed to identify the graph popup HGBA1C point");
			Assert.assertTrue(currentLabsPage.viewGraphPopupHGBA1CDrawDate(drawDateGregorian), "Failed to identify the graph popup HGBA1C draw date");

			currentLabsPage.clickAddLabButton();
		}

		if (map.get("LDL") != null)
		{
			Assert.assertTrue(currentLabsPage.viewLDLLabelValue(map.get("LDL")), "Failed to identify the LDL label/value");
			Assert.assertTrue(currentLabsPage.viewLDLGoal(), "Failed to identify the LDL Goal");
			Assert.assertTrue(currentLabsPage.viewLDLDrawDate(drawDateGregorian), "Failed to identify the LDL draw date");
			Assert.assertTrue(currentLabsPage.viewLDLSource(), "Failed to identify the LDL Source");
			Assert.assertTrue(currentLabsPage.viewLDLColor(Integer.parseInt(map.get("LDL")), "T"), "Failed to identify LDL as the correct color");
			Assert.assertTrue(currentLabsPage.viewGraphPopupLDLLabelValue(map.get("LDL")), "Failed to identify the graph popup LDL label/value");
			Assert.assertTrue(currentLabsPage.viewGraphPopupLDLGoal(), "Failed to identify the graph popup LDL Goal");
			Assert.assertTrue(currentLabsPage.viewLDLColor(Integer.parseInt(map.get("LDL")), "P"), "Failed to identify graph popup LDL as the correct color");
			Assert.assertTrue(currentLabsPage.viewGraphPopupLDLPoint(map.get("LDL")), "Failed to identify the graph popup LDL point");
			Assert.assertTrue(currentLabsPage.viewGraphPopupLDLDrawDate(drawDateGregorian), "Failed to identify the graph popup LDL draw date");

			currentLabsPage.clickAddLabButton();
		}

		if (map.get("HGB") != null)
		{
			Assert.assertTrue(currentLabsPage.viewHGBLabelValue(map.get("HGB")), "Failed to identify the HGB label/value");
			Assert.assertTrue(currentLabsPage.viewHGBGoal(), "Failed to identify the HGB Goal");
			Assert.assertTrue(currentLabsPage.viewHGBDrawDate(drawDateGregorian), "Failed to identify the HGB draw date");
			Assert.assertTrue(currentLabsPage.viewHGBSource(), "Failed to identify the HGB Source");
			Assert.assertTrue(currentLabsPage.viewHGBColor(Integer.parseInt(map.get("HGB")), "T"), "Failed to identify HGB as the correct color");
			Assert.assertTrue(currentLabsPage.viewGraphPopupHGBLabelValue(map.get("HGB")), "Failed to identify the graph popup HGB label/value");
			Assert.assertTrue(currentLabsPage.viewGraphPopupHGBGoal(), "Failed to identify the graph popup HGB Goal");
			Assert.assertTrue(currentLabsPage.viewHGBColor(Integer.parseInt(map.get("HGB")), "P"), "Failed to identify graph popup HGB as the correct color");
			Assert.assertTrue(currentLabsPage.viewGraphPopupHGBPoint(map.get("HGB")), "Failed to identify the graph popup HGB point");
			Assert.assertTrue(currentLabsPage.viewGraphPopupHGBDrawDate(drawDateGregorian), "Failed to identify the graph popup HGB draw date");

			currentLabsPage.clickAddLabButton();
		}

		if (map.get("ALBUMIN") != null)
		{
			Assert.assertTrue(currentLabsPage.viewAlbuminLabelValue(map.get("ALBUMIN")), "Failed to identify the ALBUMIN label/value");
			Assert.assertTrue(currentLabsPage.viewAlbuminGoal(), "Failed to identify the ALBUMIN Goal");
			Assert.assertTrue(currentLabsPage.viewAlbuminDrawDate(drawDateGregorian), "Failed to identify the ALBUMIN draw date");
			Assert.assertTrue(currentLabsPage.viewAlbuminSource(), "Failed to identify the ALBUMIN Source");
			Assert.assertTrue(currentLabsPage.viewAlbuminColor(Integer.parseInt(map.get("ALBUMIN")), "T"), "Failed to identify ALBUMIN as the correct color");
			Assert.assertTrue(currentLabsPage.viewGraphPopupAlbuminLabelValue(map.get("ALBUMIN")), "Failed to identify the graph popup ALBUMIN label/value");
			Assert.assertTrue(currentLabsPage.viewGraphPopupAlbuminGoal(), "Failed to identify the graph popup ALBUMIN Goal");
			Assert.assertTrue(currentLabsPage.viewAlbuminColor(Integer.parseInt(map.get("ALBUMIN")), "P"), "Failed to identify graph popup ALBUMIN as the correct color");
			Assert.assertTrue(currentLabsPage.viewGraphPopupAlbuminPoint(map.get("ALBUMIN")), "Failed to identify the graph popup ALBUMIN point");
			Assert.assertTrue(currentLabsPage.viewGraphPopupAlbuminDrawDate(drawDateGregorian), "Failed to identify the graph popup ALBUMIN draw date");

			currentLabsPage.clickAddLabButton();
		}

		if (map.get("URINEALBUMINCREATININERATIO") != null && map.get("PatientType").equals("CKD"))
		{
			Assert.assertTrue(currentLabsPage.viewUrineAlbuminCreatinineRatioLabelValue(map.get("URINEALBUMINCREATININERATIO")),
			        "Failed to identify the URINE ALBUMIN CREATININE RATIO label/value");
			Assert.assertTrue(currentLabsPage.viewUrineAlbuminCreatinineRatioGoal(), "Failed to identify the URINE ALBUMIN/CREATININE RATIO Goal");
			Assert.assertTrue(currentLabsPage.viewUrineAlbuminCreatinineRatioDrawDate(drawDateGregorian), "Failed to identify the URINE ALBUMIN/CREATININE RATIO draw date");
			Assert.assertTrue(currentLabsPage.viewUrineAlbuminCreatinineRatioSource(), "Failed to identify the URINE ALBUMIN/CREATININE RATIO Source");
			Assert.assertTrue(currentLabsPage.viewUrineAlbuminCreatinineRatioColor(Integer.parseInt(map.get("URINEALBUMINCREATININERATIO")), "T"),
			        "Failed to identify URINE ALBUMIN/CREATININE RATIO as the correct color");
			Assert.assertTrue(currentLabsPage.viewGraphPopupUrineAlbuminCreatinineRatioLabelValue(map.get("URINEALBUMINCREATININERATIO")),
			        "Failed to identify the graph popup URINE ALBUMIN/CREATININE RATIO label/value");
			Assert.assertTrue(currentLabsPage.viewGraphPopupUrineAlbuminCreatinineRatioGoal(), "Failed to identify the graph popup URINE ALBUMIN/CREATININE RATIO Goal");
			Assert.assertTrue(currentLabsPage.viewUrineAlbuminCreatinineRatioColor(Integer.parseInt(map.get("URINEALBUMINCREATININERATIO")), "P"),
			        "Failed to identify graph popup URINE ALBUMIN/CREATININE RATIO as the correct color");
			Assert.assertTrue(currentLabsPage.viewGraphPopupUrineAlbuminCreatinineRatioPoint(map.get("URINEALBUMINCREATININERATIO")),
			        "Failed to identify the graph popup URINE ALBUMIN/CREATININE RATIO point");
			Assert.assertTrue(currentLabsPage.viewGraphPopupUrineAlbuminCreatinineRatioDrawDate(drawDateGregorian),
			        "Failed to identify the graph popup URINE ALBUMIN/CREATININE RATIO draw date");

			currentLabsPage.clickAddLabButton();
		}

		if (map.get("DIPSTICKFORPROTEIN") != null)
		{
			Assert.assertTrue(currentLabsPage.viewDipstickForProteinLabelValue(map.get("DIPSTICKFORPROTEIN")), "Failed to identify the DIPSTICK FOR PROTEIN label/value");
			Assert.assertTrue(currentLabsPage.viewDipstickForProteinGoal(), "Failed to identify the DIPSTICK FOR PROTEIN Goal");
			Assert.assertTrue(currentLabsPage.viewDipstickForProteinDrawDate(drawDateGregorian), "Failed to identify the DIPSTICK FOR PROTEIN draw date");
			Assert.assertTrue(currentLabsPage.viewDipstickForProteinSource(), "Failed to identify the URINE DIPSTICK FOR PROTEIN Source");
			Assert.assertTrue(currentLabsPage.viewDipstickForProteinColor(map.get("DIPSTICKFORPROTEIN")), "Failed to identify DIPSTICK FOR PROTEIN as the correct color");
		}

		if (map.get("CO2LEVEL") != null)
		{
			Assert.assertTrue(currentLabsPage.viewCO2LevelLabelValue(map.get("CO2LEVEL")), "Failed to identify the CO2 LEVEL label/value");
			Assert.assertTrue(currentLabsPage.viewCO2LevelGoal(), "Failed to identify the CO2 LEVEL Goal");
			Assert.assertTrue(currentLabsPage.viewCO2LevelDrawDate(drawDateGregorian), "Failed to identify the CO2 LEVEL draw date");
			Assert.assertTrue(currentLabsPage.viewCO2LevelSource(), "Failed to identify the CO2 LEVEL Source");
			Assert.assertTrue(currentLabsPage.viewCO2LevelColor(Integer.parseInt(map.get("CO2LEVEL")), "T"), "Failed to identify CO2LEVEL as the correct color");
			Assert.assertTrue(currentLabsPage.viewGraphPopupCO2LevelLabelValue(map.get("CO2LEVEL")), "Failed to identify the graph popup CO2 LEVEL label/value");
			Assert.assertTrue(currentLabsPage.viewGraphPopupCO2LevelGoal(), "Failed to identify the graph popup CO2 LEVEL Goal");
			Assert.assertTrue(currentLabsPage.viewCO2LevelColor(Integer.parseInt(map.get("CO2LEVEL")), "P"), "Failed to identify graph popup CO2LEVEL as the correct color");
			Assert.assertTrue(currentLabsPage.viewGraphPopupCO2LevelPoint(map.get("CO2LEVEL")), "Failed to identify the graph popup CO2 LEVEL point");
			Assert.assertTrue(currentLabsPage.viewGraphPopupCO2LevelDrawDate(drawDateGregorian), "Failed to identify the graph popup CO2 LEVEL draw date");

			currentLabsPage.clickAddLabButton();
		}

		if (map.get("CALCIUM") != null)
		{
			Assert.assertTrue(currentLabsPage.viewCalciumLabelValue(map.get("CALCIUM")), "Failed to identify the CALCIUM label/value");
			Assert.assertTrue(currentLabsPage.viewCalciumGoal1(), "Failed to identify the CALCIUM Goal1");
			Assert.assertTrue(currentLabsPage.viewCalciumGoal2(), "Failed to identify the CALCIUM Goal2");
			Assert.assertTrue(currentLabsPage.viewCalciumDrawDate(drawDateGregorian), "Failed to identify the CALCIUM draw date");
			Assert.assertTrue(currentLabsPage.viewCalciumSource(), "Failed to identify the CALCIUM Source");
			Assert.assertTrue(currentLabsPage.viewCalciumColor(Double.parseDouble(map.get("CALCIUM")), map.get("PatientType"), "T"), "Failed to identify CALCIUM as the correct color");
			Assert.assertTrue(currentLabsPage.viewGraphPopupCalciumLabelValue(map.get("CALCIUM")), "Failed to identify the graph popup CALCIUM label/value");
			Assert.assertTrue(currentLabsPage.viewGraphPopupCalciumGoal(), "Failed to identify the graph popup CALCIUM Goal");
			Assert.assertTrue(currentLabsPage.viewCalciumColor(Double.parseDouble(map.get("CALCIUM")), map.get("PatientType"), "P"),
			        "Failed to identify graph popup CALCIUM as the correct color");
			Assert.assertTrue(currentLabsPage.viewGraphPopupCalciumPoint(map.get("CALCIUM")), "Failed to identify the graph popup CALCIUM point");
			Assert.assertTrue(currentLabsPage.viewGraphPopupCalciumDrawDate(drawDateGregorian), "Failed to identify the graph popup CALCIUM draw date");

			currentLabsPage.clickAddLabButton();
		}

		if (map.get("KTV") != null && map.get("PatientType").equals("ESRD"))
		{
			Assert.assertTrue(currentLabsPage.viewKTVLabelValue(map.get("KTV")), "Failed to identify the KT/V label/value");
			// Assert.assertTrue(currentLabsPage.viewKTVGoal(), "Failed to identify the KT/V Goal");
			Assert.assertTrue(currentLabsPage.viewKTVDrawDate(drawDateGregorian), "Failed to identify the KT/V draw date");
			Assert.assertTrue(currentLabsPage.viewKTVSource(), "Failed to identify the KT/V Source");
			Assert.assertTrue(currentLabsPage.viewKTVColor(Double.parseDouble(map.get("KTV")), "T"), "Failed to identify KTV as the correct color");
			Assert.assertTrue(currentLabsPage.viewGraphPopupKTVLabelValue(map.get("KTV")), "Failed to identify the graph popup KTV label/value");
			// Assert.assertTrue(currentLabsPage.viewGraphPopupKTVGoal(), "Failed to identify the graph popup KTV Goal");
			Assert.assertTrue(currentLabsPage.viewKTVColor(Double.parseDouble(map.get("KTV")), "P"), "Failed to identify graph popup KTV as the correct color");
			Assert.assertTrue(currentLabsPage.viewGraphPopupKTVPoint(map.get("KTV")), "Failed to identify the graph popup KTV point");
			Assert.assertTrue(currentLabsPage.viewGraphPopupKTVDrawDate(drawDateGregorian), "Failed to identify the graph popup KTV draw date");

			currentLabsPage.clickAddLabButton();
		}

		if (map.get("URR") != null && map.get("PatientType").equals("ESRD"))
		{
			Assert.assertTrue(currentLabsPage.viewURRLabelValue(map.get("URR")), "Failed to identify the URR label/value");
			Assert.assertTrue(currentLabsPage.viewURRGoal(), "Failed to identify the URR Goal");
			Assert.assertTrue(currentLabsPage.viewURRDrawDate(drawDateGregorian), "Failed to identify the URR draw date");
			Assert.assertTrue(currentLabsPage.viewURRSource(), "Failed to identify the URR Source");
			Assert.assertTrue(currentLabsPage.viewURRColor(Integer.parseInt(map.get("URR")), "T"), "Failed to identify URR as the correct color");
			Assert.assertTrue(currentLabsPage.viewGraphPopupURRLabelValue(map.get("URR")), "Failed to identify the graph popup URR label/value");
			Assert.assertTrue(currentLabsPage.viewGraphPopupURRGoal(), "Failed to identify the graph popup URR Goal");
			Assert.assertTrue(currentLabsPage.viewURRColor(Integer.parseInt(map.get("URR")), "P"), "Failed to identify graph popup URR as the correct color");
			Assert.assertTrue(currentLabsPage.viewGraphPopupURRPoint(map.get("URR")), "Failed to identify the graph popup URR point");
			Assert.assertTrue(currentLabsPage.viewGraphPopupURRDrawDate(drawDateGregorian), "Failed to identify the graph popup URR draw date");

			currentLabsPage.clickAddLabButton();
		}

		if (map.get("POTASIUM") != null)
		{
			Assert.assertTrue(currentLabsPage.viewPotassiumLabelValue(map.get("POTASIUM")), "Failed to identify the POTASIUM label/value");
			Assert.assertTrue(currentLabsPage.viewPotassiumGoal(), "Failed to identify the POTASIUM Goal");
			Assert.assertTrue(currentLabsPage.viewPotassiumDrawDate(drawDateGregorian), "Failed to identify the POTASIUM draw date");
			Assert.assertTrue(currentLabsPage.viewPotassiumSource(), "Failed to identify the POTASIUM Source");
			Assert.assertTrue(currentLabsPage.viewPotassiumColor(Double.parseDouble(map.get("POTASIUM")), "T"), "Failed to identify POTASIUM as the correct color");
			Assert.assertTrue(currentLabsPage.viewGraphPopupPotassiumLabelValue(map.get("POTASIUM")), "Failed to identify the graph popup POTASIUM label/value");
			Assert.assertTrue(currentLabsPage.viewGraphPopupPotassiumGoal(), "Failed to identify the graph popup POTASIUM Goal");
			Assert.assertTrue(currentLabsPage.viewPotassiumColor(Double.parseDouble(map.get("POTASIUM")), "P"), "Failed to identify graph popup POTASIUM as the correct color");
			Assert.assertTrue(currentLabsPage.viewGraphPopupPotassiumPoint(map.get("POTASIUM")), "Failed to identify the graph popup POTASIUM point");
			Assert.assertTrue(currentLabsPage.viewGraphPopupPotassiumDrawDate(drawDateGregorian), "Failed to identify the graph popup POTASIUM draw date");

			currentLabsPage.clickAddLabButton();
		}

		if (map.get("PTH") != null)
		{
			Assert.assertTrue(currentLabsPage.viewPTHLabelValue(map.get("PTH")), "Failed to identify the PTH label/value");
			Assert.assertTrue(currentLabsPage.viewPTHGoal1(), "Failed to identify the PTH Goal1");
			Assert.assertTrue(currentLabsPage.viewPTHGoal2(), "Failed to identify the PTH Goal2");
			Assert.assertTrue(currentLabsPage.viewPTHGoal3(), "Failed to identify the PTH Goal3");
			Assert.assertTrue(currentLabsPage.viewPTHGoal4(), "Failed to identify the PTH Goal4");
			Assert.assertTrue(currentLabsPage.viewPTHGoal5(), "Failed to identify the PTH Goal5");
			Assert.assertTrue(currentLabsPage.viewPTHDrawDate(drawDateGregorian), "Failed to identify the PTH draw date");
			Assert.assertTrue(currentLabsPage.viewPTHSource(), "Failed to identify the PTH Source");
			Assert.assertTrue(currentLabsPage.viewPTHColor(Integer.parseInt(map.get("PTH")), map.get("PatientType"), map.get("CKDStage"), "T"),
			        "Failed to identify PTH as the correct color");
			Assert.assertTrue(currentLabsPage.viewGraphPopupPTHLabelValue(map.get("PTH")), "Failed to identify the graph popup PTH label/value");
			Assert.assertTrue(currentLabsPage.viewGraphPopupPTHGoal(), "Failed to identify the graph popup PTH Goal");
			Assert.assertTrue(currentLabsPage.viewPTHColor(Integer.parseInt(map.get("PTH")), map.get("PatientType"), map.get("CKDStage"), "P"),
			        "Failed to identify graph popup PTH as the correct color");
			Assert.assertTrue(currentLabsPage.viewGraphPopupPTHPoint(map.get("PTH")), "Failed to identify the graph popup PTH point");
			Assert.assertTrue(currentLabsPage.viewGraphPopupPTHDrawDate(drawDateGregorian), "Failed to identify the graph popup PTH draw date");

			currentLabsPage.clickAddLabButton();
		}

		if (map.get("HEPATITISBTITER") != null)
		{
			Assert.assertTrue(currentLabsPage.viewHepatitisBTiterLabelValue(map.get("HEPATITISBTITER")), "Failed to identify the HEPATITIS B TITER label/value");
			Assert.assertTrue(currentLabsPage.viewHepatitisBTiterGoal(), "Failed to identify the HEPATITIS B TITER Goal");
			Assert.assertTrue(currentLabsPage.viewHepatitisBTiterDrawDate(drawDateGregorian), "Failed to identify the HEPATITIS B TITER draw date");
			Assert.assertTrue(currentLabsPage.viewHepatitisBTiterSource(), "Failed to identify the HEPATITIS B TITER Source");
			Assert.assertTrue(currentLabsPage.viewHepatitisBTiterColor(Integer.parseInt(map.get("HEPATITISBTITER")), "T"), "Failed to identify HEPATITIS B TITER as the correct color");
			Assert.assertTrue(currentLabsPage.viewGraphPopupHepatitisBTiterLabelValue(map.get("HEPATITISBTITER")), "Failed to identify the graph popup HEPATITIS B TITER label/value");
			Assert.assertTrue(currentLabsPage.viewGraphPopupHepatitisBTiterGoal(), "Failed to identify the graph popup HEPATITIS B TITER Goal");
			Assert.assertTrue(currentLabsPage.viewHepatitisBTiterColor(Integer.parseInt(map.get("HEPATITISBTITER")), "P"),
			        "Failed to identify graph popup HEPATITIS B TITER as the correct color");
			Assert.assertTrue(currentLabsPage.viewGraphPopupHepatitisBTiterPoint(map.get("HEPATITISBTITER")), "Failed to identify the graph popup HEPATITIS B TITER point");
			Assert.assertTrue(currentLabsPage.viewGraphPopupHepatitisBTiterDrawDate(drawDateGregorian), "Failed to identify the graph popup HEPATITIS B TITER draw date");

			currentLabsPage.clickAddLabButton();
		}

		if (map.get("FERRITIN") != null)
		{
			Assert.assertTrue(currentLabsPage.viewFerritinLabelValue(map.get("FERRITIN")), "Failed to identify the FERRITIN label/value");
			Assert.assertTrue(currentLabsPage.viewFerritinGoal(), "Failed to identify the FERRITIN Goal");
			Assert.assertTrue(currentLabsPage.viewFerritinDrawDate(drawDateGregorian), "Failed to identify the FERRITIN draw date");
			Assert.assertTrue(currentLabsPage.viewFerritinSource(), "Failed to identify the FERRITIN Source");
			Assert.assertTrue(currentLabsPage.viewFerritinColor(Integer.parseInt(map.get("FERRITIN")), "T"), "Failed to identify FERRITIN as the correct color");
			Assert.assertTrue(currentLabsPage.viewGraphPopupFerritinLabelValue(map.get("FERRITIN")), "Failed to identify the graph popup FERRITIN label/value");
			Assert.assertTrue(currentLabsPage.viewGraphPopupFerritinGoal(), "Failed to identify the graph popup FERRITIN Goal");
			Assert.assertTrue(currentLabsPage.viewFerritinColor(Integer.parseInt(map.get("FERRITIN")), "P"), "Failed to identify graph popup FERRITIN as the correct color");
			Assert.assertTrue(currentLabsPage.viewGraphPopupFerritinPoint(map.get("FERRITIN")), "Failed to identify the graph popup FERRITIN point");
			Assert.assertTrue(currentLabsPage.viewGraphPopupFerritinDrawDate(drawDateGregorian), "Failed to identify the graph popup FERRITIN draw date");

			currentLabsPage.clickAddLabButton();
		}

		if (map.get("TSAT") != null)
		{
			Assert.assertTrue(currentLabsPage.viewTSATLabelValue(map.get("TSAT")), "Failed to identify the TSAT label/value");
			Assert.assertTrue(currentLabsPage.viewTSATGoal(), "Failed to identify the TSAT Goal");
			Assert.assertTrue(currentLabsPage.viewTSATDrawDate(drawDateGregorian), "Failed to identify the TSAT draw date");
			Assert.assertTrue(currentLabsPage.viewTSATSource(), "Failed to identify the TSAT Source");
			Assert.assertTrue(currentLabsPage.viewTSATColor(Integer.parseInt(map.get("TSAT")), "T"), "Failed to identify TSAT as the correct color");
			Assert.assertTrue(currentLabsPage.viewGraphPopupTSATLabelValue(map.get("TSAT")), "Failed to identify the graph popup TSAT label/value");
			Assert.assertTrue(currentLabsPage.viewGraphPopupTSATGoal(), "Failed to identify the graph popup TSAT Goal");
			Assert.assertTrue(currentLabsPage.viewTSATColor(Integer.parseInt(map.get("TSAT")), "P"), "Failed to identify graph popup TSAT as the correct color");
			Assert.assertTrue(currentLabsPage.viewGraphPopupTSATPoint(map.get("TSAT")), "Failed to identify the graph popup TSAT point");
			Assert.assertTrue(currentLabsPage.viewGraphPopupTSATDrawDate(drawDateGregorian), "Failed to identify the graph popup TSAT draw date");

			currentLabsPage.clickAddLabButton();
		}

		if (map.get("BLOODPRESSURESYSTOLIC") != null && map.get("CheckValidation").equals("N"))
		{
			Assert.assertTrue(currentLabsPage.viewBloodPressureSystolicLabelValue(map.get("BLOODPRESSURESYSTOLIC")), "Failed to identify the BLOOD PRESSURE SYSTOLIC label/value");
			Assert.assertTrue(currentLabsPage.viewBloodPressureSystolicGoal(), "Failed to identify the BLOOD PRESSURE SYSTOLIC Goal");
			Assert.assertTrue(currentLabsPage.viewBloodPressureSystolicDrawDate(drawDateGregorian), "Failed to identify the BLOOD PRESSURE SYSTOLIC draw date");
			Assert.assertTrue(currentLabsPage.viewBloodPressureSystolicSource(), "Failed to identify the BLOOD PRESSURE SYSTOLIC Source");
			Assert.assertTrue(currentLabsPage.viewBloodPressureSystolicColor(Integer.parseInt(map.get("BLOODPRESSURESYSTOLIC")), "T"),
			        "Failed to identify BLOOD PRESSURE SYSTOLIC as the correct color");
			Assert.assertTrue(currentLabsPage.viewGraphPopupBloodPressureSystolicLabelValue(map.get("BLOODPRESSURESYSTOLIC")),
			        "Failed to identify the graph popup BLOOD PRESSURE SYSTOLIC label/value");
			Assert.assertTrue(currentLabsPage.viewGraphPopupBloodPressureSystolicGoal(), "Failed to identify the graph popup BLOOD PRESSURE SYSTOLIC Goal");
			Assert.assertTrue(currentLabsPage.viewBloodPressureSystolicColor(Integer.parseInt(map.get("BLOODPRESSURESYSTOLIC")), "P"),
			        "Failed to identify graph popup BLOOD PRESSURE SYSTOLIC as the correct color");
			Assert.assertTrue(currentLabsPage.viewGraphPopupBloodPressureSystolicPoint(map.get("BLOODPRESSURESYSTOLIC")), "Failed to identify the graph popup BLOOD PRESSURE SYSTOLIC point");
			Assert.assertTrue(currentLabsPage.viewGraphPopupBloodPressureSystolicDrawDate(drawDateGregorian), "Failed to identify the graph popup BLOOD PRESSURE SYSTOLIC draw date");

			currentLabsPage.clickAddLabButton();
		}

		if (map.get("BLOODPRESSUREDIASTOLIC") != null && map.get("CheckValidation").equals("N"))
		{
			Assert.assertTrue(currentLabsPage.viewBloodPressureDiastolicLabelValue(map.get("BLOODPRESSUREDIASTOLIC")), "Failed to identify the BLOOD PRESSURE DIASTOLIC label/value");
			Assert.assertTrue(currentLabsPage.viewBloodPressureDiastolicGoal(), "Failed to identify the BLOOD PRESSURE DIASTOLIC Goal");
			Assert.assertTrue(currentLabsPage.viewBloodPressureDiastolicDrawDate(drawDateGregorian), "Failed to identify the BLOOD PRESSURE DIASTOLIC draw date");
			Assert.assertTrue(currentLabsPage.viewBloodPressureDiastolicSource(), "Failed to identify the BLOOD PRESSURE DIASTOLIC Source");
			Assert.assertTrue(currentLabsPage.viewBloodPressureDiastolicColor(Integer.parseInt(map.get("BLOODPRESSUREDIASTOLIC")), "T"),
			        "Failed to identify BLOOD PRESSURE DIASTOLIC as the correct color");
			Assert.assertTrue(currentLabsPage.viewGraphPopupBloodPressureDiastolicLabelValue(map.get("BLOODPRESSUREDIASTOLIC")),
			        "Failed to identify the graph popup BLOOD PRESSURE DIASTOLIC label/value");
			Assert.assertTrue(currentLabsPage.viewGraphPopupBloodPressureDiastolicGoal(), "Failed to identify the graph popup BLOOD PRESSURE DIASTOLIC Goal");
			Assert.assertTrue(currentLabsPage.viewBloodPressureDiastolicColor(Integer.parseInt(map.get("BLOODPRESSUREDIASTOLIC")), "P"),
			        "Failed to identify graph popup BLOOD PRESSURE DIASTOLIC as the correct color");
			Assert.assertTrue(currentLabsPage.viewGraphPopupBloodPressureDiastolicPoint(map.get("BLOODPRESSUREDIASTOLIC")),
			        "Failed to identify the graph popup BLOOD PRESSURE DIASTOLIC point");
			Assert.assertTrue(currentLabsPage.viewGraphPopupBloodPressureDiastolicDrawDate(drawDateGregorian), "Failed to identify the graph popup BLOOD PRESSURE DIASTOLIC draw date");
		}
	}

	@AfterClass
	public void tearDown() throws TimeoutException, WaitException
	{
		appFunctions.capellaLogout();
		pageBase.quit();
	}
}
