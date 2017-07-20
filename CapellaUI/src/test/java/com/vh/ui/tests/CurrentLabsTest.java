package com.vh.ui.tests;

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
		// appFunctions.selectPatientFromMyPatients("Glayds Whoriskey"); // CKD Patient
		// appFunctions.navigateToMenu("Patient Experience->Labs->Current Labs");
	}

	// @Test(priority = 1)
	// @Step("Verify the Current Labs page")
	public void verify_CurrentLabsPage() throws WaitException, URLNavigationException, InterruptedException
	{
		Assert.assertTrue(currentLabsPage.viewPageHeaderLabel(), "Failed to identify the Current Labs page header label");
		Assert.assertTrue(currentLabsPage.viewAddLabButton(), "Failed to identify the ADD LAB button");
	}

	// @Test(priority = 2)
	// @Step("Verify the Add Lab Results popup for CKD Patients")
	public void verify_AddLabResultsPopupCKD() throws WaitException, URLNavigationException, InterruptedException
	{
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

		Assert.assertTrue(currentLabsPage.viewAddpopupBloodPressureSystolicLabel(), "Failed to identify the Add Lab Results popup BLOOD PRESURE SYSTOLIC label");
		Assert.assertTrue(currentLabsPage.viewAddpopupBloodPressureSystolicTextBox(), "Failed to identify the Add Lab Results popup BLOOD PRESURE SYSTOLIC text box");
		Assert.assertTrue(currentLabsPage.viewAddpopupBloodPressureSystolicGoal(), "Failed to identify the Add Lab Results popup BLOOD PRESURE SYSTOLIC Goal");

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

		Assert.assertTrue(currentLabsPage.viewAddpopupBloodPressureDiastolicLabel(), "Failed to identify the Add Lab Results popup BLOOD PRESURE DIASTOLIC label");
		Assert.assertTrue(currentLabsPage.viewAddpopupBloodPressureDiastolicTextBox(), "Failed to identify the Add Lab Results popup BLOOD PRESURE DIASTOLIC text box");
		Assert.assertTrue(currentLabsPage.viewAddpopupBloodPressureDiastolicGoal(), "Failed to identify the Add Lab Results popup BLOOD PRESURE DIASTOLIC Goal");

		currentLabsPage.clickAddPopupCancelButton();
	}

	// @Test(priority = 3)
	// @Step("Verify the Add Lab Results popup for ESRD Patients")
	public void verify_AddAddLabResultsPopupESRD() throws WaitException, URLNavigationException, InterruptedException
	{
		appFunctions.selectPatientFromMyPatients("Waliy Al D Holroyd"); // ESRD Patient

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

		Assert.assertTrue(currentLabsPage.viewAddpopupBloodPressureDiastolicLabel(), "Failed to identify the Add Lab Results popup BLOOD PRESURE DIASTOLIC label");
		Assert.assertTrue(currentLabsPage.viewAddpopupBloodPressureDiastolicTextBox(), "Failed to identify the Add Lab Results popup BLOOD PRESURE DIASTOLIC text box");
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

		Assert.assertTrue(currentLabsPage.viewAddpopupBloodPressureSystolicLabel(), "Failed to identify the Add Lab Results popup BLOOD PRESURE SYSTOLIC label");
		Assert.assertTrue(currentLabsPage.viewAddpopupBloodPressureSystolicTextBox(), "Failed to identify the Add Lab Results popup BLOOD PRESURE SYSTOLIC text box");
		Assert.assertTrue(currentLabsPage.viewAddpopupBloodPressureSystolicGoal(), "Failed to identify the Add Lab Results popup BLOOD PRESURE SYSTOLIC Goal");

		currentLabsPage.clickAddPopupCancelButton();
	}

	@Test(priority = 4, dataProvider = "CapellaDataProvider")
	@Step("Verify Adding Labs with different scenarios")
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
			currentLabsPage.clearKTVTextBox();
			currentLabsPage.clearURRTextBox();
			currentLabsPage.clickAddPopupSaveButton();
		}
		else
		{
			if (map.get("PatientType").equals("ESRD") && map.get("CheckValidation").equals("Y"))
			{
				Assert.assertTrue(currentLabsPage.viewAddpopupUrineAlbuminCreatinineRatioErrorMessage(),
				        "Failed to identify the Add Lab Results popup Urine Albumin Creatinine Ratio error message");
				currentLabsPage.clearUrineAlbuminCreatinineRatioTextBox();
				currentLabsPage.clickAddPopupSaveButton();
			}
		}

		String drawDateGregorian = appFunctions.adjustCurrentDateBy(map.get("APPLYTHISDATETOALLVALUES"), "MM/dd/YYYY");

		if (map.get("HEIGHT") != null)
		{
			Assert.assertTrue(currentLabsPage.viewHeightLabelValue(map.get("HEIGHT")), "Failed to identify the HEIGHT label/value");
			Assert.assertTrue(currentLabsPage.viewHeightDrawDate(drawDateGregorian), "Failed to identify the HEIGHT draw date");
			Assert.assertTrue(currentLabsPage.viewHeightSource(), "Failed to identify the HEIGHT Source");
			Assert.assertTrue(currentLabsPage.viewHeightColor(), "Failed to identify HEIGHT as the correct color");
		}

		if (map.get("WEIGHT") != null)
		{
			Assert.assertTrue(currentLabsPage.viewWeightLabelValue(map.get("WEIGHT")), "Failed to identify the WEIGHT label/value");
			Assert.assertTrue(currentLabsPage.viewWeightDrawDate(drawDateGregorian), "Failed to identify the WEIGHT draw date");
			Assert.assertTrue(currentLabsPage.viewWeightSource(), "Failed to identify the WEIGHT Source");
			Assert.assertTrue(currentLabsPage.viewWeightColor(), "Failed to identify WEIGHT as the correct color");
		}

		if (map.get("TARGETDRYWEIGHT") != null)
		{
			Assert.assertTrue(currentLabsPage.viewTargetDryWeightLabelValue(map.get("TARGETDRYWEIGHT")), "Failed to identify the TARGET DRY WEIGHT label/value");
			Assert.assertTrue(currentLabsPage.viewTargetDryWeightDrawDate(drawDateGregorian), "Failed to identify the TARGET DRY WEIGHT draw date");
			Assert.assertTrue(currentLabsPage.viewTargetDryWeightSource(), "Failed to identify the TARGET DRY WEIGHT Source");
			Assert.assertTrue(currentLabsPage.viewTargetDryWeightColor(), "Failed to identify TARGET DRY WEIGHT as the correct color");
		}

		if (map.get("CALCIUMXPHOSPHOROUS") != null)
		{
			Assert.assertTrue(currentLabsPage.viewCalciumXPhosphorousLabelValue(map.get("CALCIUMXPHOSPHOROUS")), "Failed to identify the CALCIUM X PHOSPHOROUS label/value");
			Assert.assertTrue(currentLabsPage.viewCalciumXPhosphorousGoal(), "Failed to identify the CALCIUM X PHOSPHOROUS Goal");
			Assert.assertTrue(currentLabsPage.viewCalciumXPhosphorousDrawDate(drawDateGregorian), "Failed to identify the CALCIUM X PHOSPHOROUS draw date");
			Assert.assertTrue(currentLabsPage.viewCalciumXPhosphorousSource(), "Failed to identify the CALCIUM X PHOSPHOROUS Source");
			Assert.assertTrue(currentLabsPage.viewCalciumXPhosphorousColor(Integer.parseInt(map.get("CALCIUMXPHOSPHOROUS"))),
			        "Failed to identify CALCIUM X PHOSPHOROUS as the correct color");
		}

		if (map.get("PHOSPHOROUS") != null)
		{
			Assert.assertTrue(currentLabsPage.viewPhosphorousLabelValue(map.get("PHOSPHOROUS")), "Failed to identify the PHOSPHOROUS label/value");
			Assert.assertTrue(currentLabsPage.viewPhosphorousGoal(), "Failed to identify the PHOSPHOROUS Goal");
			Assert.assertTrue(currentLabsPage.viewPhosphorousDrawDate(drawDateGregorian), "Failed to identify the PHOSPHOROUS draw date");
			Assert.assertTrue(currentLabsPage.viewPhosphorousSource(), "Failed to identify the PHOSPHOROUS Source");
			Assert.assertTrue(currentLabsPage.viewPhosphorousColor(Integer.parseInt(map.get("PHOSPHOROUS"))), "Failed to identify PHOSPHOROUS as the correct color");
		}

		if (map.get("CREATININE") != null)
		{
			Assert.assertTrue(currentLabsPage.viewCreatinineLabelValue(map.get("CREATININE")), "Failed to identify the CREATININE label/value");
			Assert.assertTrue(currentLabsPage.viewCreatinineGoal(), "Failed to identify the CREATININE Goal");
			Assert.assertTrue(currentLabsPage.viewCreatinineDrawDate(drawDateGregorian), "Failed to identify the CREATININE draw date");
			Assert.assertTrue(currentLabsPage.viewCreatinineSource(), "Failed to identify the CREATININE Source");
			Assert.assertTrue(currentLabsPage.viewCreatinineColor(Integer.parseInt(map.get("CREATININE"))), "Failed to identify CREATININE as the correct color");
		}

		if (map.get("GFR") != null)
		{
			Assert.assertTrue(currentLabsPage.viewGFRLabelValue(map.get("GFR")), "Failed to identify the GFR label/value");
			Assert.assertTrue(currentLabsPage.viewGFRGoal(), "Failed to identify the GFR Goal");
			Assert.assertTrue(currentLabsPage.viewGFRDrawDate(drawDateGregorian), "Failed to identify the GFR draw date");
			Assert.assertTrue(currentLabsPage.viewGFRSource(), "Failed to identify the GFR Source");
			Assert.assertTrue(currentLabsPage.viewGFRColor(Integer.parseInt(map.get("GFR"))), "Failed to identify GFR as the correct color");
		}

		if (map.get("HGBA1C") != null)
		{
			Assert.assertTrue(currentLabsPage.viewHGBA1CLabelValue(map.get("HGBA1C")), "Failed to identify the HGBA1C label/value");
			Assert.assertTrue(currentLabsPage.viewHGBA1CGoal(), "Failed to identify the HGBA1C Goal");
			Assert.assertTrue(currentLabsPage.viewHGBA1CDrawDate(drawDateGregorian), "Failed to identify the HGBA1C draw date");
			Assert.assertTrue(currentLabsPage.viewHGBA1CSource(), "Failed to identify the HGBA1C Source");
			Assert.assertTrue(currentLabsPage.viewHGBA1CColor(Integer.parseInt(map.get("HGBA1C"))), "Failed to identify HGBA1C as the correct color");
		}

		if (map.get("LDL") != null)
		{
			Assert.assertTrue(currentLabsPage.viewLDLLabelValue(map.get("LDL")), "Failed to identify the LDL label/value");
			Assert.assertTrue(currentLabsPage.viewLDLGoal(), "Failed to identify the LDL Goal");
			Assert.assertTrue(currentLabsPage.viewLDLDrawDate(drawDateGregorian), "Failed to identify the LDL draw date");
			Assert.assertTrue(currentLabsPage.viewLDLSource(), "Failed to identify the LDL Source");
			Assert.assertTrue(currentLabsPage.viewLDLColor(Integer.parseInt(map.get("LDL"))), "Failed to identify LDL as the correct color");
		}

		if (map.get("HGB") != null)
		{
			Assert.assertTrue(currentLabsPage.viewHGBLabelValue(map.get("HGB")), "Failed to identify the HGB label/value");
			Assert.assertTrue(currentLabsPage.viewHGBGoal(), "Failed to identify the HGB Goal");
			Assert.assertTrue(currentLabsPage.viewHGBDrawDate(drawDateGregorian), "Failed to identify the HGB draw date");
			Assert.assertTrue(currentLabsPage.viewHGBSource(), "Failed to identify the HGB Source");
			Assert.assertTrue(currentLabsPage.viewHGBColor(Integer.parseInt(map.get("HGB"))), "Failed to identify HGB as the correct color");
		}

		if (map.get("ALBUMIN") != null)
		{
			Assert.assertTrue(currentLabsPage.viewAlbuminLabelValue(map.get("ALBUMIN")), "Failed to identify the ALBUMIN label/value");
			Assert.assertTrue(currentLabsPage.viewAlbuminGoal(), "Failed to identify the ALBUMIN Goal");
			Assert.assertTrue(currentLabsPage.viewAlbuminDrawDate(drawDateGregorian), "Failed to identify the ALBUMIN draw date");
			Assert.assertTrue(currentLabsPage.viewAlbuminSource(), "Failed to identify the ALBUMIN Source");
		}

		if (map.get("URINEALBUMINCREATININERATIO") != null && map.get("PatientType").equals("CKD"))
		{
			Assert.assertTrue(currentLabsPage.viewUrineAlbuminCreatinineRatioLabelValue(map.get("URINEALBUMINCREATININERATIO")),
			        "Failed to identify the URINE ALBUMIN CREATININE RATIO label/value");
			Assert.assertTrue(currentLabsPage.viewUrineAlbuminCreatinineRatioGoal(), "Failed to identify the URINE ALBUMIN/CREATININE RATIO Goal");
			Assert.assertTrue(currentLabsPage.viewUrineAlbuminCreatinineRatioDrawDate(drawDateGregorian), "Failed to identify the URINE ALBUMIN/CREATININE RATIO draw date");
			Assert.assertTrue(currentLabsPage.viewUrineAlbuminCreatinineRatioSource(), "Failed to identify the URINE ALBUMIN/CREATININE RATIO Source");
		}

		if (map.get("DIPSTICKFORPROTEIN") != null)
		{
			Assert.assertTrue(currentLabsPage.viewDipstickForProteinLabelValue(map.get("DIPSTICKFORPROTEIN")), "Failed to identify the DIPSTICK FOR PROTEIN label/value");
			Assert.assertTrue(currentLabsPage.viewDipstickForProteinGoal(), "Failed to identify the DIPSTICK FOR PROTEIN Goal");
			Assert.assertTrue(currentLabsPage.viewDipstickForProteinDrawDate(drawDateGregorian), "Failed to identify the DIPSTICK FOR PROTEIN draw date");
			Assert.assertTrue(currentLabsPage.viewDipstickForProteinSource(), "Failed to identify the URINE DIPSTICK FOR PROTEIN Source");
		}

		if (map.get("CO2LEVEL") != null)
		{
			Assert.assertTrue(currentLabsPage.viewCO2LevelLabelValue(map.get("CO2LEVEL")), "Failed to identify the CO2 LEVEL label/value");
			Assert.assertTrue(currentLabsPage.viewCO2LevelGoal(), "Failed to identify the CO2 LEVEL Goal");
			Assert.assertTrue(currentLabsPage.viewCO2LevelDrawDate(drawDateGregorian), "Failed to identify the CO2 LEVEL draw date");
			Assert.assertTrue(currentLabsPage.viewCO2LevelSource(), "Failed to identify the CO2 LEVEL Source");
		}

		if (map.get("CALCIUM") != null)
		{
			Assert.assertTrue(currentLabsPage.viewCalciumLabelValue(map.get("CALCIUM")), "Failed to identify the CALCIUM label/value");
			Assert.assertTrue(currentLabsPage.viewCalciumGoal1(), "Failed to identify the CALCIUM Goal1");
			Assert.assertTrue(currentLabsPage.viewCalciumGoal2(), "Failed to identify the CALCIUM Goal2");
			Assert.assertTrue(currentLabsPage.viewCalciumDrawDate(drawDateGregorian), "Failed to identify the CALCIUM draw date");
			Assert.assertTrue(currentLabsPage.viewCalciumSource(), "Failed to identify the CALCIUM Source");
		}

		if (map.get("KTV") != null && map.get("PatientType").equals("ESRD"))
		{
			Assert.assertTrue(currentLabsPage.viewKTVLabelValue(map.get("KTV")), "Failed to identify the KT/V label/value");
			Assert.assertTrue(currentLabsPage.viewKTVGoal(), "Failed to identify the KT/V Goal");
			Assert.assertTrue(currentLabsPage.viewKTVDrawDate(drawDateGregorian), "Failed to identify the KT/V draw date");
			Assert.assertTrue(currentLabsPage.viewKTVSource(), "Failed to identify the KT/V Source");
		}

		if (map.get("URR") != null && map.get("PatientType").equals("ESRD"))
		{
			Assert.assertTrue(currentLabsPage.viewURRLabelValue(map.get("URR")), "Failed to identify the URR label/value");
			Assert.assertTrue(currentLabsPage.viewURRGoal(), "Failed to identify the URR Goal");
			Assert.assertTrue(currentLabsPage.viewURRDrawDate(drawDateGregorian), "Failed to identify the URR draw date");
			Assert.assertTrue(currentLabsPage.viewURRSource(), "Failed to identify the URR Source");
		}

		if (map.get("POTASIUM") != null)
		{
			Assert.assertTrue(currentLabsPage.viewPotassiumLabelValue(map.get("POTASIUM")), "Failed to identify the POTASIUM label/value");
			Assert.assertTrue(currentLabsPage.viewPotassiumGoal(), "Failed to identify the POTASIUM Goal");
			Assert.assertTrue(currentLabsPage.viewPotassiumDrawDate(drawDateGregorian), "Failed to identify the POTASIUM draw date");
			Assert.assertTrue(currentLabsPage.viewPotassiumSource(), "Failed to identify the POTASIUM Source");
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
		}

		if (map.get("HEPATITISBTITER") != null)
		{
			Assert.assertTrue(currentLabsPage.viewHepatitisBTiterLabelValue(map.get("HEPATITISBTITER")), "Failed to identify the HEPATITIS B TITER label/value");
			Assert.assertTrue(currentLabsPage.viewHepatitisBTiterGoal(), "Failed to identify the HEPATITIS B TITER Goal");
			Assert.assertTrue(currentLabsPage.viewHepatitisBTiterDrawDate(drawDateGregorian), "Failed to identify the HEPATITIS B TITER draw date");
			Assert.assertTrue(currentLabsPage.viewHepatitisBTiterSource(), "Failed to identify the HEPATITIS B TITER Source");
		}

		if (map.get("FERRITIN") != null)
		{
			Assert.assertTrue(currentLabsPage.viewFerritinLabelValue(map.get("FERRITIN")), "Failed to identify the FERRITIN label/value");
			Assert.assertTrue(currentLabsPage.viewFerritinGoal(), "Failed to identify the FERRITIN Goal");
			Assert.assertTrue(currentLabsPage.viewFerritinDrawDate(drawDateGregorian), "Failed to identify the FERRITIN draw date");
			Assert.assertTrue(currentLabsPage.viewFerritinSource(), "Failed to identify the FERRITIN Source");
		}

		if (map.get("TSAT") != null)
		{
			Assert.assertTrue(currentLabsPage.viewTSATLabelValue(map.get("TSAT")), "Failed to identify the TSAT label/value");
			Assert.assertTrue(currentLabsPage.viewTSATGoal(), "Failed to identify the TSAT Goal");
			Assert.assertTrue(currentLabsPage.viewTSATDrawDate(drawDateGregorian), "Failed to identify the TSAT draw date");
			Assert.assertTrue(currentLabsPage.viewTSATSource(), "Failed to identify the TSAT Source");
		}

		if (map.get("BLOODPRESSURESYSTOLIC") != null)
		{
			Assert.assertTrue(currentLabsPage.viewBloodPressureSystolicLabelValue(map.get("BLOODPRESSURESYSTOLIC")), "Failed to identify the BLOOD PRESSURE SYSTOLIC label/value");
			Assert.assertTrue(currentLabsPage.viewBloodPressureSystolicGoal(), "Failed to identify the BLOOD PRESSURE SYSTOLIC Goal");
			Assert.assertTrue(currentLabsPage.viewBloodPressureSystolicDrawDate(drawDateGregorian), "Failed to identify the BLOOD PRESSURE SYSTOLIC draw date");
			Assert.assertTrue(currentLabsPage.viewBloodPressureSystolicSource(), "Failed to identify the BLOOD PRESSURE SYSTOLIC Source");
		}

		if (map.get("BLOODPRESSUREDIASTOLIC") != null)
		{
			Assert.assertTrue(currentLabsPage.viewBloodPressureDiastolicLabelValue(map.get("BLOODPRESSUREDIASTOLIC")), "Failed to identify the BLOOD PRESSURE DIASTOLIC label/value");
			Assert.assertTrue(currentLabsPage.viewBloodPressureDiastolicGoal(), "Failed to identify the BLOOD PRESSURE DIASTOLIC Goal");
			Assert.assertTrue(currentLabsPage.viewBloodPressureDiastolicDrawDate(drawDateGregorian), "Failed to identify the BLOOD PRESSURE DIASTOLIC draw date");
			Assert.assertTrue(currentLabsPage.viewBloodPressureDiastolicSource(), "Failed to identify the BLOOD PRESSURE DIASTOLIC Source");
		}
	}

	@AfterClass
	public void tearDown() throws TimeoutException, WaitException
	{
		// appFunctions.capellaLogout();
		// pageBase.quit();
	}
}
