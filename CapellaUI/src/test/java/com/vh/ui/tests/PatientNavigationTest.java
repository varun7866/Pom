package com.vh.ui.tests;

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
import com.vh.ui.pages.PatientNavigationPage;

import ru.yandex.qatools.allure.annotations.Step;

/*
 * @author Harvy Ackermans
 * @date   June 22, 2017
 * @class  PatientNavigationTest.java
 * 
 * Before running this test suite:
 * 1. Change the "username" and "password" parameters in the "resources\application.properties" file to your own
 * 2. Clear your browser's cache
 */

public class PatientNavigationTest extends TestBase
{	
	// Class objects
	WebPage pageBase;
	ApplicationFunctions appFunctions;
	PatientNavigationPage patientNavigationPage;
	
	@BeforeClass
	public void buildUp() throws TimeoutException, WaitException, URLNavigationException, InterruptedException {
		WebDriver driver = getWebDriver();
		pageBase = new WebPage(driver);
		appFunctions = new ApplicationFunctions(driver);
		patientNavigationPage = new PatientNavigationPage(driver);

		appFunctions.capellaLogin();
		appFunctions.selectPatientFromMyPatients("Mikal Gallogly"); // QA
		// appFunctions.selectPatientFromMyPatients("Aasaf Whoriskey"); // Stage
	}

