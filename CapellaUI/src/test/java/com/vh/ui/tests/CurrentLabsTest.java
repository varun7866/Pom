package com.vh.ui.tests;

import org.openqa.selenium.TimeoutException;
import org.openqa.selenium.WebDriver;
import org.testng.Assert;
import org.testng.annotations.AfterClass;
import org.testng.annotations.BeforeClass;
import org.testng.annotations.Test;

import com.vh.test.base.TestBase;
import com.vh.ui.actions.ApplicationFunctions;
import com.vh.ui.actions.WebActions;
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
 * 3. Change the Patient name to a Patient under your ID in the call to the selectPatientFromMyPatients() method in the buildUp() method
 * 4. It's not required, but it would be a good idea to delete all existing Labs
 */

public class CurrentLabsTest extends TestBase
{	
	// Class objects
	WebPage pageBase;
	WebActions webActions;
	ApplicationFunctions appFunctions;
	CurrentLabsPage currentLabsPage;
	
	@BeforeClass
	public void buildUp() throws TimeoutException, WaitException, URLNavigationException, InterruptedException {
		WebDriver driver = getWebDriver();
		pageBase = new WebPage(driver);
		webActions = new WebActions(driver);
		appFunctions = new ApplicationFunctions(driver);
		currentLabsPage = new CurrentLabsPage(driver);

		appFunctions.capellaLogin();
		appFunctions.selectPatientFromMyPatients("Waliy Al D Holroyd");
		appFunctions.navigateToMenu("Patient Experience->Labs->Current Labs");
	}

	@Test(priority = 1)
	@Step("Verify the Current Labs page")
	public void verify_CurrentLabsPage() throws WaitException, URLNavigationException, InterruptedException
	{
		Assert.assertTrue(currentLabsPage.viewPageHeaderLabel(), "Failed to identify the Current Labs page header label");
		Assert.assertTrue(currentLabsPage.viewAddLabButton(), "Failed to identify the ADD LAB button");
	}

