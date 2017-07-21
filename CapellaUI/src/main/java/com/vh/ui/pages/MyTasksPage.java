package com.vh.ui.pages;

import static com.vh.ui.web.locators.MyTasksLocators.BTN_ADD;
import static com.vh.ui.web.locators.MyTasksLocators.BTN_CANCEL;
import static com.vh.ui.web.locators.MyTasksLocators.BTN_NEWTASK;
import static com.vh.ui.web.locators.MyTasksLocators.CMB_PRIORITY;
import static com.vh.ui.web.locators.MyTasksLocators.LBL_LOADING;
import static com.vh.ui.web.locators.MyTasksLocators.LBL_NEWTASKPOPUPNEWTASK;
import static com.vh.ui.web.locators.MyTasksLocators.LBL_PRIORITY;
import static com.vh.ui.web.locators.MyTasksLocators.LBL_TASKDATE;
import static com.vh.ui.web.locators.MyTasksLocators.TXT_ASSIGNEDTO;
import static com.vh.ui.web.locators.MyTasksLocators.TXT_PATIENTNAME;
import static com.vh.ui.web.locators.MyTasksLocators.TXT_TASKDATE;
import static com.vh.ui.web.locators.MyTasksLocators.TXT_TASKDESCRIPTION;
import static com.vh.ui.web.locators.MyTasksLocators.TXT_TASKTITLE;
import static com.vh.ui.web.locators.MyTasksLocators.LBL_LOADING;

import org.openqa.selenium.By;
import org.openqa.selenium.TimeoutException;
import org.openqa.selenium.WebDriver;

import com.vh.ui.actions.ApplicationFunctions;
import com.vh.ui.exceptions.WaitException;
import com.vh.ui.page.base.WebPage;
import com.vh.ui.waits.WebDriverWaits;

import ru.yandex.qatools.allure.annotations.Step;

/*
 * @author Sudheer Kumar Balivada
 * @date   March 29, 2017
 * @class  MyContactsPage.java
 */

public class MyTasksPage extends WebPage
{
	ApplicationFunctions appFunctions;
	public MyTasksPage(WebDriver driver) throws WaitException {
		super(driver);
		appFunctions = new ApplicationFunctions(driver);
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
    
    @Step("Verify if Task Date label exists")
    public boolean viewTaskDateLabel() {
        try {
            return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_TASKDATE);
        } catch (WaitException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
            return false;
        }
    }
    
    @Step("Verify if Task Date field exists")
    public boolean viewTaskDateField() {
        try {
            return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, TXT_TASKDATE);
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
            return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, CMB_PRIORITY);
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
            e.printStackTrace();
            return false;
        }
    }
    
    public void clickCancelOnNewTaskWindow() {
    	try {
			webActions.click(CLICKABILITY, BTN_CANCEL);
		} catch (TimeoutException e) {
			e.printStackTrace();
		} catch (WaitException e) {
			e.printStackTrace();
		}
    }
    
    public void addNewTaskPatientName(String patientName) throws TimeoutException, WaitException {
//    	webActions.enterText(NOTREQUIRED, TXT_PATIENTNAME, patientName);
    	webActions.selectValueFromAutoCompleteText(TXT_PATIENTNAME, patientName);
    }
    
    public void setNewTaskPriority(String priority) throws TimeoutException, WaitException {
    	webActions.enterText(NOTREQUIRED, CMB_PRIORITY, priority);
    }
    
    public void addNewTaskTaskTitle(String taskTitle) throws TimeoutException, WaitException {
    	webActions.enterText(NOTREQUIRED, TXT_TASKTITLE, taskTitle);
    }
    
    public void addNewTaskTaskDescription(String taskDescription) throws TimeoutException, WaitException {
    	webActions.enterText(NOTREQUIRED, TXT_TASKDESCRIPTION, taskDescription);
    }
    
    public void clickNewTaskAddButton() throws TimeoutException, WaitException {
    	webActions.click(CLICKABILITY, BTN_ADD);
    }
    
    public boolean validateSuccessMessage(String text) {
    	return appFunctions.verifySuccessMessage(text);
    }
        
    @Step("Wait for the screen to load")
    public void waitForTasksLoaded() {
//        webActions.waitUntilLoaded();
        new WebDriverWaits().waitForElementInvisible(driver, LBL_LOADING);
    }

}