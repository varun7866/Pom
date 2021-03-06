package com.vh.ui.pages;

import static com.vh.ui.web.locators.PatientNavigationLocators.ICO_ACCESSINFO;
import static com.vh.ui.web.locators.PatientNavigationLocators.ICO_ACCESSSTATUS;
import static com.vh.ui.web.locators.PatientNavigationLocators.ICO_COMORBIDSCOMPLAINTSINFO;
import static com.vh.ui.web.locators.PatientNavigationLocators.ICO_DEPRESSIONINFO;
import static com.vh.ui.web.locators.PatientNavigationLocators.ICO_DIABETESINFO;
import static com.vh.ui.web.locators.PatientNavigationLocators.ICO_DIABETESSTATUS;
import static com.vh.ui.web.locators.PatientNavigationLocators.ICO_FLUIDINFO;
import static com.vh.ui.web.locators.PatientNavigationLocators.ICO_FLUIDSTATUS;
import static com.vh.ui.web.locators.PatientNavigationLocators.ICO_HOSPITALIZATIONSINFO;
import static com.vh.ui.web.locators.PatientNavigationLocators.ICO_HOSPITALIZATIONSTATUS;
import static com.vh.ui.web.locators.PatientNavigationLocators.ICO_IMMUNIZATIONSINFO;
import static com.vh.ui.web.locators.PatientNavigationLocators.ICO_IMMUNIZATIONSSTATUS;
import static com.vh.ui.web.locators.PatientNavigationLocators.ICO_MEDICATIONSINFO;
import static com.vh.ui.web.locators.PatientNavigationLocators.ICO_MEDICATIONSSTATUS;
import static com.vh.ui.web.locators.PatientNavigationLocators.LBL_ACCESSTOOLTIP;
import static com.vh.ui.web.locators.PatientNavigationLocators.LBL_COMORBIDSCOMPLAINTSTOOLTIP;
import static com.vh.ui.web.locators.PatientNavigationLocators.LBL_DEPRESSIONTOOLTIP;
import static com.vh.ui.web.locators.PatientNavigationLocators.LBL_DIABETESTOOLTIP;
import static com.vh.ui.web.locators.PatientNavigationLocators.LBL_FLUIDTOOLTIP;
import static com.vh.ui.web.locators.PatientNavigationLocators.LBL_HOSPITALIZATIONSTOOLTIP;
import static com.vh.ui.web.locators.PatientNavigationLocators.LBL_IMMUNIZATIONSTOOLTIP;
import static com.vh.ui.web.locators.PatientNavigationLocators.LBL_MEDICATIONSTOOLTIP;
import static com.vh.ui.web.locators.PatientNavigationLocators.LBL_PATIENTADMINFALCON;
import static com.vh.ui.web.locators.PatientNavigationLocators.LBL_PATIENTADMINMANAGEDOCUMENTS;
import static com.vh.ui.web.locators.PatientNavigationLocators.LBL_PATIENTADMINMATERIALFULFILLMENT;
import static com.vh.ui.web.locators.PatientNavigationLocators.LBL_PATIENTADMINMEDICALEQUIPMENT;
import static com.vh.ui.web.locators.PatientNavigationLocators.LBL_PATIENTADMINPATIENTINFO;
import static com.vh.ui.web.locators.PatientNavigationLocators.LBL_PATIENTADMINREFERRALS;
import static com.vh.ui.web.locators.PatientNavigationLocators.LBL_PATIENTCARECARETEAM;
import static com.vh.ui.web.locators.PatientNavigationLocators.LBL_PATIENTCAREPATIENTRECAP;
import static com.vh.ui.web.locators.PatientNavigationLocators.LBL_PATIENTCAREPATIENTTASKS;
import static com.vh.ui.web.locators.PatientNavigationLocators.LBL_PATIENTEXPERIENCEACCESS;
import static com.vh.ui.web.locators.PatientNavigationLocators.LBL_PATIENTEXPERIENCECOMORBIDSCOMPLAINTS;
import static com.vh.ui.web.locators.PatientNavigationLocators.LBL_PATIENTEXPERIENCEDEPRESSION;
import static com.vh.ui.web.locators.PatientNavigationLocators.LBL_PATIENTEXPERIENCEDIABETES;
import static com.vh.ui.web.locators.PatientNavigationLocators.LBL_PATIENTEXPERIENCEFLUID;
import static com.vh.ui.web.locators.PatientNavigationLocators.LBL_PATIENTEXPERIENCEHOSPITALIZATIONS;
import static com.vh.ui.web.locators.PatientNavigationLocators.LBL_PATIENTEXPERIENCEIMMUNIZATIONS;
import static com.vh.ui.web.locators.PatientNavigationLocators.LBL_PATIENTEXPERIENCELABSCURRENTLABS;
import static com.vh.ui.web.locators.PatientNavigationLocators.LBL_PATIENTEXPERIENCELABSLABSHISTORY;
import static com.vh.ui.web.locators.PatientNavigationLocators.LBL_PATIENTEXPERIENCEMEDICATIONS;
import static com.vh.ui.web.locators.PatientNavigationLocators.LBL_PATIENTEXPERIENCEPATHWAYSSCREENINGS;
import static com.vh.ui.web.locators.PatientNavigationLocators.LBL_PLANOFCARECONSOLIDATEDSTORY;
import static com.vh.ui.web.locators.PatientNavigationLocators.LBL_PLANOFCAREHISTORY;
import static com.vh.ui.web.locators.PatientNavigationLocators.LBL_PLANOFCAREMANAGEMENT;
import static com.vh.ui.web.locators.PatientNavigationLocators.LBL_PLANOFCARENOTES;
import static com.vh.ui.web.locators.PatientNavigationLocators.LBL_PLANOFCAREOVERVIEW;
import static com.vh.ui.web.locators.PatientNavigationLocators.MNU_PATEINTCARECOLLAPSE;
import static com.vh.ui.web.locators.PatientNavigationLocators.MNU_PATIENTADMIN;
import static com.vh.ui.web.locators.PatientNavigationLocators.MNU_PATIENTADMINCOLLAPSE;
import static com.vh.ui.web.locators.PatientNavigationLocators.MNU_PATIENTADMINFALCON;
import static com.vh.ui.web.locators.PatientNavigationLocators.MNU_PATIENTADMINMANAGEDOCUMENTS;
import static com.vh.ui.web.locators.PatientNavigationLocators.MNU_PATIENTADMINMATERIALFULFILLMENT;
import static com.vh.ui.web.locators.PatientNavigationLocators.MNU_PATIENTADMINMEDICALEQUIPMENT;
import static com.vh.ui.web.locators.PatientNavigationLocators.MNU_PATIENTADMINPATIENTINFO;
import static com.vh.ui.web.locators.PatientNavigationLocators.MNU_PATIENTADMINREFERRALS;
import static com.vh.ui.web.locators.PatientNavigationLocators.MNU_PATIENTCARE;
import static com.vh.ui.web.locators.PatientNavigationLocators.MNU_PATIENTCARECARETEAM;
import static com.vh.ui.web.locators.PatientNavigationLocators.MNU_PATIENTCAREPATIENTRECAP;
import static com.vh.ui.web.locators.PatientNavigationLocators.MNU_PATIENTCAREPATIENTTASKS;
import static com.vh.ui.web.locators.PatientNavigationLocators.MNU_PATIENTEXPERIENCE;
import static com.vh.ui.web.locators.PatientNavigationLocators.MNU_PATIENTEXPERIENCEACCESS;
import static com.vh.ui.web.locators.PatientNavigationLocators.MNU_PATIENTEXPERIENCECOLLAPSE;
import static com.vh.ui.web.locators.PatientNavigationLocators.MNU_PATIENTEXPERIENCECOMORBIDSCOMPLAINTS;
import static com.vh.ui.web.locators.PatientNavigationLocators.MNU_PATIENTEXPERIENCEDEPRESSION;
import static com.vh.ui.web.locators.PatientNavigationLocators.MNU_PATIENTEXPERIENCEDIABETES;
import static com.vh.ui.web.locators.PatientNavigationLocators.MNU_PATIENTEXPERIENCEFLUID;
import static com.vh.ui.web.locators.PatientNavigationLocators.MNU_PATIENTEXPERIENCEHOSPITALIZATIONS;
import static com.vh.ui.web.locators.PatientNavigationLocators.MNU_PATIENTEXPERIENCEIMMUNIZATIONS;
import static com.vh.ui.web.locators.PatientNavigationLocators.MNU_PATIENTEXPERIENCELABS;
import static com.vh.ui.web.locators.PatientNavigationLocators.MNU_PATIENTEXPERIENCELABSCURRENTLABS;
import static com.vh.ui.web.locators.PatientNavigationLocators.MNU_PATIENTEXPERIENCELABSCURRENTLABSCLICK;
import static com.vh.ui.web.locators.PatientNavigationLocators.MNU_PATIENTEXPERIENCELABSLABSHISTORYCLICK;
import static com.vh.ui.web.locators.PatientNavigationLocators.MNU_PATIENTEXPERIENCEMEDICATIONS;
import static com.vh.ui.web.locators.PatientNavigationLocators.MNU_PATIENTEXPERIENCEPATHWAYSSCREENINGS;
import static com.vh.ui.web.locators.PatientNavigationLocators.MNU_PLANOFCARE;
import static com.vh.ui.web.locators.PatientNavigationLocators.MNU_PLANOFCARECOLLAPSE;
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
	public boolean verifyPlanOfCareMenuExpanded() throws TimeoutException, WaitException
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

	@Step("Verify the collapse of the Plan of Care menu")
	public boolean verifyPlanOfCareMenuCollapse() throws TimeoutException, WaitException
	{
		webActions.click(CLICKABILITY, MNU_PLANOFCARE);

		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, MNU_PLANOFCARECOLLAPSE);
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
	
	@Step("Verify the collapse of the Patient Care menu")
	public boolean verifyPatientCareMenuCollapse() throws TimeoutException, WaitException
	{
		webActions.click(CLICKABILITY, MNU_PATIENTCARE);

		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, MNU_PATEINTCARECOLLAPSE);
	}

	@Step("Verify the visibility of the Patient Experience menu")
	public boolean viewPatientExperienceMenu() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, MNU_PATIENTEXPERIENCE);
	}

	@Step("Verify the expansion of the Patient Experience menu")
	public boolean verifyPatientExperienceMenuExpanded() throws TimeoutException, WaitException
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

	@Step("Verify the Fluid screen is displayed")
	public boolean viewPatientExperienceFluidScreen() throws TimeoutException, WaitException
	{
		webActions.click(CLICKABILITY, MNU_PATIENTEXPERIENCEFLUID);

		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_PATIENTEXPERIENCEFLUID);
	}

	@Step("Verify the Access screen is displayed")
	public boolean viewPatientExperienceAccessScreen() throws TimeoutException, WaitException
	{
		webActions.click(CLICKABILITY, MNU_PATIENTEXPERIENCEACCESS);

		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_PATIENTEXPERIENCEACCESS);
	}

	@Step("Verify the Medications screen is displayed")
	public boolean viewPatientExperienceMedicationsScreen() throws TimeoutException, WaitException
	{
		webActions.click(CLICKABILITY, MNU_PATIENTEXPERIENCEMEDICATIONS);

		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_PATIENTEXPERIENCEMEDICATIONS);
	}

	@Step("Verify the Diabetes screen is displayed")
	public boolean viewPatientExperienceDiabetesScreen() throws TimeoutException, WaitException
	{
		webActions.click(CLICKABILITY, MNU_PATIENTEXPERIENCEDIABETES);

		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_PATIENTEXPERIENCEDIABETES);
	}

	@Step("Verify the Depression screen is displayed")
	public boolean viewPatientExperienceDepressionScreen() throws TimeoutException, WaitException
	{
		webActions.click(CLICKABILITY, MNU_PATIENTEXPERIENCEDEPRESSION);

		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_PATIENTEXPERIENCEDEPRESSION);
	}

	@Step("Verify the Immunizations screen is displayed")
	public boolean viewPatientExperienceImmunizationsScreen() throws TimeoutException, WaitException
	{
		webActions.click(CLICKABILITY, MNU_PATIENTEXPERIENCEIMMUNIZATIONS);

		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_PATIENTEXPERIENCEIMMUNIZATIONS);
	}

	@Step("Verify the Pathways/Screenings screen is displayed")
	public boolean viewPatientExperiencePathwaysScreeningsScreen() throws TimeoutException, WaitException
	{
		webActions.click(CLICKABILITY, MNU_PATIENTEXPERIENCEPATHWAYSSCREENINGS);

		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_PATIENTEXPERIENCEPATHWAYSSCREENINGS);
	}

	@Step("Verify the Comorbids/Complaints screen is displayed")
	public boolean viewPatientExperienceComorbidsComplaintsScreen() throws TimeoutException, WaitException
	{
		webActions.click(CLICKABILITY, MNU_PATIENTEXPERIENCECOMORBIDSCOMPLAINTS);

		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_PATIENTEXPERIENCECOMORBIDSCOMPLAINTS);
	}

	@Step("Verify the visibility of the Patient Experience Labs menu")
	public boolean viewPatientExperienceLabsMenu() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, MNU_PATIENTEXPERIENCELABS);
	}

	@Step("Verify the expansion of the Patient Experience Labs menu")
	public boolean verifyPatientExperienceLabsMenuExpanded() throws TimeoutException, WaitException
	{
		webActions.click(CLICKABILITY, MNU_PATIENTEXPERIENCELABS);

		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, MNU_PATIENTEXPERIENCELABSCURRENTLABS);
	}

	@Step("Verify the Current Labs screen is displayed")
	public boolean viewPatientExperienceLabsCurrentLabsScreen() throws TimeoutException, WaitException
	{
		webActions.click(CLICKABILITY, MNU_PATIENTEXPERIENCELABSCURRENTLABSCLICK);

		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_PATIENTEXPERIENCELABSCURRENTLABS);
	}

	@Step("Verify the Labs History screen is displayed")
	public boolean viewPatientExperienceLabsLabsHistoryScreen() throws TimeoutException, WaitException
	{
		webActions.click(CLICKABILITY, MNU_PATIENTEXPERIENCELABSLABSHISTORYCLICK);

		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_PATIENTEXPERIENCELABSLABSHISTORY);
	}

	@Step("Verify the collapse of the Patient Experience menu")
	public boolean verifyPatientExperienceMenuCollapse() throws TimeoutException, WaitException
	{
		webActions.click(CLICKABILITY, MNU_PATIENTEXPERIENCE);

		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, MNU_PATIENTEXPERIENCECOLLAPSE);
	}

	@Step("Verify the visibility of the Patient Admin menu")
	public boolean viewPatientAdminMenu() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, MNU_PATIENTADMIN);
	}

	@Step("Verify the expansion of the Patient Admin menu")
	public boolean verifyPatientAdminMenuExpanded() throws TimeoutException, WaitException
	{
		webActions.click(CLICKABILITY, MNU_PATIENTADMIN);

		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, MNU_PATIENTADMINPATIENTINFO);
	}

	@Step("Verify the Patient Info screen is displayed")
	public boolean viewPatientAdminPatientInfoScreen() throws TimeoutException, WaitException
	{
		webActions.click(CLICKABILITY, MNU_PATIENTADMINPATIENTINFO);

		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_PATIENTADMINPATIENTINFO);
	}

	@Step("Verify the Medical Equipment screen is displayed")
	public boolean viewPatientAdminMedicalEquipmentScreen() throws TimeoutException, WaitException
	{
		webActions.click(CLICKABILITY, MNU_PATIENTADMINMEDICALEQUIPMENT);

		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_PATIENTADMINMEDICALEQUIPMENT);
	}

	@Step("Verify the Manage Documents screen is displayed")
	public boolean viewPatientAdminManageDocumentsScreen() throws TimeoutException, WaitException
	{
		webActions.click(CLICKABILITY, MNU_PATIENTADMINMANAGEDOCUMENTS);

		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_PATIENTADMINMANAGEDOCUMENTS);
	}

	@Step("Verify the Falcon screen is displayed")
	public boolean viewPatientAdminFalconScreen() throws TimeoutException, WaitException
	{
		webActions.click(CLICKABILITY, MNU_PATIENTADMINFALCON);

		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_PATIENTADMINFALCON);
	}

	@Step("Verify the Material Fulfillment screen is displayed")
	public boolean viewPatientAdminMaterialFulfillmentScreen() throws TimeoutException, WaitException
	{
		webActions.click(CLICKABILITY, MNU_PATIENTADMINMATERIALFULFILLMENT);

		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_PATIENTADMINMATERIALFULFILLMENT);
	}

	@Step("Verify the Referrals screen is displayed")
	public boolean viewPatientAdminReferralsScreen() throws TimeoutException, WaitException
	{
		webActions.click(CLICKABILITY, MNU_PATIENTADMINREFERRALS);

		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_PATIENTADMINREFERRALS);
	}

	@Step("Verify the collapse of the Patient Experience menu")
	public boolean verifyPatientAdminMenuCollapse() throws TimeoutException, WaitException
	{
		webActions.click(CLICKABILITY, MNU_PATIENTADMIN);

		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, MNU_PATIENTADMINCOLLAPSE);
	}

	@Step("Verify the hover over functionality for the Hospitalizations Tooltip")
	public boolean verifyHoverHospitalizations() throws TimeoutException, WaitException
	{
		webActions.moveMouseToElement(VISIBILITY, ICO_HOSPITALIZATIONSINFO);

		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_HOSPITALIZATIONSTOOLTIP);
	}

	@Step("Verify the hover over functionality for the Fluid Tooltip")
	public boolean verifyHoverFluid() throws TimeoutException, WaitException
	{
		webActions.moveMouseToElement(VISIBILITY, ICO_FLUIDINFO);

		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_FLUIDTOOLTIP);
	}

	@Step("Verify the hover over functionality for the Access Tooltip")
	public boolean verifyHoverAccess() throws TimeoutException, WaitException
	{
		webActions.moveMouseToElement(VISIBILITY, ICO_ACCESSINFO);

		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_ACCESSTOOLTIP);
	}

	@Step("Verify the hover over functionality for the Medications Tooltip")
	public boolean verifyHoverMedications() throws TimeoutException, WaitException
	{
		webActions.moveMouseToElement(VISIBILITY, ICO_MEDICATIONSINFO);

		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_MEDICATIONSTOOLTIP);
	}

	@Step("Verify the hover over functionality for the Diabetes Tooltip")
	public boolean verifyHoverDiabetes() throws TimeoutException, WaitException
	{
		webActions.moveMouseToElement(VISIBILITY, ICO_DIABETESINFO);

		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_DIABETESTOOLTIP);
	}

	@Step("Verify the hover over functionality for the Depression Tooltip")
	public boolean verifyHoverDepression() throws TimeoutException, WaitException
	{
		webActions.moveMouseToElement(VISIBILITY, ICO_DEPRESSIONINFO);

		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_DEPRESSIONTOOLTIP);
	}

	@Step("Verify the hover over functionality for the Immunizations Tooltip")
	public boolean verifyHoverImmunizations() throws TimeoutException, WaitException
	{
		webActions.moveMouseToElement(VISIBILITY, ICO_IMMUNIZATIONSINFO);

		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_IMMUNIZATIONSTOOLTIP);
	}

	@Step("Verify the hover over functionality for the Comorbids/Complaints Tooltip")
	public boolean verifyHoverComorbidsComplaints() throws TimeoutException, WaitException
	{
		webActions.moveMouseToElement(VISIBILITY, ICO_COMORBIDSCOMPLAINTSINFO);

		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_COMORBIDSCOMPLAINTSTOOLTIP);
	}

	@Step("Verify the Hospitalizations Status Icon")
	public boolean verifyHospitalizationsStatusIcon() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, ICO_HOSPITALIZATIONSTATUS);

	}

	@Step("Verify the Hospitalizations Status Icon")
	public boolean verifyFluidStatusIcon() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, ICO_FLUIDSTATUS);

	}

	@Step("Verify the Hospitalizations Status Icon")
	public boolean verifyAccessStatusIcon() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, ICO_ACCESSSTATUS);

	}

	@Step("Verify the Hospitalizations Status Icon")
	public boolean verifyMedicationsStatusIcon() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, ICO_MEDICATIONSSTATUS);

	}

	@Step("Verify the Hospitalizations Status Icon")
	public boolean verifyDiabetesStatusIcon() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, ICO_DIABETESSTATUS);

	}

	@Step("Verify the Hospitalizations Status Icon")
	public boolean verifyImmunizationsStatusIcon() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, ICO_IMMUNIZATIONSSTATUS);

	}

}