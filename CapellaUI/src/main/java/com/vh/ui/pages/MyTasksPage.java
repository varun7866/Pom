package com.vh.ui.pages;

import static com.vh.ui.web.locators.MyTasksLocators.BTN_ADD;
import static com.vh.ui.web.locators.MyTasksLocators.BTN_CANCEL;
import static com.vh.ui.web.locators.MyTasksLocators.BTN_NEWTASK;
import static com.vh.ui.web.locators.MyTasksLocators.LBL_DUEDATE;
import static com.vh.ui.web.locators.MyTasksLocators.LBL_NEWTASKPOPUPNEWTASK;
import static com.vh.ui.web.locators.MyTasksLocators.LBL_PRIORITY;
import static com.vh.ui.web.locators.MyTasksLocators.TXT_ASSIGNEDTO;
import static com.vh.ui.web.locators.MyTasksLocators.TXT_DUEDATE;
import static com.vh.ui.web.locators.MyTasksLocators.TXT_PATIENTNAME;
import static com.vh.ui.web.locators.MyTasksLocators.TXT_PRIORITY;
import static com.vh.ui.web.locators.MyTasksLocators.TXT_TASKDESCRIPTION;
import static com.vh.ui.web.locators.MyTasksLocators.TXT_TASKTITLE;

import org.openqa.selenium.TimeoutException;
import org.openqa.selenium.WebDriver;

import com.vh.ui.exceptions.WaitException;
import com.vh.ui.page.base.WebPage;

import ru.yandex.qatools.allure.annotations.Step;

/*
 * @author Harvy Ackermans
 * @date   March 29, 2017
 * @class  MyContactsPage.java
 */

public class MyTasksPage extends WebPage
{
	public MyTasksPage(WebDriver driver) throws WaitException {
		super(driver);
	}

	@Step("Click the NEW TASK button")
	public void clickNewTaskButton() throws TimeoutException, WaitException
	{
		webActions.click(CLICKABILITY, BTN_NEWTASK);
	}

	@Step("Verify the visibility of the New Task popup")
	public boolean viewNewTaskPopup() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_NEWTASKPOPUPNEWTASK);
	}
	
	@Step("Verify if patient name field exists")
	public boolean viewPatientName() {
		try {
			return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, TXT_PATIENTNAME);
		} catch (WaitException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return false;
		}
	}
	
	@Step("Verify if Assigned To field exists")
	public boolean viewAssignTo() {
		try {
			return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, TXT_ASSIGNEDTO);
		} catch (WaitException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return false;
		}
	}
	
	@Step("Verify if Due Date label exists")
	public boolean viewDueDateLabel() {
		try {
			return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_DUEDATE);
		} catch (WaitException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return false;
		}
	}
	
	@Step("Verify if Due Date field exists")
	public boolean viewDueDateField() {
		try {
			return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, TXT_DUEDATE);
		} catch (WaitException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return false;
		}
	}
	
	@Step("Verify if Priority label exists")
	public boolean viewPriorityLabel() {
		try {
			return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_PRIORITY);
		} catch (WaitException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return false;
		}
	}
	
	@Step("Verify if Priority text field exists")
	public boolean viewPriorityTextField() {
		try {
			return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, TXT_PRIORITY);
		} catch (WaitException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return false;
		}
	}
	
	@Step("Verify if Task Title text field exists")
	public boolean viewTaskTitleTextField() {
		try {
			return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, TXT_TASKTITLE);
		} catch (WaitException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return false;
		}
	}
	
	@Step("Verify if Task Description text field exists")
	public boolean viewTaskDescriptionTextField() {
		try {
			return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, TXT_TASKDESCRIPTION);
		} catch (WaitException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return false;
		}
	}
	
	@Step("Verify if Cancel button exists")
	public boolean viewCancelButton() {
		try {
			return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, BTN_CANCEL);
		} catch (WaitException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return false;
		}
	}
	
	@Step("Verify if Add button exists")
	public boolean viewAddButton() {
		try {
			return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, BTN_ADD);
		} catch (WaitException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return false;
		}
	}
		
	@Step("Wait for the screen to load")
	public void waitForTaskLoading() {
		webActions.waitUntilLoaded();
	}
}