	@Test(priority = 2)
	@Step("Verify the Add Lab Results popup")
	public void verify_AddAddLabResultsPopup() throws WaitException, URLNavigationException, InterruptedException
	{
		currentLabsPage.clickAddLabButton();

		Assert.assertTrue(currentLabsPage.viewAddLabResultsPopup(), "Failed to identify the Add Labs Results popup header label");

		Assert.assertTrue(currentLabsPage.viewAddPopupCancelButton(), "Failed to identify the Add Lab Results popup CANCEL button");
		Assert.assertTrue(currentLabsPage.viewAddPopupSaveButton(), "Failed to identify the Add Lab Results popup SAVE button");

		Assert.assertTrue(currentLabsPage.viewAddPopupApplyThisDateToAllValuesLabel(), "Failed to identify the Add Lab Results popup APPLY THIS DATE TO ALL VALUES label");
		Assert.assertTrue(currentLabsPage.viewAddPopupDatePicker(), "Failed to identify the Add Lab Results popup APPLY THIS DATE TO ALL VALUES picker");
		Assert.assertTrue(currentLabsPage.viewAddPopupDatePickerButtons(), "Failed to identify all of the Add Lab Results popup date picker buttons");
		Assert.assertTrue(currentLabsPage.isAddPopupDateAplliedToAllDates(0), "The Add Lab Results popup dates did not all default to current date");
		Assert.assertTrue(currentLabsPage.isAddPopupDateAplliedToAllDates(-1), "The Add Lab Results popup APPLY THIS DATE TO ALL VALUES was not applied to all dates");

		Assert.assertTrue(currentLabsPage.viewAddpopupHeightLabel(), "Failed to identify the Add Lab Results popup HEIGHT label");
		Assert.assertTrue(currentLabsPage.viewAddpopupHeightTextBox(), "Failed to identify the Add Lab Results popup HEIGHT text box");
		Assert.assertTrue(currentLabsPage.viewAddpopupHeightPlaceholder(), "Failed to identify the Add Lab Results popup HEIGHT placeholder");

		Assert.assertTrue(currentLabsPage.viewAddpopupTargetDryWeightLabel(), "Failed to identify the Add Lab Results popup TARGET DRY WEIGHT label");
		Assert.assertTrue(currentLabsPage.viewAddpopupTargetDryWeightTextBox(), "Failed to identify the Add Lab Results popup TARGET DRY WEIGHT text box");
		Assert.assertTrue(currentLabsPage.viewAddpopupTargetDryWeightPlaceholder(), "Failed to identify the Add Lab Results popup TARGET DRY WEIGHT placeholder");

		Assert.assertTrue(currentLabsPage.viewAddpopupPhosphorousLabel(), "Failed to identify the Add Lab Results popup PHOSPHOROUS label");
		Assert.assertTrue(currentLabsPage.viewAddpopupPhosphorousTextBox(), "Failed to identify the Add Lab Results popup PHOSPHOROUS text box");
		Assert.assertTrue(currentLabsPage.viewAddpopupPhosphorousGoal(), "Failed to identify the Add Lab Results popup PHOSPHOROUS goal");

		Assert.assertTrue(currentLabsPage.viewAddpopupGFRLabel(), "Failed to identify the Add Lab Results popup GFR label");
		Assert.assertTrue(currentLabsPage.viewAddpopupGFRTextBox(), "Failed to identify the Add Lab Results popup GFR text box");
		Assert.assertTrue(currentLabsPage.viewAddpopupGFRGoal(), "Failed to identify the Add Lab Results popup GFR goal");

		Assert.assertTrue(currentLabsPage.viewAddpopupLDLLabel(), "Failed to identify the Add Lab Results popup LDL label");
		Assert.assertTrue(currentLabsPage.viewAddpopupLDLTextBox(), "Failed to identify the Add Lab Results popup LDL text box");
		Assert.assertTrue(currentLabsPage.viewAddpopupLDLGoal(), "Failed to identify the Add Lab Results popup LDL goal");

		Assert.assertTrue(currentLabsPage.viewAddpopupAlbuminLabel(), "Failed to identify the Add Lab Results popup Albumin label");
		Assert.assertTrue(currentLabsPage.viewAddpopupAlbuminTextBox(), "Failed to identify the Add Lab Results popup Albumin text box");
		Assert.assertTrue(currentLabsPage.viewAddpopupAlbuminGoal(), "Failed to identify the Add Lab Results popup Albumin goal");

		Assert.assertTrue(currentLabsPage.viewAddpopupCo2LevelLabel(), "Failed to identify the Add Lab Results popup CO2 LEVEL label");
		Assert.assertTrue(currentLabsPage.viewAddpopupCo2LevelTextBox(), "Failed to identify the Add Lab Results popup CO2 LEVEL text box");
		Assert.assertTrue(currentLabsPage.viewAddpopupCo2LevelGoal(), "Failed to identify the Add Lab Results popup CO2 LEVEL goal");

		Assert.assertTrue(currentLabsPage.viewAddpopupKTVLabel(), "Failed to identify the Add Lab Results popup KT/V label");
		Assert.assertTrue(currentLabsPage.viewAddpopupKTVTextBox(), "Failed to identify the Add Lab Results popup KT/V text box");
		Assert.assertTrue(currentLabsPage.viewAddpopupKTVGoal(), "Failed to identify the Add Lab Results popup KT/V goal");

		Assert.assertTrue(currentLabsPage.viewAddpopupPotassiumLabel(), "Failed to identify the Add Lab Results popup POTASSIUM label");
		Assert.assertTrue(currentLabsPage.viewAddpopupPotassiumTextBox(), "Failed to identify the Add Lab Results popup POTASSIUM text box");
		Assert.assertTrue(currentLabsPage.viewAddpopupPotassiumGoal(), "Failed to identify the Add Lab Results popup POTASSIUM goal");
		
		Assert.assertTrue(currentLabsPage.viewAddpopupHepatitisBTiterLabel(), "Failed to identify the Add Lab Results popup HEPATITIS B TITER label");
		Assert.assertTrue(currentLabsPage.viewAddpopupHepatitisBTiterTextBox(), "Failed to identify the Add Lab Results popup HEPATITIS B TITER text box");
		Assert.assertTrue(currentLabsPage.viewAddpopupHepatitisBTiterGoal(), "Failed to identify the Add Lab Results popup HEPATITIS B TITER goal");

		Assert.assertTrue(currentLabsPage.viewAddpopupTSATLabel(), "Failed to identify the Add Lab Results popup TSAT label");
		Assert.assertTrue(currentLabsPage.viewAddpopupTSATTextBox(), "Failed to identify the Add Lab Results popup TSAT text box");
		Assert.assertTrue(currentLabsPage.viewAddpopupTSATGoal(), "Failed to identify the Add Lab Results popup TSAT goal");

		Assert.assertTrue(currentLabsPage.viewAddpopupBloodPressureDiastolicLabel(), "Failed to identify the Add Lab Results popup BLOOD PRESURE DIASTOLIC label");
		Assert.assertTrue(currentLabsPage.viewAddpopupBloodPressureDiastolicTextBox(), "Failed to identify the Add Lab Results popup BLOOD PRESURE DIASTOLIC text box");
		Assert.assertTrue(currentLabsPage.viewAddpopupBloodPressureDiastolicGoal(), "Failed to identify the Add Lab Results popup BLOOD PRESURE DIASTOLIC goal");

		Assert.assertTrue(currentLabsPage.viewAddpopupWeightLabel(), "Failed to identify the Add Lab Results popup WEIGHT label");
		Assert.assertTrue(currentLabsPage.viewAddpopupWeightTextBox(), "Failed to identify the Add Lab Results popup WEIGHT text box");
		Assert.assertTrue(currentLabsPage.viewAddpopupWeightPlaceholder(), "Failed to identify the Add Lab Results popup WEIGHT placeholder");

		Assert.assertTrue(currentLabsPage.viewAddpopupCalciumXPhosphorousLabel(), "Failed to identify the Add Lab Results popup CALCIUM X PHOSPHOROUS label");
		Assert.assertTrue(currentLabsPage.viewAddpopupCalciumXPhosphorousTextBox(), "Failed to identify the Add Lab Results popup CALCIUM X PHOSPHOROUS text box");
		Assert.assertTrue(currentLabsPage.viewAddpopupCalciumXPhosphorousGoal(), "Failed to identify the Add Lab Results popup CALCIUM X PHOSPHOROUS goal");
	}

	@AfterClass
	public void tearDown() throws TimeoutException, WaitException
	{
		appFunctions.capellaLogout();
		pageBase.quit();
	}
}
