/**
 * 
 */
package com.vh.ui.web.locators;

import org.openqa.selenium.By;

/*
 * @author Harvy Ackermans
 * @date   June 29, 2017
 * @class  PatientNavigationLocators.java
 */

public class PatientNavigationLocators
{
	public static final By ICO_HOSPITALIZATIONSINFO = By.xpath("//a[@id='Hospitalizations-9']//button");
	public static final By ICO_FLUIDINFO = By.xpath("//a[@id='Fluid-10']//button");
	public static final By ICO_ACCESSINFO = By.xpath("//a[@id='Access-11']//button");
	public static final By ICO_MEDICATIONSINFO = By.xpath("//a[@id='Medications-12']//button");
	public static final By ICO_DIABETESINFO = By.xpath("//a[@id='Diabetes-13']//button");
	public static final By ICO_DEPRESSIONINFO = By.xpath("//a[@id='Depression-14']//button");
	public static final By ICO_IMMUNIZATIONSINFO = By.xpath("//a[@id='Immunizations-15']//button");
	public static final By ICO_COMORBIDSCOMPLAINTSINFO = By.xpath("//a[@id='Comorbids-17']//button");
	public static final By ICO_HOSPITALIZATIONSTATUS = By.xpath("//a[@id='Hospitalizations-9']/span[contains(@class, 'circle')]");
	public static final By ICO_FLUIDSTATUS = By.xpath("//a[@id='Fluid-10']/span[contains(@class, 'circle')]");
	public static final By ICO_ACCESSSTATUS = By.xpath("//a[@id='Access-11']/span[contains(@class, 'circle')]");
	public static final By ICO_MEDICATIONSSTATUS = By.xpath("//a[@id='Medications-12']/span[contains(@class, 'circle')]");
	public static final By ICO_DIABETESSTATUS = By.xpath("//a[@id='Diabetes-13']/span[contains(@class, 'circle')]");
	public static final By ICO_IMMUNIZATIONSSTATUS = By.xpath("//a[@id='Immunizations-15']/span[contains(@class, 'circle')]");

	public static final By LBL_PLANOFCAREOVERVIEW = By.xpath("//h2[text()='Overview')]");
	public static final By LBL_PLANOFCAREMANAGEMENT = By.xpath("//h2[text()='Management']");
	public static final By LBL_PLANOFCAREHISTORY = By.xpath("//h2[text()='History']");
	public static final By LBL_PLANOFCARENOTES = By.xpath("//h2[text()='Notes']");
	public static final By LBL_PLANOFCARECONSOLIDATEDSTORY = By.xpath("//h3[text()='Consolidated Story']");
	public static final By LBL_PATIENTCAREPATIENTRECAP = By.xpath("//h2[contains(., 'Patient Contacts')]");
	public static final By LBL_PATIENTCAREPATIENTTASKS = By.xpath("//h2[text()='Tasks']");
	public static final By LBL_PATIENTCARECARETEAM = By.xpath("//h2[contains(., 'Providers and Team')]");
	public static final By LBL_PATIENTEXPERIENCEHOSPITALIZATIONS = By.xpath("//h2[contains(., 'HOSPITALIZATIONS')]");
	public static final By LBL_PATIENTEXPERIENCEFLUID = By.xpath("//h2[text()='Fluid']");
	public static final By LBL_PATIENTEXPERIENCEACCESS = By.xpath("//h2[text()='Access']");
	public static final By LBL_PATIENTEXPERIENCEMEDICATIONS = By.xpath("//h2[text()='Medications']");
	public static final By LBL_PATIENTEXPERIENCEDIABETES = By.xpath("//h2[text()='Diabetes']");
	public static final By LBL_PATIENTEXPERIENCEDEPRESSION = By.xpath("//h2[text()='Depression']");
	public static final By LBL_PATIENTEXPERIENCEIMMUNIZATIONS = By.xpath("//h2[text()='Immunizations']");
	public static final By LBL_PATIENTEXPERIENCEPATHWAYSSCREENINGS = By.xpath("//h2[text()='Pathways/Screening']");
	public static final By LBL_PATIENTEXPERIENCECOMORBIDSCOMPLAINTS = By.xpath("//h2[text()='Comorbids/Complaints]");
	public static final By LBL_PATIENTEXPERIENCELABSCURRENTLABS = By.xpath("//h2[contains(., 'Labs')]");
	public static final By LBL_PATIENTEXPERIENCELABSLABSHISTORY = By.xpath("//h2[contains(., 'Labs History')]");
	public static final By LBL_PATIENTADMINPATIENTINFO = By.xpath("//h2[text()='Patient Info']");
	public static final By LBL_PATIENTADMINMEDICALEQUIPMENT = By.xpath("//h2[text()='MEDICAL EQUIPMENT']");
	public static final By LBL_PATIENTADMINMANAGEDOCUMENTS = By.xpath("//h2[text()='MANAGE DOCUMENTS']");
	public static final By LBL_PATIENTADMINFALCON = By.xpath("//h2[text()='FALCON']");
	public static final By LBL_PATIENTADMINMATERIALFULFILLMENT = By.xpath("//h2[text()='MATERIAL FULFILLMENT']");
	public static final By LBL_PATIENTADMINREFERRALS = By.xpath("//h2[contains(., 'Referrals')]");
	public static final By LBL_HOSPITALIZATIONSTOOLTIP = By.xpath("//popover-container");
	public static final By LBL_FLUIDTOOLTIP = By.xpath("//popover-container");
	public static final By LBL_ACCESSTOOLTIP = By.xpath("//popover-container");
	public static final By LBL_MEDICATIONSTOOLTIP = By.xpath("//popover-container");
	public static final By LBL_DIABETESTOOLTIP = By.xpath("//popover-container");
	public static final By LBL_DEPRESSIONTOOLTIP = By.xpath("//popover-container");
	public static final By LBL_IMMUNIZATIONSTOOLTIP = By.xpath("//popover-container");
	public static final By LBL_COMORBIDSCOMPLAINTSTOOLTIP = By.xpath("//popover-container");

