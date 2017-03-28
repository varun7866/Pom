package com.vh.ui.pages;

import static com.vh.ui.web.locators.MyPatientsLocators.BTN_ADDTOCONTACTS;

import org.openqa.selenium.TimeoutException;
import org.openqa.selenium.WebDriver;

import com.vh.ui.exceptions.WaitException;
import com.vh.ui.page.base.WebPage;

import ru.yandex.qatools.allure.annotations.Step;

/*
 * @author Harvy Ackermans
 * @date   March 28, 2017
 * @class  MyPatientsPage.java
 */

public class MyPatientsPage extends WebPage
{
	public MyPatientsPage(WebDriver driver) throws WaitException {
		super(driver);
	}
	
	@Step("Verifying the visibility of the My Patients page")
	public boolean viewMyPatientsPage() throws TimeoutException, WaitException {
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, BTN_ADDTOCONTACTS);
	}
}