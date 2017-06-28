package com.vh.ui.pages;

import org.openqa.selenium.WebDriver;

import com.vh.ui.exceptions.WaitException;
import com.vh.ui.page.base.WebPage;

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
}