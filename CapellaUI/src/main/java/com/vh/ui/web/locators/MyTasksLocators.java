/**
 * 
 */
package com.vh.ui.web.locators;

import org.openqa.selenium.By;

/*
 * @author Harvy Ackermans
 * @date   March 28, 2017
 * @class  MyPatientsLocators.java
 */

public class MyTasksLocators
{
	public static final By BTN_NEWTASK = By.xpath("//button/span[contains(., 'New Task')]");

	public static final By LBL_NEWTASKPOPUPNEWTASK = By.xpath("//new-task//h2[contains(., 'New Task')]");
	
	public static final By TXT_PATIENTNAME = By.xpath("//new-task//*[@name='patientName']");
	public static final By TXT_ASSIGNEDTO = By.xpath(".//new-task//input[@placeholder='Assigned To(optional)']");
	public static final By LBL_DUEDATE = By.xpath("//new-task//label[text()='Due Date']");
	public static final By TXT_DUEDATE = By.xpath("//new-task//div[@class='datepicker']/input");
	public static final By LBL_PRIORITY = By.xpath("//new-task//md-select[@aria-label='Priority']/div/span[1]");
	public static final By TXT_PRIORITY = By.xpath("//new-task//md-select[@aria-label='Priority']/div/span[@class='mat-select-value']");
	public static final By TXT_TASKTITLE = By.xpath("//new-task//*[@name='newTaskTitle']");
	public static final By TXT_TASKDESCRIPTION = By.xpath("//new-task//*[@name='newTaskDescription']");
	public static final By BTN_CANCEL = By.xpath("//new-task//button/span[text()='Cancel']");
	public static final By BTN_ADD = By.xpath("//new-task//button[@type='submit']/span[1]");
}