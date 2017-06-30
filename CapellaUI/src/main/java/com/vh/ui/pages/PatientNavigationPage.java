package com.vh.ui.pages;

import static com.vh.ui.web.locators.PatientNavigationLocators.LBL_PATIENTCARECARETEAM;
import static com.vh.ui.web.locators.PatientNavigationLocators.LBL_PATIENTCAREPATIENTRECAP;
import static com.vh.ui.web.locators.PatientNavigationLocators.LBL_PATIENTCAREPATIENTTASKS;
import static com.vh.ui.web.locators.PatientNavigationLocators.LBL_PATIENTEXPERIENCEHOSPITALIZATIONS;
import static com.vh.ui.web.locators.PatientNavigationLocators.LBL_PLANOFCARECONSOLIDATEDSTORY;
import static com.vh.ui.web.locators.PatientNavigationLocators.LBL_PLANOFCAREHISTORY;
import static com.vh.ui.web.locators.PatientNavigationLocators.LBL_PLANOFCAREMANAGEMENT;
import static com.vh.ui.web.locators.PatientNavigationLocators.LBL_PLANOFCARENOTES;
import static com.vh.ui.web.locators.PatientNavigationLocators.LBL_PLANOFCAREOVERVIEW;
import static com.vh.ui.web.locators.PatientNavigationLocators.MNU_PATIENTCARE;
import static com.vh.ui.web.locators.PatientNavigationLocators.MNU_PATIENTCARECARETEAM;
import static com.vh.ui.web.locators.PatientNavigationLocators.MNU_PATIENTCAREPATIENTRECAP;
import static com.vh.ui.web.locators.PatientNavigationLocators.MNU_PATIENTCAREPATIENTTASKS;
import static com.vh.ui.web.locators.PatientNavigationLocators.MNU_PATIENTEXPERIENCE;
import static com.vh.ui.web.locators.PatientNavigationLocators.MNU_PATIENTEXPERIENCEHOSPITALIZATIONS;
import static com.vh.ui.web.locators.PatientNavigationLocators.MNU_PLANOFCARE;
import static com.vh.ui.web.locators.PatientNavigationLocators.MNU_PLANOFCARECONSOLIDATEDSTORY;
import static com.vh.ui.web.locators.PatientNavigationLocators.MNU_PLANOFCAREHISTORY;
import static com.vh.ui.web.locators.PatientNavigationLocators.MNU_PLANOFCAREMANAGEMENT;
import static com.vh.ui.web.locators.PatientNavigationLocators.MNU_PLANOFCARENOTES;
import static com.vh.ui.web.locators.PatientNavigationLocators.MNU_PLANOFCAREOVERVIEW;

import org.openqa.selenium.TimeoutException;
import org.openqa.selenium.WebDriver;

import com.vh.ui.exceptions.WaitException;
import com.vh.ui.page.base.WebPage;

import ru.yandex.qatools.allure.annotations.Step;

/*
 * @author Harvy Ackermans
 * @date   June 29, 2017
 * @class  PatientNavigationPage.java
 */

public class PatientNavigationPage extends WebPage
{
	public PatientNavigationPage(WebDriver driver) throws WaitException {
		super(driver);
	}

	@Step("Verify the visibility of the Plan of Care menu")
	public boolean viewPlanOfCareMenu() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, MNU_PLANOFCARE);
	}

	@Step("Verify the expansion of the Plan of Care menu")
	public boolean viewPlanOfCareMenuExpanded() throws TimeoutException, WaitException
	{
		webActions.click(CLICKABILITY, MNU_PLANOFCARE);

		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, MNU_PLANOFCAREOVERVIEW);
	}

	@Step("Verify the Overview screen is displayed")
	public boolean viewPlanOfCareOverviewScreen() throws TimeoutException, WaitException
	{
		webActions.click(CLICKABILITY, MNU_PLANOFCAREOVERVIEW);

		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_PLANOFCAREOVERVIEW);
	}

	@Step("Verify the Management screen is displayed")
	public boolean viewPlanOfCareManagementScreen() throws TimeoutException, WaitException
	{
		webActions.click(CLICKABILITY, MNU_PLANOFCAREMANAGEMENT);

		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_PLANOFCAREMANAGEMENT);
	}

	@Step("Verify the History screen is displayed")
	public boolean viewPlanOfCareHistoryScreen() throws TimeoutException, WaitException
	{
		webActions.click(CLICKABILITY, MNU_PLANOFCAREHISTORY);

		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_PLANOFCAREHISTORY);
	}

	@Step("Verify the Notes screen is displayed")
	public boolean viewPlanOfCareNotesScreen() throws TimeoutException, WaitException
	{
		webActions.click(CLICKABILITY, MNU_PLANOFCARENOTES);

		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_PLANOFCARENOTES);
	}

	@Step("Verify the Consolidated Story screen is displayed")
	public boolean viewPlanOfCareConsolidatedStoryScreen() throws TimeoutException, WaitException
	{
		webActions.click(CLICKABILITY, MNU_PLANOFCARECONSOLIDATEDSTORY);

		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_PLANOFCARECONSOLIDATEDSTORY);
	}

	@Step("Verify the visibility of the Patient Care menu")
	public boolean viewPatientCareMenu() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, MNU_PATIENTCARE);
	}

	@Step("Verify the Patient Recap screen is displayed")
	public boolean viewPatientCarePatientRecapScreen() throws TimeoutException, WaitException
	{
		webActions.click(CLICKABILITY, MNU_PATIENTCAREPATIENTRECAP);

		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_PATIENTCAREPATIENTRECAP);
	}

	@Step("Verify the Patient Tasks screen is displayed")
	public boolean viewPatientCarePatientTasksScreen() throws TimeoutException, WaitException
	{
		webActions.click(CLICKABILITY, MNU_PATIENTCAREPATIENTTASKS);

		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_PATIENTCAREPATIENTTASKS);
	}

	@Step("Verify the Patient Care Team screen is displayed")
	public boolean viewPatientCareCareTeamScreen() throws TimeoutException, WaitException
	{
		webActions.click(CLICKABILITY, MNU_PATIENTCARECARETEAM);

		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_PATIENTCARECARETEAM);
	}

	@Step("Verify the visibility of the Patient Experience menu")
	public boolean viewPatientExperienceMenu() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, MNU_PATIENTEXPERIENCE);
	}

	@Step("Verify the expansion of the Patient Experience menu")
	public boolean viewPatientExperienceMenuExpanded() throws TimeoutException, WaitException
	{
		webActions.click(CLICKABILITY, MNU_PATIENTEXPERIENCE);

		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, MNU_PATIENTEXPERIENCEHOSPITALIZATIONS);
	}

	@Step("Verify the Hospitalizations screen is displayed")
	public boolean viewPatientExperienceHospitalizationsScreen() throws TimeoutException, WaitException
	{
		webActions.click(CLICKABILITY, MNU_PATIENTEXPERIENCEHOSPITALIZATIONS);

		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_PATIENTEXPERIENCEHOSPITALIZATIONS);
	}
}