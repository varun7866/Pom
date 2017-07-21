/**
 * 
 */
package com.vh.ui.web.locators;

import org.openqa.selenium.By;

/*
 * @author Sudheer Kumar Balivada
 * @date   March 28, 2017
 * @class  MyPatientsLocators.java
 */

public class MyTasksLocators
{
	public static final By BTN_NEWTASK = By.xpath("//tasking-component//section/button");
	public static final By BTN_CANCEL = By.xpath("//new-task//button[@aria-label='Close dialog']");
    public static final By BTN_ADD = By.xpath("//new-task//button[@type='submit']");
    
	public static final By CMB_PRIORITY = By.xpath("//new-task//md-select[@name='newTaskPriorityGroup']/div/span[@class='mat-select-value']");
	
	public static final By LBL_BTNNEWTASK = By.xpath("//button/span[contains(., 'New Task')]");
	public static final By LBL_NEWTASKPOPUPNEWTASK = By.xpath("//new-task//h2[contains(., 'New Task')]");
	public static final By LBL_TASKDATE = By.xpath("//new-task//label[text()=contains(.,'Select a Date:')]");
	public static final By LBL_PRIORITY = By.xpath("//new-task//md-select[@name='newTaskPriorityGroup']/div/span[1]");
	public static final By LBL_LOADING = By.xpath("//tasking-component//section/h3[text()=contains(.,'Loading')]");
	
    public static final By TXT_PATIENTNAME = By.xpath("//new-task//*[@name='patientName']");
    public static final By TXT_ASSIGNEDTO = By.xpath(".//new-task//input[@placeholder='Assigned To(optional)']");
    public static final By TXT_TASKDATE = By.xpath("//new-task//input[@name='taskDate']");
    public static final By TXT_TASKTITLE = By.xpath("//new-task//*[@name='newTaskTitle']");
    public static final By TXT_TASKDESCRIPTION = By.xpath("//new-task//*[@name='newTaskDescription']");
}