	@Test(priority = 1)
	@Step("Verify the left navigation pane")
	public void verify_LeftNavigationPane() throws WaitException, URLNavigationException, InterruptedException
	{
		// Plan of Care
		Assert.assertTrue(patientNavigationPage.viewPlanOfCareMenu(), "Failed to identify the Plan of Care menu");
		Assert.assertTrue(patientNavigationPage.verifyPlanOfCareMenuExpanded(), "Failed to expand the Plan of Care menu");
		// Assert.assertTrue(patientNavigationPage.viewPlanOfCareOverviewScreen(), "Failed to display the Overview screen");
		// Assert.assertTrue(patientNavigationPage.viewPlanOfCareManagementScreen(), "Failed to display the Management screen");
		// Assert.assertTrue(patientNavigationPage.viewPlanOfCareHistoryScreen(), "Failed to display the History screen");
		// Assert.assertTrue(patientNavigationPage.viewPlanOfCareNotesScreen(), "Failed to display the Notes screen");
		Assert.assertTrue(patientNavigationPage.viewPlanOfCareConsolidatedStoryScreen(), "Failed to display the ConsolidatedStory screen");
		Assert.assertTrue(patientNavigationPage.verifyPlanOfCareMenuCollapse(), "Failed to collapse the Plan of Care menu");
		
		
		// Patient Care
		Assert.assertTrue(patientNavigationPage.viewPatientCareMenu(), "Failed to identify the Patient Care menu");
		Assert.assertTrue(patientNavigationPage.viewPatientCarePatientRecapScreen(), "Failed to display the Patient Recap screen");
		// Assert.assertTrue(patientNavigationPage.viewPatientCarePatientTasksScreen(), "Failed to display the Patient Tasks screen");
		Assert.assertTrue(patientNavigationPage.viewPatientCareCareTeamScreen(), "Failed to display the Care Team screen");
		Assert.assertTrue(patientNavigationPage.verifyPatientCareMenuCollapse(), "Failed to collapse the Patient Care menu");

		// Patient Experience
		Assert.assertTrue(patientNavigationPage.viewPatientExperienceMenu(), "Failed to identify the Patient Experience menu");
		Assert.assertTrue(patientNavigationPage.verifyPatientExperienceMenuExpanded(), "Failed to expand the Patient Experience menu");
		Assert.assertTrue(patientNavigationPage.viewPatientExperienceHospitalizationsScreen(), "Failed to display the Hospitalizations screen");
		Assert.assertTrue(patientNavigationPage.verifyHoverHospitalizations(), "Failed to hover over HospitalizationsTooltip");
		// Assert.assertTrue(patientNavigationPage.viewPatientExperienceFluidScreen(), "Failed to display the Fluid screen");
		Assert.assertTrue(patientNavigationPage.verifyHoverFluid(), "Failed to hover over FluidTooltip");
		// Assert.assertTrue(patientNavigationPage.viewPatientExperienceAccessScreen(), "Failed to display the Access screen");
		Assert.assertTrue(patientNavigationPage.verifyHoverAccess(), "Failed to hover over AccessTooltip");
		// Assert.assertTrue(patientNavigationPage.viewPatientExperienceMedicationsScreen(), "Failed to display the Medications screen");
		Assert.assertTrue(patientNavigationPage.verifyHoverMedications(), "Failed to hover over MedicationsTooltip");
		// Assert.assertTrue(patientNavigationPage.viewPatientExperienceDiabetesScreen(), "Failed to display the Diabetes screen");
		Assert.assertTrue(patientNavigationPage.verifyHoverDiabetes(), "Failed to hover over DiabetesTooltip");
		// Assert.assertTrue(patientNavigationPage.viewPatientExperienceDepressionScreen(), "Failed to display the Depression screen");
		Assert.assertTrue(patientNavigationPage.verifyHoverDepression(), "Failed to hover over DepressionTooltip");
		// Assert.assertTrue(patientNavigationPage.viewPatientExperienceImmunizationsScreen(), "Failed to display the Immunizations screen");
		Assert.assertTrue(patientNavigationPage.verifyHoverImmunizations(), "Failed to hover over ImmunizationsTooltip");
		// Assert.assertTrue(patientNavigationPage.viewPatientExperienceIPathwaysScreeningsScreen(), "Failed to display the Pathways/Screenings screen");
		// Assert.assertTrue(patientNavigationPage.viewPatientExperienceIComorbidsComplaintsScreen(), "Failed to display the Comorbids/Complaints screen");
		Assert.assertTrue(patientNavigationPage.verifyHoverComorbidsComplaints(), "Failed to hover over ComorbidsComplaintsTooltip");

		// Labs
		Assert.assertTrue(patientNavigationPage.viewPatientExperienceLabsMenu(), "Failed to identify the Patient Experience Labs menu");
		Assert.assertTrue(patientNavigationPage.verifyPatientExperienceLabsMenuExpanded(), "Failed to expand the Patient Experience Labs menu");
		Assert.assertTrue(patientNavigationPage.viewPatientExperienceLabsCurrentLabsScreen(), "Failed to display the Current Labs screen");
		Assert.assertTrue(patientNavigationPage.viewPatientExperienceLabsLabsHistoryScreen(), "Failed to display the Labs History screen");
		Assert.assertTrue(patientNavigationPage.verifyPatientExperienceMenuCollapse(), "Failed to collapse the Patient Experience menu");

		// Patient Admin
		Assert.assertTrue(patientNavigationPage.viewPatientAdminMenu(), "Failed to identify the Patient Admin menu");
		Assert.assertTrue(patientNavigationPage.verifyPatientAdminMenuExpanded(), "Failed to expand the Patient Admin menu");
		Assert.assertTrue(patientNavigationPage.viewPatientAdminPatientInfoScreen(), "Failed to display the Patient Info screen");
		Assert.assertTrue(patientNavigationPage.viewPatientAdminMedicalEquipmentScreen(), "Failed to display the Medical Equipment screen");
		Assert.assertTrue(patientNavigationPage.viewPatientAdminManageDocumentsScreen(), "Failed to display the Manage Documents screen");
		// Assert.assertTrue(patientNavigationPage.viewPatientAdminFalconScreen(), "Failed to display the Falcon screen");
		// Assert.assertTrue(patientNavigationPage.viewPatientAdminMaterialFulfillmentScreen(), "Failed to display the Material Fulfillment screen");
		Assert.assertTrue(patientNavigationPage.viewPatientAdminReferralsScreen(), "Failed to display the Referrals screen");
		Assert.assertTrue(patientNavigationPage.verifyPatientAdminMenuCollapse(), "Failed to collapse the Patient Experience menu");
	}

	@AfterClass
	public void tearDown() throws TimeoutException, WaitException
	{
		appFunctions.capellaLogout();
		pageBase.quit();
	}
}
