package com.vh.ui.pages;

import static com.vh.ui.web.locators.MyTasksLocators.BTN_NEWTASK;
import static com.vh.ui.web.locators.MyTasksLocators.LBL_NEWTASKPOPUPNEWTASK;

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
}