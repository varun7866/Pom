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
import com.vh.ui.pages.MyTasksPage;

import ru.yandex.qatools.allure.annotations.Step;

/*
 * @author Sudheer Kumar
 * @date   March 29, 2017
 * @class  MyTasksTest.java
 */

public class MyTasksTest extends TestBase
{	
	// Class objects
	WebPage pageBase;
	ApplicationFunctions appFunctions;
	MyTasksPage myTasks;
	
	@BeforeClass
	public void buildUp() throws TimeoutException, WaitException, URLNavigationException, InterruptedException
	{
		WebDriver driver = getWebDriver();
		pageBase = new WebPage(driver);
		appFunctions = new ApplicationFunctions(driver);
		appFunctions.capellaLogin();
		
		myTasks = new MyTasksPage(driver);
	}

	@Test(priority = 1)
	@Step("Temporary POC test")
	public void verify_MyTasksPage() throws WaitException, URLNavigationException, InterruptedException
	{
		appFunctions.clickMyTasksMenuBar();
//		Thread.sleep(7000); // Pause to give time for the Tasks to load
		myTasks.waitForTaskLoading();
	}

	@Test(priority=2)
	@Step("Verify the labels in New Task pop up")
	public void verify_NewTaskPopUp() throws TimeoutException, WaitException {
		myTasks.clickNewTaskButton();
		
		Assert.assertTrue(myTasks.viewNewTaskPopup(), "Failed to identify the New Task popup header label");
		Assert.assertTrue(myTasks.viewPatientName(), "Failed to identify the Patient Name field");
		Assert.assertTrue(myTasks.viewAssignTo(), "Failed to identify the Assigned To field");
		Assert.assertTrue(myTasks.viewDueDateLabel(), "Failed to identify the Due Date label");
		Assert.assertTrue(myTasks.viewDueDateField(), "Failed to identify the Due Date field");
		Assert.assertTrue(myTasks.viewPriorityLabel(), "Failed to identify the Priority label");
		Assert.assertTrue(myTasks.viewPriorityTextField(), "Failed to identify the Priority text field");
		Assert.assertTrue(myTasks.viewTaskTitleTextField(), "Failed to identify the Task Title text field");
		Assert.assertTrue(myTasks.viewTaskDescriptionTextField(), "Failed to identify the Task Description text field");
		Assert.assertTrue(myTasks.viewCancelButton(), "Failed to identify the Cancel Button");
		Assert.assertTrue(myTasks.viewAddButton(), "Failed to identify the Add Button");
	}
	@AfterClass
	public void tearDown() throws TimeoutException, WaitException
	{
		appFunctions.capellaLogout();
		pageBase.quit();
	}
}