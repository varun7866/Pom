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
 * @author Harvy Ackermans
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
		myTasks = new MyTasksPage(driver);

		appFunctions.capellaLogin();
	}

	@Test(priority = 1)
	@Step("Temporary POC test")
	public void verify_MyTasksPage() throws WaitException, URLNavigationException, InterruptedException
	{
		appFunctions.clickMyTasksMenuBar();
		Thread.sleep(7000); // Pause to give time for the Tasks to load
		myTasks.clickNewTaskButton();

		Assert.assertTrue(myTasks.viewNewTaskPopup(), "Failed to identify the New Task popup header label");
	}

	@AfterClass
	public void tearDown() throws TimeoutException, WaitException
	{
		appFunctions.capellaLogout();
		pageBase.quit();
	}
}