	public static final By MNU_PLANOFCARE = By.xpath("//a[text()='Plan of Care']");
	public static final By MNU_PLANOFCAREOVERVIEW = By.id("Overview-1");
	public static final By MNU_PLANOFCAREMANAGEMENT = By.id("Management-2");
	public static final By MNU_PLANOFCAREHISTORY = By.id("History-3");
	public static final By MNU_PLANOFCARENOTES = By.id("Notes-4");
	public static final By MNU_PLANOFCARECONSOLIDATEDSTORY = By.id("ConsolidatedStory-5");
	public static final By MNU_PATIENTCARE = By.xpath("//a[text()='Patient Care']");
	public static final By MNU_PATIENTCAREPATIENTRECAP = By.id("Recap-6");
	public static final By MNU_PATIENTCAREPATIENTTASKS = By.id("PatientTasks-7");
	public static final By MNU_PATIENTCARECARETEAM = By.id("CareTeam-8");
	public static final By MNU_PATIENTEXPERIENCE = By.xpath("//a[text()='Patient Experience']");
	public static final By MNU_PATIENTEXPERIENCEHOSPITALIZATIONS = By.id("Hospitalizations-9");
	public static final By MNU_PATIENTEXPERIENCEFLUID = By.id("Fluid-10");
	public static final By MNU_PATIENTEXPERIENCEACCESS = By.id("Access-11");
	public static final By MNU_PATIENTEXPERIENCEMEDICATIONS = By.id("Medications-12");
	public static final By MNU_PATIENTEXPERIENCEDIABETES = By.id("Diabetes-13");
	public static final By MNU_PATIENTEXPERIENCEDEPRESSION = By.id("Depression-14");
	public static final By MNU_PATIENTEXPERIENCEIMMUNIZATIONS = By.id("Immunizations-15");
	public static final By MNU_PATIENTEXPERIENCEPATHWAYSSCREENINGS = By.id("PathwaysScreenings-16");
	public static final By MNU_PATIENTEXPERIENCECOMORBIDSCOMPLAINTS = By.id("Comorbids-17");
	public static final By MNU_PATIENTEXPERIENCELABS = By.xpath("//a[text()='Labs']");
	public static final By MNU_PATIENTEXPERIENCELABSCURRENTLABS = By.xpath("//span[text()='Current Labs']");
	public static final By MNU_PATIENTEXPERIENCELABSCURRENTLABSCLICK = By.id("CurrentLabs-18");
	public static final By MNU_PATIENTEXPERIENCELABSLABSHISTORY = By.xpath("//span[text()='Labs History']");
	public static final By MNU_PATIENTEXPERIENCELABSLABSHISTORYCLICK = By.id("LabsHistory-19");
	public static final By MNU_PATIENTADMIN = By.xpath("//a[text()='Patient Admin']");
	public static final By MNU_PATIENTADMINPATIENTINFO = By.id("PatientInfo-20");
	public static final By MNU_PATIENTADMINMEDICALEQUIPMENT = By.id("MedicalEquipment-23");
	public static final By MNU_PATIENTADMINMANAGEDOCUMENTS = By.id("ManageDocuments-24");
	public static final By MNU_PATIENTADMINFALCON = By.id("Falcon-25");
	public static final By MNU_PATIENTADMINMATERIALFULFILLMENT = By.id("Material Fulfillment-26");
	public static final By MNU_PATIENTADMINREFERRALS = By.id("Referrals-27");
	public static final By MNU_PLANOFCARECOLLAPSE = By.xpath("//a[text()='Plan of Care' and @aria-expanded='false']");
	public static final By MNU_PATEINTCARECOLLAPSE = By.xpath("//a[text()='Patient Care' and @aria-expanded='false']");
	public static final By MNU_PATIENTEXPERIENCECOLLAPSE = By.xpath("//a[text()='Patient Experience' and @aria-expanded='false']");
	public static final By MNU_PATIENTADMINCOLLAPSE = By.xpath("//a[text()='Patient Admin' and @aria-expanded='false']");
}