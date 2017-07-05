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
	public static final By LBL_PLANOFCAREOVERVIEW = By.xpath("//h2[text()='Overview')]");
	public static final By LBL_PLANOFCAREMANAGEMENT = By.xpath("//h2[text()='Management']");
	public static final By LBL_PLANOFCAREHISTORY = By.xpath("//h2[text()='History']");
	public static final By LBL_PLANOFCARENOTES = By.xpath("//h2[text()='Notes']");
	public static final By LBL_PLANOFCARECONSOLIDATEDSTORY = By.xpath("//h2[text()='Consolidated Story']");
	public static final By LBL_PATIENTCAREPATIENTRECAP = By.xpath("//h2[text()='Recap']");
	public static final By LBL_PATIENTCAREPATIENTTASKS = By.xpath("//h2[text()='Tasks']");
	public static final By LBL_PATIENTCARECARETEAM = By.xpath("//div[contains(., 'PROVIDERS AND TEAM') and @class='col-sm-6 providers-team-screennameheader']");
	public static final By LBL_PATIENTEXPERIENCEHOSPITALIZATIONS = By.xpath("//span[text()='HOSPITALIZATIONS']");
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
}